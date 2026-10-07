---
name: review
description: >-
  Review a GitHub pull request with a code review mindset. Use when the user
  provides a PR number to review, asks to review a pull request, or wants
  inline code review of a PR's changes. If no PR number is given, detects it
  from the current branch.
---

# Review Pull Request

Review a single GitHub pull request by number. Prioritize bugs, behavioral regressions, security issues, and missing tests.

Output has up to three parts: **Findings** — things that should change before this merges, **Observations** — things worth knowing that don't block anything, and **Highlights** — good decisions or good coverage worth acknowledging, with no latent concern attached. Only Findings affect the verdict. On a good PR, Findings is empty. That is the expected outcome of a review, not a failed one.

## Arguments

The user may provide a PR number (e.g. `14263`). Parse from the user's message or `$ARGUMENTS`.

## Instructions

1. **Determine the PR number**:
   - If the user provided a PR number, use it.
   - If no PR number was provided, try to find it from the current branch:
     ```bash
     gh pr view --json number -q .number
     ```
   - If that fails (no PR for the current branch), **stop and ask the user for a PR number**. Do not guess.

2. **Determine the repository**:
   ```bash
   gh repo view --json nameWithOwner -q .nameWithOwner
   ```

3. **Fetch PR details and diff** (in parallel):
   ```bash
   gh pr view <number> --repo <repo> --json title,author,body,baseRefName,headRefName,url,files,mergeable,mergeStateStatus
   gh pr diff <number> --repo <repo>
   ```

4. **Check CI status *and* mergeability.** "The diff looks good" is not enough — a PR that can't cleanly merge, or whose required checks never ran, is **not mergeable** no matter how clean the code is. Check all three of the following; any one of them blocks a "Mergeable" verdict:

   **(a) CI checks that ran:**
   ```bash
   gh pr checks <number> --repo <repo>
   ```
   - If any required check is **failing** or **erroring**, treat it as a **Critical** finding.
   - Investigate *why* it's failing. Pull the failing run's logs and identify the root cause; failures introduced by the PR itself (e.g. its own new/changed tests, or tests broken by its changes) are the author's responsibility to fix. Distinguish these from pre-existing/flaky/unrelated failures on the base branch — note that distinction explicitly, but still flag the red CI.
     ```bash
     gh run view <run-id> --repo <repo> --log-failed
     ```
   - **Exception: PR-title/metadata-only lint checks** (e.g. a semantic/conventional-commit PR-title check) that fail purely on the PR's title or description text — not the code — don't block "Mergeable." They're a one-line metadata edit, not a code fix. Report them as an Observation, not a Critical finding.
   - If checks are still **pending/in progress** (not failed, not missing), say so — this makes the verdict **pending CI** (see step 9), but it does not by itself force "Needs changes."

   **(b) Required checks that never ran.** Green ≠ complete. `gh pr checks` only lists checks that were actually triggered. **A branch being somewhat behind the base is fine and is *not* a blocker on its own** — don't ding a PR just for being out of date. The problem is only when it's so far behind that **required checks never ran at all**: on a badly stale branch, required checks configured on the base can be **absent entirely** (not failing), so a PR can look "all green" while its required CI never actually executed. Cross-reference `gh pr checks` against the base branch's required checks; if a required check is **missing** (never ran), treat it as **Critical** — the PR is not verifiably passing and can't be called "Mergeable" until CI actually runs. (`mergeStateStatus: BLOCKED` — unsatisfied required checks/reviews — is a signal; `BEHIND` alone just means out-of-date and is not itself a blocker.)

   **(c) Merge conflicts / merge state.** Use the `mergeable` and `mergeStateStatus` fields from step 3:
   - `mergeable: CONFLICTING` or `mergeStateStatus: DIRTY` → the PR has **merge conflicts that must be resolved before merge**. Critical finding; cannot be "Mergeable".
   - `mergeStateStatus: BEHIND` → branch is out of date with base. **Not a blocker by itself** — only flag it if it caused required checks to not run (see (b)); otherwise it's at most a Note.
   - `mergeStateStatus: BLOCKED` → merge is blocked (unsatisfied required checks/reviews).
   - `mergeable: UNKNOWN` → GitHub hasn't computed it yet; re-fetch, and don't assume clean.
   - `mergeStateStatus: CLEAN` (or `UNSTABLE`, i.e. only non-required checks failing) is mergeable from a merge-state standpoint — no need to call this out, just factor it into the verdict.

   Reflect this in your verdict: red CI, required checks that never ran, or merge conflicts each independently block a "Mergeable" verdict outright. **Pending/in-progress CI does not** — it doesn't turn a clean PR into "Needs changes"; it just marks the verdict as pending CI (see step 9). A branch merely being behind (with its required checks still green) does **not** block anything either.

5. **Pick the model, then hand off to a fresh session.** Reviews run in their own Solo agent, so the review gets a clean context and the right model, and this session stays free. You know which model you are from your system context.

   **Pick the model.** If you were told which model to use — by the user, or by whoever spawned you — use that and don't second-guess it. Otherwise, judge it from the PR:

   | Harness | Heavy | Light |
   |---|---|---|
   | Claude Code | `opus` | `sonnet` |
   | Codex | a GPT-5 Codex model on **high** (or higher) reasoning | the same model on **medium** or **low** reasoning |

   - **Heavy** if any of: more than 20 files changed, diff exceeds ~500 lines, security-sensitive code (auth, crypto, permissions, data access), or architectural changes (new abstractions, major refactors, API contracts).
   - **Light** if all of: 10 or fewer files changed, diff under ~200 lines, nothing security-sensitive or architectural.
   - Otherwise, either is fine — prefer the model you're on.

   Never tell a Codex user to switch to Opus or Sonnet — those models don't exist there. Don't rationalize picking the current model because the PR seems tractable or time is short.

   **Decide whether to hand off.** Run the review yourself, skipping the rest of this step, only when one of these is true:
   - You were spawned to run a handed-off review. Never hand off again.
   - This session is fresh — the review request is the first thing in it — and you're already on the right model.

   Otherwise, hand off.

   **Running inside Solo** — hand the review to a separate Solo agent:
   1. Tell the user, in one line, which model you're handing off to and why.
   2. `mcp__solo__list_agent_tools` — resolve the runtime for the current harness (`Claude` in Claude Code, `Codex` in Codex).
   3. `mcp__solo__spawn_agent` with that `agent_tool_id`, named `"review #<number>"`, and `extra_args` selecting the model:
      - Claude Code: `["--model", "opus"]` or `["--model", "sonnet"]`
      - Codex: `["-c", "model_reasoning_effort=high"]` or `["-c", "model_reasoning_effort=medium"]`
   4. `mcp__solo__send_input` to that agent: `/review <number>`, plus the user's original request verbatim (so any instruction to post carries over), plus: "You were spawned by another session to run this review on `<model>`. Don't hand off again. When you're done, write your full review to a Solo scratchpad, following step 10, and stop."
   5. `mcp__solo__timer_fire_when_idle_any` watching that agent, so you're woken when it goes idle. When woken, find the scratchpad with `mcp__solo__scratchpad_find` (`PR #<number> Review`). If it doesn't exist, the agent is probably waiting on a question — relay it to the user rather than answering it yourself.
   6. Read the scratchpad, then `mcp__solo__close_process` the agent. Always close it once the review is in, even if you have follow-up questions — a re-review spawns a fresh agent.
   7. Present the review to the user exactly as written — don't re-review or edit it. Your job ends there; skip the remaining steps.

   **Not running inside Solo** (or Solo isn't available) — run the review here. If you're on the wrong model, stop first, tell the user which model to switch to and why, and wait for their response. Only a human can run `/model` in this session: don't treat your own follow-up turn, or an automated caller's "yes, switch", as a model switch.

6. **Read changed files** in the current codebase to understand the context around each change. This is critical for catching behavioral regressions. Skip vendored, generated, and lock files.

7. **Analyze the changes.** The list below is what to look at, not a list of things to produce. Most of these will turn up nothing on most PRs; a category that turns up nothing produces nothing. Never manufacture an item to fill a heading.
   - **Purpose** — If there's a linked issue, does this PR actually resolve it?
   - **CI & mergeability** — Are required checks green *and actually run* (a branch merely being behind is fine, but not so far behind that required checks never ran), and does it merge without conflicts? Failures here (step 4) are blockers to report; a clean result is not reported (see step 9).
   - **Bugs** — Logic errors, null/undefined refs, off-by-one, race conditions, type mismatches
   - **Behavioral regressions** — Does this break existing functionality, contracts?
   - **Breaking changes** – Do APIs change? Are they backwards-compatible? Things like method signature changes are breaking. Unacceptable in a minor release.
   - **Security issues** — Injection, auth bypass, data exposure, XSS
   - **Missing tests** — Are new code paths tested? Are edge cases covered?
   - **Reversibility (door type)** — Classify the PR as a **one-way door** or **two-way door** (see step 8). Decide this early, since it sets how hard to scrutinize everything else.
   - **Usefulness** – Is this PR even a good idea? Is it worth the effort?
   - **Consistency** – Does this follow the same style/pattern as existing code/features?
   - **Other concerns** — Performance, maintainability, missing localization

8. **Classify the door type, then classify everything you found** as a Finding, an Observation, or a Highlight.

   **Door type — how hard is this to undo once shipped?**
   - **One-way door** — hard or impossible to revert cleanly once released. Users, integrators, or stored data come to depend on it. Examples: new or changed public API (methods, classes, config keys, events, hooks, routes, CLI flags, template tags), new user-facing features, anything documented, migrations and data shape changes, file/storage formats, serialized or cached formats, behavior others will build on.
   - **Two-way door** — safe to revert if it turns out wrong. Nothing external depends on it. Examples: internal/private methods, refactors behind an unchanged public interface, bug fixes to internal logic, styling, tests, docs, dev tooling.
   - A PR that mixes both is a **one-way door** — one irreversible piece is enough. Name the piece that makes it so.
   - Judge by what the *merged* change commits the project to, not by diff size. A one-line change to a public signature is a one-way door; a 2,000-line private rewrite may not be.

   **Door type calibrates scrutiny; it never changes the verdict scale.**
   - **One-way door** — raise the bar. Scrutinize naming, signatures, defaults, extensibility, edge-case behavior, docs, and test coverage of the contract, because they get locked in. Things that would be Observations on a two-way door (awkward naming, a questionable default, a missing edge-case test on the new surface) become Findings here, since fixing them after release is a breaking change.
   - **Two-way door** — lower the bar. Don't hold the PR for taste, polish, or speculative concerns; if it's wrong it can be reverted. Nits essentially don't apply (a Nit requires a one-way door by definition). Real bugs, security issues, and red CI are still Findings regardless of door type.

   Now classify everything you found as a Finding, an Observation, or a Highlight. The test is not how interesting the issue is or how confident you are — it is what happens if the PR merges exactly as it stands, and whether there's any latent concern attached at all.

   **Findings — merging as-is hurts.** Something is broken, unsafe, or regressive, or the fix is meaningfully more expensive after merge than before it.
   - **Critical** — must fix. Bugs, security holes, breaking changes, data loss, red/missing CI, merge conflicts.
   - **Warning** — should fix. Real problems that will bite, but aren't fatal.
   - **Nit** — small, but worth doing *now*, because now is genuinely cheaper than later. The bar is a one-way door: public API surface that a release locks in, a pattern that gets copied once it's merged, migrations and data shape, behavior that a merged test cements. **If the identical change would be exactly as easy to make next week, it is not a Nit** — it's an Observation. Nits should be rare. Naming, tidier loops, extra guard clauses, and reorganized code are almost never Nits.

   **Observations — merging as-is is fine, but there's still something worth watching.** No ask attached, but a latent concern, trade-off, or piece of context remains — this is the section the human scans for things that might need addressing later, so it must not be diluted with pure compliments.
   - Pre-existing issues in code the PR touched but didn't cause.
   - "Not a problem, but I'd have written this differently."
   - Anything you'd like changed but can't honestly say is worse to defer.
   - A trade-off, edge case, or piece of context the human should know even though nothing needs to happen.

   **Highlights — good and worth saying, with zero latent concern.** If your sentence is praise with no "but," no edge case, and no residual risk, it's a Highlight, not an Observation. Test: could you delete the sentence's second half without losing information? If there's nothing to lose, it's a Highlight. Examples of what belongs here, not in Observations: "this correctly handles X," "good test coverage of Y," "this is the right trade-off." Keep these terse — one line, no elaboration. Don't manufacture praise to populate this section; most reviews should have few, and an empty Highlights section is normal.
   - Confirming clean/green CI or mergeability is **never** a Highlight or an Observation — step 4/9 already cover why: it's a silent precondition, not a finding worth narrating.

   Attribution edge cases:
   - **PR touches a line carrying a pre-existing bug** → Observation. Unless the PR makes it reachable, makes it worse, or this is plainly the moment to fix it — then Finding.
   - **PR's new code extends an existing bad pattern** → Finding. New code is never pre-existing.
   - **Pre-existing issues away from the diff** → don't report them at all. Only surface pre-existing code you had to read in order to review this PR, or that sits directly adjacent to the change. A PR review is not a codebase audit.
   - **A serious pre-existing problem (e.g. a security hole) in ground the PR touches** → report it as an Observation, plainly and without softening. The human decides whether it warrants its own issue. Don't promote it to a Finding because it's serious, and don't bury it because it isn't one.

9. **Present the review.**

   **Lead with the verdict.** The base verdict is binary — there is no middle:
   - **Mergeable** — no Findings, CI green and actually run, no conflicts.
   - **Needs changes** — one or more Findings at any severity (a Nit counts), or a red-CI/merge-state blocker from step 4 (failing/missing required checks, merge conflicts) — except PR-title/metadata-only lint failures, which don't block "Mergeable" (step 4).

   Never write "mergeable with nits" or any hedged variant. A Nit means you want a change before merge, so that's **Needs changes**. Observations never qualify the verdict — a PR with ten Observations and zero Findings is plainly **Mergeable**, and must be stated that way.

   **Pending CI is a separate qualifier, not a third verdict value.** If required checks are still running (not failed, not missing) at the time of review, append `, pending CI` to whichever base verdict applies:
   - **Mergeable, pending CI** — no Findings, no conflicts, but CI hasn't finished yet.
   - **Needs changes, pending CI** — Findings exist (or CI you *can* see is otherwise fine) and separate required checks are still running.

   A run that is merely in progress must never by itself flip a clean PR to "Needs changes" — that's what the qualifier is for. Once CI finishes, a re-review drops the qualifier and reflects the real result (a failure found on completion is then a Critical finding, as in step 4).

   **Record which model did the review**, on its own line directly under the verdict:

   ```
   Review model: Opus 5.5
   ```

   Name the model you are, from your system context (e.g. `Opus 5.5`, `Sonnet 5.5`) — not a generic "Claude". If more than one model contributed to the review you're presenting — a second opinion, a consolidated review, work done by a sub-agent you spawned — list every one, in the order they contributed: `Review model: Opus 5.5, Sonnet 5.5`. Attribute honestly: list a model only if it actually reviewed the code, not merely if it relayed or reformatted someone else's findings.

   This line matters because the model is otherwise unrecoverable after the fact — a review written to a file or scratchpad carries no record of what produced it, and the process it ran in eventually goes away. Include it even when the review is presented only in the session. When a re-review replaces an earlier one, the line reflects the models behind the review as it now stands, not the history.

   **Record the door type**, on its own line directly under the review model, label only:

   ```
   Door: One-way
   Door: Two-way
   ```

   The reason for the classification is not part of this line. In a scratchpad it goes at the end of the Summary (step 10); in the session, state it in one sentence after the verdict block.

   **Record the release type**, on its own line directly under the door type — the semver bump this PR would require if it shipped on its own:

   ```
   Release: Patch
   Release: Minor
   Release: Major
   ```

   - **Patch** — bug fixes, internal refactors, performance, docs, tests, tooling. No new public surface.
   - **Minor** — backwards-compatible additions: new features, new public API, config keys, events, hooks, deprecations.
   - **Major** — breaking changes: removed or changed public API (including signatures), changed defaults or behavior existing users rely on, required migrations or upgrade steps.

   The highest applicable type wins. Judge by what the change does, not by the target branch — then compare the two: a Major PR targeting a branch that only ships minor/patch releases is a Critical finding (step 7's breaking-changes rule), and the line still says `Major`.

   **Then Findings**, ordered by severity. File and line, what's wrong, suggested fix where you have one.

   **Then Observations**, one line each. No severity labels, no code blocks, no suggested-fix blocks. If an item needs more than a line to explain, it's probably a Finding; if it isn't, cut it.

   **Then Highlights**, one line each, same formatting rules as Observations. Pure praise only — if a line has a latent concern attached, it belongs in Observations instead (step 8).

   Omit any section entirely when it's empty. If all three are empty, say so — don't invent issues to fill space.

   Only report CI/mergeability when there's an actual problem (failing/never-ran checks, conflicts, blocked state) or when CI is pending (which the `, pending CI` verdict qualifier already communicates — a one-line note on which checks are still running is enough, no need to elaborate further). Step 4 is a check you perform, not content to output: when CI and mergeability are clean and complete, do not report on it at all — no "CI & Mergeability" header, no summary of which commands you ran or that N checks passed, no bullet list of what was verified. Passing, finished CI is a silent precondition for **Mergeable**, not a finding worth narrating.

10. **When writing this review to a Solo scratchpad** — because you were asked to save it, or you were spawned to run a handed-off review (step 5) — use this exact structure, every time, so every review pad reads the same way:

    ```
    - Reviewed at: <short sha> - discussion through <ISO8601 timestamp>
    - Repo: <owner/repo>
    - Author: <PR author>
    - Branch: <head branch>
    - Target: <base branch>
    - URL: <PR URL>
    - Review model: <model(s), as in step 9>
    - Door: <One-way | Two-way>
    - Release: <Patch | Minor | Major>
    - Verdict: <✅ | 🔴> **<Mergeable | Needs changes>[, pending CI]**

    ## Summary

    <2-4 sentences: what the PR does and the overall shape of the review. Orientation, not a restatement of the diff — this is also where a verdict's justification lives.>

    <A separate final paragraph: one sentence giving the reason for the Door classification, naming what makes it one-way or two-way.>

    ## Verification performed

    - <what you checked (CI status and mergeability per step 4, tests run or read, whether you exercised the change yourself)>: <result>

    ## Findings

    - <one bullet per finding, as in step 9: severity, file and line, what's wrong, suggested fix where you have one>

    ## Observations

    - <one bullet per observation, as in step 9: one line each, no severity labels>

    ## Highlights

    - <one bullet per highlight, as in step 9: one line each, pure praise only>

    ## <a specific heading, only if genuinely needed>

    <anything that doesn't fit the sections above — used sparingly, most reviews won't have one.>
    ```

    - **Bullet everything below the title** — the metadata block, Verification performed, Findings, and Observations. Solo's scratchpad view renders markdown, and plain consecutive lines with no blank line between them collapse onto one rendered line; a bullet list is what keeps each item on its own line.
    - **Name the scratchpad** `PR #<number> Review - <PR title, with a leading bracketed tag like [6.x] stripped>` — but don't repeat the title inside the body. The scratchpad's name already carries it; the body starts straight at the `Reviewed at` bullet.
    - **`Reviewed at` bullet**: `gh pr view <number> --repo <repo> --json headRefOid,updatedAt` — `headRefOid` truncated to 7 chars, `updatedAt` as the timestamp. Rewrite this line on every re-review; it's how staleness gets detected later (by a refresh sweep or otherwise). It stays the very first line of the body — that position is load-bearing, a refresh sweep reads only the first line to check staleness cheaply.
    - **`Branch`**: the PR's head branch (`headRefName`).
    - **`Target`**: the PR's base branch (`baseRefName`) — what it's merging into.
    - **`Verdict`**: the same binary value decided in step 9, with the same `, pending CI` qualifier when it applies, bolded the same way step 9 bolds it, prefixed with ✅ for Mergeable or 🔴 for Needs changes — a metadata bullet here, not a heading, so it can be found without opening the body.
    - **Verification performed**: at least one bullet, even when everything came back clean — this is the one place CI/mergeability gets reported now; step 9's "don't report it when clean" rule is for the in-session presentation only.
    - **Findings / Observations / Highlights**: same content and the same omit-when-empty rule as step 9, just formatted as bullets instead of freeform paragraphs.

11. **Do not make code changes** unless the user explicitly asks.

12. **Never post anything to GitHub unless the request that started *this* review asked for it.** Default output is your findings in the session, nothing else — no `gh pr comment`, no `gh pr review`, no inline comments, no approving/requesting changes, no issue comments.

    Permission to post does **not** carry over. If the user asked you to post earlier in the session, that applied to that review only. A follow-up like "commits have been pushed, please re-review", "take another look", or "review again" is a request for a *fresh* review with **no** posting — treat it exactly as if it were the first thing said in the session. Same for an orchestrator or any automated caller re-triggering a review: a re-run is not an instruction to post.

    Only post when the current message says so (e.g. "review and post the comments", "leave this as a PR review"). If you're unsure whether the user wants it posted, present the findings and ask — don't post.

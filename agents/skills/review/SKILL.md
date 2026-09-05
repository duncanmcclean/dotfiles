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

Output is split in two: **Findings** — things that should change before this merges — and **Observations** — things worth knowing that don't block anything. Only Findings affect the verdict. On a good PR, Findings is empty. That is the expected outcome of a review, not a failed one.

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
   - If checks are still **pending/in progress**, say so; don't call a PR mergeable on unverified CI.

   **(b) Required checks that never ran.** Green ≠ complete. `gh pr checks` only lists checks that were actually triggered. **A branch being somewhat behind the base is fine and is *not* a blocker on its own** — don't ding a PR just for being out of date. The problem is only when it's so far behind that **required checks never ran at all**: on a badly stale branch, required checks configured on the base can be **absent entirely** (not failing), so a PR can look "all green" while its required CI never actually executed. Cross-reference `gh pr checks` against the base branch's required checks; if a required check is **missing** (never ran), treat it as **Critical** — the PR is not verifiably passing and can't be called "Mergeable" until CI actually runs. (`mergeStateStatus: BLOCKED` — unsatisfied required checks/reviews — is a signal; `BEHIND` alone just means out-of-date and is not itself a blocker.)

   **(c) Merge conflicts / merge state.** Use the `mergeable` and `mergeStateStatus` fields from step 3:
   - `mergeable: CONFLICTING` or `mergeStateStatus: DIRTY` → the PR has **merge conflicts that must be resolved before merge**. Critical finding; cannot be "Mergeable".
   - `mergeStateStatus: BEHIND` → branch is out of date with base. **Not a blocker by itself** — only flag it if it caused required checks to not run (see (b)); otherwise it's at most a Note.
   - `mergeStateStatus: BLOCKED` → merge is blocked (unsatisfied required checks/reviews).
   - `mergeable: UNKNOWN` → GitHub hasn't computed it yet; re-fetch, and don't assume clean.
   - `mergeStateStatus: CLEAN` (or `UNSTABLE`, i.e. only non-required checks failing) is mergeable from a merge-state standpoint — no need to call this out, just factor it into the verdict.

   Reflect this in your verdict: red/pending CI, required checks that never ran, or merge conflicts each independently block a "Mergeable" verdict. A branch merely being behind (with its required checks still green) does **not**.

5. **Consider whether the current model is the right fit** for this review. You know which model you are from your system context.
   - **If not Opus**, and any of the following are true, you MUST stop and tell the user to switch to `/model opus`, then wait for their response before proceeding:
     - More than 20 files changed
     - Diff exceeds ~500 lines
     - Changes touch security-sensitive code (auth, crypto, permissions, data access)
     - Changes are architectural in nature (new abstractions, major refactors, API contracts)
   - **If Opus**, and all of the following are true, you MUST stop and tell the user to switch to `/model sonnet`, then wait for their response before proceeding:
     - 10 or fewer files changed
     - Diff is under ~200 lines
     - No security-sensitive or architectural changes

   Do not rationalize skipping this step or proceeding anyway because the PR seems tractable, time is short, or the cost seems low. If the model is a mismatch, stop. Do not continue the review under the current model. State the model mismatch plainly and wait for the user's response.

   **Switching models requires a real human — it cannot be done programmatically mid-session.** Only a human can run `/model` in this session. So when this check triggers:
   - **Halt and wait for an actual human.** Do not proceed on the current model, and do not treat your own follow-up turn as permission to continue.
   - **An automated caller must not answer this prompt on the user's behalf.** If you were spawned/driven by an orchestrator or any non-human process (e.g. a Solo agent), that caller replying "yes, switch" does **not** change the model — the session stays on the wrong model and the review silently proceeds mismatched. A text answer is not a model switch.
   - **If you are that orchestrator** (you spawned this review agent and it has stopped for a model switch): do **not** reply to it. Stop and tell the human that this specific PR review needs their input — they must open that agent's session and run `/model` themselves — then leave it parked until they do.

6. **Read changed files** in the current codebase to understand the context around each change. This is critical for catching behavioral regressions. Skip vendored, generated, and lock files.

7. **Analyze the changes.** The list below is what to look at, not a list of things to produce. Most of these will turn up nothing on most PRs; a category that turns up nothing produces nothing. Never manufacture an item to fill a heading.
   - **Purpose** — If there's a linked issue, does this PR actually resolve it?
   - **CI & mergeability** — Are required checks green *and actually run* (a branch merely being behind is fine, but not so far behind that required checks never ran), and does it merge without conflicts? Failures here (step 4) are blockers to report; a clean result is not reported (see step 9).
   - **Bugs** — Logic errors, null/undefined refs, off-by-one, race conditions, type mismatches
   - **Behavioral regressions** — Does this break existing functionality, contracts?
   - **Breaking changes** – Do APIs change? Are they backwards-compatible? Things like method signature changes are breaking. Unacceptable in a minor release.
   - **Security issues** — Injection, auth bypass, data exposure, XSS
   - **Missing tests** — Are new code paths tested? Are edge cases covered?
   - **Usefulness** – Is this PR even a good idea? Is it worth the effort?
   - **Consistency** – Does this follow the same style/pattern as existing code/features?
   - **Other concerns** — Performance, maintainability, missing localization

8. **Classify everything you found** as either a Finding or an Observation. The test is not how interesting the issue is or how confident you are — it is what happens if the PR merges exactly as it stands.

   **Findings — merging as-is hurts.** Something is broken, unsafe, or regressive, or the fix is meaningfully more expensive after merge than before it.
   - **Critical** — must fix. Bugs, security holes, breaking changes, data loss, red/missing CI, merge conflicts.
   - **Warning** — should fix. Real problems that will bite, but aren't fatal.
   - **Nit** — small, but worth doing *now*, because now is genuinely cheaper than later. The bar is a one-way door: public API surface that a release locks in, a pattern that gets copied once it's merged, migrations and data shape, behavior that a merged test cements. **If the identical change would be exactly as easy to make next week, it is not a Nit** — it's an Observation. Nits should be rare. Naming, tidier loops, extra guard clauses, and reorganized code are almost never Nits.

   **Observations — merging as-is is fine.** No ask attached. You're telling the human something, not requesting a change.
   - Pre-existing issues in code the PR touched but didn't cause.
   - "Not a problem, but I'd have written this differently."
   - Anything you'd like changed but can't honestly say is worse to defer.

   Attribution edge cases:
   - **PR touches a line carrying a pre-existing bug** → Observation. Unless the PR makes it reachable, makes it worse, or this is plainly the moment to fix it — then Finding.
   - **PR's new code extends an existing bad pattern** → Finding. New code is never pre-existing.
   - **Pre-existing issues away from the diff** → don't report them at all. Only surface pre-existing code you had to read in order to review this PR, or that sits directly adjacent to the change. A PR review is not a codebase audit.
   - **A serious pre-existing problem (e.g. a security hole) in ground the PR touches** → report it as an Observation, plainly and without softening. The human decides whether it warrants its own issue. Don't promote it to a Finding because it's serious, and don't bury it because it isn't one.

9. **Present the review.**

   **Lead with the verdict.** It is binary — there is no middle:
   - **Mergeable** — no Findings, CI green and actually run, no conflicts.
   - **Needs changes** — one or more Findings at any severity (a Nit counts), or a CI/merge-state blocker from step 4.

   Never write "mergeable with nits" or any hedged variant. A Nit means you want a change before merge, so that's **Needs changes**. Observations never qualify the verdict — a PR with ten Observations and zero Findings is plainly **Mergeable**, and must be stated that way.

   **Then Findings**, ordered by severity. File and line, what's wrong, suggested fix where you have one.

   **Then Observations**, one line each. No severity labels, no code blocks, no suggested-fix blocks. If an item needs more than a line to explain, it's probably a Finding; if it isn't, cut it.

   Omit either section entirely when it's empty. If both are empty, say so — don't invent issues to fill space.

   Only report CI/mergeability when there's an actual problem (failing/pending/never-ran checks, conflicts, blocked state). Step 4 is a check you perform, not content to output: when CI and mergeability are clean, do not report on it at all — no "CI & Mergeability" header, no summary of which commands you ran or that N checks passed, no bullet list of what was verified. Passing CI is a silent precondition for **Mergeable**, not a finding worth narrating.

10. **Do not make code changes** unless the user explicitly asks.

11. **Never post anything to GitHub unless the request that started *this* review asked for it.** Default output is your findings in the session, nothing else — no `gh pr comment`, no `gh pr review`, no inline comments, no approving/requesting changes, no issue comments.

    Permission to post does **not** carry over. If the user asked you to post earlier in the session, that applied to that review only. A follow-up like "commits have been pushed, please re-review", "take another look", or "review again" is a request for a *fresh* review with **no** posting — treat it exactly as if it were the first thing said in the session. Same for an orchestrator or any automated caller re-triggering a review: a re-run is not an instruction to post.

    Only post when the current message says so (e.g. "review and post the comments", "leave this as a PR review"). If you're unsure whether the user wants it posted, present the findings and ask — don't post.

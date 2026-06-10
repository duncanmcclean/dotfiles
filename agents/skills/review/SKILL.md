---
name: review
description: >-
  Review a GitHub pull request with a code review mindset. Use when the user
  provides a PR number to review, asks to review a pull request, or wants
  inline code review of a PR's changes. If no PR number is given, detects it
  from the current branch.
---

# Review Pull Request

Review a single GitHub pull request by number. Prioritize bugs, behavioral regressions, security issues, and missing tests. Findings are the primary focus, ordered by severity.

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
   gh pr view <number> --repo <repo> --json title,author,body,baseRefName,headRefName,url,files
   gh pr diff <number> --repo <repo>
   ```

4. **Consider whether the current model is the right fit** for this review. You know which model you are from your system context.
   - **If not Opus**, and any of the following are true, suggest switching to `/model opus` before continuing:
     - More than 20 files changed
     - Diff exceeds ~500 lines
     - Changes touch security-sensitive code (auth, crypto, permissions, data access)
     - Changes are architectural in nature (new abstractions, major refactors, API contracts)
   - **If Opus**, and all of the following are true, you MUST stop and tell the user to switch to `/model sonnet`, then wait for their response before proceeding:
     - 10 or fewer files changed
     - Diff is under ~200 lines
     - No security-sensitive or architectural changes

   Do not rationalize skipping this step because the PR is small or the cost seems low. The point is to conserve cost. State the model mismatch plainly and wait.

5. **Read changed files** in the current codebase to understand the context around each change. This is critical for catching behavioral regressions. Skip vendored, generated, and lock files.

6. **Analyze the changes** with this priority:
   - **Purpose** — If there's a linked issue, does this PR actually resolve it?
   - **Bugs** — Logic errors, null/undefined refs, off-by-one, race conditions, type mismatches
   - **Behavioral regressions** — Does this break existing functionality, contracts, introduce breaking changes?
   - **Security issues** — Injection, auth bypass, data exposure, XSS
   - **Missing tests** — Are new code paths tested? Are edge cases covered?
   - **Usefulness** – Is this PR even a good idea? Is it worth the effort?
   - **Consistency** – Does this follow the same style/pattern as existing code/features?
   - **Other concerns** — Performance, maintainability, missing localization

7. **Present findings** ordered by severity. For each finding:
   - State severity: **Critical** (must fix), **Warning** (should fix), or **Note** (consider)
   - Reference specific files and lines
   - Explain the issue and suggest a fix when possible

   If there are no findings, say so — don't invent issues.

8. **Do not make code changes** unless the user explicitly asks.

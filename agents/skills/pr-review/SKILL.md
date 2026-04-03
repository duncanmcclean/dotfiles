---
name: pr-review
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

4. **Read changed files** in the current codebase to understand the context around each change. This is critical for catching behavioral regressions. Skip vendored, generated, and lock files.

5. **Analyze the changes** with this priority:
   1. **Bugs** — Logic errors, null/undefined refs, off-by-one, race conditions, type mismatches
   2. **Behavioral regressions** — Does this break existing functionality or contracts?
   3. **Security issues** — Injection, auth bypass, data exposure, XSS
   4. **Missing tests** — Are new code paths tested? Are edge cases covered?
   5. **Other concerns** — Performance, maintainability, missing localization

6. **Present findings** ordered by severity. For each finding:
   - State severity: **Critical** (must fix), **Warning** (should fix), or **Note** (consider)
   - Reference specific files and lines
   - Explain the issue and suggest a fix when possible

   If there are no findings, say so — don't invent issues.

7. **Do not make code changes** unless the user explicitly asks.

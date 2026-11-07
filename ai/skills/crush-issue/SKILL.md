---
name: crush-issue
description: Investigate and fix a GitHub issue, Linear issue or Sentry error in its own worktree, then refine and review the fix before handing it over. Use when the user gives you an issue number or a GitHub, Linear or Sentry link to fix, or says "crush issue 1234". Given several issues, spins up an agent per issue.
---

Investigate and fix the issue I've provided.

Always spin up a separate agent to do the work, even for a single issue — one agent per issue, each following the rest of this skill. Keep this session free for me.

## Where the issue lives

| Given                                    | Read it with    | Branch name                   |
|------------------------------------------|-----------------|-------------------------------|
| A number or `github.com/.../issues` link | `gh issue view` | The issue number, eg. `1234`  |
| A `linear.app/.../issue/...` link        | The Linear MCP  | Its identifier, eg. `eng-123` |
| A `sentry.io/.../issues/...` link        | The Sentry MCP  | Its short ID, eg. `api-1a2`   |

Branch names are lowercase. When the MCP a link needs isn't connected, stop and tell me rather than guessing at the issue.

## Understand the issue

Read through the issue along with any comments. For a Sentry error, that means the stack trace, breadcrumbs, tags and the request or job that triggered it — the error is the symptom, so trace it back to the cause rather than silencing it. Once you understand it, write a failing test to try and reproduce it (if it's a backend issue), attempt to fix it and run the relevant tests. Don't commit any changes until I tell you to.

When you identify an issue as "user error" (or, for a Sentry error, expected behaviour that shouldn't be fixed), describe the reported issue to me, explain why and draft a comment for me to post to GitHub or Linear. Never post comments, or change an issue's status, yourself.

## Work in a worktree

In a package, follow the `worktree` skill: create a worktree with `tether worktree new [branch]` and do all of your work in there, testing against the worktree's own sandbox site. This keeps the fix isolated from other issues being fixed alongside it, and from what I'm working on in the main checkout.

In a Laravel app, there are no worktrees — create the branch in the main checkout and work there.

**Important:** When the issue links a reproduction repository, feel free to clone it down to `~/Code/Throwaway`, name it `[repo]-[branch]`, install Composer dependencies and use that repo as this issue's sandbox.

## Before finishing

Once the fix works and the tests pass:

1. Run the `refine` skill over the files you touched, so the fix reads like I wrote it.
2. Review your own changes using the `review` skill's checklist. That skill expects a pull request and there isn't one yet, so feed it the local diff instead and skip its PR, CI, mergeability and model-switch steps:
   ```sh
   git diff $(git merge-base origin/HEAD HEAD)   # committed work, if any
   git diff                                       # uncommitted work
   git status --porcelain                         # untracked files
   ```
   Fix every Finding it raises and re-run the tests afterwards. Observations don't need acting on, but mention them in your summary.

Don't skip these because the fix is small. They're the last thing standing between your changes and my review.

## Summary

Respond with a summary containing (in this order):

- Link to the GitHub issue, Linear issue or Sentry error
- Link to open the worktree in Tower.app (follow the `tower` skill — don't open it yourself), or the branch name in a Laravel app
- Summary of the issue and what you've changed
- Anything the review turned up that you didn't act on
- Reproduction steps
  - When possible, please perform any set up steps in the sandbox site beforehand to streamline my review
- Link to the sandbox site (packages only)

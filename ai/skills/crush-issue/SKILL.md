---
name: crush-issue
description: Investigate and fix a GitHub issue, Linear issue or Sentry error in its own worktree, then refine and review the fix before handing it over. Use when the user gives you an issue number or a GitHub, Linear or Sentry link to fix, or says "crush issue 1234". Given several issues, spins up an agent per issue.
---

Investigate and fix the issue I've provided.

Always spin up a separate agent to do the work, even for a single issue — one agent per issue, each following the rest of this skill. Keep this session free for me.

In a Laravel app, create each issue's worktree yourself before spinning up its agent (see below), then spin the agent up in the app's own Solo project, labelling it with the branch (eg. `crush #1234 (1234)`). That label is how `worktree destroy` finds the worktree's processes to tidy up. Tell the agent to work in `worktrees/<branch>`, since it starts in the main checkout.

## Where the issue lives

| Given                                    | Read it with    | Branch name                   |
|------------------------------------------|-----------------|-------------------------------|
| A number or `github.com/.../issues` link | `gh issue view` | The issue number, eg. `1234`  |
| A `linear.app/.../issue/...` link        | The Linear MCP  | Its identifier, eg. `eng-123` |
| A `sentry.io/.../issues/...` link        | The Sentry MCP  | Its short ID, eg. `api-1a2`   |

Branch names are lowercase, and agents are labelled with the identifier as it's shown, eg. `crush ENG-123 (eng-123)`. When the MCP a link needs isn't connected, stop and tell me rather than guessing at the issue.

## Understand the issue

Read through the issue along with any comments. For a Sentry error, that means the stack trace, breadcrumbs, tags and the request or job that triggered it — the error is the symptom, so trace it back to the cause rather than silencing it. Once you understand it, write a failing test to try and reproduce it (if it's a backend issue), attempt to fix it and run the relevant tests. Don't commit any changes until I tell you to.

When you identify an issue as "user error" (or, for a Sentry error, expected behaviour that shouldn't be fixed), describe the reported issue to me, explain why and draft a comment for me to post to GitHub or Linear. Never post comments, or change an issue's status, yourself.

## Work in a worktree

Follow the `worktree` skill: create a worktree with `tether worktree new [branch]` (packages) or `worktree new [branch]` (Laravel apps — it'll already exist when you were spun up for it) and do all of your work in there, testing against the worktree's own site. This keeps the fix isolated from other issues being fixed alongside it, and from what I'm working on in the main checkout.

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
- Link to open the worktree in Tower.app (follow the `tower` skill — don't open it yourself)
- Summary of the issue and what you've changed
- Anything the review turned up that you didn't act on
- Reproduction steps
  - When possible, please perform any set up steps in the sandbox site beforehand to streamline my review
- Link to the sandbox site (or the worktree's site, in a Laravel app)

---
name: crush-issue
description: Investigate and fix a GitHub issue in its own worktree, then refine and review the fix before handing it over. Use when the user gives you an issue number or link to fix, or says "crush issue 1234". Given several issues, spins up an agent per issue.
---

Investigate and fix the GitHub issue I've provided.

Always spin up a separate agent via the Solo MCP to do the work, even for a single issue — one agent per issue, each following the rest of this skill. Keep this session free for me.

## Understand the issue

Read through the issue along with any comments. Once you understand it, write a failing test to try and reproduce it (if it's a backend issue), attempt to fix it and run the relevant tests. Don't commit any changes until I tell you to.

When you identify an issue as "user error", describe the reported issue to me, explain why it's user error and draft a comment for me to post to GitHub (do NOT post it yourself).

## Work in a worktree

Follow the `worktree` skill: create a worktree with `tether worktree new [issue-number]` and do all of your work in there, testing against the worktree's own sandbox site. This keeps the fix isolated from other issues being fixed alongside it, and from what I'm working on in the main checkout.

**Important:** When the issue links a reproduction repository, feel free to clone it down to `~/Code/Throwaway`, name it `[repo]-[issue-number]`, install Composer dependencies and use that repo as this issue's sandbox.

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

- Link to the GitHub issue
- Link to open the worktree in Tower.app (follow the `tower` skill — don't open it yourself)
- Summary of the issue and what you've changed
- Anything the review turned up that you didn't act on
- Reproduction steps
  - When possible, please perform any set up steps in the sandbox site beforehand to streamline my review
- Link to the sandbox site

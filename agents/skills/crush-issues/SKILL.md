---
name: crush-issues
description: This skill fixes provided GitHub Issues.
---

You should investigate and fix the GitHub issues I've provided. You should spin up a separate agent via the Solo MCP for each issue.

You should read through the issue along with any comments to understand the issue. Once you understand it, write a failing test to try and reproduce it (if it's a backend issue), attempt to fix it and run the relevant tests. You shouldn't commit any changes until I tell you to.

Every agent should follow the `worktree` skill: create a worktree with `tether worktree new [issue-number]` and do all of its work in there, testing against the worktree's own sandbox site. This ensures that fixes are isolated from one another and what I'm working on in the main checkout.

**Important:** When the issue links a reproduction repository, feel free to clone it down to `~/Code/Throwaway`, name it `[repo]-[issue-number]`, install Composer dependencies and use that repo as this issue's sandbox.

When you identify an issue as "user error", please describe the reported issue to me, explain why its user error and draft a comment for me to post to GitHub (Do NOT post it yourself).

When each agent is done, it should respond with a summary containing (in this order):

- Link to the GitHub issue
- Link to open the worktree in Tower.app
  - Provide the worktree's absolute path as the `path` query parameter here: `open "http://duncan.test/tower.php?path=[...]"`
  - Please don't open the link yourself. I'll do it when I get around to reviewing your changes.
- Summary of the issue and what you've changed
- Reproduction steps
  - When possible, please perform any set up steps in the sandbox site beforehand to streamline my review
- Link to the sandbox site

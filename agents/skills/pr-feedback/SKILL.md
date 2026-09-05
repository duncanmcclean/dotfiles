---
name: pr-feedback
description: Use this skill any time you are asked to address PR feedback.
---

Please spin up a subagent via the Solo MCP for each PR you are asked to address feedback on.

The pull request may have been created by another agent using the `worktree` skill, so look for local branches, worktrees and sandbox sites it may have created and use them. They may use the original GitHub issue's reference.

Please review the feedback in the PR and address it. Please commit each change separately but **don't** push so I have time to review manually.

When the PR is substantial, please run the `refine` skill on the entire branch after addressing the feedback to ensure the PR is as clean as possible.

When the agent is done, it should respond with a summary containing (in this order):

- Link to GitHub PR
- Link to open the worktree in Tower.app (follow the `tower` skill — don't open it yourself)
- Summary of the feedback and what you've changed
- Reproduction steps
  - When possible, please perform any set up steps in the sandbox site beforehand to streamline my review
- Link to the sandbox site (if there is one)

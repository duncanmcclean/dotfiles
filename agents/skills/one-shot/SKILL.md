---
name: one-shot
description: Commit, push and pull request a small fix in one go.
---

Please follow these steps when pushing a small fix or feature to GitHub.

## 1. Create a branch

Review the changes and create a branch for the fix, based off my current branch.

Don't use slashes in branch names, like `fix/...` or `feature/...`. Branch names should be a very short summary of what's changing.

For example:

- Change: Ensure that preview images are updated when assets are renamed/replaced/deleted
- Branch name would be `update-set-preview-images` or `set-preview-images`

Obviously, make sure it doesn't conflict with a branch on the remote.

## 2. Commit changes

Depending on the number of changes, it may make sense to split each "part" of a fix or feature into its own commit.

Make sure to only commit files and changes made by this agent. Other agents may be working on the same branch.

## 3. Push

You know how to do it. `git push`

## 4. Open a pull request

Please open a pull request using the `/pull-request` skill.

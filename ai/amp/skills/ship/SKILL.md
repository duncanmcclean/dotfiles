---
name: ship
description: Commit, push and open a pull request for a small fix in one go, without stopping to ask in between.
---

Please follow these steps when shipping a small fix or feature to GitHub.

## 1. Create a branch

Review the changes and create a branch for the fix, based off my current branch.

Don't use slashes in branch names, like `fix/...` or `feature/...`. Branch names should be a very short summary of what's changing.

For example:

- Change: Ensure that preview images are updated when assets are renamed/replaced/deleted
- Branch name would be `update-set-preview-images` or `set-preview-images`

Obviously, make sure it doesn't conflict with a branch on the remote.

## 2. Commit changes

Commit following the `commit` skill, with two exceptions:

- Only commit files and changes made by this agent. Other agents may be working on the same branch.
- Don't stop to ask about a mix of staged and unstaged changes — the whole point of this skill is to do it in one go. Just commit this agent's changes.

## 3. Push

You know how to do it. `git push`

## 4. Open a pull request

Write the description following the `pull-request` skill's guide and open the PR straight away with `gh pr create`, as that skill does. Pass the body with `--body-file -` and a quoted heredoc (`<<'EOF'`) so backticks don't get escaped.

Some repositories prefix PR titles with the version branch, eg. `[6.x] `. Check the most recent PRs with `gh pr list --limit 5 --json title` and match them.

Give me the link to the pull request.

## 5. Attach the pull request to the Linear issue

If we've discussed a Linear issue in this conversation, attach the pull request to it with the Linear MCP's `create_attachment` tool, so the work stays tracked. Use the PR's URL and title.

Skip this step when there's no Linear issue. When there is one but the Linear MCP isn't connected, give me the PR's link to attach myself.

## 6. Watch CI

Once the PR is open, keep an eye on its GitHub Actions checks and fix anything that breaks, without stopping to ask.

Wait for the checks with `gh pr checks <number> --watch`, rather than a sleep loop.

If there are still no checks after a couple of minutes, the repository doesn't run CI on PRs, so stop checking.

When the checks finish:

- **Everything passed** → tell me in one line.
- **Something failed** → read the logs with `gh run view <run-id> --log-failed` and work out why.
    - If it's caused by the PR, fix it, commit and push (never force push), then watch the new run the same way.
    - If it isn't caused by the PR (eg. it fails on the base branch too, or it's a flaky network timeout), don't paper over it. Re-run flaky jobs once with `gh run rerun <run-id> --failed`, otherwise tell me what's broken.
    - Never skip, delete or loosen a test just to make CI go green.

Give up after three rounds of fixes and tell me what's still failing, rather than looping forever.

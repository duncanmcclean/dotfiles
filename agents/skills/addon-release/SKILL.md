---
name: addon-release
description: Prepare a release for a Statamic addon, or clean up after one. Preparing creates a `release` branch, generates the changelog entry and opens the release PR. Cleaning up checks the release shipped, then deletes the release branch and pulls the tag. Use when the user says "prepare a release", "cut a release", "pr merged", "released" or similar. Only for Statamic addon repositories — never for statamic/cms.
---

Please follow the steps below when releasing a Statamic addon. There are two parts, run at different times:

- **Preparing a release** creates the branch, writes the changelog and opens the PR. Use it when I say "prepare a release", "start a release" or "cut a release".
- **Cleaning up** happens once the PR has been merged and the release workflow has run. Use it when I say "pr merged", "released", "release tagged", "it's out" or similar.

Never merge the PR or tag a release yourself, even if everything went perfectly.

# Preparing a release

## 1. Check where we are

```sh
git remote -v
gh repo view --json defaultBranchRef -q .defaultBranchRef.name
git branch --show-current
git status --porcelain
```

- If a remote points to `statamic/cms`, stop. The `statamic-release` skill should be used instead.
- Trust `gh repo view` for the default branch. In some repos `master` is the next major version, not the default.
- If the current branch isn't the default branch, stop and ask me. Don't check it out yourself.
- If the working tree is dirty, mention it and ask whether to continue. The release branch would inherit those changes.

## 2. Sync with the remote

```sh
git pull
git fetch origin --tags
```

Tags need fetching separately. The release workflow tags a separate "Build assets" commit which isn't an ancestor of the branch, so tags sit off-branch and don't come down with a plain pull.

If `git pull` isn't a clean fast-forward, stop and tell me. Don't merge or rebase around it.

## 3. Make sure there's no `release` branch already

Check locally and on the remote:

```sh
git branch --list release
git ls-remote --heads origin release
```

If either returns anything, stop and ask me what to do. Don't delete, reuse, reset or branch off it. A leftover `release` branch usually means a previous release is still in flight.

## 4. Create the branch

```sh
git checkout -b release
```

## 5. Generate the changelog

Follow the `changelog` skill in full, preferring the project's own `changelog` skill if it has one. It knows how to find the commits since the last tag, categorise them, pick the version number and insert the entry into `CHANGELOG.md`. Don't reimplement its logic here.

If it refuses to run because of `disable-model-invocation`, tell me. That flag needs to be off for this skill to chain it.

## 6. Commit and push

The changelog should be the only change. If `git status --porcelain` shows anything else, stop and ask rather than committing it.

```sh
git add CHANGELOG.md
git commit -m "changelog"
git push -u origin release
```

## 7. Open the pull request

Open the PR directly with the `gh` CLI. Don't use the `pull-request` skill, it's for a different kind of PR.

- The title is the version number, eg. `6.1.0`, with no leading `v`.
- Some repositories prefix PR titles with the version branch, eg. `[6.x] 6.1.0`. Check the most recent PRs with `gh pr list --limit 5 --json title` and match them.
- The body is exactly `Changelog for 6.1.0`. Don't link individual issues or PRs, don't reproduce the changelog and don't add anything else. The diff is the description.

```sh
gh pr create --title "[6.x] 6.1.0" --body "Changelog for 6.1.0"
```

## 8. Report back

- Link to the pull request.
- The version number chosen and why (minor if there were new features, otherwise patch).
- How many entries went under "What's new" and "What's fixed".
- Anything noteworthy from the changelog skill's own summary, like commits it skipped or titles it reworded.
- A reminder that the PR is mine to review and merge, and that the release workflow still needs triggering by hand once it's in.

# Cleaning up after a release

When I say "pr merged", "released" or "release tagged", I mean the release PR is in and the **Create Release** workflow has been run manually. Check that's actually true before deleting anything.

## 1. Confirm the PR merged

```sh
gh pr view <number> --json number,title,state,mergedAt,mergeCommit
```

If the number isn't in context, find it with `gh pr list --state merged --limit 5 --search "head:release"`. If the PR is still open, or was closed without merging, stop and say so. There's nothing to clean up.

## 2. Confirm the release actually happened

Merging the PR doesn't release anything. The `.github/workflows/release.yml` workflow is `workflow_dispatch` only, so someone has to trigger it by hand with the version as input. Check the release itself, not just the PR:

```sh
gh run list --workflow=release.yml --limit 3 --json displayTitle,status,conclusion,createdAt,url
gh release view v<version> --json tagName,createdAt,isLatest
```

- If the run is still in progress, wait or stop. The tag isn't pushed until near the end.
- If the run failed, or `gh release view` can't find the release, stop and tell me. The release branch may still be needed to retry.
- Only continue when the run succeeded **and** the release exists.

## 3. Delete the release branch

```sh
git checkout <default-branch> && git branch -D release && git pull
```

Use the default branch you found in step 1 of preparing the release. `-D` is needed because the branch was squash-merged, so `-d` won't recognise it as merged.

## 4. Pull the tag down

Tags sit off-branch, so the pull above won't bring it:

```sh
git fetch origin --tags
git tag --list 'v*' --sort=-v:refname | head -n1
```

Confirm the newest local tag is the version just released.

## 5. Check the remote branch is gone

GitHub usually deletes `release` on merge, but a leftover remote branch will block the next release:

```sh
git ls-remote --heads origin release
```

If it's still there, tell me and ask before deleting it.

## 6. Report back

The version released, that the workflow succeeded, that the branch has been deleted, that the tag is now local, and which branch I'm on now.

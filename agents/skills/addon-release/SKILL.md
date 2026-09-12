---
name: addon-release
description: Tag a new version of an existing Statamic addon. Creates a `release` branch, generates the changelog entry, opens the release PR, waits for the user to merge it, then triggers the "Create Release" workflow, watches it finish and tidies up the branch and tag. Use when the user says "prepare a release", "cut a release", "tag a release" or similar. Also use "pr merged" or "released" to resume from the merge if the session was lost. Only for Statamic addon repositories — never for statamic/cms.
---

Please follow the steps below when releasing a Statamic addon. It's one flow: you prepare the release, I merge the PR, you take it from there.

Merging the PR is mine to do. Never merge it yourself, even if everything went perfectly. Once I've merged it, that's the go signal: trigger the release workflow without checking with me.

If the session was lost partway through and I say "pr merged" or "released", pick up at step 9. Find the PR with `gh pr list --state all --limit 5 --search "head:release"` and work out how far things got before doing anything.

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

Remember the default branch. It's the branch the release workflow runs against later.

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

## 8. Hand over and wait for the merge

Tell me:

- The link to the pull request.
- The version number chosen and why (minor if there were new features, otherwise patch).
- How many entries went under "What's new" and "What's fixed".
- Anything noteworthy from the changelog skill's own summary, like commits it skipped or titles it reworded.
- That you're watching the PR and will trigger the release as soon as I merge it.

Then start a persistent `Monitor` that polls the PR and emits one line when it reaches a terminal state:

```sh
while true; do
  state=$(gh pr view <number> --json state -q .state 2>/dev/null || echo UNKNOWN)
  case "$state" in
    MERGED|CLOSED) echo "PR <number> $state"; exit 0 ;;
  esac
  sleep 30
done
```

Set `persistent: true` so it survives however long I take to review. Don't poll more often than every 30 seconds.

- `MERGED` means go. Carry on to step 9.
- `CLOSED` means I've abandoned the release. Stop the monitor if it's still running, tell me, and don't touch the branch.

## 9. Trigger the release workflow

Merging the PR doesn't release anything. The `.github/workflows/release.yml` workflow is `workflow_dispatch` only, so trigger it against the default branch with the version as input:

```sh
gh workflow run release.yml --ref <default-branch> -f version=<version>
```

The version has no `v` prefix, the workflow adds it. Before triggering, check a run isn't already in flight from a previous attempt:

```sh
gh run list --workflow=release.yml --limit 3 --json displayTitle,status,conclusion,createdAt,url
```

If the newest run is queued or in progress and was created after the merge, don't trigger a second one. Watch that one instead.

## 10. Watch the workflow

The run takes a few seconds to appear after dispatching:

```sh
sleep 10
gh run list --workflow=release.yml --limit 1 --json databaseId,status,url -q '.[0]'
```

Then watch it. Builds can take several minutes, so use a `Monitor` that emits on every terminal state rather than a foreground command that might time out:

```sh
while true; do
  read -r run_status conclusion < <(gh run view <run-id> --json status,conclusion -q '"\(.status) \(.conclusion)"' 2>/dev/null || echo "unknown unknown")
  if [ "$run_status" = "completed" ]; then echo "Run <run-id> $conclusion"; exit 0; fi
  sleep 30
done
```

- If the conclusion is anything other than `success`, stop. Link the run, pull the failed step's log with `gh run view <run-id> --log-failed` and tell me what went wrong. Leave the `release` branch alone, it may be needed to retry.
- Only continue once the run succeeded.

## 11. Confirm the release exists

```sh
gh release view v<version> --json tagName,createdAt,isLatest
```

If it can't find the release, stop and tell me even though the run says it succeeded.

## 12. Delete the release branch

```sh
git checkout <default-branch> && git branch -D release && git pull
```

`-D` is needed because the branch was squash-merged, so `-d` won't recognise it as merged.

## 13. Pull the tag down

Tags sit off-branch, so the pull above won't bring it:

```sh
git fetch origin --tags
git tag --list 'v*' --sort=-v:refname | head -n1
```

Confirm the newest local tag is the version just released.

## 14. Check the remote branch is gone

GitHub usually deletes `release` on merge, but a leftover remote branch will block the next release:

```sh
git ls-remote --heads origin release
```

If it's still there, tell me and ask before deleting it.

## 15. Report back

The version released, a link to the release and the workflow run, that the branch has been deleted, that the tag is now local, and which branch I'm on now.

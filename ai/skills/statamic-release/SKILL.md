---
name: statamic-release
description: >-
  Prepare a Statamic release, or clean up after one. Preparing syncs the default
  branch, creates a `release` branch, and generates the changelog entry — use
  when the user says "prepare a release", "start a release", "cut a release",
  "do a statamic release". Cleaning up verifies the release shipped then deletes
  the release branch and pulls the tag — use when the user says "pr merged",
  "release tagged", "released", "it's out", or similar. Only operates inside the
  statamic/cms repo. Preparing stops before committing — it never commits,
  pushes, tags, or opens a PR.
---

# Statamic release

Two phases, run at different times. Pick the one the user is asking for:

- **[Prepare](#phase-a-prepare-the-release)** — before the release exists.
  Branch + changelog.
- **[Clean up](#phase-b-clean-up-after-the-release)** — after the PR is merged
  and the release workflow has run. Triggered by "pr merged", "released",
  "release tagged", etc.

---

# Phase A: prepare the release

Gets the repo into a state where a release PR *could* be opened: up to date,
on a fresh `release` branch, with the new version's entry written into
`CHANGELOG.md`.

This phase deliberately stops before committing. The user reviews the changelog
diff, then commits and opens the PR themselves (or asks for `commit` /
`create-pull-request`). **Do not commit, push, tag, or open a PR** as part of
Phase A, even if the run went perfectly.

## 1. Guard: must be in statamic/cms, on the default branch

```bash
git remote -v
gh repo view --json defaultBranchRef -q .defaultBranchRef.name
git branch --show-current
git status --porcelain
```

- If no remote points to `statamic/cms`, **stop** — this skill only works there.
- Note that `master` in this repo is the *next major* branch, not the default.
  Trust `gh repo view`, not intuition.
- If the current branch isn't the default branch, **stop and ask** — don't
  check it out unilaterally.
- If the working tree is dirty, mention it and ask whether to continue. The new
  branch inherits those changes.

## 2. Sync

```bash
git pull
git fetch origin --tags
```

Tags are needed and won't arrive with the pull alone: the release workflow tags
a separate "Build assets" commit that isn't an ancestor of the branch, so tags
sit off-branch.

If `git pull` isn't a clean fast-forward, stop and report — don't merge or
rebase around it.

## 3. Check no `release` branch exists yet

Both places. They're supposed to be cleaned up after each release, but might not
have been:

```bash
git branch --list release
git ls-remote --heads origin release
```

If **either** returns anything, **stop and ask the user what to do**. Don't
delete, reuse, reset, or branch off it. A leftover `release` branch usually
means a previous release is still in flight.

## 4. Create the branch

```bash
git checkout -b release
```

## 5. Generate the changelog

Invoke the **`changelog`** skill (project-scoped — it lives in
`.claude/skills/changelog/` inside statamic/cms) and follow it in full. It knows
how to find the commits since the last tag, dedupe 5.x merges, categorize,
pick the version number, and insert the entry into `CHANGELOG.md`.

Don't reimplement or paraphrase its logic here — read and follow it.

If it refuses to run because of `disable-model-invocation`, tell the user; that
flag has to be off for this skill to chain it.

## 6. Report and stop

- Version number chosen, and why (minor if there were new features, else patch).
- Counts: entries under "What's new" / "What's fixed".
- Anything noteworthy from the changelog skill's own summary — commits skipped
  and why, titles reworded, judgment calls on categorization.
- Remind the user nothing is committed, and that the release branch and
  changelog diff are theirs to review.

---

# Phase B: clean up after the release

The user says "pr merged", "released", "release tagged", or similar. They mean:
the release PR is in and the **Create Release** workflow has been run manually.
Verify that's actually true before deleting anything.

## 1. Confirm the PR merged

```bash
gh pr view <n> --json number,title,state,mergedAt,mergeCommit
```

Find the PR with `gh pr list --state merged --limit 5 --search "head:release"` if
the number isn't in context. If it's still open or was closed unmerged, **stop
and say so** — nothing to clean up.

## 2. Confirm the release actually completed

Merging the PR does *not* release. `.github/workflows/release.yml` is
`workflow_dispatch` only — someone has to trigger it manually, with the version
as input, from the branch being released. So check the release itself, not just
the PR:

```bash
gh run list --workflow=release.yml --limit 3 --json displayTitle,status,conclusion,createdAt,url
gh release view v<version> --json tagName,createdAt,isLatest
```

- If the run is still `in_progress`, **wait or stop** — the tag isn't pushed
  until near the end. Don't clean up around a half-finished release.
- If the run `failure`d, or `gh release view` 404s, **stop and report**. The
  release branch may still be needed to retry.
- Only continue when the run concluded `success` **and** the release exists.

## 3. Delete the release branch and return to the default branch

```bash
git checkout <default> && git branch -D release && git pull
```

Use the default branch from Phase A step 1 — don't assume `6.x`. `-D` is a force
delete, which is right here: the branch was merged via squash or merge commit, so
`-d` may not recognise it as merged.

## 4. Pull the tag down

Tags sit off-branch (the workflow tags a "Build assets" commit that isn't an
ancestor of the branch), so the pull in step 3 won't bring it:

```bash
git fetch origin --tags
git tag --list 'v*' --sort=-v:refname | head -n1
```

Confirm the newest local tag is the version just released.

## 5. Check the remote branch is gone

GitHub usually auto-deletes `release` on merge, but a leftover remote branch
will block the *next* release at Phase A step 3:

```bash
git ls-remote --heads origin release
```

If it's still there, tell the user and ask before deleting it — don't delete a
remote branch unprompted.

## 6. Kick off documentation (minor releases only)

Only for a minor release (`vX.Y.0`). Patch releases (`vX.Y.Z`, Z > 0) don't
get documented — skip this step entirely for those.

Use Solo MCP to run the **`document-release`** skill in the `docs` project:

1. `mcp__solo__list_projects` — find the project named `docs`.
2. `mcp__solo__list_agent_tools` — resolve the `Claude` runtime's id.
3. `mcp__solo__spawn_agent` scoped to the `docs` project
   (`project_id` from step 1, `agent_tool_id` from step 2), named
   `"<version>: document-release"`.
4. `mcp__solo__send_input` to that agent with `/document-release`.

Don't wait for it to finish — it does its own research, commits, and opens a
PR independently. Just confirm the agent spawned and started.

## 7. Report

Version released, that the workflow succeeded, branch deleted, tag now local,
and which branch they're on now. If it was a minor release, note that the
`document-release` agent was kicked off in the `docs` project.

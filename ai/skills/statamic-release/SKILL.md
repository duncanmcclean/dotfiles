---
name: statamic-release
description: >-
  Prepare a Statamic release: create a `release` branch in its own worktree
  off the up-to-date default branch, and generate the changelog entry. Use when
  the user says "prepare a release", "start a release", "cut a release", or "do
  a statamic release". Only operates inside the statamic/cms repo. Stops before
  committing, pushing, tagging, or opening a PR.
---

# Statamic release

This skill has two phases, run at different times:

- **[Prepare](#phase-a-prepare-the-release)** — before the release exists.
  Branch + changelog.
- **[Clean up](#phase-b-clean-up-after-the-release)** — after the PR is merged
  and the release workflow has run. This is a follow-up only: use it when this
  skill already prepared that release earlier in the same session. Don't select
  this skill solely because an unrelated message says "pr merged", "released",
  "release tagged", or similar.

---

# Phase A: prepare the release

Gets the repo into a state where a release PR *could* be opened: a fresh
`release` branch, checked out in its own worktree at `worktrees/release`,
branched from the up-to-date default branch, with the new version's entry
written into `CHANGELOG.md`.

Everything happens in the worktree, so the main checkout is never touched — it
can be on any branch and have uncommitted changes.

This phase deliberately stops before committing. The user reviews the changelog
diff, then commits and opens the PR themselves (or asks for `commit` /
`create-pull-request`). **Do not commit, push, tag, or open a PR** as part of
Phase A, even if the run went perfectly.

## 1. Guard: must be in statamic/cms

```bash
git remote -v
ROOT=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")
DEFAULT=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
```

- If no remote points to `statamic/cms`, **stop** — this skill only works there.
- Note that `master` in this repo is the *next major* branch, not the default.
  Trust `gh repo view`, not intuition.
- `$ROOT` is the main checkout, even when run from inside another worktree.
- The current branch and working tree state don't matter; the worktree is
  branched from `origin/$DEFAULT`, not from whatever is checked out.

## 2. Sync

```bash
git fetch origin "$DEFAULT" --tags
```

Tags are needed: the release workflow tags a separate "Build assets" commit
that isn't an ancestor of the branch, so tags sit off-branch. Never use
`--depth` — it makes the shared repo shallow.

## 3. Check no `release` branch or worktree exists yet

All three places. They're supposed to be cleaned up after each release, but
might not have been:

```bash
git branch --list release
git ls-remote --heads origin release
git worktree list
ls -d "$ROOT/worktrees/release" 2>/dev/null
```

If **any** returns anything relevant, **stop and ask the user what to do**.
Don't delete, reuse, reset, or branch off it. A leftover `release` branch or
worktree usually means a previous release is still in flight.

## 4. Create the worktree

```bash
git worktree add -b release "$ROOT/worktrees/release" "origin/$DEFAULT"
```

Use plain `git worktree add` rather than `tether worktree new` — a release
doesn't need a sandbox. Run every remaining Phase A command with
`$ROOT/worktrees/release` as the working directory. No `composer install` /
`npm ci` — the changelog only needs `git` and `gh`.

## 5. Generate the changelog

Invoke the **`changelog`** skill (project-scoped — it lives in
`.claude/skills/changelog/` inside statamic/cms) and follow it in full. It knows
how to find the commits since the last tag, dedupe 5.x merges, categorize,
pick the version number, and insert the entry into `CHANGELOG.md`.

Don't reimplement or paraphrase its logic here — read and follow it. Run it
from inside the release worktree so `CHANGELOG.md` is edited there.

If it refuses to run because of `disable-model-invocation`, tell the user; that
flag has to be off for this skill to chain it.

## 6. Report and stop

- Version number chosen, and why (minor if there were new features, else patch).
- Counts: entries under "What's new" / "What's fixed".
- Anything noteworthy from the changelog skill's own summary — commits skipped
  and why, titles reworded, judgment calls on categorization.
- Worktree path (`$ROOT/worktrees/release`).
- Remind the user nothing is committed, and that the release branch and
  changelog diff are theirs to review.

## 7. Committing and opening the pull request

Only when the user says to:

- Commit and push from inside the release worktree.
- `CHANGELOG.md` gets its own commit, with the message `changelog`.
- Anything else is committed atomically.
- The pull request title matches previous release PRs:
  `[{major version line}] {version}`, eg. `[6.x] 6.30.1`.
- The pull request body takes one of two forms:
  - Only the changelog commit: `Changelog for {version}`.
  - Multiple commits: a bullet list, starting with `Changelog for {version}`,
    followed by the other items.

---

# Phase B: clean up after the release

Use this phase only as a follow-up to Phase A from the same session. A user
saying "pr merged", "released", "release tagged", or similar is not enough to
invoke this skill, since those messages commonly belong to another workflow.
In the release-session follow-up, they mean the release PR is in and the
**Create Release** workflow has been run manually. Verify that's actually true
before deleting anything.

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

## 3. Remove the worktree and branch

From the main checkout (not the worktree):

```bash
git worktree remove --force "$ROOT/worktrees/release"
git branch -D release
git worktree list
```

`--force` covers untracked or ignored leftovers in the worktree; `-D` is a force
delete, which is right here: the branch was merged via squash or merge commit,
so `-d` may not recognise it as merged. Don't use `rm` on the directory — it can
silently no-op; verify with `git worktree list` that the worktree is gone.

The main checkout's branch is left alone. If it's the default branch from Phase
A step 1 (don't assume `6.x`), `git pull` to bring it up to date; otherwise just
mention it.

## 4. Pull the tag down

Tags sit off-branch (the workflow tags a "Build assets" commit that isn't an
ancestor of the branch), so a plain pull won't bring it:

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

Version released, that the workflow succeeded, worktree and branch removed, tag
now local, and which branch the main checkout is on. If it was a minor release, note that the
`document-release` agent was kicked off in the `docs` project.

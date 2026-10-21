---
name: destroy-worktree
description: This skill should be used when asked to destroy, delete or tear down the current worktree — removing the worktree, its sites, database and the local branch.
---

Destroy the worktree currently being worked in, along with everything that was set up for it and its local branch.

## Figure out what to destroy

The current working directory should be inside `worktrees/<branch>` of a checkout (eg. `~/Code/Statamic/cms/worktrees/fix-1234`). From inside the worktree:

- Get the branch name: `git branch --show-current`
- The checkout root is the parent of the `worktrees/` directory.
- When the checkout root has an `artisan` file, it's a **Laravel app** worktree (created by `worktree`). Otherwise, it's a **package** worktree (created by Tether).

If the current directory is **not** inside a `worktrees/` directory, stop and check with me — don't guess which worktree to destroy.

## Safety checks

Before destroying anything, check from inside the worktree:

- **Uncommitted changes:** `git status --porcelain`
- **Unpushed commits:** `git log @{u}..HEAD --oneline` (or `git log <branch> --not --remotes --oneline` if there's no upstream)

If either turns anything up, stop and tell me what would be lost. Only proceed once I've confirmed.

## Destroy it

`cd` to the checkout root first — the shell can't be sitting inside the directory being deleted — then:

```sh
tether worktree destroy <branch> --force   # packages
worktree destroy <branch> --force          # Laravel apps
```

Tether removes the worktree, deletes any tethered sandbox sites, and cleans up the `vite-<branch>` process from `solo.yml`.

`worktree` deletes the worktree's Herd workspace (its links, certificates and database), removes the worktree and deletes its Solo project. When you're running inside that Solo project, it's left alone (deleting it would kill this session) — tell me to close it myself.

The `--force` flag is needed because the interactive confirmation prompt won't work here — that's why the safety checks above matter.

Neither deletes the local branch, so delete it afterwards from the checkout root:

```sh
git branch -D <branch>
```

(`-D` rather than `-d` because squash-merged branches aren't detected as merged.)

## Afterwards

Confirm what was removed: the worktree path, sandbox site(s) or Herd links, database (for Laravel apps) and branch name.

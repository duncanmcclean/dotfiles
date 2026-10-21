---
name: cleanup-worktrees
description: This skill should be used when asked to clean up worktrees and local branches — removing anything whose work has been PR'd, keeping anything that hasn't.
---

Clean up worktrees and local branches in the current checkout. The rule: **anything with a pull request gets cleaned up** (the work lives on GitHub now), **anything without a pull request is kept** (it's not safe anywhere else yet).

Run everything from the checkout root (the directory containing `worktrees/`). If the current directory is a worktree, `cd` to the checkout root first.

When the checkout root has an `artisan` file, it's a **Laravel app** and its worktrees are managed by `worktree`. Otherwise, it's a **package** and its worktrees are managed by Tether.

## Gather the candidates

- Worktrees: `git worktree list` — only consider ones under `worktrees/`.
- Local branches: `git branch --format='%(refname:short)'` — ignore the default branch (`main`, `master`, `4.x`, etc. — check `gh repo view --json defaultBranchRef` or the origin HEAD).

## Check each branch's PR status

```sh
gh pr list --head <branch> --state all --json number,state,url --limit 5
```

- **Merged or closed PR** → clean it up.
- **Open PR** → clean it up too, but only if the branch is fully pushed (`git log <branch> --not --remotes --oneline` is empty). The branch is recoverable from the remote if review feedback comes in.
- **No PR** → keep it, always.

Never destroy a worktree with uncommitted changes (`git -C worktrees/<branch> status --porcelain`), and never delete a branch with unpushed commits — skip those and mention them in the summary instead, whatever their PR status.

## Clean up

For each branch that qualifies:

```sh
tether worktree destroy <branch> --force   # if it has a worktree (packages)
worktree destroy <branch> --force          # if it has a worktree (Laravel apps)
git branch -D <branch>
```

`tether worktree destroy` removes the worktree, its sandbox site(s) and the `vite-<branch>` entry in `solo.yml`. `worktree destroy` removes the worktree, its Herd workspace (links, certificates and database) and its Solo project. `--force` is needed because the interactive confirmation won't work here — that's why the checks above matter. The worktree must be destroyed before the branch can be deleted.

Some local branches won't have a worktree — just delete the branch for those.

Finish with a prune to sweep up anything orphaned by worktrees that were deleted some other way:

```sh
tether worktree prune --force   # packages: sandbox sites and stale solo.yml entries
worktree prune --force          # Laravel apps: Herd links, databases and Solo projects
```

## Report back

Give a short summary: what was deleted (worktrees, sandboxes or Herd links, databases, branches), what was kept because it hasn't been PR'd, and anything skipped because of uncommitted/unpushed work.

---
name: worktree
description: This skill should be used when asked to work on a bug fix or feature in a worktree — of statamic/cms, another locally-cloned package, or a Laravel app.
---

Work on the task in a Git worktree, allowing other work to continue in parallel.

How the worktree is set up depends on what's being worked on:

- **Packages** (statamic/cms, addons — no `artisan` file in the root) use Tether, which pairs the worktree with a copy of a sandbox site.
- **Laravel apps** (an `artisan` file in the root) use `worktree`, which wraps Herd's workspaces to serve the worktree as its own site with its own database.

Either way, use `[issue-number]` as the branch name for bug fixes, or a descriptive name for features.

## Packages

Create the worktree from the root of the package checkout (eg. `~/Code/Statamic/cms`):

```sh
tether worktree new fix-1234 --sandbox sandbox
```

The `--sandbox` flag indicates which application to copy when multiple are tethered to the package — most packages will have a `[package]-sandbox` app located in the root's parent directory. Pass `--base <ref>` if the work should branch from something other than the default branch.

Tether will print the worktree path (`worktrees/<branch>`) and the sandbox URL (eg. `http://sandbox-1234.test`). The sandbox copy lives in `~/Code/Throwaway` (eg. `~/Code/Throwaway/sandbox-1234`), away from the base sandbox. From then on:

- Reproduce and test in the browser at the sandbox URL. Most of the time, you should be able to use `duncan@statamic.com`/`duncan@doublethree.digital` and `password` to login.
- Run tests inside the worktree: `./vendor/bin/phpunit tests/path/to/TestFile.php`
- After changing any JS/CSS, rebuild with `npm run build-dev` (or `npm run build` if there's no `build-dev` script) inside the worktree. For heavy Control Panel work, there's a `vite-<branch>` process in `solo.yml` you can start via Solo instead.
- Only run `tether worktree destroy <branch>` when explicitly asked to clean up.

## Laravel apps

Create the worktree from anywhere inside the app:

```sh
worktree new fix-1234
```

**Always** use `worktree new` — never `git worktree add`, the `EnterWorktree` tool or a copy of the main checkout's `.env`. Only `worktree new` serves the worktree as a Herd workspace, so I can check over UI and behaviour changes in the browser, and gives it a database of its own.

Pass `--base <ref>` if the work should branch from something other than the default branch (eg. `--base origin/main` when the local `main` might be stale). The worktree gets a fresh database, migrated and seeded — only pass `--db=copy` (a copy of the main database) when I ask for it.

`worktree` will print the worktree path (`worktrees/<branch>`), its URLs and its database. The worktree is served as a subdomain of the app (eg. `https://1234.harvestglasgow.test`), as is every other domain the app is served on (eg. `https://1234.harvestayr.test`). It also gets its own Solo project with the same processes as the app. From then on:

- **Never** point the worktree at the main checkout's database, and never run migrations or seeders against it.
- Test in the browser at the worktree's URLs. Seeders should have created a user to log in with.
- Run tests inside the worktree.
- The Solo project's commands (Vite, Horizon, etc.) won't run until I trust them in Solo. Assets are built when the worktree is created — after changing any JS/CSS, rebuild with `npm run build` inside the worktree unless its Vite process is running.
- Only run `worktree destroy <branch>` when explicitly asked to clean up.

## Either way

- Work exclusively inside `worktrees/<branch>` — **never** touch the main checkout.
- As per my guidelines, please don't commit changes yourself.
- When asked for a Tower.app link, follow the `tower` skill. Don't open the link yourself — I'll do it when I get around to reviewing your changes.

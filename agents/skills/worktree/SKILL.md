---
name: worktree
description: This skill should be used when asked to work on a bug fix or feature in a worktree of statamic/cms or another locally-cloned package.
---

Work on the task in a Git worktree with a dedicated sandbox site, allowing other work to continue in parallel.

Create the worktree from the root of the package checkout (eg. `~/Code/Statamic/cms`):

```sh
tether worktree new fix-1234 --sandbox sandbox
```

Most packages will have a `[package-name]-sandbox` site located in the root's parent directory.

You should use `[issue-number]` as the branch name for bug fixes, or a descriptive name for features. The `--sandbox` flag indicates which application to copy when multiple are tethered to the package — most packages will have a `[package]-sandbox` app located in the root's parent directory. Pass `--base <ref>` if the work should branch from something other than the default branch.

Tether will print the worktree path (`worktrees/<branch>`) and the sandbox URL (eg. `http://sandbox-1234.test`). From then on:

- Work exclusively inside `worktrees/<branch>` — **never** touch the main checkout.
- Reproduce and test in the browser at the sandbox URL. Most of the time, you should be able to use `duncan@statamic.com`/`duncan@doublethree.digital` and `password` to login.
- Run tests inside the worktree: `./vendor/bin/phpunit tests/path/to/TestFile.php`
- After changing any JS/CSS, rebuild with `npm run build-dev` (or `npm run build` if there's no `build-dev` script) inside the worktree. For heavy Control Panel work, there's a `vite-<branch>` process in `solo.yml` you can start via Solo instead.
- As per my guidelines, please don't commit changes yourself.
- Only run `tether worktree destroy <branch>` when explicitly asked to clean up.

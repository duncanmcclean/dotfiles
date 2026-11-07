---
name: worktree
description: This skill should be used when asked to work on a bug fix or feature in a worktree of a package — statamic/cms, an addon or another locally-cloned package. Laravel apps don't use worktrees; work on them in the main checkout.
---

Work on the task in a Git worktree, allowing other work to continue in parallel.

Worktrees are only for **packages** (statamic/cms, addons — no `artisan` file in the root). They use Tether, which pairs the worktree with a copy of a sandbox site. Laravel apps (an `artisan` file in the root) are worked on in the main checkout instead — don't create a worktree for them.

Use a short, descriptive branch name (eg. `fix-asset-upload`) — no prefixes, names or issue numbers.

## Creating the worktree

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
- Work exclusively inside `worktrees/<branch>` — **never** touch the main checkout.
- As per my guidelines, please don't commit changes yourself.

## Handing over

When you're done, respond with (in this order):

- Link to open the worktree in Tower.app (follow the `tower` skill — don't open it yourself)
- Summary of what you've changed
- Reproduction steps
  - When possible, please perform any set up steps in the sandbox site beforehand to streamline my review
- Link to the sandbox site

Don't wait to be asked for any of these.

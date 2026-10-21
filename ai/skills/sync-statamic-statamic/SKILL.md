---
name: sync-statamic-statamic
description: Sync recent commits from "statamic/statamic" and config changes from "statamic/cms" into the boilerplate statamic/statamic application.
---

The `statamic/statamic` repository contains the base application for new Statamic sites.

It is very similar to `laravel/laravel`, the base application for new Laravel apps. Our version changes some of the defaults to better suit Statamic's flat-first approach and provides boilerplate content and Statamic configs.

To avoid `statamic/statamic` becoming stale, we need to regularly review it for necessary changes. This skill details that process.

Before you begin, checkout the `6.x` branch and pull down any changes.

## 1. Sync with `laravel/laravel`

1. Find the latest "Sync with `laravel/laravel`" PR:

  ```
  gh pr list --state merged --search "Sync with `laravel/laravel`" --limit 1
  ```

2. Take note of the last commit message on that PR:

  ```
  gh pr view <PR_NUMBER> --json commits --jq '.commits[].messageHeadline'
  ```

3. Fetch the latest commits from `laravel/laravel`. Filter out the last commit we synced (and any older ones). Filter out any `Update CHANGELOG` or `Merge pull request ...` commits too.

  ```
  gh api "repos/laravel/laravel/commits" --jq '.[] | "\(.sha[0:7]) \(.commit.message | split("\n")[0])"
  ```

   When there isn't anything new to sync, move onto Section 2.

4. Create a new branch called `sync-laravel-laravel`. If one already exists, delete it and create a new one.

5. For each `laravel/laravel` commit:

  - Copy the changes from the `laravel/laravel` commit into this codebase.
  - Create a commit with the same message as the original, WITHOUT any references to PRs/Issues/Authors.

6. Once you've worked through the commits, push up the branch and open a pull request using the `gh` CLI. Please use the provided title and description (DO NOT change it).

  **Pull request title:** "Sync with `laravel/laravel`"
  **Pull request description:**
  ```
  This pull request syncs recent changes from [`laravel/laravel`](https://github.com/laravel/laravel/commits/13.x) to `statamic/statamic`.
  ```


## 2. Sync Statamic configs

1. Checkout the `6.x` branch.

2. Find the latest "Sync Statamic configs" PR:

  ```
  gh pr list --state merged --search "Sync Statamic configs" --limit 1
  ```

3. Take note of the last commit message on that PR:

  ```
  gh pr view <PR_NUMBER> --json commits --jq '.commits[].messageHeadline'
  ```

4. Fetch the latest commits from `statamic/cms` affecting the `config` directory. Filter out the last commit we synced (and any older ones).

  ```
  gh api "repos/statamic/cms/commits?path=config" --jq '.[] | "\(.sha[0:7]) \(.commit.message | split("\n")[0])"'
  ```

   When there isn't anything new to sync, don't continue.

5. Create a new branch called `sync-statamic-configs`. If one already exists, delete it and create a new one.

6. For each `statamic/cms` commit:

  - Copy changes from the `statamic/cms` commit affecting the `config` directory to this repository's `config/statamic` directory.
  - Create a commit with the same message as the original, WITHOUT any references to PRs/Issues/Authors.

7. Once you've worked through the commits, push up the branch and open a pull request using the `gh` CLI. Please use the provided title and description (DO NOT change it).

  **Pull request title:** "Sync Statamic configs"
  **Pull request description:**
  ```
  This pull request syncs the [recent changes](https://github.com/statamic/cms/commits/6.x/config) from the config files in `cms`.
  ```

---
name: tower
description: Open a Git repository or worktree in Tower.app, or produce a link that opens it. Use when the user says "open in tower", "open this in tower", "tower", or when another skill asks for a Tower link in its summary.
---

Open a repository in Tower.app.

## Which directory

Use the path the user gave. Otherwise, use the root of the repository you're working in:

```sh
git rev-parse --show-toplevel
```

Inside a worktree, that resolves to the worktree itself (eg. `~/Code/Statamic/cms/worktrees/1234`) rather than the main checkout, which is what we want.

## Opening it yourself

When the user asks you to open it:

```sh
gittower "/absolute/path/to/repo"
```

## Providing a link instead

When summarising work for the user to review later, don't open Tower yourself. Give them a link they can click when they get around to it, passing the absolute path as the `path` query parameter:

```
http://duncan.test/tower.php?path=/absolute/path/to/repo
```

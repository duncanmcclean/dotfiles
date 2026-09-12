---
name: vscode
description: Open a Git repository or worktree in VS Code, or produce a link that opens it. Use when the user says "open in vscode", "open this in code", "vscode", "vs code", or when another skill asks for a VS Code link in its summary.
---

Open a repository in VS Code.

## Which directory

Use the path the user gave. Otherwise, use the root of the repository you're working in:

```sh
git rev-parse --show-toplevel
```

Inside a worktree, that resolves to the worktree itself (eg. `~/Code/Statamic/cms/worktrees/1234`) rather than the main checkout, which is what we want.

## Opening it yourself

When the user asks you to open it:

```sh
code "/absolute/path/to/repo"
```

## Providing a link instead

When summarising work for the user to review later, don't open VS Code yourself. Give them a link they can click when they get around to it, using VS Code's own URL scheme with the absolute path:

```
vscode://file/absolute/path/to/repo
```

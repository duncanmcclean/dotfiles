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

## Worktrees with a sandbox site

When the worktree has its own sandbox site (see the `worktree` skill), open both in the same window as a multi-root workspace.

From the package root (the parent of `worktrees/`), find the worktree's sandbox URL:

```sh
tether worktree list
```

Each line is the branch, its status and the sandbox URL. A URL like `http://sandbox-1234.test` maps to `~/Code/Throwaway/sandbox-1234`. If the branch has no URL, or the directory doesn't exist, there's no sandbox. Just open the worktree on its own.

Otherwise, write a workspace file inside the sandbox, so it's removed along with the sandbox when the worktree is destroyed:

```sh
cat > ~/Code/Throwaway/sandbox-1234/sandbox-1234.code-workspace <<'JSON'
{
    "folders": [
        { "path": "/absolute/path/to/cms/worktrees/1234" },
        { "path": "/absolute/path/to/Throwaway/sandbox-1234" }
    ]
}
JSON
```

Use the workspace file in place of the repository path below.

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

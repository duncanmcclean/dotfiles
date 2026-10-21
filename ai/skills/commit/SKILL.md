---
name: commit
description: >-
  Commit pending changes using atomic commits. Use when the user asks to
  "commit", "commit my changes", or "make a commit". Groups related changes
  into separate logical commits. Never pushes. Stops on merge conflicts and
  asks before committing a mix of staged/unstaged changes.
---

Commit the working tree's pending changes as a series of atomic commits, each one a single logical change. Never push.

## 1. Check for merge conflicts

```sh
git status --porcelain
ls -1 .git/MERGE_HEAD 2>/dev/null
```

If a merge is in progress and there are conflicted files (`UU`, `AA`, `DD`, or other `U` markers), stop and tell me. Offer to resolve them, but if you do, let me review your resolution before committing anything.

## 2. Check what's staged

If there's a mix of staged and unstaged changes, I probably staged things on purpose. Ask whether to commit only what's staged, or everything, and wait for my answer.

If everything is unstaged, or everything is already staged, carry on.

## 3. Plan the commits

```sh
git diff
git diff --staged
```

Group the changes into atomic commits. Unrelated changes in the same file may need `git add -p` to split them.

## 4. Write the messages

Check `git log --oneline -20` for the repository's conventions, then follow my rules:

- Write commit messages in lowercase.
- Use backticks when mentioning class names, methods or config options.
- Never add yourself as a co-author. No `Co-Authored-By` trailers.

## 5. Commit each group

```sh
git add <paths>
git commit -m "<message>"
```

Always stage explicit paths. Never use `git add -A`, `git add .` or `git commit -a`. Don't amend existing commits unless I ask.

## 6. Report back

Don't push. List the commits you created with `git log --oneline`.

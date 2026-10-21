---
name: clipboard
description: Copy text to the macOS clipboard. Use when the user says "copy that", "copy to clipboard", "put that on my clipboard", "clipboard", or when another skill offers a copy-to-clipboard option.
---

Copy text to the clipboard with `pbcopy`.

## What to copy

- Copy exactly what the user pointed at. When they say "copy that" with nothing more specific, copy the last thing you produced for them — a description, a comment, a command, a snippet.
- Copy the raw content, not the markdown fence around it and not any commentary you wrote alongside it.

## How to copy it

Use a quoted heredoc so quotes, backticks and dollar signs survive untouched:

```sh
pbcopy <<'CLIPBOARD'
...
CLIPBOARD
```

Don't `echo "..." | pbcopy` — it mangles shell characters and appends a trailing newline.

## Afterwards

Confirm what's been copied in a few words. Don't repeat the content back.

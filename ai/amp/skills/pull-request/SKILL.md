---
name: pull-request
description: Write pull request descriptions that sound like they were written by Duncan.
---

Please write a pull request description using the rules below, then open the pull request for me.

# Before opening a PR
Before drafting a pull request description, please ensure that a non-default branch is being used and that all relevant changes have been committed and pushed up to the remote.

# Duncan's Guide to Authoring Pull Requests
Most pull requests will follow this format:

```md
This pull request fixes an issue where `cmd+k` to open the Bard link stack conflicts with `mod+k` to open the Command Palette.

This PR fixes it by opening the link stack when text is selected and opening the Command Palette when it's not.

Fixes #...
```

* Descriptions should always start with "This pull request ..." and go on to say fixes/implements/refactors/removes.
* When referring back to the PR (like mentioning another thing it does), refer to it with short-hand, like "This PR also ...".


## Bug fixes
When describing a bug fix, please use a similar format to the following:

```
This pull request fixes an issue where...

This was happening because...

This PR fixes it by...
```

When a PR contains multiple fixes (>= 3), please add bullet points for each fix.

```
* Fixes issue where...
   * This was happening because...
   * I've fixed it by...
* Fixes issue where...
   * This was happening because...
   * I've fixed it by...
   * Closes #...
```


## UI changes
When the pull request changes something in the UI, or introduces a new UI feature, space should be left for before & after screenshots.

```
## Before

TODO: Screenshot

## After

TODO: Screenshot
```

Leave the `TODO`s in place for me to fill in.


## Major changes
When a pull request contains major changes (eg. a new feature), feel free to add sections to provide context about different parts of the change. Especially if they add APIs for developers to hook into, or introduce a behaviour change.

When it comes time to document the feature, it would be nice if it was as simple as "copy and pasting" the PR description, so please keep that case in mind.


## Referencing issues/PRs
When necessary, you may reference GitHub issues or pull requests, like so:

```
Fixes #...
Closes #...
Related: #...
Caused by #...
```

* Use `Fixes` when the PR is a bug fix and fixes a bug.
* Use `Closes` when the PR is adding a new feature, or makes a behavioural change.
* Use `Related:` when referencing a GitHub discussion, or another PR on a similar topic.
* Use `Caused by` when referencing a PR which has directly caused the issue this PR is fixing.

Do **not** combine references on the same line. Each reference should live on its own line.

From time to time, you may need to reference issues/PRs from other repositories, in this case, you should provide the repository name:

```
Fixes statamic/eloquent-driver#...
```

When the PR description uses headings, a separator should be added between the end of the "content" and the references, like this:

```
Blah.
Blah.

## Before

![]()

## After

![]()

---

Fixes #...
Fixes #...
```

Please leave a new line both before/after the separator (`---`), as per the example above.

DO NOT add the `---` unless the PR description contains headings.

## AI credit

Do NOT include a credit string (`Generated with Claude Code` or similar) anywhere in the PR description.

## After completing the task

Open the pull request straight away with `gh pr create`, populating the title and body from the description. Don't show me the description first and don't ask whether to open it — I'll ask when I want to review one.

Pass the body through a quoted heredoc so backticks reach GitHub untouched — never escape them as `` \` ``:

```bash
gh pr create --title "..." --body-file - <<'EOF'
...
EOF
```

Some repositories I contribute to prefix PR titles with the version branch, eg. `[6.x] `. Check the most recent PRs with `gh pr list --limit 5 --json title` and match them. If the current branch is the default branch, warn me first.

Once it's open, reply with the PR link and nothing else.

### When I ask to review the description first

If I've asked to see, check or review the description before it goes up, reply with the full description in a fenced code block and nothing else — no question, no tool call. End your turn there, so the description is sitting in the conversation where I can read it.

Only once it's been sent, ask me "What would you like to do?" using whichever ask-the-user tool you have. If you have none, ask in plain text and wait for my answer. Offer these single-select options:

- "Open Pull Request" → open it as described above.
- "Copy to Clipboard" → copy the raw description with `pbcopy`, using a quoted heredoc (`pbcopy <<'CLIPBOARD'`) so quotes, backticks and dollar signs survive.

---
name: authoring-pull-requests
description: Learn how to write pull request descriptions that sound like Duncan.
---

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

When headings are used in a PR description, a separator should be added between the end of the "content" and the references, like so:

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

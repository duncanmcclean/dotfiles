---
name: crush-em-all
description: This skill identifies a handful of GitHub issues to fix, and fixes them.
disable-model-invocation: true
---

Please fetch the latest GitHub issues for this repository, rejecting those that:

- Are associated with an open pull request
- Are assigned to someone
- Are labelled with `can't recreate` or `needs more info`

From there, send the latest three (unless I've given you another number) issues to the `crush-issues` skill. It will handle the fixing process from there.

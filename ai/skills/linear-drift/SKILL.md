---
name: linear-drift
description: Find where Linear has drifted from GitHub — issues still open after their PR merged, work happening without a Linear issue, stale "In Progress" issues — and propose fixes for me to approve. Use when I say "check linear drift", "sync linear and github" or similar.
---

Compare Linear with what's actually happening on GitHub, and propose fixes. Most drift is Linear lagging behind GitHub, so treat GitHub as the source of truth unless something says otherwise.

This skill needs the Linear MCP, so run it on my work profile (`claudes`). Never change GitHub. Only change Linear, and only what I approve.

## Gather

From Linear (via the MCP), every issue that isn't Done or Canceled, across our teams, with its status, assignee, last update and any GitHub links (attachments, or PR/issue URLs in the description or comments).

From GitHub, for each linked PR or issue:

```sh
gh pr view <url> --json state,mergedAt,isDraft,reviewDecision,author
gh issue view <url> --json state,stateReason,closedAt
```

Then the other direction. PRs merged in the last two weeks on repos we track in Linear, which never got a Linear issue:

```sh
gh search prs --owner statamic --owner statamic-rad-pack --merged ">=<two weeks ago>" --json url,title,author,body --limit 200
```

A PR is linked when its branch, title or body mentions a Linear identifier (eg. `COM-123`), or a Linear issue links to it. Work out which repos we track in Linear from where the existing links point, rather than assuming.

## Look for drift

| What | Proposal |
|---|---|
| Linked PR merged, or linked issue closed as completed, but Linear still open | Move to Done |
| Linked issue closed as not planned | Move to Canceled |
| Linked PR open and ready for review, but Linear in Backlog or Todo | Move to In Review |
| Linked PR open as a draft, but Linear in Backlog or Todo | Move to In Progress |
| Linear In Progress or In Review, no linked PR and no activity for two weeks | Flag as stale, and name the assignee |
| PR merged by the team with no Linear issue, on a tracked repo | Flag it, and name the author |

Ignore dependency bumps, release PRs and PRs from outside the team.

## Report

Write it to a Solo scratchpad named `Linear drift`, replacing the previous report. Number every proposal so I can approve them by number.

Link every Linear issue and GitHub issue, PR or discussion you mention, in the scratchpad and when talking to me, so I can click straight through. Use the reference as the link text, eg. [COM-301](https://linear.app/statamic/issue/COM-301) or [statamic/cms#15760](https://github.com/statamic/cms/issues/15760).

```
- Checked at: Sat 31 Oct, 10:00

## Proposed changes

1. [COM-301](https://linear.app/statamic/issue/COM-301) Remove old Glide route — [PR](https://github.com/statamic/mouthnasium/pull/1601) merged 26 Oct → Done
2. [SEO-88](https://linear.app/statamic/issue/SEO-88) Sitemap N+1 — [PR](https://github.com/statamic/seo-pro/pull/705) ready for review → In Review

## Stale

- [COM-280](https://linear.app/statamic/issue/COM-280) Rework partner search — In Progress since 2 Oct, no PR (<assignee>)

## Merged without a Linear issue

- [statamic/mouthnasium#1612](https://github.com/statamic/mouthnasium/pull/1612) Tweak Horizon config (<author>)
```

Then summarise it in one line. When I approve ("apply 1, 2", "apply all"), make exactly those changes in Linear, then mark them as done in the scratchpad.

Never nag the team yourself, by commenting on Linear or GitHub. The stale and "no Linear issue" lists are for me to follow up on.

## Repeat

When I ask for it on a schedule, set a Solo timer (`timer_set`) with the message `/linear-drift` for the interval I gave, unless one is already pending (`timer_list`).

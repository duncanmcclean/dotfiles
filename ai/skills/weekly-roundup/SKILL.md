---
name: weekly-roundup
description: Draft my answer to Basecamp's weekly "what have you done this week?" check-in, from this week's Claude Code and Codex conversations in ~/Code/Statamic. Use when I ask for a "weekly roundup", "what did I do this week", "basecamp check-in" or similar.
---

Draft bullet points summarising what I worked on this week, for me to copy, tweak and post to Basecamp.

## Gather the week

Run `scripts/digest.py`, from this skill's directory:

```sh
python3 <skill directory>/scripts/digest.py
```

It reads every Claude Code session (both profiles) and Codex session under `~/Code/Statamic` since Monday, and prints one block per session: project, active time, branches, how many edits, commits and PRs it produced, my prompts and the agent's last reply. Pass `--since 2026-10-19` when I ask about a different week.

Sessions an agent spawned (eg. a handed-off review) and brief sessions with no changes are collapsed to one line each. They're there to count, not to summarise.

When a session's purpose isn't clear from the digest, read its transcript (the `Transcript` line in the digest), or the PR/issue it links to.

## Decide what made the cut

Keep my main things, the work that took real time or produced something:

- Changes that were committed, PR'd, merged or released.
- PR reviews, issue triage and releases.
- Investigations that mattered even without a code change, like looking into downtime, performance or a security report.

Leave out:

- Anything I only spent a few minutes on.
- Small, self-contained tweaks, like changing who's allowed to do something or pre-filling a field. Lump them into "Fixed a few smaller things" if there are a lot of them.
- Questions that didn't lead to changes.
- Housekeeping, like opening things in Tower, cleaning up worktrees or tweaking my dotfiles.

Merge sessions that were the same piece of work, eg. several sessions on one branch, or a fix and its follow-up.

## Write it

Match the tone and shape of this past roundup:

```
- Dot Com
  - Fixed some Sentry errors
  - Got rid of our Glide image controller for good. Cloudflare 🚀
  - Planned out the ordering for dropping Livewire for Vue
  - Started dropping Livewire components in favour of Vue
  - Reworked the "Most Popular" sort on the Marketplace to use active installs data
  - Added an enquiry form to the partner profile pages
- CMS
  - Reviewed a bunch of PRs
  - Fixed a couple of things
  - Added a Statamic User-Agent header to Outpost/API requests
  - Dealt with an invalid security issue
  - Investigated performance issues
  - Tagged a release
- SSG
  - Reviewed PRs
  - Tidied up GitHub Issues
  - Tagged a release
- Fixed a bug in Runway
- Merged & tagged a fix for SEO Pro
```

- One short line per item, past tense, in my voice. No PR numbers, links or branch names.
- Name notable work specifically. Lump small, similar things together: "Reviewed a bunch of PRs", "Fixed a couple of things", "Fixed some Sentry errors".
- Group by project: each project is a top-level bullet, with its items as sub-bullets. Use the names we use at work, not directory names: `statamic.com` is "Dot Com", `cms` is "CMS", `statamic.dev` is "Docs", `ssg` is "SSG", `seo-pro` is "SEO Pro". Title-case anything else.
- When I've only worked on CMS this week, skip the project bullets and give one flat list.
- A project with only one item doesn't get its own bullet. Put those items at the end as top-level bullets, naming the project in the line itself, eg. "Fixed a bug in Runway".
- Order projects by how much time I spent on them, most first. Within a project, order items by when I did them during the week, so it reads like a diary. Lumped items go where their work started.

Respond with just the roundup, so it's easy to copy. Then, separately, list anything you left out that I might want to add back.

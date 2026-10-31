---
name: triage-issues
description: Triage new issues across our public GitHub repos — propose labels and "needs more info" replies, file feature requests in Linear or the ideas repo, and hand bug reports to a fixer agent. Repeats hourly via a Solo timer. Use when I say "triage issues", "check for new issues" or start my morning triage.
---

Find issues opened since the last run on our public repos, work out what each one needs, and queue it up for me. I approve anything public, but fixer agents start straight away, since they only work locally.

This skill needs the Linear MCP, so run it on my work profile (`claudes`).

## Find new issues

```sh
gh search issues --owner statamic --owner statamic-rad-pack --state open --created ">=<since>" \
    --json url,title,body,labels,author,authorAssociation,repository,createdAt --limit 100
```

`<since>` is the timestamp in `~/.local/state/triage-issues/last-run`. When the file doesn't exist, use 24 hours ago. Save the current time to it once the run is done.

Skip issues:

- Listed in `~/.local/state/triage-issues/handled`, one URL per line. Append every issue you triage to it, so a timer that fires twice never handles one twice.
- Opened by the team (`authorAssociation` of `MEMBER` or `OWNER`). They triage their own.
- On private or archived repos. `gh search` only returns public ones, but double-check anything that looks internal.

## Work out what each issue is

Read the issue, and the repo's issue templates (`.github/ISSUE_TEMPLATE/`), then decide:

- **Bug report** — something's broken.
- **Feature request** — asking for something new, even when it's filed as a bug.
- **Question or support** — note it in the summary, nothing else.
- **Spam or nonsense** — note it in the summary, nothing else.

Plenty of issues are written by AI agents and ignore the template. Judge them by what they say, not how they're laid out.

When someone on the team has already replied or labelled the issue, build on what they've done rather than repeating it. Only propose what's still missing, like labels, and don't ask for information they've already asked for.

## Bug reports

### Labels

Propose labels from the repo's existing set only (`gh label list -R <repo>`). Never invent new ones. Pick the area labels a maintainer would (eg. `bard`, `assets`, `multisite` on cms) and, when it applies, `regression`, `performance` or `bug`.

### Enough information?

An actionable bug report has:

- What went wrong and what was expected.
- Steps to reproduce.
- The output of `php please support:details`, on repos whose template asks for it. Check the Environment section actually contains it, not a hand-typed version list.

When something's missing, propose the `needs more info` label plus a reply. Use my saved reply rather than writing one:

```sh
gh api graphql -f query='{ viewer { savedReplies(first: 50) { nodes { title body } } } }'
```

Pick the one asking for `support:details` (or reproduction steps, whichever's missing). If `gh` lacks the `read:user` scope, stop and tell me to run `gh auth refresh -s read:user`. Don't improvise a reply.

### Start a fixer

When the report is actionable and the repo has a Solo project (`list_projects`, matching the repo name to the project's directory), hand it to that project's "Bug Reports" agent:

1. Find the agent named "Bug Reports" with `list_processes` in that project.
2. If there isn't one, `spawn_agent` it with the "Claude (Statamic)" runtime, named "Bug Reports".
3. If it's stopped, start it again, so it gets a fresh session.
4. If it's busy, wait for it to go idle (`timer_fire_when_idle_any`) rather than interrupting.
5. `send_input` it: `/crush-issue <issue url>`. The `crush-issue` skill spins up its own per-issue agent, so the Bug Reports agent stays free for the next one.

No Solo project for the repo means no fixer. Say so in the summary.

Don't start a fixer for issues that need more info, or that look like duplicates of an open issue. Mention likely duplicates in the summary with a link to the original.

## Feature requests

- **SEO Pro and Runway** — propose a Linear issue in that addon's Linear project, with the GitHub issue linked and labels matching how the project's existing issues are labelled. Look the project up with the Linear MCP rather than guessing.
- **cms** — ask me whether to move it to `statamic/ideas`, where we keep feature requests. If I say yes, `gh issue transfer <url> statamic/ideas`.
- **Anything else** — propose the `feature request` label if the repo has one.

## Queue it for me

Write everything to a Solo scratchpad named `Issue triage`, appending each run under a `## <date and time>` heading. Number every proposal so I can approve them by number.

Link every Linear issue and GitHub issue, PR or discussion you mention, in the scratchpad and when talking to me, so I can click straight through. Use the reference as the link text, eg. [COM-301](https://linear.app/statamic/issue/COM-301) or [statamic/cms#15760](https://github.com/statamic/cms/issues/15760).

```
## Sat 31 Oct, 10:00

1. [statamic/cms#15760](https://github.com/statamic/cms/issues/15760) — Bard toolbar disappears in fullscreen (bug)
   - Labels: `bard`, `regression`
   - Fixer: started in cms
2. [statamic/seo-pro#712](https://github.com/statamic/seo-pro/issues/712) — Allow per-entry robots.txt rules (feature request)
   - Linear: create "Per-entry robots.txt rules" in SEO Pro, labelled `feature`
3. [statamic-rad-pack/runway#870](https://github.com/statamic-rad-pack/runway/issues/870) — Relationship fieldtype throws on save (bug)
   - Labels: `needs more info`, `relationships`
   - Reply: "Support details" saved reply
4. [statamic/cms#15761](https://github.com/statamic/cms/issues/15761) — Add a dark mode toggle to the login page (feature request)
   - Move to statamic/ideas?

Skipped: [statamic/ssg#240](https://github.com/statamic/ssg/issues/240) (question), [statamic/cms#15762](https://github.com/statamic/cms/issues/15762) (duplicate of [#15701](https://github.com/statamic/cms/issues/15701))
```

Then tell me in one line how many issues came in and how many need me. When I approve ("apply 1, 3", "apply all"), apply exactly those, then mark them as done in the scratchpad.

## Repeat

At the end of each run, set a Solo timer (`timer_set`) for 60 minutes from now with the message `/triage-issues`, unless one is already pending (`timer_list`). Stop repeating when I say so.

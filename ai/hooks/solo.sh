#!/bin/sh

[ -n "$SOLO_PROCESS_ID" ] || exit 0

cat <<'CONTEXT'
This session is running inside Solo (https://soloterm.com). When I ask for something Solo provides, I mean the Solo one. Reach for the `mcp__solo__*` tools rather than an equivalent of your own. I should never have to say "via Solo".

Agents: "spin up an agent", "sub-agents" or "hand that off" means a Solo agent, never your own built-in subagent system. Resolve the runtime with `list_agent_tools`, spawn it with `spawn_agent` (preferably on the same model as this session, unless I say otherwise) and send it the work with `send_input`.

Waiting on agents: after sending work, arm `timer_fire_when_idle_all` (or `_any` to react to the first one done) on the agents' process ids, then end your turn. Never use `timer_set` or a sleep sized to a guess of how long they'll take.

Scratchpads: plans, research and anything else you write for me to read belong in a Solo scratchpad (`scratchpad_write`, `_append`, `_read`, `_find`), never a markdown file left on disk.

Todos: "add a todo" or "what's left?" means Solo todos (`todo_create`, `_list`, `_update`, `_complete`), not the built-in task list.

Timers: "remind me in 20 minutes", "check back every minute" or "ping me when that's done" means a Solo timer (`timer_set`, `_list`, `_cancel`). Never sleep or poll in a Bash loop instead. A timer's message arrives as a fresh turn, so make it self-contained.

Naming: label every agent and process you spawn with the branch it belongs to (eg. `crush #1234 (1234)`), so its work can be traced and cleaned up later.
CONTEXT

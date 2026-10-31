#!/usr/bin/env python3
"""Digest this week's Claude Code and Codex sessions in ~/Code/Statamic into one block per session."""

import argparse
import json
import re
from datetime import datetime, timedelta, timezone
from pathlib import Path

HOME = Path.home()
STATAMIC = HOME / "Code" / "Statamic"
CLAUDE_PROFILES = [HOME / ".claude", HOME / ".claude-statamic"]
CODEX_SESSIONS = HOME / ".codex" / "sessions"

IDLE_GAP = timedelta(minutes=10)
BRIEF_MINUTES = 5
PROMPT_LIMIT = 200
PROMPTS_PER_SESSION = 8
SUMMARY_LIMIT = 400

EDIT_TOOLS = {"Edit", "Write", "MultiEdit", "NotebookEdit"}
URL_PATTERN = re.compile(r"https://(?:github\.com|linear\.app|[\w-]+\.sentry\.io)/[^\s)\"'>\]`]+")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--since", help="ISO date to start from (defaults to this Monday)")
    args = parser.parse_args()

    since = start_of_week() if args.since is None else datetime.fromisoformat(args.since).astimezone()

    sessions = [*claude_sessions(since), *codex_sessions(since)]
    sessions = [session for session in sessions if session and session["prompts"]]
    sessions.sort(key=lambda session: (session["project"], session["started"]))

    print(f"Sessions since {since:%A %d %B %Y}: {len(sessions)}\n")

    for session in sessions:
        print(render(session))


def start_of_week():
    today = datetime.now().astimezone().replace(hour=0, minute=0, second=0, microsecond=0)
    return today - timedelta(days=today.weekday())


def claude_sessions(since):
    prefix = "-" + str(STATAMIC).strip("/").replace("/", "-").replace(".", "-") + "-"

    for profile in CLAUDE_PROFILES:
        for directory in (profile / "projects").glob(prefix + "*"):
            for path in directory.glob("*.jsonl"):
                if modified_since(path, since):
                    yield claude_session(path, since)


def claude_session(path, since):
    session = new_session("Claude", path)

    for entry in read_jsonl(path):
        timestamp = parse_timestamp(entry.get("timestamp"))
        if timestamp is None or timestamp < since or entry.get("isSidechain"):
            continue

        session["timestamps"].append(timestamp)
        session["cwds"].add(entry.get("cwd"))
        session["branches"].add(entry.get("gitBranch"))

        content = (entry.get("message") or {}).get("content")

        if entry.get("type") == "user" and not entry.get("isMeta") and not entry.get("isCompactSummary"):
            add_prompt(session, claude_prompt(content))

        if entry.get("type") == "assistant" and isinstance(content, list):
            for block in content:
                if block.get("type") == "text":
                    session["last_reply"] = block.get("text", "")
                if block.get("type") == "tool_use":
                    record_tool_use(session, block.get("name"), block.get("input") or {})

    return finish(session)


def claude_prompt(content):
    if isinstance(content, list):
        if any(block.get("type") == "tool_result" for block in content):
            return None
        content = " ".join(block.get("text", "") for block in content if block.get("type") == "text")

    if not isinstance(content, str):
        return None

    command = re.search(r"<command-name>(.*?)</command-name>", content, re.S)
    if command:
        arguments = re.search(r"<command-args>(.*?)</command-args>", content, re.S)
        return f"{command.group(1).strip()} {arguments.group(1).strip() if arguments else ''}"

    return content


def record_tool_use(session, name, tool_input):
    if name in EDIT_TOOLS:
        session["edits"] += 1

    if name == "Bash":
        record_command(session, tool_input.get("command", ""))


def codex_sessions(since):
    for path in CODEX_SESSIONS.glob("*/*/*/*.jsonl"):
        if modified_since(path, since):
            session = codex_session(path, since)
            if session and is_statamic(session["cwds"]):
                yield session


def codex_session(path, since):
    session = new_session("Codex", path)

    for entry in read_jsonl(path):
        payload = entry.get("payload") or {}

        if entry.get("type") == "session_meta":
            session["cwds"].add(payload.get("cwd"))
            session["branches"].add((payload.get("git") or {}).get("branch"))

        timestamp = parse_timestamp(entry.get("timestamp"))
        if timestamp is None or timestamp < since or entry.get("type") != "response_item":
            continue

        session["timestamps"].append(timestamp)

        if payload.get("type") == "message":
            text = " ".join(block.get("text", "") for block in payload.get("content") or [])
            if payload.get("role") == "user":
                add_prompt(session, text)
            if payload.get("role") == "assistant":
                session["last_reply"] = text

        if payload.get("type") in ("custom_tool_call", "function_call"):
            call = str(payload.get("input") or payload.get("arguments") or "")
            if "apply_patch" in call or payload.get("name") == "apply_patch":
                session["edits"] += 1
            record_command(session, call)

    return finish(session)


def record_command(session, command):
    if "git commit" in command:
        session["commits"] += 1
    if "gh pr create" in command:
        session["pull_requests"] += 1
    if re.search(r"gh (pr review|pr comment|pr merge|release create|workflow run)", command):
        session["github_actions"].add(re.search(r"gh \w+ \w+", command).group(0))


def new_session(tool, path):
    return {
        "tool": tool,
        "path": path,
        "timestamps": [],
        "cwds": set(),
        "branches": set(),
        "prompts": [],
        "urls": set(),
        "edits": 0,
        "commits": 0,
        "pull_requests": 0,
        "github_actions": set(),
        "last_reply": "",
    }


def add_prompt(session, text):
    if not text or not text.strip():
        return

    text = text.strip()
    if text.startswith(("<", "Caveat:", "# AGENTS.md", "[Request interrupted", "[Solo timer")):
        return

    session["urls"].update(URL_PATTERN.findall(text))
    session["prompts"].append(" ".join(text.split()))


def finish(session):
    if not session["timestamps"]:
        return None

    timestamps = sorted(session["timestamps"])
    active = sum(
        (later - earlier for earlier, later in zip(timestamps, timestamps[1:]) if later - earlier <= IDLE_GAP),
        timedelta(),
    )

    session["started"] = timestamps[0]
    session["active_minutes"] = round(active.total_seconds() / 60)
    session["project"] = project_name(session["cwds"])
    session["branches"].discard(None)
    session["branches"].discard("HEAD")

    return session


def project_name(cwds):
    for cwd in sorted(filter(None, cwds)):
        path = Path(cwd)
        if path.is_relative_to(STATAMIC) and path != STATAMIC:
            return path.relative_to(STATAMIC).parts[0]
    return "unknown"


def is_statamic(cwds):
    return project_name(cwds) != "unknown"


def render(session):
    if is_spawned(session):
        return render_spawned(session)

    if is_brief(session):
        return render_brief(session)

    prompts = session["prompts"]
    shown = prompts[:PROMPTS_PER_SESSION]

    lines = [
        f"## {session['project']} — {session['started']:%a %d %b %H:%M} ({session['tool']}, {session['active_minutes']} active mins)",
        f"Transcript: {str(session['path']).replace(str(HOME), '~')}",
        f"Branches: {', '.join(sorted(session['branches'])) or '-'}",
        f"Changes: {session['edits']} edits, {session['commits']} commits, {session['pull_requests']} PRs opened"
        + (f", {', '.join(sorted(session['github_actions']))}" if session["github_actions"] else ""),
    ]

    if session["urls"]:
        lines.append(f"Links: {' '.join(sorted(session['urls']))}")

    lines.append("Prompts:")
    lines.extend(f"- {truncate(prompt, PROMPT_LIMIT)}" for prompt in shown)

    if len(prompts) > len(shown):
        lines.append(f"- … {len(prompts) - len(shown)} more")

    if session["last_reply"]:
        lines.append(f"Last reply: {truncate(' '.join(session['last_reply'].split()), SUMMARY_LIMIT)}")

    return "\n".join(lines) + "\n"


def is_spawned(session):
    return "spawned by another session" in session["prompts"][0]


def render_spawned(session):
    task = session["prompts"][0].split(" Original request:")[0].split(" — original request:")[0]
    return f"- {session['project']} — {session['started']:%a %H:%M} spawned agent: {truncate(task, 120)}\n"


def is_brief(session):
    changed = session["edits"] or session["commits"] or session["pull_requests"] or session["github_actions"]
    return session["active_minutes"] < BRIEF_MINUTES and not changed


def render_brief(session):
    return f"- {session['project']} — {session['started']:%a %H:%M} brief, no changes: {truncate(session['prompts'][0], 120)}\n"


def truncate(text, limit):
    return text if len(text) <= limit else text[:limit] + "…"


def modified_since(path, since):
    return datetime.fromtimestamp(path.stat().st_mtime, timezone.utc) >= since


def parse_timestamp(value):
    if not value:
        return None
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return None


def read_jsonl(path):
    with path.open(errors="replace") as file:
        for line in file:
            try:
                yield json.loads(line)
            except json.JSONDecodeError:
                continue


if __name__ == "__main__":
    main()

---
name: caffeine
description: Keep a Mac awake (caffeinate) or let it sleep again (decaffeinate) so remote sessions are not interrupted by idle sleep. Use whenever the user wants the Mac to stay awake, stop sleeping, or stay reachable for remote access — and equally whenever they want to undo that. Trigger on "caffeinate", "decaffeinate", "keep my Mac awake", "stop my Mac sleeping", "let it sleep again", "is my Mac still awake", or when starting or finishing a remote/SSH/Claude Code session where sleep would interrupt the work.
---

# Mac caffeine

Three commands. The only thing that matters is running them in this exact form.

## On

```bash
nohup caffeinate -ims >/dev/null 2>&1 & disown
```

Do not run bare `caffeinate` — it blocks until interrupted, which hangs the session it was
meant to protect. `nohup ... & disown` detaches it so it survives the shell, the SSH
connection, and the agent process going away.

Flags: `-i` prevent idle system sleep, `-m` keep disks awake, `-s` prevent sleep on mains
power. Add `-d` only if the user wants the screen kept on — remote work does not need it.

To make it expire on its own, add `-t <seconds>` before the `&`. Offer this when the user
names a timeframe; it avoids a forgotten session keeping the machine awake indefinitely.

## Off

```bash
pkill -x caffeinate
```

This stops every `caffeinate` on the machine. Usually correct. If the user runs other
tools that hold sleep assertions, check `pgrep -lf caffeinate` first and kill by PID.

## Status

```bash
pmset -g assertions | grep -iE 'PreventUserIdleSystemSleep|PreventSystemSleep'
```

This is macOS's own answer, not "is the process alive", so it is the thing to trust when
behaviour disagrees with expectations.

## Reporting back

One line. Confirm it is on and how to undo it, or confirm normal sleep is restored. When
the user signals they are finishing up, ask whether to decaffeinate rather than silently
leaving it running.

## Clamshell notes

A MacBook in clamshell — lid shut, on mains power, external display attached — runs
normally, so `caffeinate` applies as usual. The lid is not the problem. Losing power or the
external display is: the Mac sleeps instantly and nothing in userspace prevents that.

For a Mac that permanently lives in clamshell as a remote box, per-session caffeinating is
the wrong tool. Suggest the persistent settings instead:

```bash
pmset -g custom | grep -A 12 'AC Power'   # record current values before changing
sudo pmset -c sleep 0                     # never idle-sleep on mains power
sudo pmset -c womp 1                      # allow network traffic to wake it
```

`womp` matters in clamshell because there is no keyboard to press if it does sleep.

These persist across reboots until explicitly reversed (`sudo pmset -c sleep <original>`),
unlike `caffeinate`, which stops when the process stops or the machine restarts. Say so —
invisible persistent state is the thing the user will forget about later.

## When sleep is not actually the problem

If a remote session still drops, check before assuming this failed: Wi-Fi dropping on
idle, the SSH server or Tailscale not running, or the job not being under `tmux`/`screen`
so it dies with the connection rather than with the machine.

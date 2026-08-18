# Hooks

A **skill** runs when you ask for it. A **hook** runs on its own, when something
happens — Claude finishes a reply, edits a file, starts a session. A skill is
new abilities. A hook is new habits.

Each file here is one working hook, adapted from tooling that runs daily. Nothing
is a mock-up.

## What's in here

| Hook | Fires on | What it does |
|---|---|---|
| `done.sh` | Stop | Writes a line to `~/claude-done.log` every time Claude finishes. The first hook from the class — the smallest one that proves the idea. |
| `recap-deck.sh` | Stop | After a substantial session, asks Claude once to publish a short recap slide deck of the work. The real hook the class is built around. |

## Installing a hook — two steps, not one

Skills are picked up the moment their folder exists. **Hooks are not.** A hook has
to be copied *and* registered. That second step is the whole difference.

**1. Copy the script and make it runnable:**

```bash
mkdir -p ~/.claude/hooks
cp start-with-ai/hooks/done.sh ~/.claude/hooks/done.sh
chmod +x ~/.claude/hooks/done.sh
```

**2. Register it in `~/.claude/settings.json`** under the event it listens for:

```json
{
  "hooks": {
    "Stop": [
      { "hooks": [ { "type": "command",
        "command": "bash {{HOME}}/.claude/hooks/done.sh" } ] }
    ]
  }
}
```

Replace `{{HOME}}` with your real home path — run `echo $HOME` to get it. `~`
does not always expand inside JSON, so use the full path.

**Prove it fired:**

```bash
cat ~/claude-done.log
```

Two triggers, two lines. Empty file means it did not fire — check the three
things below.

## When a hook does not run

A hook needs exactly three things. When one is empty, it is one of these:

1. **The path is wrong** — use the real path from `echo $HOME`, not `~`.
2. **The script is not executable** — did you run `chmod +x`?
3. **The JSON is invalid** — one missing comma and the whole file is ignored.
   Ask Claude *"is my settings.json valid?"*

## Running two hooks on one event

The `Stop` array holds a list. Add more `{ "type": "command", ... }` entries to
run several hooks when Claude finishes — a speaking one, a logging one, the recap
deck. They run in order.

## The events

`done.sh` and `recap-deck.sh` both use **Stop**. Other events fire at other
moments — before a tool runs, after a file is edited, when a session starts.
Same shape every time: *on this event, run that command.* New hooks land here as
we build them.

## The one rule worth stealing

A hook that only reads and reports is safe to leave running. A hook that changes
or sends things should show you first, or be one you wrote on purpose. `done.sh`
only appends to a log. `recap-deck.sh` only *asks* Claude to build something —
you still see it before anything is published.

## License

MIT. Take these, change them, teach them to someone else.

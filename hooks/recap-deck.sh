#!/usr/bin/env bash
# Stop hook: after a substantial chunk of work, ask Claude once to publish a
# simple, responsive HTML recap deck walking through what it did.
#
# Fires at most ONCE per session (sentinel file), and only when the session has
# done real work (tool-call count over threshold). Never blocks otherwise.
#
# Exit 0 with no output  -> stop normally.
# Prints {"decision":"block",...} -> Claude continues and builds the deck.

set -uo pipefail

THRESHOLD="${RECAP_DECK_THRESHOLD:-25}"   # tool calls that count as "substantial"
STATE_DIR="${TMPDIR:-/tmp}/claude-recap-deck"
mkdir -p "$STATE_DIR" 2>/dev/null || exit 0

input="$(cat)" || exit 0

session_id="$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null)"
transcript="$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)"

# No session id -> nothing to dedupe against; stay silent.
[ -n "$session_id" ] || exit 0

sentinel="$STATE_DIR/${session_id}.done"
[ -e "$sentinel" ] && exit 0

# Gauge effort from the transcript. If unreadable, do nothing rather than guess.
[ -n "$transcript" ] && [ -r "$transcript" ] || exit 0

tool_calls="$(grep -o '"type":"tool_use"' "$transcript" 2>/dev/null | wc -l | tr -d ' ')"
[ -n "$tool_calls" ] || exit 0
[ "$tool_calls" -ge "$THRESHOLD" ] 2>/dev/null || exit 0

# Mark first so a failure downstream can't loop us.
: > "$sentinel"

cat <<'JSON'
{"decision":"block","reason":"Before finishing: publish a short recap deck of the work you just completed.\n\nWrite a self-contained HTML slide deck to your scratchpad directory and publish it with the Artifact tool (load the artifact-design skill first).\n\nRules:\n- KEEP THE SLIDES SIMPLE. One idea per slide. A headline plus at most ~4 short lines or a small table. No dense paragraphs.\n- Cover: what the task was, what you actually did, what you found or changed, and what is left for the user to do.\n- Quote real evidence (paths, numbers, commands) over adjectives. If something failed or is unverified, give it a slide.\n- MUST BE RESPONSIVE: readable on a phone and a desktop. Use relative units, flex/grid, max-width:100% on media, and let any wide table or code block scroll inside its own overflow-x:auto container so the page body never scrolls sideways.\n- Support light and dark themes via prefers-color-scheme plus :root[data-theme=...] overrides.\n- Arrow keys / click to move between slides; show a slide counter.\n\nThen give the user the artifact URL in one line. Do not re-summarize the deck's contents in chat."}
JSON
exit 0

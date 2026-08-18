# Start With AI

Workshop materials — organizing your life and your business with an AI assistant
that actually knows your work.

Everything here is a working skill, adapted from tooling that runs daily against
real calendars, real inboxes, and real project boards. Nothing is a mock-up.

## What's in here

| Skill | What it does |
|---|---|
| `skills/business-cards/` | A photo of a business card becomes a contact, a task, a draft email, and an archived original |
| `skills/morning-plan/` | Weather, today's schedule, the travel gaps and collisions hiding in it, then a plan you approve |
| `skills/daily-briefing/` | Reads every inbox you have and answers one question: what needs you today |
| `skills/email-triage/` | Sorts what's actually waiting on you, drafts replies, and never sends anything |
| `skills/screenshot-routing/` | A screenshot of a text or notification becomes an event, a task, a contact, or a reply — without inventing the date |

Supporting reading:

- [`docs/what-is-a-skill.md`](docs/what-is-a-skill.md) — the whole concept in one page
- [`docs/setup.md`](docs/setup.md) — from nothing to your first working skill
- [`docs/credentials.md`](docs/credentials.md) — connecting real accounts without leaking keys
- [`docs/flowcharts.md`](docs/flowcharts.md) — how each skill actually runs

## Hooks — the next step

A skill runs when you ask. A **hook** runs on its own, when something happens.
The `hooks/` folder holds working examples:

| Hook | Fires on | What it does |
|---|---|---|
| [`hooks/done.sh`](hooks/done.sh) | Stop | Logs a line every time Claude finishes — the smallest hook that proves the idea |
| [`hooks/recap-deck.sh`](hooks/recap-deck.sh) | Stop | Asks Claude to publish a recap deck after a substantial session |

Unlike skills, a hook must be **copied and registered** — see
[`hooks/README.md`](hooks/README.md).

## Quick start

You need [Claude Code](https://claude.com/claude-code) installed and signed in.

```bash
git clone https://github.com/VanderpoolTeacher/start-with-ai.git
mkdir -p ~/.claude/skills
cp -r start-with-ai/skills/* ~/.claude/skills/
```

That's the install. Skills are picked up as soon as the folder exists — no
restart, no registration step. Start Claude Code and say *"good morning"* or
*"catch me up"* and the matching skill fires.

## Before they work: fill in the placeholders

Every skill ships as a template. Personal values appear as double braces and
must be replaced before the skill is useful:

| Placeholder | What to put there |
|---|---|
| `{{USER_NAME}}` | Your name, as the assistant should refer to you |
| `{{HOME_CITY}}` | City and state for weather, e.g. `Toledo,OH` |
| `{{DRIVE_ROOT}}` | Absolute path to your cloud drive, if you have one mounted |
| `{{TASK_BOARD_ID}}` | Your Trello board ID, if you use Trello |
| `{{ARCHIVE_DIR}}` | Where scanned originals should be filed |

Grep for what's left:

```bash
grep -rn "{{" ~/.claude/skills/
```

A skill with unreplaced placeholders will still run — it will just ask you the
questions the placeholder was supposed to answer.

## The one rule worth stealing

**Reads are free. Writes ask first. Sends never happen.**

Every skill here is read-only until it has shown you what it plans to do. The
briefing skills never mark anything read. The email skill drafts and stops —
you press send. This is not a limitation, it's the reason these are usable on
a real inbox instead of a test account.

## Requirements

- Claude Code
- For calendar/email/task skills: the matching connectors enabled in Claude
- For the Trello scripts: a free API key and token (see `docs/credentials.md`)
- No paid API keys are required for the weather lookup — it uses `wttr.in`

## License

MIT. Take these, change them, teach them to someone else.

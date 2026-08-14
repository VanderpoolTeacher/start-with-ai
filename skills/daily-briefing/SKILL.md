---
name: daily-briefing
description: Use when the user asks to be brought up to speed, wants a briefing, or types /catchup — gathers email, calendar, tasks, and chat into one action-oriented briefing of what needs them today.
---

# Daily briefing

Several sources, one question answered: **what needs {{USER_NAME}} today?**

This is read-only. Nothing gets sent, moved, replied to, or marked read. The
briefing ends with a numbered list of things they *could* do; they pick one or
ignore it.

## The filter

Every item earns its place by answering yes to one of these:

- Someone is blocked on them.
- Something is due, overdue, or happening today.
- They started something and left it unfinished — an unsent draft, a
  half-scheduled post.

FYI traffic, newsletters, CC-only threads, "thanks!" replies, and tasks with no
due date do not appear. **A short briefing is a correct briefing.**

## Step 1 — Establish the window

Keep the last-run timestamp in a state file:

```bash
mkdir -p ~/.claude/state
cat ~/.claude/state/briefing-last-run 2>/dev/null || echo "FIRST-RUN"
date -u +%Y-%m-%dT%H:%M:%SZ
```

- **No file** → look back 24 hours and say so in the header.
- **Under 2 hours ago** → widen to 24h and say why.
- Otherwise use the stored timestamp.

Write the new timestamp **only after the briefing prints successfully**, so a
crashed run doesn't silently skip a day.

## Step 2 — Gather, in parallel

Fire every source in one message. A source that fails gets one line
(`Chat: unavailable — connector not loaded`) and the briefing continues. Never
block the whole briefing on one dead connector.

**Email** — four passes:

| Purpose | Roughly |
|---|---|
| New, addressed to them | `to:me` in the window, minus promotions/social/updates |
| Gone quiet on them | `to:me is:unread older_than:3d newer_than:21d` |
| **What they already answered** | `in:sent` in the window |
| Their own loose ends | list drafts |

**Run the sent query every time and read it before writing a line.** Mail
clients sometimes put a reply in a brand-new thread containing only that one
sent message — so `to:me` can't match it, and the original thread still looks
like it's waiting. Before any item claims someone is waiting, confirm no sent
message answers it. **Match on recipient and subject, not thread ID** — the
thread ID is exactly what differs.

Three more things the queries get wrong that you fix by reading:

1. **They match whole threads, so their own sent mail comes back.** A thread only
   counts if the *last* message is from someone else.
2. **Automated mail slips through uncategorized.** Drop `no-reply@`,
   `do-not-reply@`, board notifications, digest robots.
3. **Calendar invite responses are mostly noise.** An accept is noise. A
   *decline* on something this week is signal — it may have just emptied a slot.

For drafts, read enough of each to name the recipient and subject. An unsent
draft is a top-tier signal.

**Calendar** — today in full: time, title, attendee count, location. Then the
rest of the week as titles and days only. Flag TBD or empty locations.

**Tasks** — dates only. Assignment is not a signal; there may be hundreds of
assigned tasks with no due date, and they're a backlog, not a briefing.

**Chat** — DMs and mentions since the window opened, then threads they replied in
that have newer replies. Report only those where the last message isn't theirs.

## Step 3 — Correlate before you write

This is the whole reason the sources are read in one context:

- Same person in two places → **one** line, not two. "Adam emailed about the
  proposal and his task is 2 days overdue" beats two separate entries.
- A task due today with a meeting about it today → one line, both facts.
- An unsent draft to someone who has since followed up → lead with that. It's
  the most embarrassing item on the list and the easiest to fix.

## Step 4 — Write it

```
# Briefing — Thu Aug 6, 9:14 AM
Since Wed Aug 5, 8:02 AM · 25h

## Needs you today
Julia is blocked on your invoice answer — draft written yesterday, never sent.

## Today
9:00   Foundation sync · 3 attendees
2:00   Recording · time TBD, location TBD

## Waiting on you
Email    Adam — draft unsent since yesterday
Tasks    Decide the free offer — due today

## Could do next
1. Send the Julia draft
2. Set the recording time
```

Rules for the prose:

- **"Needs you today" is at most 3 lines.** If everything is urgent, nothing is.
  If nothing qualifies, say `Nothing is blocking.`
- Full sentences there. Terse columns everywhere else.
- **Say what the person actually wants, not that mail arrived.** "Adam is waiting
  on a date for the walkthrough" — never "you have an email from Adam."
- Drop any section that's genuinely empty. Don't print `## Chat — nothing`.
- Numbered actions are concrete and single-step. "Send the Julia draft" is an
  action; "handle email" is not.

## Step 5 — Stop

Print it, write the timestamp, and wait. **Do not start on item 1 because it
looks obvious.**

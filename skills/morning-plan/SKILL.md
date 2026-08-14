---
name: morning-plan
description: Use when the user starts their day, says good morning, or types /morning — weather, where they physically have to be, the collisions hiding in today's calendar, and a short plan they approve before anything is written.
---

# Morning

One question: **what does today look like, and where do I have to be?**

Steps 1–5 are read-only. Step 6 is the only place anything gets written, and it
waits for a yes.

## Step 1 — Weather

No API key, no connector, no browser:

```bash
curl -s --max-time 12 "https://wttr.in/{{HOME_CITY}}?format=j1"
```

Parse `current_condition[0]` and `weather[0]`: temp, feels-like, the day's
min/max, sunrise, sunset, and the `hourly` entries **at the times they are
actually outside**.

**Then check the calendar and confirm the city is right.** If today's events are
somewhere else, pull that location too and say which is which. Never report home
weather for a day spent elsewhere.

Report it for decisions, not decoration:

- What to wear, if the range is wide.
- Rain **at the hours they're out**, not the daily average. A 7% afternoon and a
  60% 5:00 PM are different days when there's a pickup at 5:15.
- Sunset, when the evening runs somewhere.

Three lines. If the weather changes no decision, one line.

## Step 2 — The shape of the day

Pull **today only**, ordered by start time, and **always pass the IANA timezone
name** (`America/New_York`), never a raw UTC offset — offsets break recurring
events at the daylight-saving boundary.

Every event gets time, title, and **place**. Then:

- **Flag any empty or TBD location.** Those are the ones that bite. A recording
  at 2:00 with no address is a problem at 1:45.
- Separate the fixed furniture — recurring blocks they already know about — from
  things involving other people.
- Note anything they haven't responded to yet.

## Step 3 — Geography

Keep a table of recurring addresses so they never have to be looked up:

| Place | Address |
|---|---|
| {{PLACE_1}} | {{ADDRESS_1}} |
| {{PLACE_2}} | {{ADDRESS_2}} |

When two consecutive events sit at different addresses, **say the gap out loud
in minutes.** Across downtown is a walk. Across the county is not.

If three or more things land in one area, say so — that's the stretch to batch
errands into, and it isn't visible from a list.

## Step 4 — Connections

The whole reason this skill exists. Look for:

- **Impossible pairs.** One ends at 3:00 across town, the next starts at 3:00
  downtown. That's not a full calendar, it's a broken one. Say which has to move.
- **Family commitments the workday runs into.** A workshop until 5:00 and a
  pickup at 5:15 across town — the two live in different parts of their head.
- **A person on today's calendar who also has an open thread.** One line, not
  two: "answer it before you're sitting across from her."
- **A task due today whose meeting is also today.**
- **Travel that eats a block.** A 90-minute gap with a 20-minute drive at each
  end is a 50-minute gap.

Three or four at most. If there are none, say the day is clean — that's worth
knowing too.

## Step 5 — What today asks

Short. Only what is genuinely today: someone blocked on them, something due,
something left unfinished.

## Step 6 — The plan

**Compute the real open time first.** Take the day's span, subtract meetings,
subtract the fixed blocks, subtract travel. State it plainly:

> 3h10m open, in two pieces — 9:00–11:00 and 3:30–4:40.

Most morning plans fail because they pretend the day is empty. It never is.

Then **shortlist 5–7 candidates, ranked, one line each on why it earned the
slot**, with a rough size so it can be matched to a gap. Draw from tasks with
live due dates, people blocked on them, and unfinished work from yesterday.

**Commitments with a hard external date outrank everything.** A proposal
promised for a meeting six days out beats a task that's been overdue for six
days and will still be there tomorrow.

**They pick up to three.** If the picks don't fit the open time, say so rather
than pretending they fit.

**On their yes — and only then — write the blocks:**

- No attendees, notifications suppressed
- Titled so they're unmistakably self-blocks
- **Re-read every event after writing it.** "No error" is not confirmation.

Then **name what was shortlisted and not picked**, explicitly, as *not today*.
That turns a thing that quietly slid into a thing they decided.

## Rules

- **Read-only through step 5.** Nothing created, moved, sent, or marked read.
- **Never resolve a relative date** out of an email or a task. "Tuesday at 3"
  has no year. Anchor it from the calendar or ask.
- **Never send anything.**
- **Do not touch existing calendar events.** New blocks only.
- If a source fails, give it one line and keep going.

# What a skill actually is

A folder with a markdown file in it. That's the whole technology.

```
~/.claude/skills/
└── morning-plan/
    └── SKILL.md
```

No install step, no config file, no restart. The folder exists, so the skill
exists.

## The two parts

Every `SKILL.md` opens with frontmatter — a name and a description — followed by
instructions written in plain English.

```markdown
---
name: morning-plan
description: Use when the user starts their day or says "good morning" —
  weather, where they have to be, the collisions hiding in today's calendar.
---

# Morning

One question: what does today look like, and where do I have to be?

## Step 1 — Weather
...
```

**The description is the trigger.** It is not documentation for humans — it is
what the assistant reads to decide whether this skill applies to what you just
said. A description that says *what the skill does* fires unreliably. One that
says *when to use it* fires correctly:

| Weak | Strong |
|---|---|
| "Generates a morning report" | "Use when the user starts their day or types /morning" |
| "Email helper" | "Use when the user asks what's in their inbox, who is waiting on them, or wants a reply drafted" |

Name the situations, not the features.

**The body is the procedure.** Numbered steps, the exact tools or commands to
use, and — most importantly — the things that have gone wrong before.

## Why this beats a long prompt

You could paste the same instructions into a chat every morning. Three reasons
not to:

1. **It fires on its own.** You say "good morning," the skill loads. You don't
   have to remember you wrote it.
2. **It accumulates.** Every time the procedure gets something wrong, you add a
   line. Six weeks later the skill encodes six weeks of corrections, and it is
   worth more than the day you wrote it.
3. **It travels.** A folder can be copied, versioned, and handed to someone else.
   A habit of pasting a prompt cannot.

## The part people skip

The most valuable lines in a mature skill are not the steps. They are the
warnings — the specific, dated, hard-won notes about what breaks:

> Use `category:`, **not** `in:`, for promotions — `in:` only accepts archive,
> snoozed, trash, sent, and inbox, and silently matches nothing here.

> Always pass the IANA timezone name, never a raw UTC offset — offsets break
> recurring events at the daylight-saving boundary.

> A thread only counts as waiting on you if the *last* message is from someone
> else. Check the sent folder before claiming anyone is blocked.

Each of those exists because something went wrong once. Writing it down is the
difference between a tool that gets better and a tool that makes the same
mistake forever.

**When your assistant gets something wrong, don't just correct it in the moment
— open the skill and add the line.** That habit is the entire practice.

## How specific should it be?

Specific enough that a stranger could follow it. Vague instructions produce
vague work:

| Vague | Specific |
|---|---|
| "Check the calendar" | "Pull today only, ordered by start time, and flag any event with an empty location" |
| "Summarize the email" | "Say what the person wants, not that mail arrived. 'Adam needs a date for the walkthrough,' never 'you have an email from Adam.'" |
| "Don't do anything risky" | "Read-only through step 5. Step 6 writes, and only after a yes." |

## Try it

Write a skill for the thing you explained to someone twice this month. That is
almost always the right first skill.

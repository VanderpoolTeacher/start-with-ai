---
name: email-triage
description: Use when the user asks what is in their inbox, who is waiting on them, what they have missed, or wants a reply drafted. Sorts what genuinely needs them, drafts replies on request, and never sends anything.
---

# Email triage

Two jobs: **work out who is actually waiting**, and **draft the replies they
ask for**. Never send.

## The hard boundary

The assistant drafts. The human sends. Every time, with no exceptions and no
"this one is obviously fine."

Not because the drafts are bad — because a sent email cannot be unsent, and the
one time the tone is wrong is the time it goes to the person who matters most.

## Step 1 — Pull the window

Default to since-yesterday unless they say otherwise. Ask if it's ambiguous;
"catch me up on email" after a week away is a different query than after lunch.

## Step 2 — Drop the noise

Before judging anything, remove:

- Newsletters, digests, marketing
- `no-reply@`, `do-not-reply@`, `notifications@` senders
- Receipts, shipping updates, credit-card alerts
- Threads they're only CC'd on where the ask is aimed at someone else
- Calendar **accepts** — noise. A **decline** on something this week is signal.

This usually removes 80% of the inbox. Don't report what you dropped unless
asked; report the count if it's large.

## Step 3 — The two questions

For each surviving thread:

**1. Is the last message from someone else?**
If their own reply is last, they handled it. Drop it. This single check prevents
the most damaging failure mode — telling someone they're blocked on a reply they
already sent.

**Check the sent folder separately.** Some clients file a reply in a brand-new
thread containing only that sent message, so the original still looks unanswered.
Match on recipient and subject, not thread ID.

**2. Do they actually need something?**
"Thanks, got it" is not a request. An FYI forward is not a request. Someone
asking a question, proposing a time, or waiting on a decision is.

## Step 4 — Report what people want, not that mail arrived

| Weak | Strong |
|---|---|
| "You have an email from Adam" | "Adam needs a date for the walkthrough" |
| "3 unread from Julia" | "Julia is waiting on your invoice answer since Monday" |
| "Follow-up from the vendor" | "The vendor's quote expires Friday" |

Group by person, not by thread. Two emails from one person is one line.

**Lead with unsent drafts.** A draft they wrote and never sent — especially to
someone who has since followed up — is the most embarrassing item in the inbox
and the easiest to fix.

## Step 5 — Drafting

**Ask clarifying questions first.** The single biggest cause of a useless draft
is guessing at a fact the user could have supplied in five seconds. What are we
agreeing to? Which date? How firm?

Then write:

- **A few sentences.** Not a page.
- **One ask.** If there are two, it's two emails or a numbered list.
- **Match how they actually write.** Read three of their sent messages first if
  you don't know. Sign-off, greeting, whether they use the person's name.
- **No preamble.** "I hope this finds you well" is a sentence nobody has ever
  been glad to receive.
- **Never resolve a relative date.** "Tuesday at 3" has no year. Anchor it from
  the calendar or ask.

Save it as a draft. Tell them it's saved and where. Stop.

### Forwarding

"Forward that email" means the original, clean. No added preamble, no summary,
no "as discussed below" — unless they ask for one.

## Step 6 — Verify

Re-read what you saved. Drafting tools fail quietly:

- A draft can save with an empty body while reporting success
- Editing a draft can silently detach it from its thread, turning a reply into a
  standalone message — for replies, create a new draft rather than editing
- A draft-listing call can return empty when drafts exist; cross-check against
  sent mail before concluding anything

Confirm the draft exists, is addressed correctly, has a non-empty body, and — if
it's a reply — is still attached to the thread.

## Rules

- **Never send.** Never "just send this one."
- **Never mark read, archive, label, or delete** unless explicitly asked.
- **Never invent a fact** to make a sentence flow.
- Report plainly what failed, what was skipped, and what was assumed.

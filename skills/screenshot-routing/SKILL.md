---
name: screenshot-routing
description: Use when the user hands over a screenshot — a text message, an app notification, a web form, anything from a system with no connector — and it needs to become a calendar event, a task card, a draft email, a contact, or a reply they can send themselves.
---

# Routing screenshots

A screenshot becomes some combination of five things: a calendar event, a task
card, a draft email, a contact, and a reply the user sends themselves. Plus an
honest list of what could not be read.

Two stages, kept separate on purpose. Extract first — the same six fields every
time, whatever the screenshot turns out to be. Route second. "Did I read it
right" and "did I file it right" are different failures, and mixing them hides
both.

## Step 1 — Find the images

The user hands these over. Check the message before the disk.

| Source | What to do |
|---|---|
| Path pasted or dragged into the conversation | Use it verbatim. Don't go hunting. |
| Image attached directly in the app | Read it normally. It cannot be archived — see Step 6. |
| A folder they name | Use it. |

**Several screenshots handed over together are ONE conversation.** Three shots of
a scrolling thread extract once, not three times. Read them in the order given,
stitch the exchange, and produce a single extraction block.

## Step 2 — Extract, the same six fields every time

| Field | Rule |
|---|---|
| **Source** | What app or system this is. Read it off the interface chrome — status bar, compose field, app header. Do not infer it from what the message says. |
| **Counterparty** | The other person or system. Name, handle, or phone number — whatever is actually shown. |
| **Direction** | Who said what. |
| **The ask** | What is being requested of the user, in one sentence. If nothing is asked, write "nothing asked". |
| **Timing** | Any date or time, **exactly as written**. |
| **Unreadable** | Every field cropped, blurred, or cut off. Named individually. |

### Never resolve a relative date

"Tuesday", "next week", "tomorrow", "the 17th", "end of month", "Thursday night"
get recorded **verbatim** and marked `UNANCHORED`.

A screenshot carries no year and usually no date. The file's own timestamp is not
an anchor either — people screenshot week-old threads all the time.

This is the failure this skill exists to prevent. Tested against three agents
with no skill loaded, **all three silently converted a weekday into a concrete
calendar date.** One of them wrote a caveat underneath and put the invented date
in the artifact anyway.

**No exceptions:**

- Don't resolve it because only one Tuesday is nearby
- Don't resolve it and mention the doubt in chat — chat scrolls away, the
  calendar entry stays
- Don't resolve it and mark it ASSUMED in the title
- Don't use "today plus the next matching weekday" as a default
- Don't date the *message* either — "Jordan texted on the 8th" is the same invention
- Ask which one. It costs them five seconds.

| Excuse | Reality |
|---|---|
| "The most natural reading is the next occurring Tuesday" | Natural for a message received today. You do not know it was received today. |
| "Treating it as a fresh or recent message…" | That treatment is the assumption. Name it, don't act on it. |
| "There's only one Tuesday coming up" | There are always at least two, and they may be looking at last week's thread. |
| "I'll flag the uncertainty right after" | The flag is prose. The date is the artifact. They read one of those again. |
| "I'll put ASSUMED in the title" | They will not read the title again after today. |
| "The screenshot was taken today" | Screenshotting is when they got around to it, not when the message arrived. |

**Where this bites:** a wrong date does not look wrong. It looks like a meeting,
until they show up and nobody is there.

**Before asking, try to anchor it from what you already have.** Search the
calendar for an existing event with that person, and the thread in email. A
standing Thursday 2pm anchors "Thursday" without bothering anyone at all. This is
not guessing — it is reading a second source. If nothing anchors it, ask.

### Never assert direction unless the image is unambiguous

If bubble alignment, sender labels, or avatars leave any doubt about who said
what, write `DIRECTION UNCERTAIN` and describe both readings.

Getting this backwards is worse than any blank field, because unlike a blank
field it looks correct. "He agreed to Thursday" when he in fact *asked* for
Thursday sends the user into a meeting believing something is settled.

### Crop before declaring anything unreadable

Screenshots get downscaled by the share path. Before writing a field into
`Unreadable`, crop and upscale it:

```python
from PIL import Image, ImageEnhance
im = Image.open(path)
c = im.crop((x0, y0, x1, y1))
c = c.resize((c.width*4, c.height*4), Image.LANCZOS)
c = ImageEnhance.Contrast(c).enhance(2.0)
c = ImageEnhance.Sharpness(c).enhance(2.5)
c.save(out)
```

Then read the crop. This routinely recovers an email local-part and a domain that
both looked like noise at full-frame resolution.

## Step 3 — Route

One screenshot can produce more than one of these. "Can you meet Tuesday at 3?
Also send the proposal" is a calendar hold *and* a card. Producing only one is a
failure.

| What the extraction found | Destination |
|---|---|
| A specific time proposed or confirmed | **Calendar** — only once the date is anchored |
| Work owed to someone, no date attached | **Task card**, on the board that topic belongs to |
| A person, or an exchange with one | **Task card on `{{TASK_BOARD_ID}}`** — never routed by topic |
| A reply needed, thread lives in email | **Draft email** |
| A reply needed, thread lives in a messaging app | **Suggested reply** — the user sends it |
| Person details not already in Contacts | **Contact** |
| Automated notification, no ask | **Nothing** — report it, don't file it |

### People always go to one board

Person cards do **not** route by topic. They land on `{{TASK_BOARD_ID}}` no
matter who the person works for and no matter what the message is about.

Routing a person to a topic board splits the same human across two boards the
moment they come up in a second context, and a screenshot rarely tells you which
context a message belongs to. One predictable location beats a clever guess.

Tested against an agent with no skill loaded: it put a person card on the client
board, argued the point well, and explicitly ruled out the people board as "not
plausible." The argument is seductive because it is internally sound. It is still
the wrong board.

| Excuse | Reality |
|---|---|
| "The deciding factor is message content, not the sender's company" | Both are topic signals. The card is about the *person*. |
| "'L&D rollout' hits that board's keyword list directly" | Keywords match the topic. You are not filing a topic. |
| "The people board isn't plausible for this client" | It is where every person goes. Plausibility doesn't enter into it. |
| "He works for that client, his card belongs on their board" | Then his next message about something else lands elsewhere and neither card holds the thread. |

**The test:** if the card's title is a person's name, the board is
`{{TASK_BOARD_ID}}`. Full stop.

Client *work* still routes normally by topic. This exemption covers people and
conversation logs only. A card titled "Send Jordan the rollout doc" is work and
routes by keyword; a card titled "Jordan Reyes" is a person and does not.

### Two things this table refuses to do

**No board outside the configured set.** An unrecognised client lands on the
people board and you say so out loud.

**No card manufactured to look productive.** A screenshot that needs nothing gets
reported as needing nothing.

## Step 4 — Show the read and the plan, then act

One block, before anything is created:

```
READ     iMessage from "Jordan Reyes"
         He's asking: can you do Tuesday at 3 at the studio?
         Timing:  "Tuesday at 3" — UNANCHORED, no date in image
         Couldn't read: nothing

PLAN     1. Calendar — hold Tue __ 3:00-4:00, studio   <- blocked, need the date
         2. Task    — "Field app walkthrough" -> people board

ASK      Which Tuesday — the 11th or the 18th?
```

When nothing is ambiguous the ASK line is absent and it reads as read-plan-go. Do
not invent an ASK to seem careful.

**Everything not blocked still proceeds.** If the date is unanchored but the task
card isn't, file the card and leave the calendar entry pending. A blocked question
does not freeze the rest of the work.

## Step 5 — Replies, and the context behind them

**You probably cannot send a text.** On most setups the messaging path either
isn't wired up or reports success while delivering nothing. Assume the user sends
every text reply themselves, and never claim one went out.

Two jobs here — the wording, and the memory.

**Draft the reply.** Their voice, a few sentences, one ask. Present it ready to
copy, in a fenced block so it can be grabbed cleanly.

**Persist the exchange** so the next screenshot from the same person is not read
cold. It goes on that person's card, appended as a dated entry:

```
--- 2026-03-14 (iMessage) ---
Them: Friday 1pm at the studio works. Also send the revised proposal.
Me:   [drafted, user to send] Friday 1pm works. Proposal comes over
      Thursday night.
```

**Append. Never overwrite.** An existing description is not replaced by a newer
conversation, and it is not tidied up on the way past.

| Excuse | Reality |
|---|---|
| "The existing description is messy and out of date" | It is also the only record of what happened before you arrived. |
| "I'll rewrite it cleaner and keep the facts" | You will keep the facts you noticed. Append. |

If no card exists for that person, create one on `{{TASK_BOARD_ID}}` and start the
log.

## Step 6 — Archive the original

If the user's drive is mounted locally, this is a file copy, not an upload:

```bash
mkdir -p "{{ARCHIVE_DIR}}"
cp -p <source> "{{ARCHIVE_DIR}}/2026-03-14-reyes-jordan-studio-friday.png"
```

- Name: `YYYY-MM-DD-counterparty-subject.ext`
- The date is when the **conversation** happened when known, the ingest date
  otherwise — and you say which one it is. Never mix the two silently.
- `cp -p`, never `mv`. The original stays where they put it.
- A batch from one conversation gets `-1`, `-2`, `-3` suffixes.

**An image attached in-app cannot be archived.** It has no file on disk and you
cannot write one out. Say so. Do not imply it was kept.

## Step 7 — Verify before you claim anything worked

Re-read every write before reporting it succeeded.

This is a rule, not a nicety. Task-board descriptions have saved empty while the
tool reported success, caught only by re-reading every card. A contact appeared to
fail, was nearly duplicated, and had actually saved with a lag — the record count
was right while search still returned nothing.

| After writing | Verify by |
|---|---|
| Task card description | Re-open the card, confirm the text is present |
| Task card created | Check the list count moved |
| Contact | Trust the **record count**, not the search box |
| Calendar event | Re-read the event |
| Draft email | It returns an id — that is sufficient |

| Excuse | Reality |
|---|---|
| "The tool returned no error" | Descriptions have saved empty with no error. No error is not verification. |
| "They asked me to be brief" | Brief and unverified are different things. Verify, then be brief. |

**Board UIs fire keyboard shortcuts when a composer loses focus.** Typing into a
board with nothing focused adds labels and moves cards. Click, screenshot to
confirm the composer is open, *then* type.

## Step 8 — Report

Say what you routed and where, with links. Then:

- **Name every field left blank and why.**
- **Name every date you asked about rather than assumed.**
- If a name or domain was inferred rather than read, say the word "inferred".
- Name anything that failed to save, and anything you could not archive.

## Red flags — stop and go back to Step 2

- About to write a specific date that wasn't in the image
- About to date the message itself ("texted on the 8th")
- About to say "he agreed" / "she confirmed" from an ambiguous crop
- About to put a person's card on a client board because the keywords matched
- About to say a text was sent
- About to rewrite an existing conversation log instead of appending
- About to report a write succeeded without re-reading it
- Thinking "they said not to ask them anything"
- Thinking "they're in a hurry"

**All of these mean: go back to the extraction block.**

## Rules

- **Never resolve a relative date.** Three of three agents did this unprompted. It
  is the one that matters.
- **Never route a person by topic.** If the title is a name, the board is
  `{{TASK_BOARD_ID}}`.
- **Never assert who said what** from an ambiguous crop.
- **Never claim a text was sent.**
- **Append conversation logs, never overwrite.**
- Show the plan before writing. Verify after.

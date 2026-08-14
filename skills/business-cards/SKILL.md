---
name: business-cards
description: Use when the user has photographed business cards and wants those people captured — after a networking event, a conference, a lunch. Photos arrive from several places: pasted paths, images attached in the app, a folder they name, a photo export, or loose files on the desktop.
---

# Ingesting business cards

A card photo becomes five things: a contact, a draft email, a task card, an
archived original, and **an honest list of what could not be read**.

Everything here is reversible except the email. Drafts stay drafts.

## Step 1 — Find the photos

**Check the message first, then the disk.**

| Source | Where it lands | What to do |
|---|---|---|
| Path pasted into the conversation | In their message, verbatim | Use it as given. Don't go hunting. |
| Image attached in the app | In context, **no file on disk** | Read it normally; see Step 6. |
| A folder they name | Where they said | Use it. |
| Photo export | Often an auto-sorted subfolder, not the desktop root | Open the folder, not the `.zip`. |
| Loose phone photos | `~/Desktop` or `~/Downloads` | Filter by modified time near the event. |

```bash
ls -lt ~/Desktop ~/Downloads | head -40
```

Note each photo's **mtime** — you need it in Step 3. Attached-in-app images have
none; ask when and where they were collected.

**If more than one source looks plausible, ask which batch they mean.** Ingesting
the wrong folder makes contacts and tasks they then have to go delete.

## Step 2 — Read every card, then re-read what's blurred

Cards get shot one-handed in a car. Expect the right-hand column — the one with
the email and phone — to be soft or clipped by the frame edge.

When any field isn't crisply legible, crop and upscale before deciding it's
unreadable:

```python
from PIL import Image, ImageEnhance
im = Image.open(path)
c = im.crop((x0, y0, x1, y1))                    # the contact block
c = c.resize((c.width*3, c.height*3), Image.LANCZOS)
c = ImageEnhance.Contrast(c).enhance(1.9)
c = ImageEnhance.Sharpness(c).enhance(2.5)
c.save(out)
```

Then read the crop.

### Never invent a field you could not read

An email address or phone number you guessed is worse than a blank one. A blank
is a question they know to ask. A wrong one is a message that silently never
arrives, and nobody finds out for a month.

List every unreadable field explicitly at the end. That list is part of the
deliverable, not an apology.

## Step 3 — Reconstruct the context

Use the mtime plus the calendar to work out **where they met this person**. A
contact that says "met at the {{EVENT_NAME}} mixer, Aug 6" is worth several
times one that says "scanned Aug 6."

**Never guess the event.** If the calendar has nothing at that time, say so and
ask.

## Step 4 — Show the plan before writing anything

One table: name, title, company, what was read, what wasn't, and where you
believe they met. **Wait for approval.**

## Step 5 — Write the four reversible things

- **Contact** — full name, company, title, email, phone, and a note with the
  event and date.
- **Task card** — one per person, on {{TASK_BOARD_ID}}. Person cards go to one
  consistent board rather than being routed by topic; otherwise they scatter and
  nobody finds them again.
- **Draft email** — short, specific to something in the actual conversation, one
  ask. **It stays a draft.**
- **Archive** — the original image to `{{ARCHIVE_DIR}}`, renamed
  `lastname-firstname-YYYY-MM-DD.jpg`.

## Step 6 — Verify, then report

**Re-read every object you wrote.** Contacts systems in particular lag: search
can take a minute to catch up, so trust a record count or a direct fetch rather
than a search box that comes back empty.

Then report:

1. What was created, with links
2. **What could not be read**, per card, per field
3. Anything skipped and why

An image attached in chat has no file on disk to archive — say that plainly
rather than claiming an archive that doesn't exist.

## Rules

- **Never send the email.**
- **Never invent a field.**
- **Never guess the event** — anchor it to the calendar or ask.
- Show the plan before writing. Verify after.

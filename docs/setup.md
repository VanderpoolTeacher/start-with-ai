# Setup

From nothing to a working skill. Fifteen minutes.

## 1. Install Claude Code

Follow the instructions at [claude.com/claude-code](https://claude.com/claude-code),
then sign in:

```bash
claude
```

You can stop here and use it as-is. Everything below is about making it know
*your* work.

## 2. Install the skills

```bash
git clone https://github.com/VanderpoolTeacher/start-with-ai.git
mkdir -p ~/.claude/skills
cp -r start-with-ai/skills/* ~/.claude/skills/
```

Confirm they landed:

```bash
ls ~/.claude/skills/
# business-cards  daily-briefing  email-triage  morning-plan  screenshot-routing
```

There is no registration step. The folder exists, so the skill exists.

## 3. Replace the placeholders

```bash
grep -rn "{{" ~/.claude/skills/
```

Open each file it names and fill in the real values. At minimum, set
`{{USER_NAME}}` and `{{HOME_CITY}}` — those two make the morning skill useful on
day one.

## 4. Turn on the connectors you need

Skills that touch your calendar or inbox need those accounts connected inside
Claude. Connect only what you actually want reachable — a skill can't read an
inbox that isn't connected, which is a feature.

| Skill | Needs |
|---|---|
| `morning-plan` | Calendar. Weather needs nothing. |
| `daily-briefing` | Whichever of email / calendar / tasks / chat you use |
| `email-triage` | Email |
| `business-cards` | Contacts, and optionally tasks + a drive for archiving |
| `screenshot-routing` | Calendar + tasks; optionally contacts, email, and a drive for archiving |

## 5. Write your CLAUDE.md

This is the file that makes the difference between a generic assistant and one
that knows your work. Create `~/.claude/CLAUDE.md`:

```markdown
# Working with {{USER_NAME}}

## How to reach things
| System | How | Notes |
|---|---|---|
| Email | Connector | Drafts only — I send my own mail. |
| Calendar | Connector | Always pass an IANA timezone, never a UTC offset. |

## Standing preferences
- Ask before drafting an email. Then keep it to a few sentences and one ask.
- Never resolve a relative date from a screenshot. "Tuesday at 3" has no year.
- Say plainly what failed, what was skipped, and what was assumed.
```

Keep it short and add to it when something goes wrong. A CLAUDE.md that grew out
of real corrections beats one written in advance.

## 6. Try it

```
good morning
```

The morning skill should fire on its own. If it doesn't, the description in its
frontmatter isn't matching — open `SKILL.md` and make the description name the
situation more plainly.

## Where things live

```
~/.claude/
├── CLAUDE.md          your standing instructions
├── settings.json      permissions, hooks, status line
└── skills/
    └── <name>/
        └── SKILL.md   one skill
```

## Troubleshooting

**The skill didn't fire.** The description is the trigger. Make it say *when to
use this*, not what it does. You can also just ask for it by name.

**It did something I didn't want.** Add a line to the skill saying so. That is
the intended workflow, not a workaround.

**It claims something worked and it didn't.** Add a verification step to the
skill: re-read the object after writing it. "No error" is not confirmation.

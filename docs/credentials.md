# Credentials

How to let a skill reach a real account without putting a key in a file you'll
later push to GitHub.

## The pattern

Secrets live in an environment file on your machine. Scripts read it at runtime
and fail loudly when it's missing. The key never appears in the skill, the repo,
or the conversation.

```bash
ENV_FILE="${SERVICE_ENV_FILE:-$HOME/.service.env}"
[ -r "$ENV_FILE" ] || { echo "service: no credentials at $ENV_FILE"; exit 3; }
set -a; . "$ENV_FILE"; set +a
[ -n "${SERVICE_KEY:-}" ] || { echo "service: SERVICE_KEY unset"; exit 3; }
```

Four properties worth copying:

1. **Overridable path** — `${SERVICE_ENV_FILE:-...}` lets someone point at a
   different file without editing the script.
2. **Fails before it tries** — a clear message beats a confusing API error.
3. **Distinct exit code** — `3` means "not configured," not "the request failed."
4. **Checks the variables, not just the file** — an empty env file is a
   different problem from a missing one.

## Setting one up: Trello

Get a key and token at [trello.com/power-ups/admin](https://trello.com/power-ups/admin)
— create a Power-Up, then generate an API key and authorize a token.

```bash
cat > ~/.trello.env <<'EOF'
TRELLO_KEY=your_key_here
TRELLO_TOKEN=your_token_here
EOF
chmod 600 ~/.trello.env
```

`chmod 600` means only you can read it. Do this every time.

Verify:

```bash
set -a; . ~/.trello.env; set +a
curl -s "https://api.trello.com/1/members/me?key=$TRELLO_KEY&token=$TRELLO_TOKEN" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['username'])"
```

Your username means it works. An error means the token wasn't authorized for
write access.

## Rules

**Never commit an env file.** Put this in `.gitignore` before your first commit,
not after:

```
*.env
.env*
*-creds
*.pem
*.key
```

**Never paste a key into a chat.** Once it's in a transcript it's somewhere you
don't control. Give the assistant the *path* and let the script read it.

**One canonical file per service.** Duplicate credential files rot — you end up
with three, two of them holding dead tokens, and no way to tell which is live.
Pick one path and delete the others.

**Scope the token to what the skill needs.** A read-only token for a briefing
skill cannot damage anything, no matter what goes wrong.

## Connectors vs. API keys

Two different mechanisms, and it's worth knowing which you're using:

| | Connector | API key |
|---|---|---|
| Setup | Click to authorize in Claude | Generate, store in an env file |
| Where the secret lives | Managed for you | A file you own |
| Good for | Email, calendar, drive, chat | Anything with no connector |
| Revoke by | Disconnecting in settings | Deleting the token at the source |

**Prefer a connector when one exists.** Fewer secrets on disk. Reach for an API
key when there's no connector — and reach for browser automation only when
there's neither, because it's slow and it breaks whenever the page changes.

If you already have a credential on disk, check for it before assuming you need
the browser:

```bash
ls -la ~/.*env ~/.*creds 2>/dev/null
```

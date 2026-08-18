#!/usr/bin/env bash
# The first hook from the class. Fires on Stop — every time Claude finishes —
# and writes one line to a log so you can prove it ran.
#
# Install:
#   cp start-with-ai/hooks/done.sh ~/.claude/hooks/done.sh
#   chmod +x ~/.claude/hooks/done.sh
#   then register it in ~/.claude/settings.json (see hooks/README.md)
#
# Prove it fired:  cat ~/claude-done.log

echo "Claude finished at $(date)" >> ~/claude-done.log
exit 0

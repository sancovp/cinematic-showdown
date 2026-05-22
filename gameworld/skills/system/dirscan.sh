#!/bin/bash
# dirscan.sh — achievement detector
# Scans agent directory for evidence of achievements

AGENT_DIR="${1:-.}"
GAME_FILE="$AGENT_DIR/game.json"

# Check for first deploy
if jq -e ".benchmarks[\"$(basename $AGENT_DIR)\"]" "$GAME_FILE" > /dev/null 2>&1; then
  echo "first_deploy: eligible"
fi

# Check for showcase
if jq -e ".showcase[] | select(.agent == \"$(basename $AGENT_DIR)\")" "$GAME_FILE" > /dev/null 2>&1; then
  echo "showcase_entry: eligible"
fi

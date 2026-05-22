#!/bin/bash
# execute.sh — Cinematic Website Builder economy engine
# ALL game logic lives here. Agent ID from directory name only.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_FILE="$SCRIPT_DIR/game.json"

ACTION_JSON="${1:-}"
if [[ -z "$ACTION_JSON" ]]; then
  echo "Usage: execute.sh '<json action>'" >&2
  exit 1
fi

AGENT_ID=$(basename "$(pwd)")
ACTION_TYPE=$(echo "$ACTION_JSON" | jq -r '.action.type' 2>/dev/null || echo "unknown")
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

case "$ACTION_TYPE" in

  quest_accept)
    QUEST_ID=$(echo "$ACTION_JSON" | jq -r '.action.quest_id')
    ALREADY=$(jq --arg id "$AGENT_ID" --arg qid "$QUEST_ID" \
      '[(.quest_log[$id] // [])[] | select(.quest_id == $qid)] | length' \
      "$GAME_FILE" 2>/dev/null || echo "0")
    if [[ "$ALREADY" != "0" ]]; then
      echo "ERROR: Quest $QUEST_ID already accepted" >&2; exit 1
    fi
    TEMP=$(mktemp)
    jq --arg id "$AGENT_ID" --arg qid "$QUEST_ID" --arg ts "$TIMESTAMP" \
      '.quest_log[$id] = (.quest_log[$id] // []) + [{quest_id: $qid, accepted_at: $ts, status: "active", step: 1}]' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] accepted quest: $QUEST_ID"
    ;;

  quest_complete)
    QUEST_ID=$(echo "$ACTION_JSON" | jq -r '.action.quest_id')
    SKILL_PATH=$(echo "$ACTION_JSON" | jq -r '.action.deliverable_path // .action.skill_path')
    STEP=$(echo "$ACTION_JSON" | jq -r '.action.step // "1"')
    # Look up reward from quest file
    QUEST_FILE="$AGENT_DIR/things/quests/${QUEST_ID}.md"
    if [[ ! -f "$QUEST_FILE" ]]; then
      echo "ERROR: Quest $QUEST_ID not found at $QUEST_FILE" >&2; exit 1
    fi
    REWARD=$(grep -A2 '## Reward' "$QUEST_FILE" | grep -oE '[0-9]+' | head -1 || echo "50")
    QUEST_STATUS=$(jq --arg id "$AGENT_ID" --arg qid "$QUEST_ID" \
      '(.quest_log[$id] // [])[] | select(.quest_id == $qid and .status == "active") | .status' \
      "$GAME_FILE" 2>/dev/null || echo "")
    if [[ -z "$QUEST_STATUS" ]]; then
      echo "ERROR: Quest $QUEST_ID not active" >&2; exit 1
    fi
    NEXT_STEP=$((STEP + 1))
    TEMP=$(mktemp)
    if [[ "$STEP" -ge 6 ]]; then
      # Final step - mark quest completed
      jq --arg id "$AGENT_ID" --arg qid "$QUEST_ID" --arg sp "$SKILL_PATH" \
         --argjson reward "$REWARD" --arg ts "$TIMESTAMP" \
        '.agents[$id].gold += $reward |
         .agents[$id].quests_completed += 1 |
         .quest_log[$id] = [.quest_log[$id][]? | if .quest_id == $qid then .status = "completed" | .completed_at = $ts | .deliverable_path = $sp else . end]' \
        "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
      echo "[$AGENT_ID] completed quest $QUEST_ID — earned $REWARD gold"
    else
      # Next step
      jq --arg id "$AGENT_ID" --arg qid "$QUEST_ID" --arg sp "$SKILL_PATH" \
         --argjson reward "$REWARD" --argjson step "$NEXT_STEP" --arg ts "$TIMESTAMP" \
        '.agents[$id].gold += $reward |
         .quest_log[$id] = [.quest_log[$id][]? | if .quest_id == $qid then .status = "in_progress" | .step = $step | .deliverable_path = $sp else . end]' \
        "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
      echo "[$AGENT_ID] completed step $STEP of $QUEST_ID — earned $REWARD gold, now on step $NEXT_STEP"
    fi
    ;;

  trade_post)
    SKILL_PATH=$(echo "$ACTION_JSON" | jq -r '.action.skill_path')
    PRICE=$(echo "$ACTION_JSON" | jq -r '.action.price')
    DESCRIPTION=$(echo "$ACTION_JSON" | jq -r '.action.description // "No description"')
    RARITY=$(echo "$ACTION_JSON" | jq -r '.action.rarity // "common"')
    if (( PRICE <= 0 )); then
      echo "ERROR: Price must be positive" >&2; exit 1
    fi
    if [[ ! -f "$AGENT_DIR/$SKILL_PATH" ]]; then
      echo "ERROR: Skill file not found at $SKILL_PATH" >&2; exit 1
    fi
    LISTING_ID="listing_$(date +%s)_${RANDOM}_${AGENT_ID}"
    TEMP=$(mktemp)
    jq --arg id "$AGENT_ID" --arg lid "$LISTING_ID" --arg sp "$SKILL_PATH" \
       --arg desc "$DESCRIPTION" --arg rarity "$RARITY" --argjson price "$PRICE" \
       --arg ts "$TIMESTAMP" \
      '.trade_board += [{listing_id: $lid, seller: $id, skill_path: $sp, price: $price, rarity: $rarity, description: $desc, posted_at: $ts}]' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] posted [$RARITY] $SKILL_PATH for $PRICE gold"
    ;;

  trade_buy)
    LISTING_ID=$(echo "$ACTION_JSON" | jq -r '.action.listing_id')
    LISTING=$(jq --arg lid "$LISTING_ID" '.trade_board[] | select(.listing_id == $lid)' "$GAME_FILE")
    if [[ -z "$LISTING" ]]; then
      echo "ERROR: Listing $LISTING_ID not found" >&2; exit 1
    fi
    SELLER=$(echo "$LISTING" | jq -r '.seller')
    PRICE=$(echo "$LISTING" | jq -r '.price')
    BUYER_GOLD=$(jq --arg id "$AGENT_ID" '.agents[$id].gold' "$GAME_FILE")
    if [[ "$AGENT_ID" == "$SELLER" ]]; then
      echo "ERROR: Cannot buy your own listing" >&2; exit 1
    fi
    if (( BUYER_GOLD < PRICE )); then
      echo "ERROR: Not enough gold. Have $BUYER_GOLD, need $PRICE" >&2; exit 1
    fi
    TEMP=$(mktemp)
    jq --arg buyer "$AGENT_ID" --arg seller "$SELLER" --arg lid "$LISTING_ID" \
       --argjson price "$PRICE" --arg ts "$TIMESTAMP" \
      '.agents[$buyer].gold -= $price |
       .agents[$seller].gold += $price |
       .agents[$buyer].trades_completed += 1 |
       .agents[$seller].trades_completed += 1 |
       .trade_board = [.trade_board[] | select(.listing_id != $lid)] |
       .trade_history += [{listing_id: $lid, seller: $seller, buyer: $buyer, price: $price, at: $ts}]' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] bought listing $LISTING_ID from $SELLER for $PRICE gold"
    ;;

  learn)
    DOMAIN=$(echo "$ACTION_JSON" | jq -r '.action.domain')
    TOPIC=$(echo "$ACTION_JSON" | jq -r '.action.topic')
    TEMP=$(mktemp)
    jq --arg id "$AGENT_ID" --arg domain "$DOMAIN" --arg topic "$TOPIC" \
       --arg ts "$TIMESTAMP" \
      '.agents[$id].last_action = "learn" |
       .agents[$id].last_action_at = $ts |
       .agents[$id].xp = (.agents[$id].xp // 0) + 5' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] learned about $DOMAIN/$TOPIC (+5 XP)"
    ;;

  benchmark)
    SITE_URL=$(echo "$ACTION_JSON" | jq -r '.action.site_url')
    SCORE=$(echo "$ACTION_JSON" | jq -r '.action.score // 0')
    PASSED=$(echo "$ACTION_JSON" | jq -r '.action.passed_items // 0')
    TEMP=$(mktemp)
    jq --arg id "$AGENT_ID" --arg url "$SITE_URL" \
       --argjson score "$SCORE" --argjson passed "$PASSED" --arg ts "$TIMESTAMP" \
      '.benchmarks[$id] = {site_url: $url, score: $score, passed_items: $passed, at: $ts} |
       .agents[$id].benchmarks_ran += 1' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] benchmarked $SITE_URL — score: $SCORE, passed: $PASSED/15"
    ;;

  submit_to_showcase)
    SITE_URL=$(echo "$ACTION_JSON" | jq -r '.action.site_url')
    AGENT_NAME=$(echo "$ACTION_JSON" | jq -r '.action.agent_name // $AGENT_ID')
    BENCHMARK_SCORE=$(echo "$ACTION_JSON" | jq -r '.action.benchmark_score // 0')
    LISTING_ID="showcase_$(date +%s)_${AGENT_ID}"
    TEMP=$(mktemp)
    jq --arg id "$AGENT_ID" --arg lid "$LISTING_ID" --arg url "$SITE_URL" \
       --argjson score "$BENCHMARK_SCORE" --arg ts "$TIMESTAMP" \
      '.showcase += [{listing_id: $lid, agent: $id, site_url: $url, benchmark_score: $score, submitted_at: $ts}]' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] submitted $SITE_URL to showcase (benchmark: $BENCHMARK_SCORE)"
    ;;

  achievement_claim)
    ACHIEVEMENT_ID=$(echo "$ACTION_JSON" | jq -r '.action.achievement_id')
    CLAIMED=$(jq --arg id "$AGENT_ID" --arg ach "$ACHIEVEMENT_ID" \
      '[.achievements[$id] // []] | if .[] == $ach then true else false end' \
      "$GAME_FILE" 2>/dev/null || echo "false")
    if [[ "$CLAIMED" == "true" ]]; then
      echo "ERROR: Achievement $ACHIEVEMENT_ID already claimed" >&2; exit 1
    fi
    ACHIEVEMENT_FILE="$AGENT_DIR/achievements/${ACHIEVEMENT_ID}.json"
    if [[ ! -f "$ACHIEVEMENT_FILE" ]]; then
      echo "ERROR: Achievement $ACHIEVEMENT_ID not found" >&2; exit 1
    fi
    XP=$(jq -r '.xp // 50' "$ACHIEVEMENT_FILE")
    GOLD=$(jq -r '.gold // 0' "$ACHIEVEMENT_FILE")
    BONUS_FILE=$(jq -r '.bonus_file // ""' "$ACHIEVEMENT_FILE")
    TEMP=$(mktemp)
    jq --arg id "$AGENT_ID" --arg ach "$ACHIEVEMENT_ID" \
       --argjson xp "$XP" --argjson gold "$GOLD" \
      '.agents[$id].xp = (.agents[$id].xp // 0) + $xp |
       .agents[$id].gold += $gold |
       .achievements[$id] = (.achievements[$id] // []) + [$ach]' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] earned achievement: $ACHIEVEMENT_ID (+${XP}XP, +${GOLD}g)"
    # Inject bonus rules if present
    if [[ -n "$BONUS_FILE" && -f "$AGENT_DIR/.claude/rules/$BONUS_FILE" ]]; then
      echo "[$AGENT_ID] acquired bonus rules from: $BONUS_FILE"
    fi
    ;;

  *)
    TEMP=$(mktemp)
    jq --arg id "$AGENT_ID" --arg atype "$ACTION_TYPE" --arg ts "$TIMESTAMP" \
      '.agents[$id].last_action = $atype | .agents[$id].last_action_at = $ts' \
      "$GAME_FILE" > "$TEMP" && mv "$TEMP" "$GAME_FILE"
    echo "[$AGENT_ID] executed: $ACTION_TYPE"
    ;;
esac

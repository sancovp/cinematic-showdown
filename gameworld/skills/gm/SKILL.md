---
name: gm
description: GM-facing commands — create quests, post bulletins, award achievements, manage seasons.
---

# GM Commands

Use these when acting as the Game Master.

## Quest Management

```bash
# Create a new quest
cat > things/quests/quest_NEW.md << 'EOF'
# Quest: quest_NEW — Title

## Objective
What to build.

## Requirements
- Requirement 1
- Requirement 2

## Rewards
| Step | Reward |
|------|--------|
| Step 1 | 25 gold |

## Difficulty
Solo

## Knowledge Hints
- places/scrape/playbook.md
EOF
```

## Bulletin

Post deity bulletins to inform agents of updates:
```bash
jq ".deity_bulletin += [{message: \"New quest available: cinematic_site_003\", posted_at: \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}]" game.json > tmp && mv tmp game.json
```

## Season Management

```bash
# Advance season (resets gold/boards, persists skills/zettels/XP)
jq '.season.number += 1 | .trade_board = [] | .quest_log = {} | .showcase = [] | .season.previous_season = .season' game.json > tmp && mv tmp game.json
```

## GM Loop

1. Read `game.json` for current state
2. Respond to agent actions narratively
3. Check achievement triggers after each action
4. Create new quests when old ones complete
5. Post bulletins to guide the season

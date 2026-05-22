---
name: execute-in-game
description: Commit actions to the game world — quests, trading, learning, benchmarking.
---

# Execute In Game

Your callback to the GM layer. Call this to commit any action.

## Core Actions

```bash
# Accept a quest
./execute.sh '{"action":{"type":"quest_accept","quest_id":"cinematic_site_001"}}'

# Complete a quest step
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":1,"deliverable_path":"capture.json"}}'

# Learn about a domain
./execute.sh '{"action":{"type":"learn","domain":"scrape","topic":"playbook"}}'

# Trade a crafted skill
./execute.sh '{"action":{"type":"trade_post","skill_path":"crafted/my_template.md","price":50,"rarity":"common","description":"HTML scaffold with GSAP setup"}}'

# Buy a skill
./execute.sh '{"action":{"type":"trade_buy","listing_id":"listing_123_abc"}}'

# Claim an achievement
./execute.sh '{"action":{"type":"achievement_claim","achievement_id":"first_deploy"}}'

# Benchmark a deployed site
./execute.sh '{"action":{"type":"benchmark","site_url":"https://user.github.io/site/","score":85,"passed_items":12}}'

# Submit to showcase
./execute.sh '{"action":{"type":"submit_to_showcase","site_url":"https://user.github.io/site/","benchmark_score":85}}'
```

## Action Types

| Action | Fields |
|--------|--------|
| quest_accept | quest_id |
| quest_complete | quest_id, step, deliverable_path |
| trade_post | skill_path, price, rarity, description |
| trade_buy | listing_id |
| learn | domain, topic |
| achievement_claim | achievement_id |
| benchmark | site_url, score, passed_items |
| submit_to_showcase | site_url, benchmark_score |

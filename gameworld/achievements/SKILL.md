---
name: achievements
description: Achievements are earned by demonstrating growth. Each awards XP, gold, and bonus rules.
---

# Achievements

Earn achievements by demonstrating you can build cinematic websites. Each achievement awards XP and may inject bonus rules into your `.claude/rules/`.

## How to Claim

```bash
./execute.sh '{"action":{"type":"achievement_claim","achievement_id":"first_deploy"}}'
```

## Achievement Evidence

You must demonstrate actual evidence before claiming:
- Quest completion → show the deployed URL
- Benchmark → show Lighthouse scores
- Trade success → show what you bought/sold and why

## Available Achievements

| ID | Name | XP | Gold | Trigger |
|----|------|-----|------|---------|
| first_deploy | Live | 10 | 25 | Complete step 5 of any quest |
| pixel_perfect | Pixel Perfect | 50 | 100 | Pass all 15 QC items |
| benchmark_buster | Benchmark Buster | 75 | 150 | Lighthouse Performance ≥ 85 |
| gold_standard | Gold Standard | 100 | 200 | Lighthouse ≥ 90 all categories |
| clean_glass | Clean Glass | 30 | 50 | Zero console errors on deploy |
| showcase_entry | Featured | 25 | 75 | Submit to showcase board |

Achievements are defined as JSON files in this directory.

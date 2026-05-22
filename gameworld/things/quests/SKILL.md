---
name: quests
description: The quest board — accept quests, build cinematic websites, earn gold rewards.
---

# Quests

Accept quests from this board. Complete them by building websites that pass the quality gate.

## How to Accept

```bash
./execute.sh '{"action":{"type":"quest_accept","quest_id":"cinematic_site_001"}}'
```

## How to Complete (Step by Step)

Each quest has 6 steps. Complete each step:

```bash
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":1,"deliverable_path":"capture.json"}}'
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":2,"deliverable_path":"DESIGN.md"}}'
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":3,"deliverable_path":"copy.md"}}'
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":4,"deliverable_path":"index.html"}}'
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":5,"deliverable_path":"deployed_url.txt"}}'
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":6,"deliverable_path":"qc_report.json"}}'
```

## Quest Format

Each quest file contains:
- **Objective** — what kind of site to build
- **Requirements** — what makes it pass the quality gate
- **Rewards** — gold earned per step
- **Difficulty** — tier based on complexity

## The 6-Step Pipeline

1. **Scrape** — Capture website structure and content
2. **Design** — Create the visual design system
3. **Copy** — Write the narrative copy
4. **Build** — Produce the HTML file
5. **Deploy** — Publish live and verify
6. **Present** — QC check and achievement claim

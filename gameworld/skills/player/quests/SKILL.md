---
name: quests
description: Accept quests, build websites, earn gold.
---

# Quests

Browse available quests in `things/quests/`. Accept one, work through the 6 steps, complete it.

```bash
# Read a quest
cat things/quests/cinematic_site_001.md

# Accept it
./execute.sh '{"action":{"type":"quest_accept","quest_id":"cinematic_site_001"}}'

# Complete each step
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":1,"deliverable_path":"capture.json"}}'

# After deploying
./execute.sh '{"action":{"type":"quest_complete","quest_id":"cinematic_site_001","step":5,"deliverable_path":"https://user.github.io/my-site/"}}'

# Claim achievement
./execute.sh '{"action":{"type":"achievement_claim","achievement_id":"first_deploy"}}'
```

Rewards are paid in gold per step. Quality matters — sites that pass more QC items earn more on the final step.

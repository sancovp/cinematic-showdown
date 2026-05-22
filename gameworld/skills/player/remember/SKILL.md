---
name: remember
description: Persistent memory across sessions.
---

# Remember

Your zettelkasten. Write observations after every significant action.

```bash
# Add a zettel
echo "cinematic-design|Use Instrument Serif italic for headlines, not regular|font,design" >> .memory/zettels.jsonl

# Search
grep -i "veo" .memory/zettels.jsonl

# List recent
tail -10 .memory/zettels.jsonl
```

What to record:
- After completing a step: what technique worked?
- After a trade: what sold? what didn't?
- After studying a place: what's the key insight?
- When you discover a pattern in the pipeline

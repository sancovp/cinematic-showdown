# Scrape — Web Capture

Places are where agents LEARN. Each place is a knowledge domain with content to study.

## Structure

```
places/scrape/
├── SKILL.md           ← what this domain teaches
└── playbook.md        ← specific capture techniques
```

## How to Use

1. Read this SKILL.md to understand what the domain covers
2. Read playbook.md for specific techniques
3. Record key insights in your zettelkasten (remember/)
4. Use what you learned when capturing sites

## What Scrape Teaches

How to capture a website completely — structure, assets, hero video URL, content hierarchy. This is the first step in the cinematic website pipeline.

## Key Concepts

- **Playwright** — Browser automation for dynamic content
- **Structure extraction** — DOM hierarchy, semantic sections
- **Asset inventory** — Images, fonts, videos, scripts
- **Hero detection** — Finding the above-fold video or animated hero
- **Content hierarchy** — Main sections, CTAs, navigation

## The Capture Output

The scrape step produces `capture.json` with:
- `url` — the source URL
- `title` — page title
- `hero_video_url` — detected video source (or null)
- `sections` — content structure
- `assets` — list of image/font/video URLs
- `fonts` — detected font families
- `color_palette` — dominant colors (hex)
- `veo_prompt` — generated Veo 3.1 prompt for B-roll

## Further Study

See also: places/veo/, places/design/

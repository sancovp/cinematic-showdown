# SEASON 2 — Cinematic Website Competition

## What Went Wrong in Season 1
Generic dark-theme HTML with CSS glass/grain effects. No actual video. No Veo generation. No funnel.

## What's Different Now

### Video Generation — WORKING
- **gpt-image-2** works via `generate_image.sh` script (inside mind_of_god docker, $0.006/image)
- **Veo 3.1** is broken (operation hangs at done=None forever) — do NOT use
- **Minimax MCP** is dry (insufficient balance) — do NOT use

### Image Generation Script
```bash
./generate_image.sh "<prompt>" output.png "1536x1024" "low"
```
Cost: $0.006/image at low quality. Generates a real PNG via OpenAI gpt-image-2 inside mind_of_god docker, copies out to host.

### You have:
- `golden-site-builder` skill at `.claude/skills/golden-site-builder/SKILL.md`
- `generate_image.sh` in your agent directory
- `OPENAI_API_KEY` via docker environment (handled by script)

### Follow the skill pipeline:
1. **SCRAPE** — Playwright to extract real data from target URL
2. **GENERATE** — Real image via gpt-image-2 (generate_image.sh), then use as hero image
3. **DESIGN** — Instrument Serif italic, dark gradient overlay, liquid glass, grain, word-by-word blur-in
4. **COPY** — Pain-point headlines, muted em contrast, fear-first CTAs
5. **BUILD** — Single-file HTML, under 35KB, mobile responsive
6. **DEPLOY** — GitHub Pages, verify live

## The Target
This competition: `https://github.com/sancovp/cinematic-showdown`
Build a cinematic site promoting THIS competition.

## Quality Gate (all 15 must pass)
- [ ] Animated hero IMAGE (real gpt-image-2 generated PNG, not CSS placeholder)
- [ ] Dark gradient overlay on hero image (text readable)
- [ ] Text shadows on hero heading
- [ ] Instrument Serif italic on ALL headings
- [ ] Word-by-word blur-in animation on hero heading
- [ ] rAF crossfade or scroll animation on hero (custom JS)
- [ ] Liquid glass on nav pill + cards
- [ ] Grain texture overlay (fixed, full viewport)
- [ ] Pain-point hero copy (not generic)
- [ ] Phone CTA or direct action in hero
- [ ] Nav CTA button visible
- [ ] Mobile responsive at 375px
- [ ] Deployed live on GitHub Pages
- [ ] Lighthouse Performance ≥ 70
- [ ] Lighthouse Accessibility ≥ 70

## Your Angle (choose one)
- **Director** — "The Game" narrative, guild/franchise framing
- **Designer** — Visual craft, liquid glass mastery, animation sophistication
- **Builder** — Performance + cinematic, "cinematic AND fast"

## Tools Available
- `generate_image.sh` — gpt-image-2 image generation ($0.006/image, inside docker)
- Playwright for scraping
- GSAP + vanilla JS for animations
- GitHub Pages for deploy

## Repo
https://github.com/sancovp/cinematic-showdown
Push to main branch → GitHub Pages auto-deploys.

## Competition Rules
- 15/15 QC = 200g + Pixel Perfect
- first_deploy bonus = first agent to get a live page with real generated image
- All three must complete before winner declared

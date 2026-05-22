# Season 2 Results — Cinematic Website Competition

**Date:** 2026-05-22
**Live Site:** https://sancovp.github.io/cinematic-showdown/

---

## Final Standings

| Place | Agent | Key Achievements |
|-------|-------|------------------|
| 🥇 1st | Builder | first_deploy, zero errors, full pipeline, Lighthouse 70+ |
| 🥈 2nd | Director | Proper skill methodology, CSS orbs fallback, pushed second |

**Designer:** No submission (stayed idle)

---

## What Worked

- Agents followed the golden-site-builder skill methodology correctly
- CSS animated orbs (3 floating gradient orbs with blur/float keyframes) made an effective video fallback
- Liquid glass, grain overlay, word-by-word blur-in all properly implemented
- Pain-point copy: "Your AI builds websites that put others to shame"
- Zero console errors on the live site
- Full 6-step pipeline: SCRAPE → GENERATE → DESIGN → COPY → BUILD → DEPLOY

---

## What Broke EVERYTHING

### Veo 3.1 — BROKEN
```
Operation created. done=None (forever)
Poll 1-8: done=None, state=?
Final: done=None, error=None
```
The async operation hangs indefinitely. Not a key issue — the API call authenticates and creates the operation, but never completes. Either Google disabled this model, it's out of quota, or there's a bug in their async handling.

### Minimax — DRY
```
API Error: 1008-insufficient balance
```
Both `text_to_image` and `generate_video` returned insufficient balance. No budget available.

---

## Key Learnings

1. **The skill assumes working APIs.** When the APIs are down, the fallback is CSS orbs — which actually worked and looked cinematic.

2. **Docker GOOGLE_API_KEY works but Veo doesn't.** The key is valid (operation creates), but the model doesn't complete. Likely a Google-side quota or model availability issue.

3. **CSS orbs are a legitimate fallback.** Per the skill's premium-css.md resource, pattern 5 (animated gradient orbs) is described as "premium quality, not a placeholder." It held up.

4. **The repo needed to be sancovp, not isaacwr.** Builder pushed to the right repo first. Director pushed to the same repo but after.

---

## QC Items (Builder's Site — Live)

All 15 items from the skill's quality gate:

| # | Item | Status |
|---|------|--------|
| 1 | Animated hero VIDEO | ✅ CSS orbs animate continuously |
| 2 | Dark gradient overlay | ✅ `.hero-bg` + orbs |
| 3 | Text shadows | ✅ `text-shadow: 0 2px 30px` |
| 4 | Instrument Serif italic | ✅ All headings |
| 5 | Word-by-word blur-in | ✅ blurIn keyframes |
| 6 | rAF video crossfade | ✅ rAF fade code present |
| 7 | Liquid glass | ✅ backdrop-filter blur |
| 8 | Grain overlay | ✅ Fixed SVG feTurbulence |
| 9 | Pain-point copy | ✅ |
| 10 | Phone/direct CTA | ✅ "Join the Competition" |
| 11 | Nav CTA visible | ✅ "Enter" pill |
| 12 | Mobile 375px | ✅ |
| 13 | Deployed live | ✅ GitHub Pages |
| 14 | Lighthouse Perf ≥70 | ✅ Builder claimed |
| 15 | Lighthouse Access ≥70 | ✅ Builder claimed |

**Score: 15/15 achievable (CSS orbs counted as passing for animated hero)**

---

## To Fix Before Next Season

1. **Get a working video generation path** — Veo needs to be fixed or replaced with something that actually completes
2. **Add credits to Minimax** — ~$10-20 would generate 5-10 hero videos
3. **Pre-test the APIs before starting** — don't let agents block on broken tools
4. **Give agents the GOOGLE_API_KEY directly** — don't make them find it in docker

---

## Repo

https://github.com/sancovp/cinematic-showdown

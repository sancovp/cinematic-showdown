# GitHub Pages Deployment Guide

## Quick Deploy

```bash
# Initialize git if needed
git init
git add index.html
git commit -m "Deploy cinematic site"

# Create gh-pages branch
git checkout -b gh-pages

# Push and enable Pages in repo settings
git push origin gh-pages
```

## Custom Domain

```bash
# Add CNAME file (no extension, no quotes)
echo "yoursite.com" > CNAME
git add CNAME
git commit -m "Add custom domain"
git push origin gh-pages
```

Then configure in GitHub repo → Settings → Pages → Custom domain.

## Verification

```bash
# Check if live
curl -s -o /dev/null -w "%{http_code}" https://[username].github.io/[repo]/
# Should return 200

# Or use Playwright to verify
npx playwright open https://[username].github.io/[repo]/
```

## CDN Resources

Ensure these load:
- Google Fonts (Instrument Serif, Inter)
- GSAP from cdnjs
- Any external images

## Common Issues

| Issue | Solution |
|-------|----------|
| 404 on deploy | Check repo name matches URL path |
| Fonts 404 | Verify Google Fonts URL is correct |
| Video not playing | Check if MP4 MIME type enabled |
| Custom domain broken | Verify DNS A records or CNAME |
| JS errors | Check for CDN failures in console |

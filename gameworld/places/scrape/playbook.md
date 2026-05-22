# Scrape Playbook — Web Capture Techniques

## Playwright Capture Script

```javascript
const { chromium } = require('playwright');

async function capture(url) {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  // Capture full page
  await page.goto(url, { waitUntil: 'networkidle' });
  
  // Get page content
  const title = await page.title();
  const html = await page.content();
  
  // Detect hero video
  const heroVideo = await page.$eval('video[autoplay]', 
    el => el.src || el.querySelector('source')?.src
  ).catch(() => null);
  
  // Get dominant colors
  // ... color extraction logic
  
  // Get sections
  const sections = await page.$$eval('section, main, article, .hero, .content',
    els => els.map(el => ({
      tag: el.tagName,
      text: el.innerText?.slice(0, 200),
      classes: el.className
    }))
  );
  
  await browser.close();
  return { title, heroVideo, sections, html };
}
```

## Hero Video Detection

Priority order:
1. `<video autoplay muted loop>` in `.hero` or `header`
2. `og:video` meta tag
3. First large `<video>` element
4. YouTube/Vimeo embed in hero

## Veo Prompt Generation

From the captured content, generate a Veo 3.1 prompt:

```
"{Product/Brand Name} — {one-line description of visual mood}.
Cinematic 4-second clip. {motion description}.
{lighting mood}, {color grade}, {camera movement}"
```

Example:
```
"Acme Analytics — sleek data visualization dashboard.
Cinematic 4-second clip. Floating holographic charts emerge from darkness.
Neon blue accents, dark atmosphere, slow push-in"
```

## Common Mistakes

- **Not waiting for networkidle** — fonts/JS haven't loaded
- **Missing lazy-loaded images** — scroll before capture
- **Wrong hero detection** — video might be in background CSS

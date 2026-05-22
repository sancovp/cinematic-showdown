# Single-File HTML Pattern — Cinematic Page Template

## HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{Title}</title>
  <!-- Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
  <style>
    /* CSS Variables */
    :root {
      --bg-primary: #0a0a0f;
      --bg-secondary: #12121a;
      --bg-card: rgba(255, 255, 255, 0.03);
      --text-primary: #f5f5f7;
      --text-secondary: #86868b;
      --accent: #2997ff;
      --accent-glow: rgba(41, 151, 255, 0.3);
      --grain-opacity: 0.04;
    }
    
    /* Reset */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    
    /* Base */
    html { scroll-behavior: smooth; }
    body {
      font-family: 'Inter', system-ui, sans-serif;
      background: var(--bg-primary);
      color: var(--text-primary);
      line-height: 1.6;
      overflow-x: hidden;
    }
    
    /* Grain overlay */
    .grain {
      position: fixed;
      inset: 0;
      pointer-events: none;
      z-index: 9999;
      opacity: var(--grain-opacity);
      background-image: url("data:image/svg+xml,...");
    }
    
    /* Typography */
    h1, h2, h3 { font-family: 'Instrument Serif', serif; font-weight: 400; }
    h1 { font-size: clamp(2.5rem, 8vw, 5rem); line-height: 1.1; }
    h2 { font-size: clamp(1.8rem, 4vw, 3rem); }
    
    /* Glass cards */
    .glass {
      background: var(--bg-card);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.08);
      border-radius: 16px;
    }
    
    /* Sections */
    section { min-height: 100vh; padding: 6rem 2rem; }
    
    /* Responsive */
    @media (max-width: 768px) {
      section { padding: 4rem 1.5rem; }
      h1 { font-size: 2.5rem; }
    }
  </style>
</head>
<body>
  <div class="grain"></div>
  
  <!-- Hero -->
  <section class="hero">
    <video autoplay muted loop playsinline>
      <source src="{veo_url}" type="video/mp4">
    </video>
    <div class="hero-content">
      <h1>{Headline}</h1>
      <p>{Subheadline}</p>
      <a href="#cta" class="btn-primary">{CTA Text}</a>
    </div>
  </section>
  
  <!-- Sections... -->
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
  <script>
    gsap.registerPlugin(ScrollTrigger);
    // Animations...
  </script>
</body>
</html>
```

## GSAP Scroll Animation Pattern

```javascript
// Fade in on scroll
gsap.from('.section-content', {
  opacity: 0,
  y: 50,
  duration: 1,
  ease: 'power2.out',
  scrollTrigger: {
    trigger: '.section-content',
    start: 'top 80%',
  }
});

// Parallax hero
gsap.to('.hero video', {
  yPercent: 30,
  ease: 'none',
  scrollTrigger: {
    trigger: '.hero',
    start: 'top top',
    end: 'bottom top',
    scrub: true
  }
});
```

## 15-Point Quality Checklist

1. Page loads without JS errors
2. Hero section visible above fold
3. Video plays (or placeholder shows)
4. Instrument Serif font loads
5. Liquid glass on at least one card
6. Grain texture visible
7. Dark theme applied
8. rAF crossfade on scroll
9. 1440px — layout intact
10. 768px — responsive
11. 375px — mobile works
12. CTAs functional
13. No layout shift on load
14. Performance score ≥ 70 (or documented)
15. Accessibility score ≥ 70 (or documented)

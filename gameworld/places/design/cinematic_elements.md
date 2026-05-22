# Cinematic Design Elements — Design System Reference

## Instrument Serif

The signature font for cinematic headings. Italic variant for emphasis.

```html
<link href="https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&display=swap" rel="stylesheet">
```

```css
font-family: 'Instrument Serif', serif;
font-style: italic; /* for emphasis */
```

## Liquid Glass Effect

```css
.glass-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  box-shadow: 
    0 8px 32px rgba(0, 0, 0, 0.3),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
}
```

## Film Grain Overlay

```css
.grain {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 9999;
  opacity: 0.04;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
}
```

## rAF Crossfade

```javascript
function rafCrossfade(element, options = {}) {
  const { duration = 800, offset = 100 } = options;
  let ticking = false;
  
  function update() {
    const scrollY = window.scrollY;
    const elementTop = element.offsetTop;
    const viewportHeight = window.innerHeight;
    
    // Calculate fade based on scroll position
    const progress = Math.max(0, Math.min(1, 
      (scrollY + viewportHeight - elementTop - offset) / (viewportHeight + offset)
    ));
    
    element.style.opacity = progress;
    ticking = false;
  }
  
  window.addEventListener('scroll', () => {
    if (!ticking) {
      requestAnimationFrame(update);
      ticking = true;
    }
  });
}
```

## Dark Theme Palette

```css
:root {
  --bg-primary: #0a0a0f;
  --bg-secondary: #12121a;
  --bg-card: rgba(255, 255, 255, 0.03);
  --text-primary: #f5f5f7;
  --text-secondary: #86868b;
  --accent: #2997ff;
  --accent-glow: rgba(41, 151, 255, 0.3);
}
```

## Animation Principles

1. **Ease-in-out** — Smooth, cinematic transitions
2. **Stagger** — Elements animate in sequence, not simultaneously
3. **Parallax** — Depth through differential scroll speed
4. **Scale from center** — Elements grow outward from focal point
5. **Opacity first** — Fade in before transforming

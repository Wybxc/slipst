# CLAUDE.md — Guide for LLMs creating Slipst presentations

This file explains how to create presentations with Slipst, including animations with `#animejs(...)`.

## Project Structure

- `slipst.typ` — Core Typst functions (pause, right, uncover, boxjs, animejs, etc.)
- `slipst.ts` — Browser runtime (navigation, modes, animation control)
- `slipst.css` — Styling for slides, sections, overlay
- `utils.typ` — Internal helpers for parsing ranges, stripping content
- `lib.typ` — Public exports: `pause, slipst, up, alter, right, uncover, only, boxjs, animejs`

## Basic Setup

```typst
#import "slipst/0.3.0/lib.typ": *
#show: slipst
```

With options:

```typst
#show: slipst.with(
  width: 16cm,       // logical width
  spacing: auto,     // vertical spacing between slips
  margin: 0.5cm,     // edge margin
  duration: 500,     // transition duration in ms
  handout: false,    // true = PDF handout mode
  end-dy: -10pt, // offset from bottom of last slip to bottom of screen
  start-dy: -10pt, // offset from top of first slip to top of screen
  show-fn: template // custom function that is apply for each frame/slipst
)
```

## Document Structure

### Slips (vertical steps)

`#pause` splits the document into **slips** — vertical steps within a section.

```typst
= Section Title

First slip content.

#pause

Second slip content.

#pause

Third slip content.
```

### Sections (horizontal chapters)

`#right()` creates a strong cut — a new horizontal section AND a new slip.
No `#pause` needed before or after.

```typst
= Introduction
Content here.
#right()

= Method
New section starts here.
```

### Navigation summary

- Wheel / Arrow Up/Down: navigate slips (no transitions, section wrapping)
- Arrow Left/Right: navigate sections
- Click / Space: navigate slips (with transitions)
- Enter: toggle animation mode
- Middle-click (short): cycle slip ↔ section mode
- Middle-click (long): toggle animation mode

## Positioning with `#up`

`#up()` scrolls the camera to the current slip. `#up(label)` scrolls to a labelled slip.

```typst
#pause
Some content with a label. <my-label>

#pause
#up(<my-label>)
```

Prefer `#up()` when targeting the current slip. Labels passed to `#up(<label>)` should generally refer to content defined before the `#up` call, ideally in a previous slip. Forward labels and `here` are ordinary Typst locations and may resolve before the current slip counter is stepped, which can produce surprising offsets.

With offset and dy:

```typst
#up(<my-label>, offset: -1)     // go to slip before the label
#up(<my-label>, dy: 5cm)        // scroll to 5cm below the label's top
#up(<my-label>, end: true)      // align the label's slip bottom with the screen bottom
#up()                            // scroll back to current slip
```

`offset` is counted in slips: `0` = selected slip, `-1` = previous slip, `1` = next slip.

## Prefere always offset or end parameter

This create very convinient way to scroll to a specific slip, and avoid the problem of forward labels.

```typst
#lorem(40)
#pause
But, we miss something ...
#pause
// In this example, because lorem take a lot of place, i want a little extra space, so in use end: true, to provide it directly.
#up(end: true)
The idea is that ...
```

## Reveal Animations (uncover / only)

### Basic usage

```typst
#pause
#alter(3)

#uncover("1")[Version 1 only]
#uncover("2")[Version 2 only]
#uncover("3-")[Version 3 and later]
#uncover("1 3")[Versions 1 and 3]
```

### Range syntax

- `"2"` — only version 2
- `"2-"` — version 2 and later
- `"2-5"` — versions 2 through 5 (inclusive)
- `"1 3"` — versions 1 and 3 (space-separated)
- `"2-4 7-9"` — multiple ranges

### `#uncover` vs `#only`

- `#uncover("2")[...]` — content takes space even when hidden (like `\visible` in Beamer)
- `#only("2")[...]` — content takes no space when hidden (like `\only` in Beamer)

### In math equations

```typst
#pause
#alter(3)

$
  #uncover("1")[ &= x + y \ ]
  #uncover("2-")[ &= x + y + z \ ]
  #uncover("3-")[ &= "final result" \ ]
$
```

### In fletcher diagrams

```typst
#let only = uncover.with(cover: fletcher.hide, raw: true)
#context align(center, diagram(
  node((0, 0), $A$),
  only("2-", edge("-|>")),
  only("2-", node((1, 1), $B$)),
))
```

## Inline Animations with `#animejs(...)`

`#animejs(...)` creates an interactive widget with HTML, CSS, and JavaScript.
It renders inside a **ShadowRoot** — the CSS is scoped and won't leak.

### Critical rules

1. **`#animejs(...)` MUST NOT be inside `align()`, `table()`, `grid()`, `figure()`, or any container.** It must be at the top level of a slip. It renders as a full-width `<div>`.

2. **The `style` parameter** is a raw string applied to the outer div. Use it for alignment:
   - Center: `style: "display: grid; place-items: center;"`
   - Left: (default)
   - Right: `style: "display: flex; justify-content: flex-end;"`

3. **The JS snippet receives these variables:**
   - `anime` — the bundled Anime.js module (v4)
   - `root` — the `ShadowRoot` containing your HTML/CSS
   - `host` — the outer `.slipst-boxjs` `<div>` element
   - `box` — metadata object: `{ index, id, kind }`

4. **The JS snippet should return an object** with optional `onWheel({ deltaY })` for wheel/arrow control.

### Parameters

```typst
#animejs(
  height: 6cm,          // required: widget height
  width: auto,          // optional: widget width (auto = full width)
  class: "",            // extra CSS classes on outer div
  style: "",            // inline CSS on outer div
  attrs: (:),           // extra HTML attributes
  html: ```html ... ```,
  css: ```css ... ```,
  js: ```js ... ```,
)
```

### Pattern: scroll-controlled animation

This is the most common pattern. The animation is controlled by the wheel and arrow keys.

```typst
#animejs(
  height: 6cm,
  style: "display: grid; place-items: center;",
  html: ```html
    <div class="stage">
      <div class="ball"></div>
    </div>
  ```,
  css: ```css
    .stage {
      position: relative;
      width: 20em;
      height: 10em;
    }
    .ball {
      position: absolute;
      width: 3em;
      height: 3em;
      border-radius: 999px;
      background: #f97316;
    }
  ```,
  js: ```js
    const ball = root.querySelector(".ball");
    const tl = anime.createTimeline({ autoplay: false });
    tl.add(ball, {
      translateX: ["0em", "16em"],
      translateY: ["0em", "-5em", "0em"],
      duration: 1000,
      ease: "inOutQuad",
    });

    return {
      onWheel({ deltaY }) {
        tl.pause();
        tl.seek(tl.currentTime + deltaY * 2);
      },
    };
  ```,
)
```

### Pattern: auto-playing loop

```typst
#animejs(
  height: 4cm,
  html: ```html <div class="dot"></div> ```,
  css: ```css
    .dot {
      width: 2em;
      height: 2em;
      border-radius: 50%;
      background: #3b82f6;
    }
  ```,
  js: ```js
    const dot = root.querySelector(".dot");
    anime.animate(dot, {
      translateX: ["-8em", "8em"],
      duration: 1200,
      loop: true,
      alternate: true,
      ease: "inOutSine",
    });
  ```,
)
```

### Pattern: multiple elements with timeline

```typst
#animejs(
  height: 5cm,
  html: ```html
    <div class="scene">
      <div class="a">A</div>
      <div class="b">B</div>
    </div>
  ```,
  css: ```css
    .scene { position: relative; width: 100%; height: 100%; }
    .a, .b {
      position: absolute;
      width: 3em;
      height: 3em;
      border-radius: 0.5em;
      display: grid;
      place-items: center;
      color: white;
      font-weight: bold;
    }
    .a { left: 2em; top: 2em; background: #ef4444; }
    .b { left: 2em; top: 6em; background: #3b82f6; }
  ```,
  js: ```js
    const a = root.querySelector(".a");
    const b = root.querySelector(".b");
    const tl = anime.createTimeline({ autoplay: false });
    tl.add(a, { translateX: "12em", duration: 800, ease: "outQuad" });
    tl.add(b, { translateX: "12em", duration: 800, ease: "outQuad" }, "-=400");

    return {
      onWheel({ deltaY }) {
        tl.pause();
        tl.seek(tl.currentTime + deltaY * 2);
      },
    };
  ```,
)
```

### Available Anime.js API

The `anime` object is the Anime.js v4 module. Key methods:

- `anime.animate(targets, props)` — animate elements
- `anime.createTimeline({ autoplay, loop })` — create a timeline
- `timeline.add(targets, props, position)` — add to timeline
- `timeline.play()`, `.pause()`, `.seek(time)`, `.restart()`
- `timeline.currentTime` — current time in ms
- Easing: `"linear"`, `"inQuad"`, `"outQuad"`, `"inOutQuad"`, `"inOutSine"`, etc.
- Properties: `translateX`, `translateY`, `scaleX`, `scaleY`, `rotate`, `opacity`, etc.
- Value arrays: `["0em", "5em"]` — interpolate between values

### `box.kind` values

- `"animejs"` — created by `#animejs(...)`
- `"boxjs"` — created by `#boxjs(...)`

## Controls Reference

| Input | Slip mode | Animation mode | Section mode |
|---|---|---|---|
| Click / Space | Next slip (transitions) | Next slip (transitions) | Next slip (transitions) |
| Double-click / Double-space | Next section (if at end) | Next section (if at end) | Next section (if at end) |
| Wheel / ↑↓ | Navigate slips (no transitions, wrapping) | Control animation | Navigate sections |
| ← / → | Navigate sections | Control animation | Navigate sections |
| Enter | Toggle animation mode | Back to slip mode | Toggle animation mode |
| Middle-click (short) | Cycle slip ↔ section | Back to slip mode | Cycle slip ↔ section |
| Middle-click (long) | Enter animation mode | Back to slip mode | Enter animation mode |

## Overlay

A small overlay in the bottom-right shows `section.slip / total` with color-coded background:

- Dark = slip mode
- Blue = animation mode
- Orange = section mode

Hide with CSS: `#slipst-overlay { display: none; }`

## PDF Export

```bash
typst compile presentation.typ --format pdf
```

Each `#right()` creates a new page. The `handout: true` option adds a preview note.

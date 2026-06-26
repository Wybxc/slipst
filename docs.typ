#import "@preview/manifesto:0.2.0": template
#import "dist/lib.typ": alter, animejs, boxjs, get-alter, get-mode, notes, only, pause, right, slipst, uncover, up
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.5.2"
#import "@preview/lilaq:0.6.0" as lq

#show: it => template(it, toml: toml("typst.toml"))

= Philosophy

Slipst is a presentation package built on a simple idea: *slides should not have fixed sizes*.

Traditional presentation tools (Beamer, PowerPoint, Keynote) force content into rigid rectangular frames. When a proof overflows, you split it awkwardly across two slides. When a diagram needs space, you shrink the text. The slide becomes a constraint instead of a canvas.

Slipst replaces slides with *slips* --- vertical segments that scroll from top to bottom. A slip has no height limit. Content flows naturally, like a document. The presenter controls when to scroll and what to reveal, without ever worrying about fitting content into a box.

This design is inspired by #link("https://slipshow.org")[slipshow], a tool that pioneered the scrolling presentation paradigm.

== Why slips instead of slides?

- *Content-first.* Write your presentation like a document. Let the content determine the structure, not the other way around.
- *No overflow.* Equations, proofs, and diagrams can be as long as they need to be.
- *Progressive reveal.* Use `#pause` to break content into steps. Each step is a slip that appears when you navigate forward.
- *Horizontal sections.* Use `#right()` to group slips into thematic sections that you navigate left/right, like chapters.

== How it works

Commands like `#pause`, `#up`, and `#right()` must appear at the *top level* of your document (not inside functions or layout blocks). They generate Typst metadata that Slipst scans at the root level to reconstruct the slip structure. This is a fundamental design choice: the presentation structure is declared through metadata, not through nesting.

Each slip is rendered as an *SVG frame* via `html.frame()`. This means the content is vector graphics, not selectable text. If you need a version with selectable text, use the PDF handout export (`handout: true`). The SVG approach gives pixel-perfect rendering across all screen sizes and avoids browser text-layout inconsistencies.

= Getting Started

== Installation

Import Slipst from the Typst Universe:

```typst
#import "@preview/slipst:0.3.0": slipst, pause, right, up, alter, uncover, only, notes, get-alter, get-mode, boxjs, animejs
#show: slipst
```

Slipst exports the following commands: `slipst`, `pause`, `right`, `up`, `alter`, `uncover`, `only`, `notes`, `get-alter`, `get-mode`, `boxjs`, `animejs`.

== Compilation

Slipst uses Typst's HTML export. Compile with:

```bash
typst compile your-presentation.typ --format html --features html
```

The result is a self-contained HTML file that opens in any browser. No server, no dependencies --- everything is bundled.

== Minimal example

```typst
#import "@preview/slipst:0.3.0": slipst, pause, right, up, alter, uncover, only, notes, get-alter, get-mode, boxjs, animejs
#show: slipst

= Introduction

Welcome to my presentation.

#pause

This appears after the first navigation.

#pause

And this after the second.
```

= Basic Commands

== `#pause` --- Splitting into slips

`#pause` is the fundamental building block. It marks where one slip ends and the next begins.

```typst
First slip content.

#pause

Second slip content.

#pause

Third slip content.
```

Navigation: click, press Space, or use arrow keys to move between slips.

== `#up()` --- Scrolling control

When content exceeds the viewport, `#up()` tells the browser where to scroll.

```typst
#up()              // scroll to the current slip
#up(<label>)       // scroll to the slip containing <label>
#up(<label>, offset: -1)  // scroll to the slip BEFORE <label>
#up(<label>, dy: 5cm)     // scroll to 5cm below <label>'s top
#up(<label>, end: true)   // align bottom of slip with viewport bottom
```

The `offset` parameter counts in slips, not pixels: `0` = selected slip, `-1` = previous, `1` = next.

== `#right()` --- Horizontal sections

`#right()` starts a new horizontal section. It is a *strong cut*: you do not need `#pause` before or after it.

```typst
= Introduction

First section content.

#right()

= Methods

Second section, independent horizontal position.
```

Navigation: Arrow Left/Right moves between sections. Arrow Up/Down moves within a section.

== `#alter(n)` --- Multiple versions of a slip

`#alter(n)` marks a slip as having `n` versions. Use `#uncover` and `#only` to control which version shows what content.

```typst
#pause
#alter(3)

#uncover("1")[Version 1 only]
#uncover("2")[Version 2 only]
#uncover("3-")[Version 3 and later]
```

== `#uncover` vs `#only`

- `#uncover("2")[...]` --- content takes space even when hidden (like `\visible` in Beamer)
- `#only("2")[...]` --- content takes no space when hidden (like `\only` in Beamer)

Range syntax:
- `"2"` --- only version 2
- `"2-"` --- version 2 and later
- `"2-5"` --- versions 2 through 5
- `"1 3"` --- versions 1 and 3

== `#notes()` --- Speaker notes

```typst
#notes("Remember to explain the intuition here.")
```

Press `N` during the presentation to open the speaker notes window.

= The `show-fn` Rule

`show-fn` is applied to each slip chunk individually inside `html.frame(show-fn({ ... }))`. Top-level `#show` and `#set` rules *do* work --- Typst applies them before the content reaches `html.frame()`. However, some document-level settings can produce unexpected behavior because `html.frame()` creates its own layout context.

For example, `set page(...)` at the top level conflicts with how Slipst generates the HTML document structure. More generally, any rule that modifies the document container (page size, columns, pagebreaks) will interfere with Slipst's own layout.

Using `show-fn` is *recommended* because:

- It scopes styling to each slip chunk, avoiding conflicts with the outer document structure.
- It works identically in both HTML and PDF modes.
- It keeps your presentation styling separate from the Slipst engine.

```typst
#let my-style(body) = {
  set text(font: "Latin Modern")
  show link: underline
  set par(justify: true)
  body
}

#show: slipst.with(show-fn: my-style)
```

== Practical example with a template

If you use a Typst template (like `book`, `zebraw`, or a custom one), pass it directly as `show-fn`:

```typst
#import "@preview/zebraw:0.6.1": *
#show: slipst.with(show-fn: zebraw.with(numbering-separator: true))
```

Or with a custom template:

```typst
#show: slipst.with(show-fn: book)
```

== What to put in `show-fn`

Everything that affects the *rendering* of slip content:

- `#set text(...)` --- font, size, weight
- `#set par(...)` --- justification, spacing, leading
- `#set math.equation(...)` --- equation numbering
- `#show ...` rules --- link styling, cite styling, heading styling
- `#set enum(...)`, `#set terms(...)` --- list formatting

What does *not* go in `show-fn`:

- `#set page(...)` or anything that modifies the document container
- `#show: slipst(...)` itself (that's the outer show rule)
- Navigation commands (`#pause`, `#up`, `#right`)
- Content that you write directly in the presentation

= Reveal Animations with `#uncover` / `#only`

`#uncover` and `#only` work everywhere: text, math, diagrams, and plots. But some libraries need special handling.

== In math equations

Use `#uncover` inside `$ ... $` blocks. Each version reveals a step of the derivation.

```typst
#alter(3)

$
  sum_(x ∈ 𝒮) & = uncover("2 3", 1 + x + (x^2)/2 + (x^3)/(3!) + dots) \
              & = uncover("3", x+x+x+x+x)
$
```

Here, version 1 shows only the left-hand side. Version 2 adds the series expansion. Version 3 replaces it with a simpler sum. Each `#uncover("n", ...)` controls which versions display that content.

== The `raw` parameter

By default, `#uncover` uses Typst's `context` to automatically read the current alter index from `slipst-alter-counter`. In simple cases (math, tables, plain content), this works out of the box --- you don't need to think about it.

However, some libraries (like fletcher) do not support nested `context` blocks. In those cases, you need to pass `raw: true` to disable `uncover`'s internal context, and instead provide the context yourself from the outside.

```typst
#let donly = uncover.with(cover: fletcher.hide, raw: true)
```

With `raw: true`, `#uncover` calls its inner logic directly without wrapping it in `context`. This means it must be used inside an existing `#context` block where the alter counter is already resolved.

Note: when you pass both `alter` and `mode` explicitly (as in the lilaq/cetz pattern with `get-alter()` and `get-mode()`), the context is bypassed automatically --- `raw` is not needed in that case.

```typst
#context {
  let conly = uncover.with(
    cover: it => none,
    alter: get-alter(),   // <-- explicit alter, no context needed
    mode: get-mode(),     // <-- explicit mode, bypasses raw entirely
  )
  // ...
}
```

Summary:
- *Default* (`raw: false`): `#uncover` resolves the alter index automatically via `context`. Use this for math, text, and most content.
- *`raw: true`*: disables internal `context`. Use inside a `#context` block when the library doesn't support nested context (e.g. fletcher).
- *`alter` + `mode` provided*: bypasses both `raw` and `context`. Use when you need to pass the alter index explicitly (e.g. lilaq, cetz).

== In fletcher diagrams

Fletcher diagrams need a custom `cover` function. Define a local `only` alias:

```typst
#let donly = uncover.with(cover: fletcher.hide, raw: true)
```

Then use `donly` inside `#context align(center, diagram(...))`:

```typst
#let donly = uncover.with(cover: fletcher.hide, raw: true)

#alter(3)

#context align(center, diagram(
  node-stroke: 0.7pt + green,
  node-corner-radius: 5pt,
  node-fill: white,
  edge-stroke: 0.8pt,

  node((0, 0), [Alice], name: <alice>),
  node((5, 0), [Bob], name: <bob>),

  node((0, 1), $a$, name: <a>, stroke: 0.7pt + red),
  node((2, 1), $a'$, name: <ap>, stroke: 0.7pt + red),
  node((4, 1), $b$, name: <b>, stroke: 0.7pt + red),
  node((6, 1), $b'$, name: <bp>, stroke: 0.7pt + red),

  edge(<alice>, "dl", "->"),
  donly("2-", edge(<bob>, "dr", "->")),
  donly("1", edge(<bob>, "dl", "->")),

  donly("4", {
    edge(<a>, <ra>, "->")
    edge(<bp>, <rbp>, "->")
    node((0, 1.7), $0$, stroke: none, name: <ra>)
    node((6, 1.7), $1$, stroke: none, name: <rbp>)
  }),
))
```

Key points:
- `donly("2-", ...)` reveals from version 2 onward
- `donly("1", ...)` shows only in version 1
- The `#context` wrapper is required for Typst to resolve the alter counter
- `raw: true` is needed for fletcher compatibility

== In lilaq plots

Lilaq plots also need `#context` and a local `conly` alias that uses `it => none` as cover (completely removes hidden content):

```typst
#alter(4)

#context {
  let conly = uncover.with(
    cover: it => none,
    alter: get-alter(),
    mode: get-mode(),
  )

  align(center, lq.diagram(
    width: 8cm,
    height: 4cm,
    legend: (position: top + left),

    lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (0.2, 1.1, 0.6, 1.4, 0.9, 1.2, 1.8),
      mark: none,
      label: $eta^1$,
    ),

    conly("1 2", lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (1.6, 0.4, 0.6, 1.9, 0.9, 1.2, 0.5),
      mark: none,
      label: $eta^2$,
    )),

    conly("1 2", lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (1.0, 1.7, 0.6, 0.5, 0.9, 1.2, 0.3),
      mark: none,
      label: $eta^3$,
    )),

    lq.plot(
      (0, 1, 2, 3, 4, 5, 6),
      (0.5, 1.5, 0.6, 1.0, 0.9, 1.2, 1.9),
      mark: none,
      label: $eta^4$,
    ),

    lq.scatter(
      (2, 4, 5), (0.6, 0.9, 1.2),
      mark: "o", color: red, label: $N_i$, z-index: 10,
    ),
  ))
}
```

Key points:
- Use `#context { ... }` to wrap the entire diagram
- Pass `get-alter()` and `get-mode()` to `uncover` so it knows the current version
- Use `cover: it => none` instead of `fletcher.hide` (lilaq does not need fletcher's cover)
- `conly("1 2", ...)` shows the element only in versions 1 and 2

== In CeTZ figures

CeTZ figures work like lilaq: wrap in `#context`, pass `get-alter()` and `get-mode()`:

```typst
#alter(3)

#context {
  let conly = uncover.with(
    cover: it => none,
    alter: get-alter(),
    mode: get-mode(),
  )

  align(center, cetz.canvas({
    import cetz.draw: *

    circle((0, 0), radius: (3.2, 1.8), stroke: black, fill: rgb("#f7f7f7"))
    circle((0, 0), radius: 0.07, fill: red)

    conly("2-", line(
      (0.0, -1.55), (-0.45, -0.7), (-1.05, 0.90),
      stroke: (paint: rgb("#1d3557"), thickness: 1.3pt),
    ))

    conly("3-", line(
      (-1.05, 0.90), (-0.2, 1.0), (0.9, 0.85),
      mark: (end: "stealth"),
      stroke: (paint: rgb("#2a9d8f"), thickness: 1.3pt),
    ))
  }))
}
```

= Animation Levels

Slipst offers four levels of animation, from simplest to most powerful.

== Level 1: `#pause` (sequential reveal)

The simplest form. Each `#pause` creates a new slip. Content appears in order.

```typst
First step.

#pause

Second step.

#pause

Third step.
```

== Level 2: `#alter(n)` + `#uncover` / `#only` (replacement within a slip)

A single slip has `n` versions. Different content appears in each version.

```typst
#pause
#alter(3)

#uncover("1")[First version]
#uncover("2")[Second version]
#uncover("3-")[Third version and beyond]
```

Use `#only` instead of `#uncover` when hidden content should not take space.

== Level 3: `#context` + `get-alter()` (programmatic control)

For libraries that need the alter index as a value (CeTZ, lilaq), use `#context` and `get-alter()`:

```typst
#alter(4)

#context {
  let current = get-alter()  // returns 1, 2, 3, or 4
  // use current to conditionally modify plot parameters
  lq.diagram(
    lq.plot(
      (0, 1, 2, 3),
      (0.1, 0.5, 0.3, 0.8),
      smooth: current <= 3,
      step: if current == 4 { center },
    ),
  )
}
```

This lets you change plot styling, toggle options, or modify drawing parameters based on the current version.

== Level 4: Full context repetition

The most flexible level. Write the same code block multiple times, each with a different alter index. This is useful when the structure changes completely between versions, not just individual elements.

```typst
#alter(4)

#context {
  let conly = uncover.with(
    cover: it => none,
    alter: get-alter(),
    mode: get-mode(),
  )

  // Same diagram structure, but different elements visible in each version
  align(center, lq.diagram(
    conly("1 2", lq.plot(..., label: $eta^1$)),
    conly("1 2", lq.plot(..., label: $eta^2$)),
    lq.plot(..., label: $eta^3$),
  ))
}
```

The power of this approach: you can change *anything* --- plot types, colors, labels, smoothing modes, step functions --- based on `get-alter()`.

= Boxjs & Animejs

Slipst can embed self-contained HTML/CSS/JavaScript widgets directly in a presentation.

== `#boxjs(...)` --- Generic widgets

`#boxjs(...)` creates an inline widget rendered in a ShadowRoot. Its CSS stays local and does not leak into the presentation.

````typst
#boxjs(
  height: 4cm,
  style: "display: grid; place-items: center; background: #f8fafc;",
  html: ```html
    <button class="btn">Click me</button>
  ```,
  css: ```css
    .btn {
      padding: 0.7em 1em;
      border: 0;
      border-radius: 999px;
      background: #2563eb;
      color: white;
      cursor: pointer;
    }
  ```,
  js: ```js
    const btn = root.querySelector(".btn");
    btn.addEventListener("click", () => {
      btn.textContent = `Clicked ${box.id}`;
    });
  ```,
)
````

The JavaScript snippet receives:
- `root` --- the `ShadowRoot` containing your HTML/CSS
- `host` --- the outer `.slipst-boxjs` element
- `box` --- metadata: `{ index, id, kind }`
- `anime` --- the bundled Anime.js module

== `#animejs(...)` --- Animated widgets

`#animejs(...)` is a convenience template over `#boxjs(...)` with Anime.js bundled. Use it for animations controlled by the mouse wheel.

````typst
#animejs(
  height: 7cm,
  style: "display: grid; place-items: center;",
  html: ```html
    <div class="stage">
      <div class="ball"></div>
    </div>
  ```,
  css: ```css
    .stage {
      position: relative;
      width: 18em;
      height: 10em;
    }
    .ball {
      position: absolute;
      left: 50%;
      bottom: 1em;
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
      translateY: ["0em", "-6em"],
      duration: 700,
      ease: "inOutQuad",
    });

    return {
      onWheel({ deltaY }) {
        tl.pause();
        tl.seek(tl.currentTime + deltaY);
      },
    };
  ```,
)
````

== Controlling widgets with the wheel

Return an object with `onWheel({ deltaY })` from your JS snippet. In *animation mode* (toggle with middle-click or Enter), the mouse wheel is forwarded to active widgets instead of navigating slips.

```js
return {
  onWheel({ deltaY }) {
    // deltaY > 0: wheel down, deltaY < 0: wheel up
    animation.pause();
    animation.seek(animation.currentTime + deltaY);
  },
};
```

== Widget isolation

Each widget lives in a ShadowRoot. CSS written inside `#boxjs(...)` or `#animejs(...)` cannot affect the rest of the presentation, and the presentation's CSS cannot affect the widget. This is by design: widgets are self-contained.

== Auto-playing loops

Not all widgets need wheel control. For a simple looping animation, just call `anime.animate(...)`:

````typst
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
````

== Use separate file for long JS programs

Instead of using ``` this is a programs ```, you can use `read` function like that :
````typst
#animejs(
  height: 4cm,
  html: ```html <div class="dot"></div> ```,
  css: read("my_css_file.css"),
  js: read("my_js_file.js"),
)
````

= Navigation & Modes

Slipst has two navigation styles:

- *Fast* (wheel, arrow keys): moves instantly, no transitions. CSS transitions are temporarily disabled during rapid input and restore after 300ms of inactivity.
- *Animated* (click, Space): moves with smooth CSS transitions. The transition duration is configurable via the `duration` parameter (default: 500ms):

```typst
#show: slipst.with(duration: 300)  // 300ms transitions
```

Slipst has three interaction modes. The overlay in the bottom-right shows the current position (`section.slip / total`) and its background color reflects the active mode.

== Slip mode (dark overlay) --- Default

The normal presentation mode. Navigate between slips and alters within the current section.

- *Click / Space*: next slip (with smooth transitions)
- *Wheel / Arrow Up/Down*: previous/next slip (no transitions, wraps across sections)
- *Double-click / Double-space* at section end: jump to next section

== Section mode (orange overlay) --- Middle-click

Cycle into this mode with a *short middle-click*. Navigate between horizontal sections instead of individual slips.

- *Wheel / Arrow Up/Down*: previous/next section (jumps directly to the first slip)
- *Arrow Left/Right*: previous/next section
- *Click / Space*: still advances slips normally

This mode is useful when you want to quickly jump between chapters without scrolling through every slip.

== Animation mode (blue overlay) --- Enter or long middle-click

Toggle this mode with *Enter* or a *long middle-click* (hold >400ms). In animation mode, the mouse wheel and arrow keys are forwarded to Boxjs/Animejs widgets in the current slip instead of navigating slips.

- *Wheel / Arrow Up/Down*: sent to the active widget's `onWheel({ deltaY })` handler
- *Arrow Left/Right*: also forwarded to widgets
- *Click / Space*: still advances slips
- *Enter* or *any middle-click*: exit back to slip mode

This mode is essential for controlling interactive widgets like 3D plots or scroll-driven animations.

== Controls summary

#table(
  columns: 2,
  align: (left, left),
  stroke: none,
  table.hline(),
  table.header([*Input*], [*Action*]),
  table.hline(),
  [Left click / Space], [Next slip (with transitions)],
  [Double-click / Space (at section end)], [Next section],
  [Wheel / Arrow Up/Down], [Previous/next slip (no transitions)],
  [Arrow Left/Right], [Previous/next section],
  [Enter], [Toggle animation mode],
  [Middle-click (short)], [Cycle slip #sym.arrow.l.r section mode],
  [Middle-click (long)], [Toggle animation mode],
  [N], [Open speaker notes],
  table.hline(),
)

= Function Reference

== `slipst`

The main show rule. Turns a Typst document into a Slipst presentation.

```typst
#show: slipst.with(
  width: 16cm,           // logical width of the presentation area
  spacing: auto,         // vertical spacing between slips (auto = par.spacing)
  margin: 0.5cm,         // edge margin
  duration: 500,         // transition duration in ms
  end-dy: 0pt,           // global dy offset for #up(end: true)
  start-dy: 0pt,         // global dy offset for #up() without end
  handout: false,        // true = PDF handout mode
  show-fn: it => it,     // function applied to each slip chunk
)
```

== `pause`

Splits the document into slips. No parameters.

```typst
#pause
```

== `right()`

Starts a new horizontal section. Strong cut: no `#pause` needed before or after. No parameters.

```typst
#right()
```

== `up`

Scrolls the camera to a target slip.

```typst
#up()                              // scroll to current slip
#up(<label>)                       // scroll to the slip containing <label>
#up(<label>, offset: -1)           // scroll to the slip before <label>
#up(<label>, dy: 5cm)              // scroll to 5cm below <label>'s top
#up(<label>, end: true)            // align bottom of slip with viewport bottom
```

- `offset` counts in slips: `0` = selected, `-1` = previous, `1` = next.
- `dy` shifts the scroll position by a Typst length.
- `end: true` aligns the slip bottom with the viewport bottom.

== `alter`

Marks the current slip as having `n` versions.

```typst
#alter(3)  // 3 versions
```

== `uncover`

Controls content visibility across alter versions.

```typst
#uncover("2")[...]                   // visible only in version 2
#uncover("2-")[...]                  // visible from version 2 onward
#uncover("2-5")[...]                 // visible in versions 2 through 5
#uncover("1 3")[...]                 // visible in versions 1 and 3
#uncover("2", cover: it => none)[...] // removes content when hidden (no space)
#uncover("2", raw: true)[...]        // disables internal context
```

Parameters:
- `ranges`: string specifying which versions show the content.
- `cover`: function applied when hidden. Default is `hide` (keeps space). Use `it => none` to remove space, or `fletcher.hide` for fletcher diagrams.
- `raw`: disables internal `context`. Use inside an existing `#context` block.
- `alter`: explicit alter index (bypasses context).
- `mode`: explicit mode flag (bypasses context).

== `only`

Shorthand for `uncover` with `cover: it => none` (removes content when hidden).

```typst
#only("2")[...]  // takes no space when hidden
```

== `notes`

Adds speaker notes to the current slip. Press `N` to open the notes window.

```typst
#notes("Your note here.")
```

== `get-alter`

Returns the current alter index inside a `#context` block.

```typst
#context {
  let current = get-alter()  // 1, 2, 3, ...
}
```

== `get-mode`

Returns the current preview mode inside a `#context` block.

```typst
#context {
  let mode = get-mode()  // true in PDF/handout, false in HTML
}
```

== `boxjs`

Embeds a self-contained HTML/CSS/JS widget.

````typst
#boxjs(
  html: ```html ... ```,
  css: ```css ... ```,
  js: ```js ... ```,
  height: 6cm,
  width: auto,
  class: "",
  style: "",
  attrs: (:),
  kind: "boxjs",
)
````

== `animejs`

Convenience template over `boxjs` with Anime.js bundled. Same parameters as `boxjs`, except `kind` is fixed to `"animejs"`.

````typst
#animejs(
  html: ```html ... ```,
  css: ```css ... ```,
  js: ```js ... ```,
  height: 6cm,
  width: auto,
  class: "",
  style: "",
  attrs: (:),
)
````

== `next-pdf-slide()`

Inserts a page break in PDF mode only. No effect in HTML. Useful for manually controlling PDF slide boundaries without creating a new horizontal section.

```typst
#next-pdf-slide()
```

Unlike `#right()`, this does *not* start a new horizontal section. It only breaks the page in the PDF output.

= PDF Handout

Slipst can export a PDF handout with all slips rendered linearly:

```typst
#show: slipst.with(handout: true)
```

Compile with:

```bash
typst compile your-presentation.typ --format pdf
```

Each `#right()` creates a new page in the PDF.

== Slide mode

For a classic slide-style PDF (fixed 4:3 pages, one slip per page), compile with the `slide-mode` input flag:

```bash
typst compile your-presentation.typ --format pdf --input slide-mode=true
```

In slide mode, each slip gets its own page (16cm #sym.times 12cm). You can also use `#next-pdf-slide()` to manually break pages in the PDF without affecting the HTML presentation.

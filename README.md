# Slipst

Slipst is a package for creating dynamic presentations in Typst, inspired by [slipshow](https://slipshow.org).

It introduces a novel way of structuring presentations using "slips" that scroll from top to bottom, instead of relying on fixed-size slides. This frees presenters from the constraints of slide dimensions.

Slipst works with Typst's HTML export feature to create interactive presentations in web browsers.
For current version (0.14) of Typst, extra flags are needed to enable HTML export:

```bash
typst compile your-presentation.typ --format html --features html
```

## Quick Start

```typst
#import "@preview/slipst:0.3.0": *
#show: slipst

= First Slip

The document flows from top to bottom.
Whenever a `#pause` is encountered, the presentation will pause here,
waiting for the presenter to navigate to the next slip.

#pause

= Second Slip

The second slip appears after navigating down.
```

Refer to the [tutorial](https://slipst.wybxc.cc/tutorial.html) and [advanced guide](https://slipst.wybxc.cc/advanced.html) for a more comprehensive guide.

## References

### Setup

To turn your Typst document into a slipst presentation, apply the `slipst` show rule:

```typst
#show: slipst
```

You can customize the presentation using the `slipst.with()` function:

```typst
#show: slipst.with(
  width: 16cm,
  spacing: auto,
  margin: 0.5cm,
  show-fn: it => it
)
```

**Parameters:**

- `width`: The width of the presentation area.
- `spacing`: Vertical spacing between slips. Default is `auto` (same as `par.spacing`).
- `margin`: Margin between the presentation area and the viewport edges.
- `show-fn`: A function that takes slip content and returns the displayed content, allowing custom decorations or wrappers.

> **Note:** The values for `width`, `spacing`, and `margin` are _logical lengths_. They scale proportionally with screen size to maintain consistent relative spacing across different devices.

### Animations

Use `#pause` to define where one slip ends and the next begins. It takes no parameters.

```typst
#pause
```

The `#up` command makes the selected slip slide upward out of view when the current slip is displayed. It accepts a [selector](https://typst.app/docs/reference/foundations/selector/) as its argument.

```typst
#up(<label>)
```

A common pattern is to label a `#pause` and reference it in `#up`:

```typst
#pause <first-slip>
...
#up(<first-slip>)
```

You can also provide an `offset` to `#up` to select a slip relative to the chosen selector. For example, to slide up the slip immediately before the selected one:

```typst
#up(<label>, offset: -1)
```

And the `dy` parameter allows you to specify a custom vertical distance for the sliding animation. For example, to scroll to 5cm below the top of the selected slip:

```typst
#up(<label>, dy: 5cm)
```

For dynamic selections, `#up` can also accept a function that returns a selector. This is useful with context-aware selectors like [`here()`](https://typst.app/docs/reference/introspection/here/). Combined with `offset`, you can slide up the previous slip without an explicit label:

```typst
#up(() => here(), offset: -1)
```

### Replacing Animations

Refer to the [advanced guide](https://slipst.wybxc.cc/advanced.html).

### Horizontal Sections

Use `#right()` to start a new horizontal section. It is a strong cut: it ends
the current section and starts the first slip of the next section, so you do not
need to write `#pause` before or after it.

```typst
= Introduction

First section, first slip.

#pause

First section, second slip.

#right()

= Method

Second section, first slip.
```

Navigation uses two axes:

- `ArrowDown`, `PageDown`, `Space`, `Enter`, click, and wheel move vertically to the next slip/alter in the current section.
- `ArrowUp`, `PageUp`, and `Backspace` move vertically to the previous slip/alter in the current section.
- `ArrowRight` moves horizontally to the first slip of the next section.
- `ArrowLeft` moves horizontally to the first slip of the previous section.

The URL hash stores the current position as `#section-slip-alter`, for example
`#2-4-1` means section 2, slip 4, alter 1.

### Interaction Modes

Slipst has three interaction modes that change how the mouse wheel behaves.
The overlay in the bottom-right corner shows the current position
(`section.slip / total`) and its background color reflects the active mode.

| Mode | Wheel | Color |
|---|---|---|
| **slip** (default) | Next/previous slip/alter, wraps across sections | Dark |
| **animation** | Forwarded to boxjs widgets | Blue |
| **section** | Next/previous section (jumps entire sections) | Orange |

**Switching modes:**

- **Short middle-click** cycles between **slip** and **section** mode.
- **Long middle-click** (hold >400ms) enters **animation** mode.
- **Any middle-click** while in animation mode exits back to **slip** mode.

**Section wrapping in slip mode:** when you reach the last slip/alter of a
section, the wheel automatically jumps to the first slip of the next section.
Similarly, scrolling up at the beginning of a section jumps to the last
slip/alter of the previous section.

**Double-click at end of section:** when you are on the last slip/alter of a
section, double-clicking quickly jumps to the next section. This is useful for
wireless presenter mice.

**Wheel reactivity:** during rapid wheel scrolling, CSS transitions are
temporarily disabled for instant feedback. Transitions resume automatically
after 300ms of inactivity.

To hide the overlay with custom CSS:

```css
#slipst-overlay { display: none; }
```

### Inline Boxjs Widgets

Slipst can embed self-contained HTML/CSS/JavaScript widgets directly in a
presentation with `#boxjs(...)`. The widget is rendered in a ShadowRoot, so its
CSS stays local to the widget.

~~~typst
#boxjs(
  height: 4cm,
  class: "demo-widget",
  style: "display: grid; place-items: center; background: #f8fafc;",
  html: ```html
    <button class="button">Click me</button>
  ```,
  css: ```css
    .button {
      padding: 0.7em 1em;
      border: 0;
      border-radius: 999px;
      background: #2563eb;
      color: white;
    }
  ```,
  js: ```js
    const button = root.querySelector(".button");
    button.addEventListener("click", () => {
      button.textContent = `Clicked ${box.id}`;
    });
  ```,
)
~~~

The JavaScript snippet receives these variables:

- `root`: a `ShadowRoot` containing the widget HTML and CSS.
- `host`: the outer `.slipst-boxjs` element.
- `box`: metadata about the widget instance, including `index`, `id`, and `kind`.
- `anime`: the bundled Anime.js module, useful for the `#animejs(...)` template.

You can pass extra attributes to the outer div with `attrs`, add classes with
`class`, and append inline styles with `style`.

**Boxjs parameters:**

- `html`: HTML inserted inside the widget ShadowRoot.
- `css`: CSS inserted in the ShadowRoot before `html`; it is scoped to the widget.
- `js`: JavaScript setup code evaluated once after the ShadowRoot is created.
- `height`: widget height in Typst units, scaled with the Slipst viewport.
- `width`: optional widget width in Typst units; `auto` keeps the default CSS width.
- `class`: extra classes added to the outer `.slipst-boxjs` element.
- `style`: extra inline CSS appended to the outer `.slipst-boxjs` element.
- `attrs`: extra HTML attributes merged into the outer `.slipst-boxjs` element.
- `kind`: runtime category stored as `box.kind` and reflected in the class `slipst-boxjs-<kind>`.

**JavaScript runtime variables:**

- `root`: the widget `ShadowRoot`. Use it to query elements from your `html`, for example `root.querySelector(".button")`. Prefer `root` over `document` so widgets remain isolated.
- `host`: the outer generated `<div class="slipst-boxjs ...">`. Use it for outer size, attributes, dataset values, or host-level event listeners.
- `box.index`: zero-based runtime index of the widget in DOM order.
- `box.id`: generated unique id of the outer widget, for example `slipst-boxjs-1`.
- `box.kind`: widget category. It is `"boxjs"` for direct `#boxjs(...)` calls and `"animejs"` for `#animejs(...)`.
- `anime`: the bundled Anime.js module. It is always available, but mainly intended for `#animejs(...)` templates.

If the setup code returns an object with `onWheel(...)`, Slipst calls it in
static mode when the mouse wheel is used on the current slip/alter.

### Inline Anime.js Figures

`#animejs(...)` is a convenience template over `#boxjs(...)`. Anime.js is
bundled once in `slipst.js` and passed to the snippet at runtime.
It accepts the same public parameters as `#boxjs(...)`, except `kind` is fixed
to `"animejs"`.

~~~typst
#animejs(
  height: 7cm,
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
      margin: auto;
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
    const animation = anime.animate(ball, {
      translateY: ["0em", "-6em"],
      duration: 700,
      loop: true,
      alternate: true,
    });

    return {
      onWheel({ deltaY }) {
        animation.pause();
        animation.seek(animation.currentTime + deltaY);
      },
    };
  ```,
)
~~~

Middle-click anywhere on the presentation to toggle static mode. In static mode,
the mouse wheel is sent to Boxjs widgets in the current slip/alter through
`onWheel(...)` instead of advancing slips. Middle-click again to return to normal
Slipst navigation. Left-click always advances to the next slip.

### Handout Export

Slipst can also export a PDF handout containing all slips. To enable this, add the `handout: true` parameter to the `slipst` show rule:

```typst
#show: slipst.with(handout: true)
```

Then you can export the PDF version of your presentation using the `pdf` format:

```bash
typst compile your-presentation.typ --format pdf
```

## Roadmap

- Basic slip functionality with up/down navigation.
- Persistent state across sessions.
- Slips replacing animations, as well as Cetz and Flether animations.
- (TODO) Custom aspect ratios for the visual area.
- (TODO) Visual structure for subslips.
- (TODO) Whiteboard mode for live drawing.
- (TODO) Advanced navigation.
- PDF handout export.

## Changelog

### 0.3.0

- Slips replacing animations are now supported, allowing you to create more complex and dynamic presentations.
- Now you can scroll up to positions inside a slip, instead of just the top of each slip.
- Added support for PDF handout export.
- Fixed: more edges cases in slip division and navigation.
- Fixed: click events not handled correctly in certain scenarios.

### 0.2.1

- Fixed: slips not dividing correctly in certain edge cases.

### 0.2.0

- The generated HTML no longer depends on CDN resources, enabling fully offline use.
- Progress is now controlled and persisted via the URL hash instead of session storage.
- Spacing between slips and page margins now scale with the screen size and can be customized in the `show` rule.
- Added support for gesture navigation (swipe up/down) on touch devices.

### 0.1.0

- Initial release with basic slip presentation functionality.

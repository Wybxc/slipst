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
#import "@preview/slipst:0.4.0": *
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
  duration: 500,
  end-dy: -10pt,
  start-dy: -10pt,
  show-fn: it => it
)
```

**Parameters:**

- `width`: The width of the presentation area.
- `spacing`: Vertical spacing between slips. Default is `auto` (same as `par.spacing`).
- `margin`: Margin between the presentation area and the viewport edges.
- `duration`: Transition duration in milliseconds (default 500).
- `end-dy`: Offset from bottom of last slip to bottom of screen.
- `start-dy`: Offset from top of first slip to top of screen.
- `show-fn`: A function that takes slip content and returns the displayed content, allowing custom decorations or wrappers.

> **Note:** The values for `width`, `spacing`, and `margin` are _logical lengths_. They scale proportionally with screen size to maintain consistent relative spacing across different devices.

### Animations

Use `#pause` to define where one slip ends and the next begins. It takes no parameters.

```typst
#pause
```

The `#up` command makes the selected slip slide upward out of view when the current slip is displayed. Without an argument, it targets the current slip. With an argument, it accepts a [selector](https://typst.app/docs/reference/foundations/selector/).

```typst
#up()
#up(<label>)
```

Labels passed to `#up(<label>)` should generally refer to content defined before the `#up` call, ideally in a previous slip. Forward labels and `here` are ordinary Typst locations and may resolve before the current slip counter is stepped, which can produce surprising offsets. Prefer `#up()` to target the current slip.

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

The `offset` value is counted in slips, not in screen units: `0` selects the labelled slip, `-1` selects the previous slip, and `1` selects the next slip.

And the `dy` parameter allows you to specify a custom vertical distance for the sliding animation. For example, to scroll to 5cm below the top of the selected slip:

```typst
#up(<label>, dy: 5cm)
```

Use `end: true` to align the bottom of the selected slip with the bottom of the viewport instead of aligning its top with the top of the viewport:

```typst
#up(<label>, end: true)
```

Combined with `offset`, `#up()` can select slips relative to the current slip without an explicit label:

```typst
#up(offset: -1)
```

### Horizontal Sections

Use `#right()` to start a new horizontal section. It is a strong cut: it ends
the current section and starts the first slip of the next section, so you do not
need to write `#pause` before or after it.

```typst
= Introduction
Content here.
#right()

= Method
New section starts here.
```

Navigation:

- Wheel / Arrow Up/Down: navigate slips within a section
- Arrow Left/Right: navigate between sections
- Click / Space: navigate slips (with transitions)
- Double-click / Double-space at end of section: jump to next section

### Speaker Notes

Use `#notes[...]` to attach notes to the current slip. Press `N` during the
presentation to open a separate notes window.

```typst
#pause
Here is my point.
#notes[Remember to mention the budget.]
```

### Replacing Animations

Refer to the [advanced guide](https://slipst.wybxc.cc/advanced.html).

### Handout Export

Slipst can also export a PDF handout containing all slips. To enable this, add the `handout: true` parameter to the `slipst` show rule:

```typst
#show: slipst.with(handout: true)
```

Then you can export the PDF version of your presentation using the `pdf` format:

```bash
typst compile your-presentation.typ --format pdf
```

With `slide-mode: true` as a sys input, each section becomes a separate page:

```bash
typst compile your-presentation.typ --format pdf --input slide-mode=true
```

## Roadmap

- Basic slip functionality with up/down navigation.
- Persistent state across sessions.
- Slips replacing animations, as well as Cetz and Fletcher animations.
- Horizontal sections with left/right navigation.
- Speaker notes.
- (TODO) Custom aspect ratios for the visual area.
- (TODO) Visual structure for subslips.
- (TODO) Whiteboard mode for live drawing.
- (TODO) Advanced navigation.
- PDF handout export.

## Changelog

### 0.4.0

- Added horizontal sections with `#right()`.
- Added speaker notes with `#notes[...]`.
- Added `#up()` without argument to target the current slip.
- Added `end: true` parameter to `#up` for bottom-aligned scrolling.
- Added `duration`, `end-dy`, `start-dy` parameters to `slipst` show rule.
- Added `slide-mode` sys input for per-section PDF pages.
- Navigation now section-aware: Arrow Left/Right for sections, Up/Down for slips.
- Overlay showing current section.slip position.
- Fixed: `#up` with forward labels now resolves correctly.

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

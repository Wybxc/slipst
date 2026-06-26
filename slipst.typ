#import "utils.typ": *

#let preview-mode = state("preview-mode", false)
#let slipst-counter = counter("slipst")
#let slipst-alter-counter = counter("slipst-alter")

// In PDF/preview mode, a pause is only a paragraph break so the document stays readable.
// In HTML mode, it becomes metadata that _cut uses to split the document into slips.
#let pause = if dictionary(std).at("html", default: none) == none {
  parbreak()
} else {
  metadata("slipst-pause")
}

// Store navigation actions as metadata. They are converted to data-* attributes later.
#let up(..args) = {
  let labels = args.pos()
  let named = args.named()
  assert(labels.len() <= 1, message: "up accepts at most one label")
  let label = labels.at(0, default: none)
  let offset = named.at("offset", default: 0)
  let dy = named.at("dy", default: 0)
  let end = named.at("end", default: false)
  metadata((slipst-action: (up: label, offset: offset, dy: dy, end: end)))
}
#let alter(num) = metadata((slipst-action: (alter: num)))

// Start a new horizontal section. This is a strong cut: it also starts a new slip,
// so authors do not need to write #pause before or after #right().
#let right() = metadata("slipst-right")

// Page break in PDF mode only. No effect in HTML.
#let next-pdf-slide() = metadata("slipst-next-pdf-slide")

// Normalize a raw Typst block, string, or arbitrary value into source text.
#let _source(it) = {
  if type(it) == str {
    it
  } else if type(it) == content and it.func() == raw {
    it.text
  } else {
    repr(it)
  }
}

// Speaker notes for the current slip. Rendered as plain text in a separate notes window.
#let notes(body) = metadata((slipst-notes: _source(body)))

// Read the current alter index. Use inside #context blocks that wrap cetz.canvas().
#let get-alter() = slipst-alter-counter.get().first()
#let get-mode() = preview-mode.get()

// Reveal content only on selected alter steps.
// Parameters:
// - ranges: alter indexes where body should be visible, e.g. "2", "2-", "2-4", or ("1", "3-").
// - cover: function used when body is outside ranges; hide keeps layout space, `it => none` removes it.
// - raw: kept for API compatibility, has no effect.
// - _alter: override the alter index. Required inside cetz.canvas() where context is unavailable.
// - body: content controlled by the visibility rule.
// In preview/PDF mode, every alter is shown at once, so body is always returned.
#let uncover(ranges, cover: hide, raw: false, alter: none, mode: none, body) = {
  let inner = () => {
    if preview-mode.get() {
      return body
    }

    let ranges = _parse_ranges(ranges)
    let alter-idx = slipst-alter-counter.get().first()
    let should-show = _is_in_ranges(alter-idx, ranges)
    if should-show {
      body
    } else {
      cover(body)
    }
  }
  if mode != none and alter != none {
    if mode {
      return body
    }
    // No context needed: the caller provides the alter index directly.
    // Used inside cetz.canvas() where Typst context is not available.
    let ranges = _parse_ranges(ranges)
    let should-show = _is_in_ranges(alter, ranges)
    if should-show { body } else { cover(body) }
  } else {
    if raw {
      inner()
    } else {
      context inner()
    }
  }
}

// Like uncover, but removes the content entirely outside the selected alter range.
#let only = uncover.with(cover: it => none)

// Control metadata changes presentation structure but should not create an empty slip by itself.
#let _is_invisible_metadata(it) = {
  if it.func() != metadata {
    return false
  }
  if it.value == "slipst-pause" or it.value == "slipst-right" or it.value == "slipst-next-pdf-slide" {
    return true
  }
  if type(it.value) == dictionary {
    return it.value.at("slipst-action", default: none) != none
  }
  false
}

// Append the current remainder as a slip when it contains visible/meaningful content.
#let _finish_slip(slips, remainder) = {
  let slip = _strip(remainder)
  let meaningful = slip.filter(it => not _is_invisible_metadata(it))
  if meaningful.len() > 0 {
    slips + (slip,)
  } else {
    slips
  }
}

// Append the current section when it contains at least one slip.
#let _finish_section(sections, slips, remainder) = {
  let slips = _finish_slip(slips, remainder)
  if slips.len() > 0 {
    sections + (slips,)
  } else {
    sections
  }
}

// Split the top-level document into horizontal sections, then vertical slips.
// #pause starts a new slip in the current section; #right starts a new section
// and also starts a new slip, so it acts as a strong cut.
#let _cut_sections(it) = {
  let sections = ()
  let slips = ()
  let remainder = ()

  for child in it.children {
    if child.func() == metadata and child.value == "slipst-pause" {
      slips = _finish_slip(slips, remainder)
      remainder = (child,)
    } else if child.func() == metadata and child.value == "slipst-right" {
      sections = _finish_section(sections, slips, remainder)
      slips = ()
      remainder = (child,)
    } else {
      remainder += (child,)
    }
  }

  _finish_section(sections, slips, remainder)
}

// Boxjs entries are special metadata and should not be wrapped in html.frame.
#let _is_boxjs(it) = {
  it.func() == metadata and type(it.value) == dictionary and it.value.at("slipst-boxjs", default: none) != none
}

// Render a contiguous Typst content chunk as an HTML frame.
// This is the main bridge from Typst layout to browser-rendered presentation content.
#let _frame_chunk(chunk, width: auto, show-fn: it => it, alter-idx: 1) = {
  let chunk = _strip(chunk)
  if chunk.len() > 0 {
    html.frame(show-fn({
      slipst-alter-counter.update(alter-idx)
      block(width: width, chunk.join())
    }))
  }
}

// Emit the placeholder DOM node for a Boxjs widget.
// The actual ShadowRoot, CSS, HTML, and JS controller are created in slipst.ts.
#let _boxjs_box(spec) = {
  let height = spec.height
  assert(type(height) == length, message: "boxjs height must be a length")

  let width = spec.width
  assert(type(width) == length or width == auto, message: "boxjs width must be a length or auto")

  let box-idx = counter("slipst-boxjs").get().first()
  let id = "slipst-boxjs-" + str(box-idx)

  let style = "height: calc(" + str(height.to-absolute().cm()) + " * var(--slip-1cm));"
  if width != auto {
    style += " width: calc(" + str(width.to-absolute().cm()) + " * var(--slip-1cm));"
  }
  if spec.style != "" {
    style += " " + spec.style
  }

  let attrs = (
    id: id,
    class: str(("slipst-boxjs slipst-boxjs-" + str(spec.kind) + " " + str(spec.class)).trim()),
    style: str(style),
    "data-slipst-boxjs-id": id,
    "data-slipst-boxjs-kind": str(spec.kind),
    "data-slipst-boxjs-html": str(spec.html),
    "data-slipst-boxjs-css": str(spec.css),
    "data-slipst-boxjs-js": str(spec.js),
    ..spec.attrs,
  )
  counter("slipst-boxjs").step()

  html.elem(
    "div",
    attrs: attrs,
  )
}

// Convert one slip into a sequence of renderable parts.
// Normal Typst content is batched into frames, while Boxjs metadata becomes widget divs.
#let _render_slip_content(slip, width: auto, show-fn: it => it, alter-idx: 1) = {
  let parts = slip.fold((output: (), chunk: ()), (acc, item) => {
    let (output, chunk) = acc
    if _is_boxjs(item) {
      let spec = item.value.at("slipst-boxjs")
      (
        output: output + (_frame_chunk(chunk, width: width, show-fn: show-fn, alter-idx: alter-idx), _boxjs_box(spec)),
        chunk: (),
      )
    } else {
      (output: output, chunk: chunk + (item,))
    }
  })
  let output = parts.output + (_frame_chunk(parts.chunk, width: width, show-fn: show-fn, alter-idx: alter-idx),)
  output
}

// Render a slip as one or more layered HTML divs.
// Each alter step duplicates the slip in the same grid cell and JS toggles opacity.
#let _slip(slip, section-idx: 1, slip-idx: 1, width: auto, show-fn: it => it) = context {
  let global-slip-idx = slipst-counter.get().first()
  let attrs = (
    class: "slip",
    data-section: str(section-idx),
    data-slip: str(slip-idx),
    "data-global-slip": str(global-slip-idx),
  )

  let actions = slip
    .filter(it => it.func() == metadata)
    .map(it => it.value)
    .filter(it => type(it) == dictionary)
    .map(it => it.at("slipst-action", default: none))
    .filter(it => type(it) == dictionary)
  let up = actions.rev().find(it => it.at("up", default: "slipst-missing-up") != "slipst-missing-up")
  let alter = actions.rev().find(it => it.at("alter", default: none) != none)

  // Extract speaker notes from metadata.
  let slip-notes = slip
    .filter(it => it.func() == metadata)
    .map(it => it.value)
    .filter(it => type(it) == dictionary)
    .map(it => it.at("slipst-notes", default: none))
    .filter(it => type(it) == str)
  if slip-notes.len() > 1 {
    warn("Slip has multiple #notes — only the last one will be displayed.")
  }
  if slip-notes.len() > 0 {
    attrs.insert("data-notes", slip-notes.last())
  }

  // A slip can have several alter states; default is one visible state.
  let alter-num = if type(alter) == dictionary {
    alter.at("alter", default: 1)
  } else {
    1
  }
  attrs.insert("data-slip-alter-num", str(alter-num))

  if type(up) == dictionary {
    // Resolve the target label into a slip index and expose it to the JS layout code.
    let anchor = up.at("up")

    let offset = up.at("offset", default: 0)
    assert(type(offset) == int, message: "Offset must be a number")

    let dy = up.at("dy", default: 0)
    assert(type(dy) == length or dy == 0, message: "dy must be a length")

    let end = up.at("end", default: false)
    assert(type(end) == bool, message: "end must be a boolean")

    if anchor == none {
      anchor = global-slip-idx
    } else if type(anchor) == function {
      anchor = anchor()
      anchor = slipst-counter.at(anchor).first()
    } else {
      anchor = slipst-counter.at(anchor).first()
    }
    attrs.insert("data-slip-up", str(anchor + offset))
    if dy != 0 {
      attrs.insert("data-slip-dy", str(dy.to-absolute().cm()))
    }
    if end {
      attrs.insert("data-slip-end", "true")
    }
  }

  for alter-idx in range(1, alter-num + 1) {
    // All alters of the same slip occupy the same CSS grid cell.
    let attrs-local = (
      "data-slip-alter-idx": str(alter-idx),
      "style": "grid-row: " + str(slip-idx) + "; grid-column: 1;",
      ..attrs,
    )
    html.elem(
      "div",
      attrs: attrs-local,
      {
        for part in _render_slip_content(slip, width: width, show-fn: show-fn, alter-idx: alter-idx) {
          part
        }
      },
    )
  }
  slipst-counter.step()
}

// Render one horizontal section. Its nested slip-container keeps the existing
// vertical slip layout local to that section.
#let _section(slips, section-idx: 1, width: auto, show-fn: it => it) = {
  html.elem(
    "div",
    attrs: (
      class: "section",
      "data-section": str(section-idx),
      "data-section-slip-count": str(slips.len()),
      style: "grid-column: " + str(section-idx) + "; grid-row: 1;",
    ),
    html.elem(
      "div",
      attrs: (class: "slip-container", "data-section": str(section-idx)),
      {
        let slip-idx = 1
        for slip in slips {
          _slip(
            slip,
            section-idx: section-idx,
            slip-idx: slip-idx,
            width: width,
            show-fn: show-fn,
          )
          slip-idx += 1
        }
      },
    ),
  )
}

// Main show rule. It has two paths:
// - non-HTML output: show a readable linear preview/handout;
// - HTML output: generate a complete web document with CSS, JS, and slip DOM nodes.
#let slipst(
  body,
  width: 16cm,
  spacing: auto,
  margin: 0.5cm,
  duration: 500,
  end-dy: -10pt,
  start-dy: -10pt,
  handout: false,
  show-fn: it => it,
) = {
  let slide-mode = sys.inputs.at("slide-mode", default: none) == "true"

  if dictionary(std).at("html", default: none) == none {
    let page-width = if slide-mode { 16cm } else { width + margin * 2 }
    let page-height = if slide-mode { 12cm } else { auto }
    return context show-fn({
      set page(width: page-width, height: page-height, margin: margin)
      preview-mode.update(true)

      let resolved-spacing = if spacing == auto { par.spacing } else { spacing }
      let sections = _cut_sections(body)
      let section-idx = 0
      for section in sections {
        section-idx += 1
        if section-idx > 1 {
          pagebreak()
        }
        for slip in section {
          let has-next-pdf-slide = slip.any(it => it.func() == metadata and it.value == "slipst-next-pdf-slide")
          slip.join()
          if slide-mode or has-next-pdf-slide {
            pagebreak()
          } else {
            v(resolved-spacing)
          }
        }
      }
    })
  }

  preview-mode.update(false)
  counter("slipst").update(1)
  counter("slipst-boxjs").update(1)

  fmap(body, it => context {
    let spacing = if spacing == auto {
      par.spacing
    } else {
      spacing
    }
    let variables = (
      "--end-dy": end-dy.to-absolute().cm(),
      "--start-dy": start-dy.to-absolute().cm(),
      "--slip-width": width.to-absolute().cm(),
      "--slip-spacing": spacing.to-absolute().cm(),
      "--slip-margin": margin.to-absolute().cm(),
      "--transition-duration-configured": str(duration / 1000) + "s",
    )
    html.html(style: variables.pairs().map(((k, v)) => k + ": " + str(v)).join("; "), {
      html.meta(charset: "utf-8")
      html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
      html.head({
        html.style(read("slipst.css"))
        html.script(read("slipst.js"), type: "module")
      })
      html.body(html.main(html.div(
        id: "section-container",
        {
          let section-idx = 1
          for section in _cut_sections(it) {
            _section(section, section-idx: section-idx, width: width, show-fn: show-fn)
            section-idx += 1
          }
        },
      )))
    })
  })
}

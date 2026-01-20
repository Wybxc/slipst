#let pause = metadata((kind: "slipst-pause"))

#let _should_strip(item) = {
  type(item) == content and (item.func() == parbreak or item == [ ])
}

#let _strip(segment) = {
  let _ = while _should_strip(segment.first(default: none)) {
    segment.remove(0)
  }
  let _ = while _should_strip(segment.last(default: none)) {
    segment.pop()
  }
  segment
}

#let _cut(content) = {
  let (segments, remainder) = content.children.fold((segments: (), remainder: ()), (acc, item) => {
    let (segments, remainder) = acc
    if item.func() == metadata {
      (segments + (remainder,), ())
    } else if item.func() == heading and item.at("depth", default: 100) <= 2 {
      (segments + (remainder,), (item,))
    } else {
      (segments, remainder + (item,))
    }
  })
  let segments = segments + (remainder,)
  let segments = segments.map(_strip).filter(segment => segment.len() > 0)
  segments
}

#let slipst(body, width: 16cm) = {
  if dictionary(std).at("html", default: none) == none {
    panic("Slipst is only available in HTML export mode.")
  }
  let segments = _cut(body)
  html.html({
    html.meta(charset: "utf-8")
    html.head({
      html.link(rel: "stylesheet", href: "https://esm.sh/normalize.css@8.0.1/normalize.css")
      html.style(read("slipst.css"))
      html.script(read("slipst.js"), type: "module")
    })
    html.main(html.div(
      id: "container",
      {
        for (i, slip) in segments.enumerate() {
          html.elem(
            "div",
            attrs: (class: "slip", data-slip: str(i + 1)),
            html.frame(block(width: width, slip.join())),
          )
        }
      },
    ))
  })
}

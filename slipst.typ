#let pause = if dictionary(std).at("html", default: none) == none {
  parbreak()
} else {
  metadata("slipst-pause")
}
#let up(label) = metadata((slipst-action: (up: label)))

#let _should_strip(item) = {
  type(item) == content and (item.func() == parbreak or item == [ ])
}

#let _strip(slip) = {
  let _ = while _should_strip(slip.first(default: none)) {
    slip.remove(0)
  }
  let _ = while _should_strip(slip.last(default: none)) {
    slip.pop()
  }
  slip
}

#let _cut(content) = {
  let (slips, remainder) = content.children.fold((slips: (), remainder: ()), (acc, item) => {
    let (slips, remainder) = acc
    if (
      (item.func() == metadata and item.value == "slipst-pause")
        or (item.func() == heading and item.at("depth", default: 100) <= 2)
    ) {
      (slips + (remainder,), (item,))
    } else {
      (slips, remainder + (item,))
    }
  })
  let slips = slips + (remainder,)
  let slips = slips.map(_strip).filter(slip => slip.len() > 0)
  slips
}

#let _slip(slip, width: auto) = context {
  let idx = counter("slipst").get().first()
  counter("slipst").step()

  let attrs = (class: "slip", data-slip: str(idx))

  let actions = slip
    .filter(item => item.func() == metadata)
    .map(item => item.value)
    .filter(it => type(it) == dictionary)
    .map(it => it.at("slipst-action", default: none))
    .filter(it => type(it) == dictionary)
  let up = actions.rev().find(it => it.at("up", default: none) != none)
  if type(up) == dictionary {
    let anchor = up.at("up")
    let anchor = counter("slipst").at(anchor).first()
    attrs.insert("data-slip-up", str(anchor - 1))
  }

  html.elem(
    "div",
    attrs: attrs,
    html.frame(block(width: width, slip.join())),
  )
}

#let slipst(body, width: 16cm) = {
  if dictionary(std).at("html", default: none) == none {
    return body
  }

  counter("slipst").update(1)

  let slips = _cut(body)

  html.html({
    html.meta(charset: "utf-8")
    html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
    html.head({
      html.style(read("slipst.css"))
      html.script(read("slipst.js"), type: "module")
    })
    html.body({
      html.main(html.div(
        id: "container",
        {
          for slip in slips {
            _slip(slip, width: width)
          }
        },
      ))
    })
  })
}

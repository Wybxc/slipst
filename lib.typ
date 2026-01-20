#let slipst(body) = {
  if dictionary(std).at("html", default: none) == none {
    panic("Slipst is only available in HTML export mode.")
  }
  html.body(body)
}

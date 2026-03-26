#import "../dist/lib.typ": *
#import "@preview/showybox:2.0.4": showybox
#import "@preview/zebraw:0.6.1": *

#show: slipst.with(show-fn: zebraw.with(numbering-separator: true))

= Slipst Advanced

Here are some uncategorized advanced features of Slipst that didn't fit into the tutorial.

#pause

== Absolute Positioning with `up`

We know that `up` can point to an anchor slip, which means to scroll to the top of the anchor slip. <1>

#pause
#up(<1>)

Here `#up(<1>)` will scroll to the top of the previous slip, which contains the label `<1>`.

#pause

However, sometimes you may want to scroll to the middle of a slip. For example, when there is a looong paragraph...

#text(fill: luma(50%), lorem(200)) <long>

#pause
#up(<long>, dy: 5cm)

We use `#up(<long>, dy: 5cm)` to scroll to a position 5cm below the top of the slip `<long>`.

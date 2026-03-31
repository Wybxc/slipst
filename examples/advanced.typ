#import "../dist/lib.typ": *
#import "@preview/showybox:2.0.4": showybox
#import "@preview/zebraw:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

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

#pause
#up(here)

== Altering Slips, a.k.a. Replacing Animations

In beamer/polylux/touying, you can have animations by defining multiple versions of a slide, and then revealing them one by one.

#pause

In slipst, many of these animations can already be achieved by `#pause` and `#up`, but sometimes you may want to have more control, e.g. to have the left half of the content appear first, and then the right half, or to let a figure of tree grow branch by branch.

#pause

This is where `#alter` comes in. Insert `#alter(n)` to mark the current slip has `n` versions.

```typ
#pause
#alter(3)
```

#pause#up(here, offset: -1)

Inside the slip with `#alter(n)`, you can use `#uncover(...)` to specify which version(s) of the slip a content belongs to. The syntax of `#uncover` is inspired by polylux/touying's, for example:
- `#uncover("2")` means the content only appears in 2nd version.
- `#uncover("1-3")` means the content appears in 1st, 2nd, and 3rd versions.
- `#uncover("2-")` means the content appears in 2nd version and all later versions.
- `#uncover(("1", "3"))` means the content appears in 1st and 3rd versions, but not in 2nd version.

#pause#up(here, offset: -1)

```typ
#alter(3)
This slip has 3 versions.

#uncover("1")[This is the 1st version.]
#uncover("2")[This is the 2nd version.]
#uncover("3")[This is the 3rd version.]
```

#alter(3)

This slip has 3 versions.

#uncover("1")[This is the 1st version.]
#uncover("2")[This is the 2nd version.]
#uncover("3")[This is the 3rd version.]

#pause#up(here, offset: -1, dy: 3cm)

As you can see, the content not shown still takes up space. If you want the content to not take up space, you can use `#only` instead of `#uncover`.

```typ
#alter(3)
This slip has 3 versions.

#only("1")[This is the 1st version.]
#only("2")[This is the 2nd version.]
#only("3")[This is the 3rd version.]
```

#alter(3)

This slip has 3 versions.

#only("1")[This is the 1st version.]
#only("2")[This is the 2nd version.]
#only("3")[This is the 3rd version.]

#pause#up(here, offset: -1, dy: 3cm)

`#uncover` can also be used in math equations:

#alter(6)

$
  &#hide[=] "filter" p med ("map" f med (y:y s)) \
  #uncover("2-")[ $&= "filter" p med (f med y : "map" f med y s)$] \
  #uncover("3-")[ $&= bold("if") p med (f med y) bold("then") f med y : "filter" p med ("map" med f med y s) bold("else") "filter" p med ("map" med f med y s)$ ] \
  #uncover("4-")[ $&= bold("if") p med (f med y) bold("then") f med y : "map" f med ("filter" med (p ∘ f) med y s) bold("else") "map" f med ("filter" med (p ∘ f) med y s)$ ] \
  #uncover("5-")[ $&= bold("if") p med (f med y) bold("then") "map" f med ( y : "filter" (p ∘ f) med y s ) bold("else") "map" f med ("filter" med (p ∘ f) med y s)$ ] \
  #uncover("6-")[ $&= "map" f med (bold("if") p med (f med y) bold("then") y : "filter" (p ∘ f) med y s bold("else") "filter" med (p ∘ f) med y s)$] \
  &= "map" f med ("filter" (p ∘ f) med (y:y s)) \
$

#pause#up(here)

And in CeTZ/fletcher diagrams. You need to customize the `cover` parameter of `#uncover` to work with diagrams. The `cover` parameter is a function that is used to cover the content that is not shown.
For technical reasons, you also need to set `raw: true` and wrap the diagram with `context` to make it work.

```typ
#let only = uncover.with(cover: fletcher.hide, raw: true)
#context diagram(
  node((0, 0), $⊢ A ∧ (B => C)$),
  only("2-", node((-0.6, 0.7), $⊢ A$)),
  // ...
)
```

#alter(3)

#let only = uncover.with(cover: fletcher.hide, raw: true)
#context align(center, diagram(
  node-stroke: 0.5pt,
  node-corner-radius: 3pt,
  node-fill: oklch(95%, 0.02, 286deg),
  node((0, 0), $⊢ A ∧ (B => C)$),
  only("2-", edge("-|>")),
  only("2-", node((-0.6, 0.7), $⊢ A$)),
  only("2-", edge((0, 0), (0.6, 0.7), "-|>")),
  only("2-", node((0.6, 0.7), $A ⊢ B => C$)),
  only("3", edge("-|>")),
  only("3-", node((0.6, 1.5), $A, B ⊢ C$)),
))

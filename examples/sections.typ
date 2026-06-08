#import "../dist/lib.typ": *

#show: slipst

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

#right()

= Method

The second section starts here. No `#pause` is needed around `#right()`.

#pause

#up(<1>)

This is the second slip of the second section.

#pause

#import "@preview/cetz:0.5.2" as cetz
#figure(
  {
    cetz.canvas({
      import cetz.draw: *

      let scale = 1.2

      // Vertex positions: (col, 3-row)
      let pos(i, j) = (j * scale, (3 - i) * scale)

      // Draw a hyperedge as a closed curve through vertices (no fill)
      let hyperedge-curve(vertices, color) = {
        let pts = vertices.map(((i, j)) => pos(i, j))
        // Draw lines connecting vertices in order
        for k in range(pts.len() - 1) {
          let next = calc.rem(k + 1, pts.len())
          line(pts.at(k), pts.at(next), stroke: color + 2pt)
        }
      }

      // Context normalization hyperedges (blue) - 2x2 blocks with diagonal cross
      // (0,0): diagonal cross through (0,0)-(1,1)-(0,1)-(1,0)
      hyperedge-curve(((0, 0), (1, 1), (0, 1), (1, 0)), blue)
      // (0,1): diagonal cross through (0,2)-(1,3)-(0,3)-(1,2)
      hyperedge-curve(((0, 2), (1, 3), (0, 3), (1, 2)), blue)
      // (1,0): diagonal cross through (2,0)-(3,1)-(2,1)-(3,0)
      hyperedge-curve(((2, 0), (3, 1), (2, 1), (3, 0)), blue)
      // (1,1): diagonal cross through (2,2)-(3,3)-(2,3)-(3,2)
      hyperedge-curve(((2, 2), (3, 3), (2, 3), (3, 2)), blue)

      // Alice compatibility hyperedges (red) - horizontal zigzag
      // a=0, x=0: row 0 with zigzag
      hyperedge-curve(((0, 0), (0, 1), (1, 2), (1, 3)), rgb(250, 0, 0, 255))
      // a=1, x=0: row 1 with zigzag
      hyperedge-curve(((1, 0), (1, 1), (0, 2), (0, 3)), rgb(200, 0, 0, 255))
      // a=0, x=1: row 2 with zigzag
      hyperedge-curve(((2, 0), (2, 1), (3, 2), (3, 3)), rgb(150, 0, 0, 255))
      // a=1, x=1: row 3 with zigzag
      hyperedge-curve(((3, 0), (3, 1), (2, 2), (2, 3)), rgb(100, 0, 0, 255))

      // Bob compatibility hyperedges (green) - vertical zigzag
      // b=0, y=0: col 0 with zigzag
      hyperedge-curve(((0, 0), (1, 0), (2, 1), (3, 1)), rgb(0, 250, 0, 255))
      // b=1, y=0: col 1 with zigzag
      hyperedge-curve(((0, 1), (1, 1), (2, 0), (3, 0)), rgb(0, 200, 0, 255))
      // b=0, y=1: col 2 with zigzag
      hyperedge-curve(((0, 2), (1, 2), (2, 3), (3, 3)), rgb(0, 150, 0, 255))
      // b=1, y=1: col 3 with zigzag
      hyperedge-curve(((0, 3), (1, 3), (2, 2), (3, 2)), rgb(0, 100, 0, 255))

      // Draw vertices on top
      for i in range(4) {
        for j in range(4) {
          let (x, y) = pos(i, j)
          circle((x, y), radius: 0.12, fill: white, stroke: 1.5pt)
        }
      }

      // Row labels (Alice)
      content((-0.5, 3 * scale), $0|0$)
      content((-0.5, 2 * scale), $0|1$)
      content((-0.5, 1 * scale), $1|0$)
      content((-0.5, 0 * scale), $1|1$)

      // Column labels (Bob)
      content((0 * scale, 4.0), $0|0$)
      content((1 * scale, 4.0), $0|1$)
      content((2 * scale, 4.0), $1|0$)
      content((3 * scale, 4.0), $1|1$)

      // Axis labels
      content((-1.1, 1.5), [Alice $(a|x)$], angle: 90deg)
      content((1.5, 4.6), [Bob $(b|y)$])
    })
  },
  caption: [Contextual hypergraph of the Bell $(2,2,2)$ scenario. The hyperedge are represented by the same color.],
)<fig:chsh-hypergraph>

#pause
#alter(3)
$
  sum_(x ∈ 𝒮) & = uncover("2 3", 1 + x + (x^2)/2 + (x^3)/(3!) + dots) \
              & = uncover("3", x+x+x+x+x)
$

#right()

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

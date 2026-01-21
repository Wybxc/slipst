# Slipst

Slipst is a package for creating dynamic presentations in Typst, inspired by [slipshow](https://slipshow.org).

It introduces a novel way of structuring presentations using "slips" that scroll from top to bottom, instead of relying on fixed-size slides. This frees presenters from the constraints of slide dimensions.

## Quick Start

```typst
#import "@preview/slipst:0.1.0": *
#show: slipst

= First Slip

The document flows from top to bottom.
Whenever a `#pause` is encountered, the presentation will pause here,
waiting for the presenter to navigate to the next slip.

#pause

= Second Slip

The second slip appears after navigating down.
```

Refer to the [tutorial](examples/tutorial.typ) for a more comprehensive guide.

## Roadmap

- [x] Basic slip functionality with up/down navigation.
- [x] Persistent state across sessions.
- [ ] Slips replacement animations, as well as Cetz and Flether animations.

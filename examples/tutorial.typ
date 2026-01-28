#import "@preview/slipst:0.1.0": *
#import "@preview/showybox:2.0.4": showybox
#import "@preview/zebraw:0.6.1": *
#set text(font: "MLMRoman12")
#show: slipst.with(show-fn: zebraw.with(numbering-separator: true))
#show link: underline

#align(center)[= Slipst]

Slipst is a package for creating dynamic presentations in Typst, inspired by #link("https://slipshow.org")[slipshow].

It introduces a novel way of structuring presentations using "slips" that scroll from top to bottom, instead of relying on fixed-size slides. This frees presenters from the constraints of slide dimensions.

== Basic Usage

Now, *click* or press the *arrow* or *enter* keys to see what happens.

#pause

New paragraphs appear as you progress through the presentation.

These are _slips_, the building blocks of a Slipst presentation, and are equivalent to slides in traditional slide decks.
Slips are unbounded vertically, allowing content to flow naturally.

#pause

Slips can contain arbitrary Typst content, including _text_, _images_, _equations_, and more.

$ x = (-b plus.minus sqrt(b^2 - 4 a c))/(2 a) $ <an1>

#pause

When the screen is full, you can scroll down to reveal more content. #up(<an1>)

#pause

Navigating between slips is intuitive. Use the arrow keys or scroll wheel to move up and down through the presentation. To advance, you can also click the slide area or press the enter key or spacebar. Press backspace to go back.

#pause
#up(here)

== Writing Slipst Presentations

Now that you are familiar with Slipst's basic functionality,
let's see how to create your own Slipst presentations.

#pause

First, import Slipst from the Typst Universe and use a `#show` rule to turn your document into a Slipst presentation.

```typ
#import "@preview/slipst:0.1.0": *
#show: slipst
```

#pause <an2>

Then, start writing your content as usual.

```typ
#align(center)[= Slipst]

Slipst is a package for creating dynamic presentations in Typst, inspired by #link("https://slipshow.org")[slipshow].
```

#pause
#up(<an2>)

To create slips, simply insert a `#pause` command wherever you want the content to be revealed progressively.

```typ
Now, *click* or press the *arrow* or *enter* keys to see what happens.

#pause

New paragraphs appear as you progress through the presentation.
```

#pause
#up(here, offset: -1)

To scroll down, use the `#up` command with a label to make the slip scroll to the top of the view.
The placement of `#up` does not matter as long as it appears at the top level.

```typ
$ x = (-b plus.minus sqrt(b^2 - 4 a c))/(2 a) $ <an1>

#pause

When the screen is full, you can scroll down to reveal more content. #up(<an1>)
```

#pause
#up(here)

Slipst renders your content to SVG using `html.frame`.
Your favorite components from the Typst Universe work seamlessly within Slipst presentations.

#showybox(
  title-style: (
    weight: 900,
    color: oklch(44%, 0.12, 25deg),
    sep-thickness: 0pt,
    align: left,
  ),
  frame: (
    title-color: oklch(95%, 0.03, 25deg),
    border-color: oklch(44%, 0.12, 25deg),
    thickness: (left: 1pt),
    radius: 0pt,
  ),
  title: "Showybox Example",
)[
  Zebraw code blocks work perfectly too!

  ```typ
  #import "@preview/showybox:2.0.4": showybox
  #showybox(...)
  ```
]

#pause

#showybox(
  title-style: (
    weight: 900,
    color: oklch(44%, 0.12, 150deg),
    sep-thickness: 0pt,
    align: left,
  ),
  frame: (
    title-color: oklch(97.43%, 0.041, 150deg),
    border-color: oklch(44%, 0.12, 150deg),
    thickness: (left: 1pt),
    radius: 0pt,
  ),
  title: "Note",
)[
  Zebraw's default setup would flag issues with HTML output.
  You can use `show-fn` to specify the `#show` rule inside the `html.frame`.

  ```typ
  #show: slipst.with(show-fn: zebraw.with(numbering-separator: true))
  ```
]

#pause
#up(here, offset: -1)

That's it! You are now ready to create your own Slipst presentations in Typst. Enjoy the freedom of dynamic presentations!

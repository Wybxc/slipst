// Cache Typst function identities used to inspect content nodes below.
#let sequence = [].func()
#let styled = text(red)[].func()
#let space = [ ].func()
#let symbol-func = $.$.body.func()
#let context-func = (context {}).func()

// Sanity checks for Typst internals this file relies on.
#assert($mu$.body.func() == symbol-func)
#assert(type(sym.mu) == symbol)

// Test whether a content value was produced by a specific Typst function.
#let _is(it, func) = {
  type(it) == content and it.func() == func
}

// Empty structural nodes should not create empty slips/frames.
#let _should_strip(it) = {
  _is(it, parbreak) or _is(it, space) or (_is(it, sequence) and it.children.len() == 0)
}

// Remove leading and trailing empty paragraph/space/sequence nodes from a content list.
#let _strip(slip) = {
  let _ = while _should_strip(slip.first(default: none)) {
    slip.remove(0)
  }
  let _ = while _should_strip(slip.last(default: none)) {
    slip.pop()
  }
  slip
}

// Apply func to the meaningful root sequence while preserving outer styling.
#let fmap(it, func) = {
  assert(type(it) == content)
  if it.func() == sequence {
    let children = _strip(it.children)
    if (children.len() == 1) {
      fmap(children.at(0), func)
    } else {
      func(it)
    }
  } else if it.func() == styled {
    styled(fmap(it.child, func), it.styles)
  } else {
    it
  }
}

// not actual maximum integer, but large enough
#let _int_max = 1.bit-lshift(53) - 1

// Parse range in string into [start, end) format.
//
// range syntax:
// - "2": only 2
// - "2-": from 2 to infinity
// - "2-5": from 2 to 5 (inclusive)
#let _parse_range(range_str) = {
  let parts = range_str.split("-")
  let start = int(parts.at(0))
  let end = if parts.len() == 1 {
    start + 1
  } else if parts.at(1) == "" {
    _int_max
  } else {
    int(parts.at(1)) + 1
  }
  return (start, end)
}

#assert(_parse_range("2") == (2, 3))
#assert(_parse_range("2-") == (2, _int_max))
#assert(_parse_range("2-5") == (2, 6))

// Parse multiple ranges from a string (space-separated) or array of strings.
// Examples: "2", "2-", "2-5", "1 3", "2-4 7-9", ("2", "4-5")
#let _parse_ranges(ranges) = {
  if type(ranges) == str {
    let parts = ranges.split(" ").filter(s => s.len() > 0)
    return parts.map(_parse_range)
  }
  if type(ranges) == array {
    return ranges.map(_parse_range)
  }
  panic("uncover/only: expected string or array, got " + str(type(ranges)))
}

#assert(_parse_ranges("2") == ((2, 3),))
#assert(_parse_ranges("2-") == ((2, _int_max),))
#assert(_parse_ranges("2-5") == ((2, 6),))
#assert(_parse_ranges("1 3") == ((1, 2), (3, 4)))
#assert(_parse_ranges("2-4 7-9") == ((2, 5), (7, 10)))
#assert(_parse_ranges("1  3") == ((1, 2), (3, 4)))
#assert(_parse_ranges(("2", "4-5")) == ((2, 3), (4, 6)))

// Check if num is in any of the ranges
#let _is_in_ranges(num, ranges) = {
  for range in ranges {
    if num >= range.at(0) and num < range.at(1) {
      return true
    }
  }
  return false
}

#assert(_is_in_ranges(2, _parse_ranges("2")))
#assert(not _is_in_ranges(3, _parse_ranges("2")))
#assert(_is_in_ranges(2, _parse_ranges("2-5")))
#assert(_is_in_ranges(4, _parse_ranges("2-5")))
#assert(not _is_in_ranges(6, _parse_ranges(("2-5", "7-9"))))
#assert(_is_in_ranges(1, _parse_ranges("1 3")))
#assert(not _is_in_ranges(2, _parse_ranges("1 3")))
#assert(_is_in_ranges(3, _parse_ranges("1 3")))
#assert(_is_in_ranges(7, _parse_ranges("2-4 7-9")))

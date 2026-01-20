#import "../lib.typ": *
#import "@preview/showybox:2.0.4": showybox
#show: slipst.with()

= Prime numbers

What is a prime number?

#pause

#showybox(title: "Definition", frame: (title-color: oklch(28%, 0.1, 142deg)))[
  A *prime number* is an integer divisible by exactly two integers: 1, and itself.

  We consider 1 not to be a prime number, as it is divisible only by one integer.
]

#pause <thm>

#showybox(title: "Theorem", frame: (title-color: oklch(28%, 0.1, 255deg)))[
  There are infinitely many prime numbers.
]

#pause <proof>
#up(<thm>)

_Proof._

Suppose there are finitely many prime numbers.

Let's write $p_0, p_1, dots, p_(n-1)$ a list of all prime numbers. We define:

$
  P = product_(i=0)^(n-1)p_i, quad
  N = P + 1.
$

#pause

Let $p$ be a prime divisor of $N$. We claim that:

$
  forall i, p eq.not p_i
$

#pause
#up(<proof>)

Indeed,

$
  p "divides" N and p "divides" P arrow.r.double.long p "divides" 1
$

So $p$ is a prime that is not part of the $p_i$, a contradiction. #pause
*Therefore, there must exists infinitely many prime numbers.*

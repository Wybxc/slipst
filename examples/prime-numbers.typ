#import "../lib.typ": pause, slipst
#import "@preview/showybox:2.0.4": showybox
#show: slipst.with()

= Prime numbers

What is a prime number?

#pause

#showybox(title: "Definition")[
  A *prime number* is an integer divisible by exactly two integers: 1, and itself.

  We consider 1 not to be a prime number, as it is divisible only by one integer.
]

#pause

#showybox(title: "Theorem")[
  There are infinitely many prime numbers.
]

#pause

_Proof._

Suppose there are finitely many prime numbers.

Let's write $p_0, p_1, dots.c, p_(n-1)$ a list of all prime numbers. We define:

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
Indeed,

$
  p "divides" N and p "divides" P arrow.r.double p "divides" 1
$

So $p$ is a prime that is not part of the $p_i$, a contradiction. #pause
*Therefore, there must exists infinitely many prime numbers.*

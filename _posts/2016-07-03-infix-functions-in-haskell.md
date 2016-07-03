---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell]
infotext: "infix functions and related concepts in Haskell"
---
{% include JB/setup %}

### Infix functions

Functions in Haskell default to prefix syntax, meaning that the function 
being applied is at the beginning of the expression rather than the middle.

Operators are functions which can be used in infix style. All operators 
are functions.

The syntax between prefix functions and infix functions is interchangeable, 
with a small change:

{% highlight haskell linenos=table %}

prefixFunc a b

a `prefixFunc` b

a infixFunc b

(infixFunc) a b

{% endhighlight %}

### Associativity and Precedence

We can ask GHCi for information such as associativity and precedence of 
operators and functions by using `:info` command.

{% highlight haskell linenos=table %}
:info (*)

class Num a where
  ...
  (*) :: a -> a -> a
  ...

infixl 7 *
{% endhighlight %}

The `infixl` means `(*)` is an infix function, and it is left associative. 
`7` is the precedence, higher is applied first, on a scale of `0 - 9`.

### Parenthesizing

When you want to refer to an infix function without applying any arguments, 
or use them as prefix functions instead of infix, you need warp the infix 
function in parentheses.

{% highlight haskell linenos=table %}
(+) 1 2
{% endhighlight %}

In order to partially apply functions, you can use `sectioning`.

{% highlight haskell linenos=table %}
(+ 1) 2
{% endhighlight %}

With commutative functions, such as addition, it makes no difference between 
`(+1)` and `(1+)`. If you use sectioning with a function that is not 
commutative, the order matters.

### ($) operator

The ($) operator is a convenience for expressing something with fewer pairs 
of parentheses. The information of ($) operator is

{% highlight haskell linenos=table %}
($) ::
  forall (r :: GHC.Types.RuntimeRep) a (b :: TYPE r).
  (a -> b) -> a -> b
infixr 0 $
{% endhighlight %}
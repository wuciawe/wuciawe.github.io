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

### Composition operator

Function composition is a type of higher-order function that allows us to 
combine functions such that the result of applying one function gets passed 
to the next function as an argument.

The composition operator is defined as:

{% highlight haskell linenos=table %}
(.) :: (b -> c) -> (a -> b) -> a -> c
infixr 9 .
{% endhighlight %}

For example:

{% highlight haskell linenos=table %}
f :: Bool -> String
f x = 
  case x of
    True -> "it is true."
    False -> "it is false."

g :: Int -> Bool
g x = x == 1

(f.g) 5 -- it is false.
{% endhighlight %}

We can think of the (.) or composition operator as being a way of pipelining 
data through multiple functions.

### Pointfree

In Haskell the precedence of an ordinary function call (white space, usually) 
is of 10. While the composition operator has a precedence of 9. It results 
in the case where we want to compose functions then apply it to some parameter, 
we have to parenthesize the composition so as to keep the application in 
right order.

With the help of ($) operator, the syntax can be much neater:

{% highlight haskell linenos=table %}
(f.g) 5 -- it is false.
f.g $ 1 -- it is true.
{% endhighlight %}

Further more, we can focus on composing functions, rather than applying functions, 
which is thus pretty elegant:

{% highlight haskell linenos=table %}
print :: Show a => a -> IO()
print a = (putStrLn . show) a

-- pointfree version
print :: Show a => a -> IO()
print = putStrLn . show
{% endhighlight %}

Pointfree refers to a style of composing functions without specifying their 
arguments. The “point” in “pointfree” refers to the arguments, not to the function 
composition operator.

### (->) operator

The type constructor for functions, (->), is also a function, whose information 
is like:

{% highlight haskell linenos=table %}
data (->) t1 t2
infixr 0 `(->)`
{% endhighlight %}

Since (->) is an infix operator and right associative, it makes currying the default 
in Haskell.

### Infix type constructor and data constructor

Any operator that starts with a colon (:) must be an infix type or data constructor. 
All infix data constructors must start with a colon. The type constructor of functions, 
(->), is the only infix type constructor that doesn't start with a colon. Another exception 
is that they cannot be (::) as this syntax is reserved for type assertions.
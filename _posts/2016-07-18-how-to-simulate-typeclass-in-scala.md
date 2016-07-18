---
layout: post
category: [functional programming, haskell, scala]
tags: [functional programming, haskell, scala]
infotext: "summary on 'Type Classes as Objects and Implicits, the way to simulate simple usage of typeclass in scala."
---
{% include JB/setup %}

### (Originally proposed) typeclass in Haskell

The original model of typeclass consists of single parameter typeclass, which enables the definition 
of ad-hoc overloaded functions. A typeclass declaration consists of a class name, a type parameter, 
and a set of method declarations. Each of the methods in the typeclass declaration should have at 
least one occurrence of the type parameter in their signature.

#### Think type parameter as `self`

If we think of the type parameter in the typeclass declaration as the equivalent of the `self` 
argument in an OO language, we can see that a few different types of methods can be modeled:

- `Consumer method`s like `show` are the closest o typical OO methods. They take one argument 
of type `a`, and using that argument they produce some result.

{% highlight haskell linenos=table %}
class Show a where
  show :: a -> String
{% endhighlight %}

- `Binary method`s like `<` can take two arguments of type `a`, and produce some result. And 
different from OO language, typeclass binary method arguments are only `statically dispatched`, 
and not `dynamically dispatched`.

{% highlight haskell linenos=table %}
class Ord a where
  (<) :: a -> a -> Bool
{% endhighlight %}

- `Factory method`s like `read` return a value of type `a` instead of consuming values of type 
`a`. In OO language, factory methods can be dealt with in different ways (for example, by using 
`static method`s).

{% highlight haskell linenos=table %}
class Read a where
  read :: String -> a
{% endhighlight %}

#### One Instance One Type

A characteristic of typeclass is that only one instance is allowed for a given type.

### Extended typeclass

#### Multiple parameter typeclass

An extension to the originally proposed typeclass is to lift the restriction of a single type 
parameter:

{% highlight haskell linenos=table %}
class Coerce a b where
  coerce :: a -> b

instance Coerce Char Int where
  coerce = ord
{% endhighlight %}

#### Overlapping instances

Another extension of typeclass is to allow instances to overlap, as long as there is a most 
specific one.

{% highlight haskell linenos=table %}
instance Ord a => Ord [a] where ...

instance Ord [Int] where ...
{% endhighlight %}

Despite two possible matches for `[Int]`, the compiler is able to make an unambiguous decision 
to which of there instances to pick by selecting the most specific one.

### Implicits in Scala

Scala automates type-driven selection of values with the `implicit` keyword. A method call may 
omit the final argument list if the method definition annotated that list with `implicit` keyword, 
and if, for each argument in that list, there is exactly one value of the right type in the 
`implicit scope`, which roughly means that it must be accessible without a prefix.

#### Implicit propagation

The arguments in an implicit argument list are part of the implicit scope, so that implicit 
arguments are propagated naturally.

{% highlight haskell linenos=table %}
import java.io.PrintStream

implicit val out = System.out

def log(msg: String)(implicit o: PrintStream) = o println msg

def logT(msg: String)(implicit o: PrintStream): Unit = log(s"[${new java.util.Date()}]$msg")
{% endhighlight %}

In the above example, `logT`'s implicit argument `o` is propagated to the call  to `log`.

#### Partially applied implicit argument list

The implicit argument list must be the last argument list and it may either be omitted or supplied 
in its entirety. There is a simple idiom to encode a wildcard for an implicit argument.

{% highlight haskell linenos=table %}
def logPrefix(msg: String)(implicit o: PrintStream, prefix: String): Unit = log(s"[$prefix]$msg")

def ?[T](implicit w: T): T = w
{% endhighlight %}

With the definition of the polymorphic method `?`, which looks up an implicit value of type `T` 
in the implicit scope, we can write something as:

{% highlight haskell linenos=table %}
logPrefix("some message")(?, new java.util.Date().toString)
{% endhighlight %}

where we omit he value for the output stream, while provide an explicit value for the prefix. Type 
inference and implicit search will turn the call `?` into `?[PrintStream](out)`, assuming `out` is 
in the implicit scope as before.
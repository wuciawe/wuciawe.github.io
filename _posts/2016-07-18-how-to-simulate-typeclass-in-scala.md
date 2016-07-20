---
layout: post
category: [functional programming, haskell, scala]
tags: [functional programming, haskell, scala]
infotext: "summary on 'Type Classes as Objects and Implicits', the way to simulate simple usage of typeclass in scala."
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

{% highlight scala linenos=table %}
import java.io.PrintStream

implicit val out = System.out

def log(msg: String)(implicit o: PrintStream) = o println msg

def logT(msg: String)(implicit o: PrintStream): Unit = log(s"[${new java.util.Date()}]$msg")
{% endhighlight %}

In the above example, `logT`'s implicit argument `o` is propagated to the call  to `log`.

#### Partially applied implicit argument list

The implicit argument list must be the last argument list and it may either be omitted or supplied 
in its entirety. There is a simple idiom to encode a wildcard for an implicit argument.

{% highlight scala linenos=table %}
def logPrefix(msg: String)(implicit o: PrintStream, prefix: String): Unit = log(s"[$prefix]$msg")

def ?[T](implicit w: T): T = w
{% endhighlight %}

With the definition of the polymorphic method `?`, which looks up an implicit value of type `T` 
in the implicit scope, we can write something as:

{% highlight scala linenos=table %}
logPrefix("some message")(?, new java.util.Date().toString)
{% endhighlight %}

where we omit he value for the output stream, while provide an explicit value for the prefix. Type 
inference and implicit search will turn the call `?` into `?[PrintStream](out)`, assuming `out` is 
in the implicit scope as before.

#### Implicit scope

When looking for an implicit value of type `T`, the compiler will consider implicit value 
definitions (definitions introduced by implicit `val`, implicit `object`, or implicit `def`), 
as well as implicit arguments that have type `T` and that are in scope locally (accessible 
without prefix) where the implicit value is required. Additionally, it will consider implicit 
values of type `T` that are defined in the types that are part of the type `T`, as well as in 
the companion objects of the base classes of these parts. The set of parts of a type `T` is 
determined as follows:

- for a compound type `T1` with ... with `Tn`, the union of the parts of `Ti`, and `T`,
- for a parameterized type `S[T1,...,Tn]`, the union of the parts of `S` and the parts of `Ti`,
- for a singleton type `p.type`, the parts of the type of `p`,
- for a type projection `S#U`, the parts of `S` as well as `S#U` itself,
- in all other cases, just `T` itself.

For more detailed discussions on this topic, follow these links: 
[implicit scope](http://stackoverflow.com/questions/5598085/where-does-scala-look-for-implicits), 
[implicit parameter precedence](http://stackoverflow.com/questions/8623055/scala-implicit-parameter-resolution-precedence), and 
[implicit parameter precedence again](http://eed3si9n.com/implicit-parameter-precedence-again).

#### Implicits as typeclasses

Implicits provide the type-driven selection mechanism that was missing for type class programming 
to be convenient in OO. The `Ord` typeclass and the `OrdPair` typeclass for tuple is like:

{% highlight scala linenos=table %}
trait Ord[T] {
  def compare (x:T,y:T):Boolean
}

implicit def OrdPair[A,B](implicit ordA:Ord[A],ordB:Ord[B]) = new Ord[(A,B)] {
  def compare (xs:(A,B),ys:(A,B)) = ???
}
{% endhighlight %}

Different from Haskell, type class instances are named, so that the programmer may supply them 
explicitly to resolve ambiguities manually.

The `cmp` function is rendered as the following method:

{% highlight scala linenos=table %}
def cmp[a](x:a,y:a)(implicit ord:Ord[a]):Boolean = ord.compare (x,y)
{% endhighlight %}

This common type of implicit argument can be abbreviated using context bounds:

{% highlight scala linenos=table %}
def cmp[a:Ord](x:a,y:a):Boolean = ?[Ord[a]].compare (x,y)
{% endhighlight %}

Since we do not have a name for the type class instance anymore, we use the `?` method to 
retrieve the implicit value for the type `Ord[a]`.

We can further use implicit conversion to enable idiomatic style `x.compare(y)`.

### The `CONCEPT` pattern

The `CONCEPT` pattern of Scala is inspired by the basic Haskell typeclass and C++ concepts. 
This pattern can be used in any OO language that supports generics, with implicits it becomes 
syntactically neat.

The CONCEPT pattern aims at representing the generic programming notion of concepts as 
conventional OO interfaces with generics. CONCEPT describes a set of requirements for the type 
parameters used by generic algorithms.

The CONCEPT pattern can model n-ary, factory and consumer methods just like typeclass. Following 
are examples for typeclasses `Show`, `Read` and `Coerce`:

{% highlight scala linenos=table %}
trait Show[T]{
  def show(x: T): String
}

trait Read[T]{
  def read(x: String): T
}

trait Coerce[A, B]{
  def coerce(x: A): B
}
{% endhighlight %}

Benefits of the CONCEPT pattern:

- Retroactive modeling: it allows mimicking the addition of a method to a class without having 
to modify the original class.
- Multiple method implementations: it is possible to have multiple implementations of conceptual 
methods for the same type.
- Binary (n-ary) methods: it can have multiple arguments of the manipulated type. Thus a simple 
form of type-safe statically dispatched n-ary methods is possible.
- Factory methods: it doesn't need an actual instance of the modeled type.

Limitations and Alternatives:

- All arguments of conceptual methods are statically dispatched. Thus conceptual methods are less 
expressive than conventional OO methods, which allow the self-argument to be dynamically 
dispatched, or multi-methods, in which all arguments are dynamically dispatched.
- Bounded polymorphism offers an alternative to typeclass-style concepts. The main advantage 
of this approach is that `compare` in following example is a real, dynamically dispatched, method 
of `Apple`, and all the private infromation about `Apple` objects is available. But it precludes 
retroactive modeling and makes it harder to support multiple implementations of a method for the 
same object.

{% highlight scala linenos=table %}
traid Ord[T]{
  def compare(x: T): Boolean
}

class Apple(x: Int) extends Ord[Apple] ...
{% endhighlight %}

The above is partial of the paper [Type Classes as Objects and Implicits](http://dl.acm.org/citation.cfm?id=1869489){:target='_blank'}.
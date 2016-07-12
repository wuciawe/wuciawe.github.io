---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell, category]
infotext: "first piece on categorical typeclass in Haskell, introduction to Magma, Semigroup, and Monoid in Haskell."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

The `algebra` is a word frequently used to describe these abstract patterns. In 
Haskell we mean one or more operations and the set they operate over. By set, we 
mean the type they operate over.

Algebra generally refers to one of the most important fields of mathematics. An 
algebra is variously:

- School algebra, such as that taught in primary and secondary school. This usually 
entails the balancing of polynomial equations and learning how functions and graphs 
work.
- The study of number systems and operations within them. This will typically entail 
a particular area such as groups or rings. This is what mathematicians commonly mean 
by algebra. This is sometimes disambiguated by being referred to as abstract algebra.
- A third and final way algebra is used is to refer to a vector space over a field with 
a multiplication.

Here, it means the study of mathematical symbols and the rules governing their 
manipulation. It is differentiated from arithmetic by its use of abstractions such as 
variables. We care about the rules of how to manipulate this thing without reference to 
its particular value.

In Haskell, the algebras can be implemented with typeclasses: the typeclasses define the 
set of operations. When we talk about operations over a set, the set is the type the 
operations are for. The instance defines how each operation will perform for a given type 
or set.

### Magma

In abstract algebra, a magma (or groupoid) is a basic kind of algebraic structure. 
Specifically, a magma consists of a set, \\(\mathbf{M}\\), equipped with a single binary 
operation, \\(\mathbf{M} \times \mathbf{M} \rightarrow \mathbf{M}\\). The binary operation 
must be closed by definition but no other properties are imposed.

### Semigroup

In mathematics, a semigroup is an algebraic structure consisting of a set together with an 
associative binary operation. A semigroup generalizes a monoid in that there might not exist 
an identity element. It also (originally) generalized a group (a monoid with all inverses) to 
a type where every element did not have to have an inverse, thus the name semigroup.

Associativity means the arguments can be regrouped (or reparenthesized, or reassociated) in 
different orders and give the same result.

{% highlight haskell linenos=table %}
class Semigroup a where
  (<>) :: a -> a -> a
  sconcat :: Data.List.NonEmpty.NonEmpty a -> a
  stimes :: Integral b => b -> a -> a
{% endhighlight %}

#### Law

Algebras are defined by their laws and are useful principally for their laws. Laws make up 
what algebras are. Among other things, laws provide us guarantees that let us build on 
solid foundations for the predictable composition (or combination) of programs. Without 
the ability to combine programs, everything must be hand-written from scratch, nothing 
can be reused.

The Law for Semigroup is associativity:

{% highlight haskell linenos=table %}
(a <> b) <> c = a <> (b <> c)
{% endhighlight %}

### Monoid

A monoid is a binary associative operation with an identity. Associativity means the arguments 
can be regrouped (or reparenthesized, or reassociated) in different orders and give the same 
result, as in addition. Identity means there exists some value such that when we pass it as 
input to our function, the operation is rendered moot and the other value is returned, such as 
adding zero or multiplying by one.

{% highlight haskell linenos=table %}
class Monoid a where
  mempty :: a
  mappend :: a -> a -> a
  mconcat :: [a] -> a
  mconcat = foldr mappend mempty
{% endhighlight %}

There also exists `(<>)` which is the infix version of `mappend`.

#### Use newtype for multiple Monoid instances

Integers form a monoid under summation and multiplication. But typeclass instances are unique 
to the types they are for. To resolve the conflict, we have the `Sum` and `Product` newtypes 
to wrap numeric values and signal which Monoid instance we want.

#### Commutativity

A variant of monoid that provides even stronger guarantees is the Abelian or commutative 
monoid. Commutativity can be particularly helpful when doing concurrent or distributed 
processing of data because it means the intermediate results being computed in a different 
order won’t change the eventual answer.

#### Law

Monoid instances must abide by the following laws:

{% highlight haskell linenos=table %}
-- left identity
mappend mempty x = x

-- right identity
mappend x mempty = x

-- associativity
mappend x (mappend y z) = mappend (mappend x y) z
-- or
x <> (y <> z) = (x <> y) <> z

mconcat = foldr mappend mempty
{% endhighlight %}

### Strength

When talking about the strength of an algebra, it usually means the number of 
operations the algebra provides which in turn expands what can be done with any 
given instance of that algebra without needing to know the specific type.

The reason we cannot and do not want to simply make all of our algebras as big as 
possible is that there are datatypes which are very useful representationally, but 
which do not have the ability to satisfy everything in a larger algebra that could 
work fine if you removed an operation or law.

The most obvious way to see that Monoid is stronger than Semigroup is to observe 
that it has a strict superset of the operations and laws that Semigroup provides. 
Anything which is a Monoid is by definition also a Semigroup.

When Monoid is too strong or more than we need, we can use Semigroup. By further 
removing the associativity requirement, it results in a Magma.
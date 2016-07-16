---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell, category]
infotext: "third piece on categorical typeclass in Haskell, introduction to Applicative in Haskell, which is a rather new typeclass in Haskell."
---
{% include JB/setup %}

Applicative is a monoidal functor. Monoid mashes two values of the same type together. 
Functor, on the other hand, is for function application over some structure while 
keeping the structure untouched. Monoid’s core operation, `mappend` smashes the structures 
together, so the structures themselves have been joined. However, the core operation of 
Functor, `fmap` applies a function to a value that is within some structure while leaving 
that structure unaltered.

### Applicative

The Applicative typeclass allows for function application lifted over structure (like Functor). 
But with Applicative the function we’re applying is also embedded in some structure. Because 
the function and the value it’s being applied to both have structure, we have to smash those 
structures together. So, Applicative involves monoids and functors.

{% highlight haskell linenos=table %}
class Functor => Applicative (f :: * -> *) where
  pure :: a -> fa
  (<*>) :: f (a -> b) -> f a -> f b
  (*>) :: f a -> f b -> f b
  (<*) :: f a -> f b -> f a
{% endhighlight %}

The `pure` function does a simple and very boring thing: it embeds something into functorial 
(applicative) structure which can be thought as being a bare minimum bit of structure or 
structural identity. The more core operation of this typeclass is `<*>`.

Note the similarity between `($)`, `(<$>)` and `(<*>)`:

{% highlight haskell linenos=table %}
($)   ::                   (a -> b)  ->  a  ->  b

(<$>) :: Functor f     =>  (a -> b)  -> f a -> f b

(<*>) :: Applicative f => f (a -> b) -> f a -> f b
{% endhighlight %}

#### Lift

Along with these core functions, the `Control.Applicative` library provides some other convenient 
functions: `liftA`, `liftA2`, and `liftA3`:

{% highlight haskell linenos=table %}
liftA :: Applicative f => (a -> b) -> f a -> f b

liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c

liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
{% endhighlight %}

The type signature of `liftA` is almost identical to `fmap`, and it is functionally as well.

{% highlight haskell linenos=table %}
fmap (+1) [1,2,3]
-- [2,3,4]

liftA (+1) [1,2,3]
-- [2,3,4]
{% endhighlight %}

The relationship between `liftA` and `fmap` is like:

{% highlight haskell linenos=table %}
fmap :: Functor f => (a -> b) -> f a -> f b
-- fmap func (f a) = f (func a)

liftA :: Applicative f => (a -> b) -> f a -> f b
-- liftA func (f a) = pure func <*> (f a) = f (func a)
{% endhighlight %}

With `liftA2` we can write something as follows:

{% highlight haskell linenos=table %}
-- write
(,) <$> [1,2] <*> [3,4]
-- [(1,3), (1,4), (2,3), (2,4)]

-- as
liftA2 (,) [1,2] [3,4]
-- [(1,3), (1,4), (2,3), (2,4)]
{% endhighlight %}

, similar for `liftA3`.

#### Law

Applicative instances must abide by the following laws:

{% highlight haskell linenos=table %}
-- identity
pure id <*> v = v

-- composition
pure (.) <*> u <*> v <*> w = u <*> (v <*> w)

-- homomorphism
pure f <*> pure x = pure (f x)

-- interchange
u <*> pure y = pure ($ y) <*> u
{% endhighlight %}

Note that, a homomorphism is a structure-preserving map between two categories. The effect 
of applying a function that is embedded in some structure to a value that is embedded in 
some structure should be the same as applying a function to a value without affecting any 
outside structure.
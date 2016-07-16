---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell, category]
infotext: "second piece on categorical typeclass in Haskell, introduction to Functor in Haskell."
---
{% include JB/setup %}

The great logician Rudolf Carnap appears to have been the first person to use 
the word `functor` in the 1930s. He invented the word to describe certain types 
of grammatical function words and logical operations over sentences or phrases. 
Functors are combinators: they take a sentence or phrase as input and produce a 
sentence or phrase as an output, with some logical operation applied to the whole.

### Functor

A functor is a way to apply a function over or around some structure that we don’t 
want to alter. That is, we want to apply the function to the value that is "inside" 
some structure and leave the structure alone. It is a mapping between categories.

{% highlight haskell linenos=table %}
class Functor (f :: * -> *) where
  fmap :: (a -> b) -> f a -> f b
  (<$) :: a -> f b -> f a
{% endhighlight %}

There also exits `(<$>)` which is the infix version of `fmap`.

The `f` in the `Functor` definition must be kind `* -> *` for:

- Each argument (and result) in the type signature for a function must be a fully 
applied type. Each argument must have the kind `*`.
- The type `f` was applied to a single argument in two different places: `f a` and 
`f b`. Since `f a` and `f b` must each have the kind `*`, `f` by itself must be kind 
`* -> *`.

And Functor is an example of higher kinded polymorphism. Higher kinded polymorphism 
is polymorphism which has a type variable abstracting over types of a higher kind.

Note the similarity between `(<$>)` and `($)`:

{% highlight haskell linenos=table %}
(<$>) :: Functor f => (a -> b) -> f a -> f b

($)   ::              (a -> b) ->  a  ->  b
{% endhighlight %}

#### Law

Functor instances must abide by the following laws:

{% highlight haskell linenos=table %}
-- identity
fmap id == id

-- composition
fmap (f . g) == fmap f . fmap g
{% endhighlight %}

so that

{% highlight haskell linenos=table %}
-- structure preservation
fmap :: Functor f => (a -> b) -> f a -> f b
{% endhighlight %}

#### Lifting

{% highlight haskell linenos=table %}
let lms = [Just "Ave", Nothing, Just "woohoo"]

fmap (const 'p') lms
-- "ppp"

(fmap . fmap) (const 'p') lms
-- [Just 'p', Nothing, Just 'p']
{% endhighlight %}

By composing `fmap`, it transforms deeper content inside the structure.

In the above example, since the type signature of `(.)` is `(b -> c) -> (a -> b) -> a -> c`, 
and the type signature of `fmap` is `Functor f => (a0 -> b0) -> f a0 -> f b0`, then in 
the type signature of `fmap . fmap` the `a` is `a0 -> b0`, the `b` is `f a0 -> f b0`, 
the `c` is `f0 (f a0) -> f0 (f b0)`, such that the type signature of `fmap . fmap` is 
`(a0 -> b0) -> f0 (f a0) -> f0 (f b0)`.

### Natural transformation

Instead of transforming the value in the structure, natural transformations gives the 
ability to transform only the structure and leave the type argument to that structure 
or type constructor alone.

We can attempt to put together a type to express what we want:

{% highlight haskell linenos=table %}
nat :: (f -> g) -> f a -> g a
{% endhighlight %}

This type is impossible because we can’t have higher-kinded types as argument types to 
the function type. To fix it:

{% highlight haskell linenos=table %}
{-# LANGUAGE RankNTypes #-}

type Nat f g = forall a. f a -> g a
{% endhighlight %}

The quantification of `a` in the right-hand side of the declaration allows us to obligate 
all functions of this type to be oblivious to the contents of the structures `f` and `g` 
in much the same way that the identity function cannot do anything but return the argument 
it was given.

Syntactically, it lets us avoid talking about `a` in the type of Nat — which is what we 
want, we shouldn’t have any specific information about the contents of `f` and `g` because 
we’re supposed to be only performing a structural transformation, not a fold.

### Uniqueness

In Haskell, Functor instances will be unique for a given datatype. This isn’t true for Monoid; 
however, we use newtypes to avoid confusing different Monoid instances for a given type. But 
Functor instances will be unique for a datatype, in part because of parametricity, in part 
because arguments to type constructors are applied in order of definition.

In a hypothetical not-Haskell language, the following might be possible:

{% highlight haskell linenos=table %}
data Tuple a b = Tuple a b deriving (Eq, Show)

-- impossible in Haskell
instance Functor (Tuple ? b) where
  fmap f (Tuple a b) = Tuple (f a) b
{% endhighlight %}

There are essentially two ways to address this. One is to flip the arguments to the type 
constructor; the other is to make a new datatype using a Flip newtype:

{% highlight haskell linenos=table %}
{-# LANGUAGE FlexibleInstances #-}

module FlipFunctor where

  data Tuple a b = Tuple a b deriving (Eq, Show)
  
  newtype Flip f a b = Flip (f b a) deriving (Eq, Show)
  
-- this actually works, goofy as it looks.
  instance Functor (Flip Tuple a) where
    fmap f (Flip (Tuple a b)) = Flip $ Tuple (f a) b
  
  fmap (+1) (Flip (Tuple 1 "blah")) -- Flip (Tuple 2 "blah")
{% endhighlight %}

However, `Flip Tuple a b` is a distinct type from `Tuple a b` even if it’s only there to 
provide for different Functor instance behavior.
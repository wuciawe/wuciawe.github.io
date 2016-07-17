---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell, category]
infotext: "fifth piece on categorical typeclass in Haskell, structures over functions like other classes."
---
{% include JB/setup %}

### Functor for function

Let's first look at following example:

{% highlight haskell linenos=table %}
import Control.Applicative

mulFunc :: Integer -> Integer
mulFunc x = x * 2

addFunc :: Integer -> Integer
addFunc x = x + 10

m :: Integer -> Integer
m = mulFunc . addFunc

m' :: Integer -> Integer
m' = fmap mulFunc addFunc
{% endhighlight %}

It is going to fmap a function over another function where the functorial context is a partially 
applied function. The `functorial context` means  the structure that the function is being lifted 
over in order to apply to the value inside. For example, a list is a functorial context we can 
lift functions over. We say that the function gets lifted over the structure of the list and 
applied to or mapped over the values that are inside the list.

As in function composition, `fmap` composes the two functions before applying them to the argument. 
The result of the one can then get passed to the next as input. Using fmap here lifts the one 
partially-applied function over the next. This is the Functor of functions.

The implementation of the instance of the functor for function is like:

{% highlight haskell linenos=table %}
instance Functor ((->) r) where
  fmap = (.)

-- the function type
data (->) a b

-- and
(.) :: (b -> c) -> (a -> b) -> (a -> c)
f . g = \a -> f (g a)
{% endhighlight %}

From this, we can determine that `r`, the argument type for functions, is part of the structure 
being lifted over when we lift over a function, not the value being transformed or mapped over.

This leaves the result of the function as the value being transformed.

{% highlight haskell linenos=table %}
instance Functor ((->) r) where
  fmap = (.)

-- the function type
(.) :: (b -> c) -> (a -> b) -> (a -> c)

fmap :: Functor f => 
        (a -> b) -> f a -> f b
     :: (b -> c) -> f b -> f c
     :: (b -> c) -> ((->) a) b -> ((->) a) c
     :: (b -> c) -> (a -> b) -> (a -> c)
{% endhighlight %}

That is functorial lifting for functions.

### Applicative for function

Following is an exmaple for applicative for functions:

{% highlight haskell linenos=table %}
import Control.Applicative

mulFunc :: Integer -> Integer
mulFunc x = x * 2

addFunc :: Integer -> Integer
addFunc x = x + 10

m2 :: Integer -> Integer
m2 = (+) <$> mulFunc <*> addFunc

m2' :: Integer -> Integer
m2' = liftA2 (+) mulFunc addFunc
{% endhighlight %}

Now we’re in an `applicative context`. We’ve added another function to lift over the contexts of 
our partially-applied functions. This time, we still have partially-applied functions that are 
awaiting application to an argument, but this will work differently than fmapping did. This time, 
the argument will get passed to both functions in parallel, and the results will be added together.

Mapping a function awaiting two arguments over a function awaiting one produces a two argument 
function.

{% highlight haskell linenos=table %}
(*2) :: Num a => a -> a
(+) :: Num a => a -> a -> a
(+) <$> (*2) :: Num a => a -> a -> a
{% endhighlight %}

We’d use applicative for functions when two functions would share the same input and we want to 
apply some other function to the result of those to reach a final result.

{% highlight haskell linenos=table %}
(<*>) :: Applicative f => (f   (a -> b)) -> (f    a) -> (f    b)
--                        f ~ a ->          f ~ a ->    f ~ a ->
(<*>) ::                 (a -> (a -> b)) -> (a -> a) -> (a -> b)
{% endhighlight %}

The implementation of applicative for function is like:

{% highlight haskell linenos=table %}
instance Applicative ((->) r) where
  pure = const
  f <*> a = \r -> f r (a r)

-- where
const :: a -> b -> a
const a b = a
{% endhighlight %}

### Monad for function

Following is an example for monad for functions:

{% highlight haskell linenos=table %}
import Control.Applicative

mulFunc :: Integer -> Integer
mulFunc x = x * 2

addFunc :: Integer -> Integer
addFunc x = x + 10

m3 :: Integer -> Integer
m3 = do
  a <- mulFunc
  b <- addFunc
  return (a + b)
{% endhighlight %}

This time the context is monadic, it does the same thing as the example in applicative for 
functions. We assign the variable `a` to the partially-applied function mulFunc, and `b` to 
addFunc. As soon as we receive an input, it will fill the empty slots in mulFunc and addFunc. 
The results will be bound to the variables `a` and `b` and passed into return.

This is the idea of `Reader`, which will be described below soon. It is a way of stringing 
functions together when all those functions are awaiting one input from a shared environment.

It is just another way of abstracting out function application and gives us a way to do 
computation in terms of an argument that hasn't been supplied yet. We use this most often when 
we have a constant value that we will obtain from somewhere outside our program that will be an 
argument to a whole bunch of functions. Using Reader allows us to avoid passing that argument 
around explicitly.

The implementation of monad for function is like:

{% highlight haskell linenos=table %}
instance Monad ((->) r) where
  return = pure
  m >>= k = flip k <*> m

-- where
flip :: (a -> b -> c) -> (b -> a -> c)
flip f a b = f b a
{% endhighlight %}

Speaking generally in terms of the algebras alone, you cannot get a Monad instance from the 
Applicative. You can get an Applicative from the Monad. However, our instances above aren’t in 
terms of an abstract datatype -- we know it’s the type of functions.

Because it’s not hiding behind a Reader newtype, we can use flip and apply to make the Monad 
instance. We need specific type information to augment what the Applicative is capable of before 
we can get our Monad instance.

### Reader

As we saw above, functions have Functor, Applicative, and Monad instances. Usually when you see 
or hear the term Reader, it’ll be referring to the Monad or Applicative instances.

We use function composition because it lets us compose two functions without explicitly having to 
recognize the argument that will eventually arrive; the Functor of functions is function 
composition. With the Functor of functions, we are able to map an ordinary function over another 
to create a new function awaiting a final argument.

The Applicative and Monad instances for the function type give us a way to map a function that is 
awaiting an `a` over another function that is also awaiting an `a`. Reader means reading an 
argument from the environment into functions.

Reader is defined as follows:

{% highlight haskell linenos=table %}
newtype Reader r a = Reader { runReader :: r -> a }
{% endhighlight %}

The `r` is the type we’re “reading” in and `a` is the result type of the function. The Reader 
newtype has a handy `runReader` accessor to get the function out of Reader.

#### Functor instance for Reader

{% highlight haskell linenos=table %}
instance Functor (Reader r) where
  fmap :: (a -> b) -> Reader r a -> Reader r b
  fmap f (Reader ra) = Reader $ \r -> f (ra r)
                     = Reader $ (f . ra)

-- same as (.)
compose :: (b -> c) -> (a -> b) -> (a -> c)
compose f g = \x -> f (g x)

-- where
\r -> f (ra r)
\x -> f (g x)
{% endhighlight %}

#### Applicative instance for Reader

To write the Applicative instance for Reader, need to use a pragma called InstanceSigs. It’s an 
extension to assert a type for the typeclass methods. It is ordinarily not allowed to assert type 
signatures in instances. The compiler already knows the type of the functions, so it’s not usually 
necessary to assert the types in instances anyway. Here is for the sake of clarity, to make the 
Reader type explicit in our signatures.

{% highlight haskell linenos=table %}
{-# LANGUAGE InstanceSigs #-}
instance Applicative (Reader r) where
  pure :: a -> Reader r a
  pure a = Reader $ \_ -> a = Reader . const
  
  (<*>) :: Reader r (a -> b) -> Reader r a -> Reader r b
  (Reader rab) <*> (Reader ra) = Reader $ \r -> (rab r) (ra r)
{% endhighlight %}

#### Monad instance for Reader

{% highlight haskell linenos=table %}
{-# LANGUAGE InstanceSigs #-}
instance Monad (Reader r) where
  return :: a -> Reader r a
  return = pure = Reader . const

  (>>=) :: Reader r a -> (a -> Reader r b) -> Reader r b
        :: forall a b. Reader r a -> (a -> Reader r b) -> Reader r b
  (Reader ra) >>= aRb = Reader $ \r -> runReader (aRb (runReader ra r)) r

-- and
ask :: Reader r r
ask = Reader $ \r -> r = Reader id
{% endhighlight %}

Reader Monad by itself is kinda boring. It can’t do anything the Applicative cannot.

#### Change Reader context

The following code lets us start a new Reader context with a different argument being provided:

{% highlight haskell linenos=table %}
withReaderT 
    :: (r' -> r)
    -- ^ The function to modify the environment.
    -> ReaderT r m a
    -- ^ Computation to run in the modified environment.
    -> ReaderT r' m a
withReaderT f m = ReaderT $ runReaderT m . f
{% endhighlight %}
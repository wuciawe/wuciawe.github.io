---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell, category]
infotext: "fourth piece on categorical typeclass in Haskell, introduction to Monad in Haskell."
---
{% include JB/setup %}

A monad is an applicative functor with some unique features that make it a bit more powerful 
than either alone. A functor maps a function over some structure; an applicative maps a 
function that is contained over some structure over some structure and then mappends the two 
bits of structure. So monads can be thought as just another way of applying functions over 
structure, with a couple of additional features.

### Monad

Following is the definition of monad:

{% highlight haskell linenos=table %}
class Applicative m => Monad (m :: * -> *) where
  (>>=) :: m a -> (a -> m b) -> m b
  (>>) :: m a -> m b -> m b
  return :: a -> m a
  fail :: String -> m a
  
-- another function
  (=<<) :: (a -> m b) -> m a -> m b
{% endhighlight %}

The `return` function is identical to `pure` function in applicative.

The `(>>)` function is almost the same as the `(*>)` function in applicative, for example:

{% highlight haskell linenos=table %}
putStrLn "Hello, " >> putStrLn "World!"
-- Hello,
-- World!

putStrLn "Hello, " *> putStrLn "World!"
-- Hello,
-- World!
{% endhighlight %}

The `(>>=)` function is more or less like `(*)` in applicative, it reorders the to-be-applied 
function and the underlying structure as the argument of the function application. Note the 
similarity between `($)`, `(<$>)`, `(<*>)`, and `(>>=)`:

{% highlight haskell linenos=table %}
($)   ::                   (a -> b)  ->     a      ->  b

(<$>) :: Functor f     =>  (a -> b)  ->    f a     -> f b

(<*>) :: Applicative f => f (a -> b) ->    f a     -> f b

(>>=) :: Monad m       =>    m a     -> (a -> m b) -> m b
{% endhighlight %}

What makes monad so powerful is the function `join` introduced in `Control.Monad` library:

{% highlight haskell linenos=table %}
join :: Monad m => m (m a) -> m a
{% endhighlight %}

It, in a sense, is a generalization of `concat` of `Foldable`:

{% highlight haskell linenos=table %}
concat :: Foldable t => t [a] -> [a]
{% endhighlight %}

#### What Monad is NOT

As monad is widely used, and there are many descriptions on it through different aspects, 
there are many misunderstanding of monad.

Monad is `not`:

- Impure. Monadic functions are pure functions. IO is an abstract datatype that allows for 
impure, or effectful, actions, and it has a Monad instance. But there’s nothing impure about 
monads.
- An embedded language for imperative programming. Simon Peyton-Jones, one of the lead 
developers and researchers of Haskell and its implementation in GHC, has famously said, 
"Haskell is the world’s finest imperative programming language," and he was talking about the 
way monads handle effectful programming. While monads are often used for sequencing actions 
in a way that looks like imperative programming, there are commutative monads that do not order 
actions.
- A value. The typeclass describes a specific relationship between elements in a domain and 
defines some operations over them. When we refer to something as “a monad,” we’re using that the
same way we talk about “a monoid,” or “a functor.” None of those are values.
- About strictness. The monadic operations of bind and return are nonstrict. Some operations can 
be made strict within a specific instance.

#### Lift

The Monad class also includes a set of lift functions that are the same as the ones in 
Applicative. They don’t really do anything different, but they are still around because some 
libraries used them before applicatives were discovered, so the liftM set of functions still 
exists to maintain compatibility.

{% highlight haskell linenos=table %}
liftA :: Applicative f => (a -> b) -> f a -> f b
liftM :: Monad m => (a1 -> r) -> m a1 -> m r

liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c
liftM2 :: Monad m => (a1 -> a2 -> r) -> m a1 -> m a2 -> m r

liftA3 :: Applicative f => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
liftM3 :: Monad m => (a1 -> a2 -> a3 -> r) -> m a1 -> m a2 -> m a3 -> m r
{% endhighlight %}

Similar to applicative, the `fmap` also has some relationship with `return` and `>>=` of 
monad:

{% highlight haskell linenos=table %}
fmap f xs = xs >>= return . f
{% endhighlight %}

And more:

{% highlight haskell linenos=table %}
-- consider
fmap :: Functor f => (a -> f b) -> f a -> f (f b)

let appendOne x = [x, 1]

:t fmap appendOne [4, 5, 6]
-- fmap appendOne [4, 5, 6] :: Num t => [[t]]

fmap appendOne [4, 5, 6]
-- [[4,1],[5,1],[6,1]]

-- and for >>=
[4, 5, 6] >>= appendOne
-- [4, 1, 5, 1, , 1]
{% endhighlight %}

We can see that with `(>>=)` the result smashes the nested structures into a flatten pattern, 
which differentiates from `fmap` keeps the structures in the result. Later, it will be 
demonstrated that these two have significant difference, of course it has.

#### do syntax

Look at the following examples:

{% highlight haskell linenos=table %}
sequencing :: IO ()
sequencing = do
  putStrLn "Hello, "
  putStrLn "World"
  
sequencing' :: IO ()
sequencing' =
  putStrLn "Hello, " >>
  putStrLn "World"

sequencing'' :: IO ()
sequencing'' =
  putStrLn "Hello, " *>
  putStrLn "World"

binding :: IO ()
binding = do
  name <- getLine
  putStrLn name

binding' :: IO ()
  binding' =
  getLine >>= putStrLn
{% endhighlight %}

We can see that do syntax is a syntactic sugar for monad functions. In the second example, 
instead of naming the variable and passing that as an argument to the next function, we use 
`(>>=)` to pass it.

#### Only `(<$>)` is not enough

As mentioned above, by using `fmap` can achieve similar effect as `>>=`, but it is not close 
enough though. Look at the following example:

{% highlight haskell linenos=table %}
putStrLn <$> getLine
{% endhighlight %}

It waits the input, but it never prints, which means that the IO action of getLine has been 
evaluated and the IO action of putStrLn not.

{% highlight haskell linenos=table %}
getLine :: IO String
putStrLn :: String -> IO ()

-- The type of fmap
<$> :: Functor f => (a -> b) -> f a -> f b

-- The (a -> b) is putStrLn
-- (a -> b )   a        b
--   |         |        |
putStrLn :: String -> IO ()

-- The f a is getLine
-- f a     f    a
--  |      |    |
getLine :: IO String

-- so that
--                      f     b
--                      |     |
putStrLn <$> getLine :: IO (IO ())

-- we can further decompose the process

-- the type of putStrLn <$> x is
f :: Functor f => f String -> f (IO ())
-- String  f (IO ())
-- |       |
 f x = putStrLn <$> x

-- the type of x <$> getLine is
g :: (String -> b0) -> IO b0
-- (String -> b0) IO b0
-- |               |
 g x =         x <$> getLine

-- here b0 is IO () in f :: Functor f => f String -> f (IO ())
-- so that
putStrLn <$> getLine :: IO (IO ())
--                      |   |   |
--                     [1] [2] [3]
{% endhighlight %}

1. This outermost IO structure represents the effects getLine must perform to get a String 
that the user typed in.
2. This inner IO structure represents the effects that would be performed if putStrLn was 
evaluated.
3. The unit here is the unit that putStrLn returns.

One of the strengths of Haskell is that we can refer to, compose, and map over effectful 
computations without performing them or bending over backwards to make that pattern work.

For example of waiting to evaluate IO actions (or any computation in general really):

{% highlight haskell linenos=table %}
let printOne = putStrLn "1"
let printTwo = putStrLn "2"
let twoActions = (printOne, printTwo)

:t twoActions
-- twoActions :: (IO (), IO ())

fst twoActions
-- 1

snd twoActions
-- 2

fst twoActions
-- 1
{% endhighlight %}

Note that we are able to evaluate IO actions multiple times.

In order to make `putStrLn <$> getLine` work as originally expected, we need to join those 
two IO layers together:

{% highlight haskell linenos=table %}
join $ putStrLn <$> getLine
{% endhighlight %}

#### order matters

In the above example, `join` merges the effects of getLine and putStrLn into a single IO action. 
This merged IO action performs the effects in the "order" determined by the nesting of the IO 
actions. As it happens, the cleanest way to express "ordering" in a lambda calculus without 
bolting on something unpleasant is through nesting of expressions or lambdas.

Sometimes it is valuable to suspend or otherwise not perform an IO action until some determination 
is made, so types are like `IO (IO ())` aren’t necessarily invalid, but you should be aware of 
what’s needed to make this example work.

Following is an example to desugar do syntax:

{% highlight haskell linenos=table %}
twoBinds :: IO ()
twoBinds = do
  putStrLn "name pls:"
  name <- getLine
  putStrLn "age pls:"
  age <- getLine
  putStrLn ("y helo thar: " ++ name ++ " who is: " ++ age ++ " years old.")

twoBinds' :: IO ()
twoBinds' =
  putStrLn "name pls:" >>
  getLine >>=
  (\name ->
    putStrLn "age pls:" >>
    getLine >>=
    (\age ->
      putStrLn ("y helo thar: " ++ name ++ " who is: " ++ age ++ " years old.")))
{% endhighlight %}

#### do syntax, applicative, and monad

If the do syntax looks like:

{% highlight haskell linenos=table %}
doSomething = do
  a <- f
  b <- g
  ...
  return (zed a b ...)
{% endhighlight %}

You can rewrite it using Applicative. On the other hand, if it looks like:

{% highlight haskell linenos=table %}
doSomething = do
  a <- f
  b <- g
  ...
  zed a b ...
{% endhighlight %}

You’re going to need Monad because zed is producing more monadic structure, and you’ll 
need `join` to crunch that back down. And in this case, the final result can rely on the 
previous results.

#### Law

Monad instances must abide by the following laws:

{% highlight haskell linenos=table %}
-- identity
-- right identity
m >>= return = m
-- left identity
return x >>= f = f x

-- associative
(m >>= f) >>= g = m >>= (\x -> f x >>= g)
{% endhighlight %}

#### Kleisli composition

With Functor and Applicative, the concerned functions are the usual `(a -> b)` arrangement, 
so composition just works. It is also guaranteed by the laws of those typeclasses:

{% highlight haskell linenos=table %}
fmap id = id
-- guarantees
fmap f . fmap g = fmap (f . g)
{% endhighlight %}

The composition of monad can be defined as:

{% highlight haskell linenos=table %}
mcomp :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c
mcomp f g a = join (f <$> (g a))
{% endhighlight %}

Using `join` and `<$>` means, we can use `>>=` instead:

{% highlight haskell linenos=table %}
mcomp' :: Monad m => (b -> m c) -> (a -> m b) -> a -> m c
mcomp' f g a = g a >>= f
{% endhighlight %}

There is another kind of function composition, which enables us to compose `>>=`, called 
`Kleisili composition`. To get Kleisli composition off the ground, we have to flip some 
arguments around to make the types work:

{% highlight haskell linenos=table %}
-- notice the order is flipped to match >>=
(>=>) :: Monad m => (a -> m b) -> (b -> m c) -> a -> m c

-- similar to
flip (.) :: (a -> b) -> (b -> c) -> a -> c

-- where
flip :: (a -> b -> c) -> b -> a -> c
{% endhighlight %}

It’s function composition with monadic structure hanging off the functions we’re composing. 
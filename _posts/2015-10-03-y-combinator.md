---
layout: post
category: [functional programming]
tags: [functional programming, scala, scheme]
infotext: 'some stuff for Y Combinator'
---
{% include JB/setup %}

Inspired by this [article](http://mvanier.livejournal.com/2897.html){:target="_blank"}, I finally figure out what a `Y Combinator` is, and 
decide to write this post which covers my understanding on Y Combinator (implicit recursive function call and 
explicit type recursion) and examples in Scheme and Scala.

### What is a combinator

A combinator is a function with no free variables (or with all variables bounded), a pure lambda expression that 
refers only to its arguments.

### What is a Y Combinator

Y Combinator is a combinator which takes a single argument which is a function 
that is not recursive and turns back a version of that argument which is recursive. 
So it is clear that Y Combinator is a higher order function.

And actually the input function is also a higher order function. What the Y 
Combinator does is to return the fix-point-of the input function. That is to 
say:

{% highlight scheme linenos=table %}
(Y f) = (f (Y f))
{% endhighlight %}

Y Combinator directly computes out the fix-point of `f`.

### Example of factorial function in Scheme

First, we define a almost-factorial function as:

{% highlight scheme linenos=table %}
(define almost-factorial
    (lambda (f)
        (lambda (n)
            (if (= n 0)
                1
                (* n (f (- n 1))))))
{% endhighlight %}

As we can see, the type of `almost-factorial` is `(Int => Int) => Int => Int`. Our 
aim is to define a Y such that `(Y almost-factorial)` is the factorial function 
with type `Int => Int` and the factorial function is the fix-point-of `almost-factorial` 
which means:

{% highlight scheme linenos=table %}
factorial = (almost-factorial factorial)
          = (almost-factorial
                (almost-factorial
                    (almost-factorial ...)))
{% endhighlight %}

Before derive the Y Combinator, let's define another function called 
part-factorial:

{% highlight scheme linenos=table %}
(define part-factorial
    (lambda (self)
        (lambda (n)
            (if (= n 0)
            1
            (* n ((self self) (- n 1)))))))

((part-factorial part-factorial) 5) ; => 120
{% endhighlight %}

We can see that with `(part-factorial part-factorial)`, we get a definition of 
factorial function. The input argument of `part-factorial` is a function named 
`self`, and `(self self)` has the type `Int => Int`. So, let's assume the type 
of `self` is `X => Int => Int`, from `(self self)` we know that `X = X => Int => Int`. 
And it is clear that the type of `part-factorial` is also `X => Int => Int`, so that 
`(part-factorial part-factorial)` has the type `Int => Int`.

Let's utilize the definition of `almost-factorial`:

{% highlight scheme linenos=table %}
(define part-factorial
    (lambda (self)
        (almost-factorial (self self))))

((part-factorial part-factorial) 5) ; => 120
{% endhighlight %}

Then we can define `factorial` as:

{% highlight scheme linenos=table %}
(define factorial
    ((lambda (self)
        (almost-factorial (self self)))
     (lambda (self)
        (almost-factorial (self self)))))

;; or you can do the follows
;; (define factorial
;;     ((lambda (self)
;;         (self self))
;;      (lambda (self)
;;         (almost-factorial (self self)))))

(factorial 5) ; => 120
{% endhighlight %}

Finally, we can define Y Combinator as follows:

{% highlight scheme linenos=table %}
(define Y
    (lambda (f)
        ((lambda (h)
            (h h))
         (lambda (g)
            (f (g g))))))

((Y almost-factorial) 5) ; => 120
{% endhighlight %}

Let's figure out what happens, `(lambda (h) (h h))` defines an anonymous function which applies its argument 
to the argument itself, it corresponds to the `(part-factorial part-factorial)` part for obtaining a definition 
of `factorial`. From here, we can image that if the final result is a function with type `A => B`, then the 
return type of `h` should be `A => B`. Let's assume the type of `h` is `X => A => B`, then we get a type 
recursion `X = X => A => B` because of `(h h)`.

And `(lambda (g) (f (g g)))` corresponds to the definition of `part-factorial` which enables the explicit 
self call reference to obtain the fix-point-of `f`, where `f` is of the type `(A => B) => A => B`. Apply 
`(lambda (g) (f (g g)))` to `(lambda (h) (h h))`, we finally get the fix-point-function with type `A => B`. 
We can also notice that the return type of `(g g)` should be `A => B` because of `(f (g g))` and the fact 
that the type of the input argument of `f` is `A => B` meanwhile the return type of `f` is `A => B` as well. 
And we will apply this anonymous function to `(lambda (h) (h h))`, so the type of `g` is also `X => A => B`.

Well, this is a definition of Y Combinator. With the respect to the type within the definition, you will find 
an infinite type recursion, fortunately the Scheme is a dynamical type language, so that it will not be a 
big problem.

And the above definition works in the lazy version of Scheme, for strict evaluation Scheme define Y as:

{% highlight scheme linenos=table %}
(define Y
    (lambda (f)
        ((lambda (x) (x x))
         (lambda (x)
            (f (lambda (y)
                    ((x x) y)))))))
{% endhighlight %}

### Example of factorial function in Scala

Let's first deal with the easy part, define the `almostFactorial`:

{% highlight scala linenos=table %}
val almostFactorial = (f: Int => Int) => (n: Int) => if(n == 0) 1 else n * f(n - 1)
{% endhighlight %}

Then, let's try to define Y. Since Scala is a statically typed language, the recursion on type level will 
cause invalid cyclic reference. So it's hard to define Y through higher kinded type. Fortunately, it is 
possible to define Y with the help of case class:

{% highlight scala linenos=table %}
def Y[A, Z] = (f: (A => Z) => A => Z) => {
    case class H(h: H => A => Z){
        def apply(h: H) = this.h(h)
    }
    val h = H(x => f(x(x)(_)))
    h(h)
}

val factorial = Y(almostFactorial)
println(factorial(5)) // 120
{% endhighlight %}

I think it's ok to use case class to break the self reference on type level since in Scala functions are 
taken as objects.

---
layout: post
category: [scala, functional programming]
tags: [scala, case class, pattern matching, functional programming, option]
---
{% include JB/setup %}

`pattern matching` is common in functional language. `case class` is provided by Scala to allow pattern matching on objects 
without requiring a large amount of boilerplate.

## Case Class

Classes with `case` modifier are called `case classes`. When a class is declared as a case class, following will be done 
by compiler:

-   a factory method with the name of the class is added to that class
-   all the arguments in the parameter list of the case class implicitly get a `val` prefix.
-   the compiler adds "natural" implementations of methods toString, hashCode, equals to the class. == will compare case 
classes structurally.
-   the compiler adds a copy method to the class for making modified copies

<!-- more -->

## Pattern Matching

{% highlight scala %}
selector match { alternatives }
{% endhighlight %}

A pattern match includes a sequence of _alternatives_, each starting with the keyword `case`. A match expression is evaluated 
by trying each of the patterns in the order they are written. The first pattern that matches is selected, it will be 
executed but not fall through following patterns which is not like that in Java, where a keyword `break` is a must for the 
same effect.

-   A `constant pattern` matches values that are equal to the constant with respect to ==.
-   A `variable pattern` matches every value. The variable then refers to that value in the right hand side of the case clause.
-   The _wildcard pattern_ `_` also matches every value, but it does not introduce a variable name to refer to that value.
-   A `constructor pattern` matches certain case class with arguments also patterns. This makes deep patterns available with concise notations.
-   The `sequence pattern` like List or Array can be matched like case classes.
-   You can match against `tuple patterns`.
-   The `typed patterns` is the convenient replacement for type tests and type casts.

If no case pattern is matched, the match expression would throw a MatchError.

Scala uses a simple lexical rule for disambiguation between constant pattern and variable pattern: a simple name starting with a lowercase letter is take to 
be a pattern variable; all other references are taken to be constants. If the constant is a field of some object with a 
lowercase name, prefix it with a qualifier as this.pi. Or you can enclose the variable name in back ticks as `pi`.

If you want to match against a sequence without specifying its length, using `_*` as the last element of the pattern, this matches any 
number of elements within a sequence including zero elements.

Because of `type erasure`, there is no information about type arguments of generics maintained at runtime. The only exception to 
the erasure rule is arrays. Maybe `reflection` make type information available.

In addition to the standalone variable patterns, you can also add a variable to any other pattern. You simply write the 
variable name, an at sign `@`, and then the pattern. This gives you a variable-binding pattern.

The `if statement` following the pattern composes the pattern guard.

## Sealed Classes

Making the superclass of the case classes `sealed` restricts adding new subclasses in the same file. This enables the 
compiler to detect missing combinations of patterns in the match expression.

Using `@unchecked` annotation on the selector expression of the match can make the compiler not emit warning on checking 
missing match expressions.

## The Option type

You can also use pattern matching with `Option` values, which is Some(x) where x is the actual value or None object.

## Case sequences as partial functions

A sequence of cases (i.e., alternatives) in curly braces can be used anywhere a function literal can be used. Essentially, a case sequence is a function
literal, only more general. Instead of having a single entry point and list of parameters, a case sequence has multiple entry points, each with their
own list of parameters. Each case is an entry point to the function, and the parameters are specified with the pattern. The body of each entry point is the
right-hand side of the case.

One other generalization is worth noting: a sequence of cases gives you a partial function. If you apply such a function on a value it does not support,
it will generate a run-time exception. For example:

{% highlight scala %}
val second: List[Int] => Int = {
  case x :: y :: _ => y
}
{% endhighlight %}

When compiling above code, the compiler will complain that the match is not exhaustive:

{% highlight console %}
<console>:17: warning: match is not exhaustive!
missing combination    Nil
{% endhighlight %}

The type List[Int] => Int includes all functions from lists of integers to integers, whether or not the functions are partial. The type that
only includes partial functions from lists of integers to integers is written PartialFunction[List[Int],Int] .

{% highlight scala %}
val second: PartialFunctin[List[Int], Int] = {
  case x :: y :: _ => y
}
{% endhighlight %}

Partial functions have a method isDefinedAt , which can be used to test whether the function is defined at a particular value. In this case, the function
is defined for any list that has at least two elements.

Such an expression gets translated by the Scala compiler to a partial function by translating the patterns twice—once for the implementation of the real function, and once to
test whether the function is defined or not. For instance, the function literal { case x :: y :: _ => y } above gets translated to the following partial
function value:

{% highlight scala %}
new PartialFunction[List[Int], Int] {
  def apply(xs: List[Int]) = xs match {
    case x :: y :: _ => y
  }
  
  def isDefinedAt(xs: List[Int]) = xs match {
    case x :: y :: _ => true
    case _ => false
  }
}
{% endhighlight %}

This translation takes effect whenever the declared type of a function literal is PartialFunction . If the declared type is just Function1 , or is missing,
the function literal is instead translated to a complete function.

In general, you should try to work with complete functions whenever possible, because using partial functions allows for runtime errors that the
compiler cannot help you with. Sometimes partial functions are really helpful, though. You might be sure that an unhandled value will never be supplied. Alternatively, you might be using a framework that expects partial
functions and so will always check isDefinedAt before calling the function.
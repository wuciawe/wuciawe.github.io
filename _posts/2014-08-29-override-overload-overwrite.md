---
layout: post
category: [object oriented]
tags: [object oriented, c++, java, scala]
---
{% include JB/setup %}

These three concepts are quite confusing. But I think the `overload` and `overwrite` are fake concepts. In Java and 
Scala, there even doesn't exist the concept of `overwrite`. `overload` can be considered as normal functions, the only 
special thing is that normal functions have the same function name. All the things are determined at compile time.

While `override` is very useful for polymorphism. The called method is determined at runtime. I think the concept of 
`overwrite` may come from the use of keyword `virtual` in C++. When the base class method is assigned with `virtual`, 
then `override` takes effects, which calls `late binding`. Or the methods will be `early binded`, and there is no 
polymorphic behavior.

<!-- more -->

## In C++

`override`: subclass method overrides base class method means:

-   in different range (in derived class and base class)
-   the same function name 
-   the same function signature
-   the return type conforms covariance
-   the base class method is virtual

`overload`: function overloading means:

-   the same range (in the same class)
-   the same function name
-   different function signature

`overwrite`: subclass method hides base class method means:

-   in different range (in derived class and base class)
-   the same function name
-   two cases on parameters ( _`signature?`_ ):
    -   the same parameters, the base class method is not virtual
    -   different parameters

## In Java

`override`: subclass method overrides base class method means:

-   in different range (in derived class and base class)
-   the same function name
-   the same function signature
-   the return type conforms covariance

In Java, when you override a method, you could add `@Override` annotation on that method, this will let the compiler to 
help you check out whether you actually override a method or just mistake or misspell something. 

`overload`: function overloading means:

-   the same range (in the same class)
-   the same function name
-   different function signature

## In Scala

Similar case with Java, but no restrictions on `Operator Overloading`.

Scala provides `override` keyword for the use of `@Overrride` annotation in Java.

## Summation

The concept `overwrite` introduced in C++ is really a result of using `virtural` keyword.

While in Java and Scala, `override` is enabled by default. And Java provides`@Override` annotation and Scala provides 
`override` keyword to help avoid some common bugs at compile time. `override` makes polymorphism very powerful.

`overload` is a concept in the case of different functions sharing the same function name. I think this case takes no 
difference with the case that you declare different functions with different function names. Because only function name 
can not determine the function signature or function type. While functions are picked by their functions signature, and 
`override` is a mechanism based on function signature restricted by function type.
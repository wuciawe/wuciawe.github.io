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

`overload`: function overloading means:

-   the same range (in the same class)
-   the same function name
-   different function signature

## In Scala

Similar case with Java, but no restrictions on `Operator Overloading`.
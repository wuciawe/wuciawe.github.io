---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell]
infotext: "datatype and typeclass in haskell"
---
{% include JB/setup %}

In Haskell there are six categories of entities that have names.

- First, there are variables and data constructors which exist at 
the term-level. `Term-level` is where the values live and is the 
code that executes when the program is running.
- At the type-level, which is used during the static analysis and 
verification of the program, we have type variables, type constructors, 
and typeclasses.
- Lastly, for the purpose of organizing code into coherent groupings 
across different files, we have modules which have names as well.

### Datatype

A type or datatype is a classification of values or data. Types in 
Haskell determine what values are members of it or inhabit it. 
Unlike in other languages, datatypes in Haskell by default do not 
delimit the operations that can be performed on that data.

#### Type constructor

The type constructor (or type name) is the name of the type and is 
capitalized. It is used in type signatures.

Just as data declarations generate data constructors to create values 
that inhabit that type, data declarations generate type constructors 
which can be used to denote that type.

#### Data constructor

Data constructors create the values that inhabit the type they are 
defined in. They are the values that show up at the term level instead 
of the type level.

Data constructors in Haskell have a type and can either be constant 
values (nullary) or take one or more arguments just like functions.

#### Type alias

A type alias, or type synonym, is a name for a type, usually for some 
convenience, that has another name.

### Typeclass

A typeclass is a set of operations defined with respect to a polymorphic 
type. When a type is an instance of a typeclass, values of that type can 
be used in the standard operations defined for that typeclass. In Haskell 
typeclasses are unique pairings of class and concrete instance.

### Polymorphism

Polymorphism in Haskell means being able to write code in terms of values 
which may be one of several, or any, type. Polymorphism in Haskell is either 
parametric or constrained.

Polymorphic type variables give us the ability to implement expressions that 
can accept arguments and return results of different types without having to 
write variations on the same expression for each type.

Broadly speaking, type signatures may have three kinds of types: concrete, 
constrained polymorphic, or parametrically polymorphic.

In Haskell, polymorphism divides into two categories: parametric polymorphism 
and constrained polymorphism. If you’ve encountered polymorphism before, it was 
probably a form of constrained, often called ad-hoc, polymorphism. Ad-hoc 
polymorphism in Haskell is implemented with typeclasses.

Parametric polymorphism is broader than ad-hoc polymorphism. Parametric polymorphism 
refers to type variables, or parameters, that are fully polymorphic. When 
unconstrained by a typeclass, their final, concrete type could be anything. 
Constrained polymorphism, on the other hand, puts typeclass constraints on the 
variable, decreasing the number of concrete types it could be, but increasing 
what you can actually do with it by defining and bringing into scope a set of 
operations.

A function is polymorphic when its type signature has variables that can represent 
more than one type. That is, its parameters are polymorphic. Parametric polymorphism 
refers to fully polymorphic (unconstrained by a typeclass) parameters. Parametricity 
is the property we get from having parametric polymorphism. Parametricity means that 
the behavior of a function with respect to the types of its (parametrically polymorphic) 
arguments is uniform. The behavior can not change just because it was applied to an 
argument of a different type.

Type variable is a way to refer to an unspecified type or set of
types in Haskell type signatures. Type variables ordinarily will be
equal to themselves throughout a type signature.
---
layout: post
category: [functional programming, haskell]
tags: [functional programming, haskell]
infotext: "datatype and typeclass in haskell"
---
{% include JB/setup %}

Haskell is strong typing and static typing. `Static typing` means 
that the types are known to the compiler and checked for mismatches, 
or type errors, at compile time.

In Haskell there are six categories of entities that have names.

- First, there are `variables` and `data constructors` which exist at 
the term-level. The `term-level` is where the values live and is the 
code that executes when the program is running.
- At the `type-level`, which is used during the static analysis and 
verification of the program, we have `type variables`, `type constructors`, 
and `typeclasses`.
- Lastly, for the purpose of organizing code into coherent groupings 
across different files, we have `module`s which have names as well.

### Datatype

A type or `datatype` is a classification of values or data. Types in 
Haskell determine what values are members of it or inhabit it. 
Unlike in other languages, datatype in Haskell by default does not 
delimit the operations that can be performed on that data.

Haskell offers `sum type`s, `product type`s, product types with `record 
syntax`, `type alias`es, and a special datatype called a `newtype` that 
offers a different set of options and constraints from either type synonyms 
or data declarations.

#### Data declaration, `data`

Data declarations define new datatype in Haskell. Data declarations 
always create a new type constructor, but may or may not create new 
data constructors. So, A type can be thought of as an enumeration of 
constructors that have zero or more arguments. Data declarations are 
how we refer to the entire definition that begins with the `data` 
keyword, which is used to declare a new algebraic datatype.

{% highlight haskell linenos=table %}
data Bool = True | False

data Maybe a = Nothing | Just a
{% endhighlight %}

Keyword data signals that what follows is a data declaration, or a 
declaration of a datatype. In the above example, `Bool` and `Maybe` are 
type constructors and `True`, `False`, `Nothing`, and `Just` are data 
constructors.

##### Type constructor

The type constructor (or type name) is the name of the datatype and is 
capitalized. It is used in type signatures.

Just as data declarations generate data constructors to create values 
that inhabit that type, data declarations generate type constructors 
which can be used to denote that type.

##### Data constructor

Data constructors are functions that create data, or values, that 
inhabit a particular type they are defined in. They are the values 
that show up at the term level instead of the type level.

Data constructors in Haskell have a type and can either be constant 
values (nullary) or take one or more arguments just like functions.

##### Constants and constructors

Although the term `constructor` is often used to describe all type 
constructors and data constructors, we can make a distinction between 
constants and constructors. Type and data constructors that take no 
arguments are constants. They can only store a fixed type and amount 
of data.

`Arity` refers to the number of arguments a function or constructor takes. 
A function that takes no arguments is called `nullary`. Constructors that
take one argument are called `unary`. Data constructors that take more than 
one argument are called `product`s.

##### Sum and Product, Record syntax

Datatype is algebraic, sum type and product type.

A `sum type` is any type that has multiple possible representations, and uses 
`|` to separate each representation. Following are definitions of sum types:

{% highlight haskell linenos=table %}
data Bool = True | False

data Either a b = Left a | Right b
{% endhighlight %}

A `product type` is the datatype whose data constructor takes more than one 
argument. Following is an example of definition of product type:

{% highlight haskell linenos=table %}
data People = People String Int
{% endhighlight %}

The most direct way to explain why they’re called sum and product is to 
demonstrate sum and product in terms of `cardinality`.

In the above examples, the sum type `Bool`'s cardinality is `2`, which is given 
by `1 + 1`, as the cardinality of constants `True` and `False` is `1`. And the 
sum type `Either`'s cardinality is the sum of the cardinality of type variable 
`a` and type variable `b`. So the cardinality of a sum type is the sum of the 
cardinality of its inhabitants.

On the other hand, a product type’s cardinality is the product of the cardinality 
of its inhabitants. As a result, the cardinality of `People` is the product of the 
cardinality of `String` and `Int`. Arithmetically, products are multiplication. 
Where a sum type was expressing `or`, a product type expresses `and`.

There is a special syntax for declaring a product type: record syntax. Records in 
Haskell are product types with additional syntax to provide convenient accessors to 
fields within the record. For example:

{% highlight haskell linenos=table %}
data Person = Person { name :: String
                     , age :: Int
                     } deriving (Eq, Show)

let person = Person "Root" 18

name person
age person
{% endhighlight %}

Besides record syntax, there is also a type `tuple` called `anonymous product`. A tuple 
is an ordered grouping of values. A minimal tuple takes at least two arguments to 
construct the concrete data, so it is a product type.

All the existing algebraic rules for products and sums apply in type systems, and that 
includes the distributive property.

In normal arithmetic, the expression is in normal form when it’s been reduced to a final 
result. However, in type system, `sum of products` expression is in normal form, as there 
is no computation to perform.

In the arithmetic of calculating inhabitants of types, function type is the exponent 
operator. Given a function ?`a −> b`?, we can calculate the inhabitants with the formula ?
`b^?a`.

#### Type alias

A type alias, or type synonym, is a name for a type, usually for some convenience, that 
has another name. It is denoted by the keyword `type`.

Type aliases create type constructors, not data constructors, for example:

{% highlight haskell linenos=table %}
type String = [Char]
{% endhighlight %}

#### Data declaration, `newtype`

The `newtype` is a special case of data declarations. The newtype is 
different in that it permits only one constructor and only one field.

For example:

{% highlight haskell linenos=table %}
newtype Radius = Radius Double

data Diameter = Diameter Double
{% endhighlight %}

where `Diameter` follows a normal data declaration, and `Radius` is 
defined by `newtype`.

The differences between `newtype` and `data`, `type` are:

- newtype cannot be a product type, sum type, or contain nullary 
constructors, it can only have a single constructor taking a single 
argument
- newtype introduces no runtime overhead, it reuses the representation 
of the type it contains, as it's not allowed to be a record (product 
type) or tagged union (sum type), the difference between newtype and the 
type it contains is gone by the time the compiler generates the code, 
which is similar to a type synonym (no additional "boxing up", newtype 
is like a single-member C union that avoids creating an extra pointer, 
but still gives a new type constructor and data constructor, so you don't 
mix up things that share a single representation)
- newtype creates a strict value constructor and type synonym creates 
a lazy one

In summary, reasons to use newtype:

- Signal intent: using newtype makes it clear that you only intend for it 
to be a wrapper for the underlying type. The newtype cannot eventually grow 
into a more complicated sum or product type, while a normal datatype can.
- Improve type safety: avoid mixing up many values of the same representation, 
such as Text or Integer .
- Add different typeclass instances to a type that is otherwise unchanged 
representationally.

### Type variable

Sometimes we need the flexibility of allowing different types or amounts 
of data to be stored in datatypes. For those times, type and data 
constructors may be parametric. When a constructor takes arguments, then 
it’s like a function in at least one sense – it must be fully applied to 
become a concrete type or value.

`Type variable` is a way to refer to an unspecified type or set of types in 
Haskell type signatures. Type variables ordinarily will be equal to themselves 
throughout a type signature.

### Kind

`Kind`s are the types of types, or types one level up. We represent kinds
in Haskell with `*` and `#`. Kind `*` is the kind of all standard lifted 
types, while types that have the kind `#` are unlifted. A lifted type, 
which includes any custom defined datatype, is any that can be inhabited 
by `bottom`. Lifted types are represented by a pointer. Unlifted types are 
any type which cannot be inhabited by `bottom`. Types of kind `#` are often 
native machine types and raw pointers. While `newtype`s are a special case in
that they are kind `*`, but are unlifted because their representation is 
identical to that of the type they contain, so the newtype itself is not 
creating any new pointer beyond that of the type it contains. That fact means 
that the newtype itself cannot be inhabited by bottom, only the thing it 
contains can be, so newtypes are unlifted.

We know something is a fully applied, concrete type when it is represented as 
`*`. When it is `* -> *`, it, like a function, is still waiting to be applied.

Kinds are the types of type constructors, primarily encoding the number of 
arguments they take. The default kind in Haskell is `*`. Kind signatures work 
like type signatures, using the same `::` and `->` syntax, but there are only 
a few kinds. Kinds are not types until they are fully applied.

### Typeclass

A `typeclass` is a set of operations defined with respect to a polymorphic 
type. It is a means of expressing faculties or interfaces that multiple 
datatypes may have in common. When a type is an instance of a typeclass, 
values of that type can be used in the standard operations defined for that 
typeclass. In Haskell typeclasses are unique pairings of class and concrete 
instance.

#### Inheritance

Typeclass inheritance is when a typeclass has a superclass. This is a 
way of expressing that a typeclass requires another typeclass to be 
available for a given type before you can write an instance.

#### Insatance

An `instance` is the definition of how a typeclass should work for 
a given type. Instances are unique for a given combination of typeclass 
and type.

In Haskell we have derived instances so that obvious or common 
typeclasses, such as `Eq`, `Enum`, `Ord`, and `Show` can have the 
instances generated based only on how the datatype is defined.

### Polymorphism

Broadly speaking, type signatures may have three kinds of types: concrete, 
constrained polymorphic, or parametrically polymorphic.

Polymorphism in Haskell means being able to write code in terms of values 
which may be one of several, or any, type. Polymorphism in Haskell is either 
parametric or constrained.

Instead of limiting functions to a concrete type, we use typeclass polymorphic 
type variables. Polymorphic type variables give us the ability to implement 
expressions that can accept arguments and return results of different types 
without having to write variations on the same expression for each type.

In Haskell, polymorphism divides into two categories: parametric polymorphism 
and constrained polymorphism.

#### Parametric polymorphism

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
arguments is uniform. The behavior is uniform across all concrete applications of the 
function, it can not change just because it was applied to an argument of a different 
type.

#### Ad-hoc polymorphism

Polymorphism in many other languages is probably a form of constrained, often 
called ad-hoc, polymorphism. Ad-hoc polymorphism in Haskell is implemented with 
typeclasses.

Ad-hoc polymorphism is polymorphism that applies one or more typeclass 
constraints to what would’ve otherwise been a parametrically polymorphic type 
variable. Here, rather than representing a uniformity of behavior across all 
concrete applications, the purpose of ad-hoc polymorphism is to allow the 
functions to have different behavior for each instance. This ad-hoc-ness is 
constrained by the types in the typeclass that defines the methods and Haskell’s 
requirement that typeclass instances be unique for a given type.
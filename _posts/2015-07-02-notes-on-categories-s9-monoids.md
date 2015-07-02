---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, monoids. I'm so happy to come to the concept of monoids. It's a large step."
---
{% include JB/setup %}

`Definition:` A category with exactly one object is called a monoid.

In order to specify a category, we need to specify the `objects`, `maps`, which object is the `domain` of 
each map, which object is the `codomain` of each map, which map is the `identity map` of each object and 
which map is the `composite` of any two composable maps. And the following three laws should be satisfied: 
bookkeeping laws, associative laws and identity laws.

Let's define M for multiplication as * ->(n)-> *, where * is the only object in the category. And all the 
maps in the category are endomaps. Suppose taking all natural numbers as the maps, and taking the composition of two 
maps in the category is the product of the two numbers, then the identity is the number one 1, and the 
bookkeeping laws and the associative laws are satisfied in this category.

The object in M seems features. There are ways interpreting such category in sets, so that the object takes 
on a certain life. An interpretation will be denoted as: M -> S. One interpretation interprets the only 
object * of M as the set N of natural numbers, and each map in M is interpreted as a map from the set of 
natural numbers to itself: N ->(fn)-> N, defined by fn(x) = n * x. Then f1 is the identity, and fn◦fm = fnm is 
the composition of two maps. This shows the interpretation preserves the structure of the category.

Such a 'structure-preserving' interpretation of one category into another is called a `functor` (from the 
first category to the second). A functor is also required to preserve the notions of domain and codomain.

Let's define another monoid N, which has only one object *, the maps are numbers again, while the composition 
is addition instead of multiplication. Now 1* must be 0. To give a functor N -> S means that we interpret 
* as some set S and each map * ->(n)-> * in N as an endomap S ->(gn)-> S of the set S, in such a way that 
g0 = 1S and gn◦gm = g(n+m). We take S to be a set of numbers and define gn(x) = n + x.

All the above suggests the 'standard example' of interpretation of a monoid in sets, in which the object of 
the monoid is interpreted as the set of maps of the monoid itself. In this way, we get a standard functor 
from any monoid to the category of sets.

There are many functors from N to sets other than the standard one. Suppose we take a set X together with 
an endomap alpha, and interpret * as X and send each map n of N (a natural number) to the composite of alpha 
with itself n times, i.e. alpha^n. In order to preserve the identities, we send the number 0 to the identity 
map on X. In this way, we get a functor from n to sets, h: N -> S which can be summarized this way:

1.  h(*) = X
2.  h(n) = alpha^n
3.  h(0) = 1X

Then it is clear that h(n+m) = h(n)◦h(m).

In this way, whenever we specify a set-with-endomap X[endomap] we obtain a functorial interpretation of N 
in sets. This suggests another reasonable name for S[endomap] would be S[N] to suggest that an object is a 
functor from N to S.
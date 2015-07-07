---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, group theory, the number of types of connected objects, constants, codiscrete, and many connected objects."
---
{% include JB/setup %}

`Definition:` C is called connected if it has exactly one component, i.e. FC = 1 (where F is the left adjoint to the 
inclusion I of the category of discrete objects). This is equivalent 
to pi0◦C = 1, where pi0 = IF.

`Definition:` A group is a monoid in which every element has an inverse.

The group case of monoid has special features which arise from the following:

1.  Each congruence relation on a group arises from a normal subgroup
2.  for any two representations, the underlying set of the map space is the map set 
of the underlying sets
3.  given elements x and y in a connected representation, there is a group element g 
with x◦g = y.

`Theorem:` The number of non-isomorphic connected representations of a group G is 
at most the number of subgroups of G.

### Constants and codiscrete objects

`Definition:` A constant of a monoid M is an element c such that cm = c for all elements m of M.

The codiscrete inclusion J is right-adjoint to the fixed-point functor G. Indeed, we have a string 
of four adjoints F -| I -| G -| J relating the M-actions to the abstract set. While 
FI ≈ GI ≈ GJ are all equivalent to the identity functor on S, the composite FJ assings, 
to every set S, the set of (tokens for) connected components of the codiscrete action on S[C].

For S =/= 0, FJS = 1.

### Monoids with at least two constants

`Proposition:` If a monoid M has at least two constants, then for every nonempty set S, the codiscrete action 
J(S) is connected.

In fact, there are more connected M-actions. If M has at least two constants, then the truth-value space Omega in 
the category of right M-actions is connected. For any right M-action X, the map space Omega[X] is connected. Any 
X is the domain of a subobject of a connected object, for example X -> Omega[X] by the 'singleton' inclusion.
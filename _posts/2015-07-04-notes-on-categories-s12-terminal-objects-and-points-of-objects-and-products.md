---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, terminal objects, points of an object, and products in categories."
---
{% include JB/setup %}

### Terminal objects

`Definition:` In any category C, an object T is a terminal object if and only if it has the property: for 
each object X in C there is exactly one map from X to T.

`Theorem:` Suppose that C is any category and that both T1 and T2 are terminal objects in C. Then T1 and T2 are 
isomorphic; i.e. there are maps f: T1 -> T2, g: T2 -> T1 such that g◦f is the identity of T1 and f◦g is 
the identity of T2.

`Definition:` A point of X is a map T -> X where T is terminal.

A product of A and B is an object P, and a pair of maps, P ->(p1)-> A, P ->(p2)-> B.

`Definition:` Suppose that A and B are objects in a category C. A product of A and B (in C) is 

1.  an object P in C, and
2.  a pair of maps, P ->(p1)-> A, P ->(p2)-> B in C satisfying: for every object T and every pair of maps 
T ->(q1)-> A, T ->(q2)-> B, there is exactly one map T ->(q)-> P for which q1 = p1◦q and q2 = p2◦q.

Note on terminology: the objects that are being multiplied are called factors, and the resulting object 
is called their product.

`Theorem:` Suppose that A <-(p1)<- P ->(p2)-> B and A <-(q1)<- Q ->(q2)-> B, are two products of A and B. 
Because A <-(p1)<- P ->(p2)-> B is a product, viewing Q as a 'test' object gives a map Q -> P; because 
A <-(q1)<- Q ->(q2)-> B is a product, we also get a map P -> Q. These two maps are necessarily inverse to 
each other, and therefore the two objects P, Q are isomorphic.
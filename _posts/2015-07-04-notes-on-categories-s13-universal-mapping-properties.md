---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, universal mapping properties."
---
{% include JMB/setup %}

An example of universal mapping property appearing 
in the definition of terminal object: 1 is terminal 
means that `for each` object X, there is exactly one 
map X -> 1. The object 1 is described by its relation 
to every object in the 'universe', i.e. the category 
under consideration.

The idea of figure arises when, in investigating some 
category C, we find a small class A of objects in C which 
we use to probe the more complicated objects X by 
means of maps A ->(x)-> X from objects in A. We call 
the map x a figure of shape A in X. (or sometimes 
a singular figure of shape A in X, if we want to 
emphasize that the map x may collapse A somewhat, so 
that the picture of A in X may not have all the features 
of A).

If the categroy C has a terminal object, we can consider 
it as a basic shape for figures. Indeed, we have already 
given figures of that shape a special name: a figure of 
shap 1 in X, 1 -> X, is called a point of X. In sets, the points 
of X are in a sense all there is to X, so that we often use the 
words 'point' and 'element' interchangeably, whereas in 
dynamical systems points are fixed states, and in 
graphs they are loops.

The category of sets has a special property, roughly because the objects have no structure: If two points 
agree on points, they are the same map. That is, suppose X ->(f)-> Y and X ->(g)-> Y, if fx = gx for every 
point 1 ->(x)-> X, we can conclude that f = g. This special property of the category of sets is not true of 
S[endomap], nor of S[irreflexive]. In S[endomap] the 
2-cycle C2 has no points at all, since 'points' are fixed 
points; any two maps from C2 to any system agree at all points (since 
they are no points to disagree on) even though they 
may be different maps.

Given any pair of maps X[endomap:alpha] =>(f,g)=> Y[endomap:beta] 
in S[endomap], if for all figures N[endomap:delta] ->(x)-> X[endomap:alpha] 
of shape N[endomap:delta] it is true that fx = gx, then f = g.

### Incidence relations

Suppose we have in X a figure x of shape A, and a 
figure y of shape B. We use a map u: A -> B satisfying 
yu = x to describe the structure of the overlap.

One way in which x may be incident ot y is if there is 
map u such that yu = x, another possibility is that 
we may have maps from an object T to A and to B so 
that with xu1 = yu2. The second possibility means 
in effect that there is given a third figure T -> X 
together with incidences in the first sense to each 
of x and y.

### Basic figure-types, singular figures, and incidence, in the category of graphs

In the category of graphs S[irreflexive] the two objects 
D = *, and A = * -> * can serve as basic figure-types. 
A is an arrow of the graph and D is a dot.

Given any pair of maps X ->(f)-> Y, X ->(g)-> Y in 
S[irreflexive], if fx = gx for all figures D ->(x)-> X 
of shape D and for all figures A ->(x)-> X of shape 
A, then f = g.

Another useful figure-type is that of the graph M = * -> * <- *. 
This graph has two arrows, which means that there are 
two different maps from A to M, namely the maps.

### More on universal mapping properties

Universal mapping properties

Initial object | Terminal object
Sum of two objects | Product of two objects
... | Exponential, power, map space (note mentioned yet)

The definition for a 'left column property' is similar to 
that of the corresponding 'right column property' with 
the only difference that all the maps appearing in the 
definition are reversed - domain and codomain are interchanged.

Let's clarify it with a simple example. The idea of initial 
object is similar to that of terminal object but 'opposite'. 
T is a terminal object if for each object X there is exactly 
one map from X to T, X -> T. Correspondingly, I is an 
initial object if for each object X there is exactly one 
map from I to X, I -> X.

In the category of abstract sets an initial object is an empty set.

And, the dual of product of two objects is the sum of two objects.

Round P269 there is an example which gives a construction reduces 
products in one category to terminal objects in another. (in particular, 
makes the uniqueness theorem for products a consequence of the 
corresponding theorem for terminal objects).

### Calculate products

We refer to any product B1 <-(p1)<- P ->(p2)->B2 as the product 
of B1 and B2 and denote the object P by B1 x B2. We call the two 
maps p1, p2 'the projections of the product to its factors'. For 
any two maps from an object A to B1 and B2, i.e. any B1 <-(f1)<- A ->(f2)-> B2, 
there is exactly one map A ->(f)-> B1 x B2 satisfying p1f = f1 and 
p2f = f2. This map is also denoted by a special symbol <f1, f2> which 
indicates the list of the maps that give rise to f.

`Definition:` For any pair of maps B1 <-(f1)<- A ->(f2)-> B2, <f1, f2> is 
the unique map A -> B1 x B2 that satisfies the equations 
p1<f1, f2> = f1 and p2<f1, f2> = f2.

These equations can be read: 'the first component of the map <f1, f2> is f1' and 
'the second component of the map <f1, f2> is f2'.

This means, in terms of figures, that the figures of shape A in 
the product B1 x B2 are precisely the ordered pairs 
consisting of a figure of shape A in B1 and a figure of 
shape A in B2. On the one hand, given a figure of shape A in 
the product B1 x B2, A -> B1 x B2, we obtain figures in B1 and 
B2 by composing it with the projections; on the other hand, the 
definition of product syas that any two figures f1 of shape A in 
B1 and f2 of shape A in B2 arise this way from exactly one figure 
of shape A in B1 x B2, which we called <f1, f2>.

For any object X in any category having products there is 
a standard map X -> X x X, namely the one whose components 
are both the identity map 1X. This standard map is often called 
the diagonal map.
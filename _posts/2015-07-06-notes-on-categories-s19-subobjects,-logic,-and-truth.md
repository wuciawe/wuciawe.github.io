---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, subobjects, logic and truth"
---
{% include JB/setup %}

### Subobjects

`Definition:` In any category, a map S ->(i)-> X is an inclusion, or monomorphism, or 
monic map, if it satisfies: For each object T and each pair of maps s1, s2 from T to S 
i◦s1 = i◦s2 implies s1 = s2.

Other names for 'inclusion' or 'inclusion map' are: 'monic map' and 'non-singular map', 
or, especially in sets, 'injective map' and 'one-to-one map'. There is a special notation 
to indicate that a map S ->(i)-> X is an inclusion; instead of writing a plain arrow like 
-> one put a little hook on its tail, so that S c->i-> X indicates that i is an inclusion 
map.

### Truth

In the category of sets the two-element set 2 = {true, false} has the following property; If 
X is a set and S c->i-> X is any subset of X, there is exactly one function phiS: X -> 2 such 
that for all x, x is included in S, i if and only if phiS(x) = true.

Given a part of a set X, say S c->i-> X, its corresponding map X ->phiS-> 2 is called the 
characteristic map of the part S, i, since at least phiS characterizes the points of X that 
are included in the part S, i as those points x such that phiS(x) = true.

Actually, the map phiS does much better than that since this characterization is valid for all 
kinds of figures T ->(x)-> X and not only for points; the only difference is that when T is not 
the terminal set, we need a map trueT from T to 2 rather than the map true: 1 -> 2. The map trueT 
is nothing but the composite of the unique map T -> 1 with true: 1 -> 2.

The fundamental property of the characterisitc map phiS is that for any figure T ->(x)-> X, x is 
included in the part S, i of X if and only if phiS(x) = trueT.

### The true value object

P358 some examples for graphs
---
layout: post
category: [math]
tags: [math, category]
infotext: 'Introdution to Categories, binary operations and diagonal arguments'
---
{% include JB/setup %}

### Binary operations and actions

We will study two cases of mapping a product to an object. The first case 
is that in which the three objects are the same, i.e. maps B x B -> B. Such 
a map is called a binary operation on the object B. The word 'binary' refers 
to the fact that an input of the map consists of two elements of B. (A map 
B x B x B -> B is a ternary operation on B, and unary operations are the same 
as endomaps).

Another case of a mapping with domain a product is a map X x B -> X. Such 
a map is called an action of B on X.

### Cantor's diagonal argument

The most general case of a map whose domain is a product has all three objects 
different: T x X ->(f)-> Y. Again each point 1 ->(x)-> X yields a map T ->(f(-,x))-> Y, 
so that f gives rise to a family of maps T -> Y, one for each point of X, or as 
we often say, a family parameterized by (the points of) X, in this case a family of 
maps T -> Y. In the category of sets for each given pair T, Y of sets, there is 
a set X big enough so that for an appropriate single map f, the maps f(-, x) 
give all maps T -> Y, as x runs through the points of X.

One might think that if T were infinite, we would not need to take X bigger; however 
it is wrong, the famous theorem proved over one hundred years ago by Georg Cantor shows: 
T itself (infinite or not) is essentially never big enough to serve as the domain of 
a parameterization of all maps T -> Y.

`Diagonal Theorem:` (In any category with products) If Y is an object such that 
there exists an object T with enough points to parameterize all the maps T -> Y by 
means of some single map T x T ->(f)-> Y, then Y has the 'fixed point property': every 
endomap Y ->(alpha)-> Y of Y has at least one point 1 ->(y)-> Y for which alpha◦y = y.

`Cantor's Contrapositive Corollary:` If Y is an object known to have at least one endomap 
alpha which has no fixed points, then for every object T and for every attempt f: T x T -> Y 
to parameterize maps T -> Y by points of T, there must be at least one map T -> Y which 
is left out of the family, i.e. does not occur as f(-, x) for any point x in T.
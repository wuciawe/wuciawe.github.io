---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, this post is a review of the concepts of idempotents, involutions and graphs."
---
{% include JB/setup %}

### Involutions

An involution is an endomap that composed with itself gives the identity. The internal diagram of an involution 
consists of some circles of length 2 and some fixed points.

### Idempotents

An idempotent endomap is one that applied twice has the same effect as applied once. This means the image 
of any element is a fixed point or reaches a fixed point in one step.
 
The common feature of involution endomaps and idempotent endomaps is that both of them contain some fixed 
points.

### Automorphisms

An automorphism endomap is an endomap that has an inverse.

### Irreflexive graphs

An irreflexive graph is a pair of maps with the same domain and the same codomain. The domain can be interpreted 
as the set of arrows of the graph, and the codomain as the set of dots, while the maps are interpreted as 
'source' and 'target', i.e. s(x) is the dot that is the source of the arrow x, while t(x) is the target dot 
of the same arrow.

A map in the category of irreflexive graphs is a pair of set maps, one from arrows X to arrows Y, and the 
other from dots P to dots Q. And the pair of set maps should satisfy two conditions, namely, to preserve 
source and to preserve target. The conditions are two equations s'◦fA = fD◦s and t'◦fA = fD◦t.

The composition of two maps f and g is defined as (g◦f)A = gA◦fA and (g◦f)D = gD◦fD, and the following two 
equations should be satisfied: s''◦(g◦f)A = (g◦f)D◦s and t''◦(g◦f)A = (g◦f)D◦t.

### Reflexive graphs

A reflexive graph is the same as an irreflexive graph, but with the additional structure given by a map 
i: P -> X that assigns to each dot a special or 'preferred' arrow that has that dot as source and as target, 
and therefore it is a loop on that dot. In other words, a map i is required to satisfy the equations: 
s◦i = 1P and t◦i = 1P, and therefore i is a section for s as well as for t.

Thus the structure of reflexive graph involves two sets and three structural maps.

The map of the reflexive graphs involves an additional equation compared with that of irreflexive graphs: 
fA◦i = j◦fD.

Composing source and target with their common section i, if we get idempotent maps, say e0 = i◦s and 
e1 = i◦t. Then not only e0 and e1 are the idempotent endomaps of the set of arrows X, but furthermore 
they satisfy the equations: e0◦e1 = e1 and e1◦e0 = e0. More generally, by composing any two of the endomaps 
e0, e1 in any order, the result is always the right-hand one.
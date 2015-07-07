---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, the connected components functor"
---
{% include JB/setup %}

### Connectedness versus discreteness

Besides map spaces and the truth space, another construction that is characterized by a 'higher 
universal mapping property' objectifies the counting of connected components. Reflexive graphs 
and discrete dynamical systems, though very different categories, support this 'same' construction. 
Dots d and d' in a reflexive graph are connected if for some n >= 0 there are dots d = d0, d1, ..., dn = d' and arrows
a1, ..., an such that for each i either the source of ai is d_{i - 1} and the target 
of ai is di or the source of ai is di and the target of ai is d_{i - 1}.

The graph as a whole is connected if it has at least one dot and any two dots in it are connected. 
A given graph connected may involve arbitrarily long chains of elementary connections ai, even though 
the structural operators s, t, i are finite in number.

By contrast, this aspect of steps without limit does not arise in the same way for 
dynamical systems, even though the dynamical systems themselves involve infinitely 
many structural operator alpha^n, effecting evolution of a system for n units of time. 
The states x, y are connected if there are n, m such that alpha^n◦x = alpha^m◦y, and that 
the system if connected if it has at least one state and every two states are connected.

`Definition 1:` A reflexive graph is discrete if it has no arrows other than the degenerate loop at 
each dot. A dynamical system is discrete if all states are rest states.

`Definition 2:` A map X -> pi0◦X  with discrete codomain is universal if for any map X -> S with 
discrete codomain there is exactly one map pi0◦X -> S making a commutative triangle. Such a pi0◦X 
is often called the space of components of X. If 1 ->(i)-> pi0◦X is any point of it, then the inverse 
image Xi c-> X under the universal map is called the i-th connected component of X.

### The points functor parallel to the components functor

`Definition 3:` A map |X| -> X with discrete domain is universal if for every map S -> X with 
discrete domain, there is exactly one S -> |X| making a commutative triangle. This |X| is the 
space of points of X.

### The topos of right actions of a monoid

`Definition 4:` A small monoid is a set M with a given associative multiplication M x M -> M with 
unit 1 -> M. A representation of M, or right action of M on a set X is a given map X x M -> X, denoted 
by juxtaposition, satisfying x(ab) = (xa)b and x1 = x, where we have used juxtaposition ab to denote 
the composition in M and 1 to denote the unit of the monoid.


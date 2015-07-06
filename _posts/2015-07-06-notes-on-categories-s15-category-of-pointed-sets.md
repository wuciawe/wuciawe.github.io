---
layout: post
category: [math]
tags: [math, category]
infotext: 'Introdution to Categories, category of the pointed sets'
---
{% include JB/setup %}

### An example of a non-distributive category

An example of a category that is not distributive is 1/S, the category 
of pointed sets. An object of this category is a set X with a chosen base 
point, or distinguished point, 1 ->(x0)-> X. A map that preserves the structure 
is a map of sets that takes the base point of the domain into the base point of 
the codomain. A map in 1/S from a set X with base point 1 ->(x0)-> X to 
a set Y with base point 1 ->(y0)-> Y is any map of sets X ->(f)-> Y such 
that fx0 = y0. The base point of the domain is mapped to the base point of 
the codomain, while the other points can be mapped to any points of the codomain, 
including the base point.

The terminal object is a set with one element, and the one element is the 
base point. A set with only one point is initial. Thus in this category 0 = 1. 
And the empty set is not an object of this category. Because it doesn't have 
a point to be chosen as base point.

In this category the unique map 0 -> 1 is an isomorphism, and this category has zero 
maps.
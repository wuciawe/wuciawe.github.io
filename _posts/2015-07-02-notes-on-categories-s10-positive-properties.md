---
layout: post
category: [math]
tags: [math, category]
infotext: "Introdution to Categories, maps preserve the positive properties."
---
{% include JB/setup %}

### Positive properties versus Negative properties

One property an element x of X[endomap:alpha] may have is to be a value of alpha. This means that there exists 
an element x' such that x = alpha(x'). This property of x can be called 'acccessibility'. The accessibility 
is preserved by the maps in S[endomap]. This is the positive property.

A negative property of x is not being a fixed point, i.e. alpha(x) =/= x. Negative properties tend not to be 
preserved, but instead they tend to be reflected. To say that a map X[endomap:alpha] ->(f)-> Y[endomap:beta] 
in S[endomap] reflects a property means that if the value of f at x has the property, then x itself has the 
property. In the case of not being a fixed point this means that if f(x) is not a fixed point, then x also 
is not a fixed point.
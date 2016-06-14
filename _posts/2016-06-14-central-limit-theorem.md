---
layout: post
category: [math]
tags: [stat, math]
infotext: 'the definition of the central limit theorem'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

The most important result about sample means is the __Central Limit Theorem__. 
Simply stated, this theorem says that for a large enough sample size \\(n\\), 
the distribution of the sample mean \\(\bar{x}\\) will approach a normal 
distribution. This is true for a sample of independent random variables 
from any population distribution, as long as the population has a finite 
standard deviation \\(\delta\\).

A formal statement of the Central Limit Theorem is the following:

If \\(\bar{x}\\) is the mean of a random sample \\(X_1, X_2, \dots , X_n\\) 
of size \\(n\\) from a distribution with a finite mean \\(\mu\\) and a 
finite positive variance \\(\delta^2\\), then the distribution of 
\\(W = \frac{\bar{x} - \mu}{\frac{\delta}{\sqrt{n}}}\\) is 
\\(\mathcal{N}(0,1)\\) in the limit as \\(n\\) approaches infinity.

This means that the variable \\(\bar{x}\\) is distributed 
\\(\mathcal{N}(\mu, \frac{\delta}{\sqrt{n}})\\).
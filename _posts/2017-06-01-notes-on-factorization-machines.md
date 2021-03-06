---
layout: post
category: [machine learning, math]
tags: [machine learning, math, matrix factorization]
infotext: 'A model gains great success in recommendation system.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

Factorization machines can be viewed as an extension to the linear regression model.

Suppose we have a bunch of features for each user and item, we want to find out the 
rating a user will give to an item. We can build a linear model:

$$
y(\vec x) = \omega_0 + \sum_{i=1}^n \omega_i x_i
$$

The drawback of the above model is that the model only learned the 
effect of features individually rather than in combination. So we supplement the 
linear model with an additional term to model pairwise feature interactions.

$$
y(\vec x) = \omega_0 + \sum_{i=1}^n \omega_i x_i + \sum_{i=1}^n\sum_{j=i+1}^n\omega_{ij}x_ix_j
$$

The \\(\omega\_{ij}\\)s are the factorized interaction parameters.

Now the size of the model is \\(O(n^2)\\), which implies a large amount of memory and 
computation complexity. And the dataset might be too sparse to learn all the weights 
reliably. FM models pairwise feature interactions as the inner product of low dimensional 
vectors, the approach is called `the kernel trick`.

$$
y(\vec x) = \omega_0 + \sum_{i=1}^n \omega_i x_i + \sum_{i=1}^n\sum_{j=i+1}^n<\vec v_i,\vec v_j>x_ix_j
$$

where \\(V \in R^{n\times k}\\). Thus the size of the model becomes \\(O(kn)\\).

But the computation appears to require \\(O(kn^2)\\). By rewriting the nonlinear term:

$$
\sum_{i=1}^n\sum_{j=i+1}^n<\vec v_i,\vec v_j>x_ix_j = \frac{1}{2} \sum_{j=1}^k ((\sum_{i=1}^n v_{ij}x_i)^2 - \sum_{i=1}^n v_{ij}^2x_i^2)
$$

Now we can solve the objective function efficiently with \\(O(kn)\\). The objective 
function with ridge is:

$$
\arg\min\nolimits_\theta \sum_{(\vec x, y) \in S} (y(\vec x) - y)^2 + \sum \lambda \theta_i^2
$$

where \\(\theta_i\\) denotes the parameters \\(\omega_i\\) and \\(v_{ij}\\).

We can easily obtain the optimal with stochastic gradient descent.

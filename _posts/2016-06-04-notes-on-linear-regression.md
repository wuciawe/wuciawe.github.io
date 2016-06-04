---
layout: post
category: [machine learning, math]
tags: [machine learning, math, regression, loss function, linear regression]
infotext: 'A very simple review on linear regression'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Linear regression

Suppose we have a set of data \\(\mathbb{D} = \\{(\boldsymbol{x}\_i, y_i)\\}\_{i = 1}^m\\), where 
\\(\boldsymbol{x}\_i \in \mathbb{R}^n\\) is the feature vector and \\(y_i \in \mathbb{R}^1\\) is the label, 
the regression with hypothesis \\(h_{\boldsymbol{\omega}, b}\\) is like:

$$
h_{\boldsymbol{\omega}, b}(\boldsymbol{x}) = \boldsymbol{\omega}^T \boldsymbol{x^{(i)}} + b
$$

which can be viewed as a mapping from \\(\mathbb{R}^n\\) to \\(\mathbb{R}^1\\).

### Ridge loss

To evaluate the goodness of the mapping, the __ridge loss__ of each element 
\\(\{\boldsymbol{x^{(i)}}, y^{(i)}\}\\) is defined as:

$$
\mathcal{L}^{(i)} = \frac{1}{2}(y^{(i)} - h_{\boldsymbol{\omega}, b}(\boldsymbol{x}^{(i)}))^2 = \frac{1}{2}(y^{(i)} - \boldsymbol{\omega}^T \boldsymbol{x}^{(i)} - b)^2
$$

Let's define \\(\boldsymbol{\theta} = \bigg(\begin{matrix}b\\\\ \boldsymbol{\omega}\end{matrix}\bigg)\\), 
and for each element \\(\{\boldsymbol{x^{(i)}}, y^{(i)}\}\\) we add one dimension to 
\\(\boldsymbol{x^{(i)}}\\) as \\(\bigg(\begin{matrix}1\\\\ \boldsymbol{x}^{(i)}\end{matrix}\bigg)\\), 
then the hypothesis becomes 

$$
h_{\boldsymbol{\theta}}(\boldsymbol{x}) = \boldsymbol{\theta}^T \boldsymbol{x}
$$

and the loss function becomes

$$
\mathcal{L}^{(i)} = \frac{1}{2}(y^{(i)} - \boldsymbol{\theta}^T \boldsymbol{x}^{(i)})^2
$$

And the gradient with respect to \\(\boldsymbol{\theta}\\) is like

$$
\nabla_\boldsymbol{\theta}\mathcal{L}^{(i)} = (y^{(i)} - \boldsymbol{\theta}^T \boldsymbol{x}^{(i)})\boldsymbol{x}^{(i)}
$$

### Regularization

Sometimes in order to reduce the complexity of the model or shrink the dimension of \\(\boldsymbol{\theta}\\), 
we will apply regularization to the loss function as

$$
\mathcal{L}_{\text{total}} = \mathcal{L}_{\text{model}} + \mathcal{L}_{\text{reg}}
$$

### Optimization

We would like to minimize the total loss as:

$$
\min_{\boldsymbol{\theta}}\mathcal{L} = \min_{\boldsymbol{\theta}}(\mathcal{L}_{\text{model}} + \mathcal{L}_{\text{reg}})
$$

This is a unconstrained linear optimization problem which can be easily solved by SGD or L-BFGS.

### Problem with multicollinearity

When the feature vector is not of full rank, we will suffer from the multicollinearity.
---
layout: post
category: [machine learning, math]
tags: [machine learning, math, classification, logistic regression, loss function]
infotext: 'A very simple review on logistic regression'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Logistic regression

Suppose we have a set of data \\(\mathbb{D} = \\{(\boldsymbol{x}\_i, y_i)\\}\_{i = 1}^m\\), where 
\\(\boldsymbol{x}\_i \in \mathbb{R}^n\\) is the feature vector and \\(y_i \in \\{0, 1\\}\\) is the 
label, we first make the hypothesis \\(h_{\boldsymbol{\theta}}\\) as:

$$
h_{\boldsymbol{\theta}}(\boldsymbol{x}) = \boldsymbol{\theta}^T \boldsymbol{x^{(i)}}
$$

where we take the same notation convention as in the 
[previous post]({%post_url 2016-06-04-notes-on-linear-regression%}), and it can be viewed as a 
mapping from \\(\mathbb{R}^n\\) to \\(\mathbb{R}^1\\) as well. But the domain of \\(y\\) is 
\\(\\{0, 1\\}\\). So we further apply the __logistic transform__ to the hypothesis as:

$$
\hat{y} = \frac{1}{1 + \mathrm{e}^{-h_{\boldsymbol{\theta}}(\boldsymbol{x})}}
$$

As a result, when \\(h_{\boldsymbol{\theta}}(\boldsymbol{x}) \ge 0\\), the prediction result is \\(1\\), 
otherwise the prediction result is \\(0\\).

### Logit link function

The logit link function is like:

$$
\pi(\boldsymbol{X}) = P(Y = 1|\boldsymbol{X}) = \frac{\mathrm{e}^{\boldsymbol{\theta}^T\boldsymbol{X}}}{1 + \mathrm{e}^{\boldsymbol{\theta}^T\boldsymbol{X}}}
$$

or, equivalently

$$
\text{logit}[P(Y = 1|\boldsymbol{X})] = \boldsymbol{\theta}^T\boldsymbol{X}
$$

which defines the relationship between the mean of \\(Y\\) and \\(X\\).

And since the \\(Y\\) is bernoulli \\(0 - 1\\), the variance of \\(Y\\) is

$$
\text{Var}(Y) = \pi(\boldsymbol{X})\big(1 - \pi(\boldsymbol{X})\big)
$$

After that, the odds, a quantity to quantify the binary data, is computed as

$$
\text{odds} = \frac{P(Y = 1|\boldsymbol{X})}{P(Y = 0|\boldsymbol{X})}
$$

And here, we have

$$
\log(\text{odds}) = \boldsymbol{\theta}^T\boldsymbol{X}
$$

So \\(\theta_i\\) denotes the contribution of unit increase in \\(\boldsymbol{X}\\) to the \\(\text{odds}\\).

### Logistic loss function

The __Logistic loss function__ is defined as

$$
\mathcal{L}^{(i)} = \log(1 + \mathrm{e}^{-(2y^{(i)} - 1)\boldsymbol{\theta}^T\boldsymbol{x}^{(i)}})
$$

And the gradient function is

$$
\nabla_{\boldsymbol{\theta}}\mathcal{L}^{(i)} = -(2y^{(i)} - 1)\Big(1 - \frac{1}{1 + \mathrm{e}^{-(2y^{(i)} - 1)\boldsymbol{\theta}^T\boldsymbol{x}^{(i)}}}\Big)\boldsymbol{x}^{(i)}
$$

So this optimization can be easily solved by [SGD or L-BFGS]({% post_url 2016-06-06-notes-on-gradient-descent-and-newton-raphson-method %}).

### Maximum Likelihood Estimation

The log-likelihood of the model is like

$$
\begin{align}
\log(\mathcal{l}(\boldsymbol{\theta})) \quad&= \log\bigg(\prod_{i = 1}^m\Big(\frac{\mathrm{e}^{\boldsymbol{\theta}^T\boldsymbol{x}^{(i)}}}{1 + \boldsymbol{\theta}^T\boldsymbol{x}^{(i)}}\Big)^{y^{(i)}}\Big(\frac{1}{1 + \boldsymbol{\theta}^T\boldsymbol{x}^{(i)}}\Big)^{1 - y^{(i)}}\bigg)\\
&= \Big(\sum_{i = 1}^my^{(i)}x^{(i)}\Big)\boldsymbol{\theta} - \sum_{i = 1}^m\log(1 + \mathrm{e}^{\boldsymbol{\theta}^T\boldsymbol{x}^{(i)}})
\end{align}
$$

And the gradient vector \\(\boldsymbol{g}\\) is like:

$$
\boldsymbol{g^{(t)}} = -\boldsymbol{X}^T(\boldsymbol{Y} - \pi^{(t)})
$$

The Hessian matrix is like:

$$
\boldsymbol{H^{(t)}} = \boldsymbol{X}^T\text{diag}[\pi_i^{(t)}(1 - \pi_i^{(t)})]\boldsymbol{X}
$$

By the Newton-Raphson method

$$
\boldsymbol{\theta}^{(t + 1)} = \boldsymbol{\theta}^{(t)} - (\boldsymbol{H}^{(t)})^{-1}\boldsymbol{g}^{(t)}
$$

In Gaussian case, we have

$$
\hat{\boldsymbol{\theta}} = (\boldsymbol{X}^T\boldsymbol{X})^{-1}\boldsymbol{X}^T\boldsymbol{Y}
$$

and

$$
Y \sim \mathcal{N}(\boldsymbol{\theta}^T\boldsymbol{X}, \sigma^2I)
$$

According to the property that the Gaussian vectors remains Gaussian with linear transformation, we have

$$
\hat{\boldsymbol{\theta}} \sim \mathcal{N}(\boldsymbol{\theta}, (\boldsymbol{X}^T\boldsymbol{X})^{-1}\sigma^2)
$$

For logistic regression, \\(\hat{\boldsymbol{\theta}}\\) is not linear in \\(Y\\). However, asymptotically (large \\(m\\)), 
it is Gaussian, and its covariance can be estimated as:

$$
\text{cov}(\hat{\boldsymbol{\theta}}) = (\boldsymbol{X}^T\text{diag}[\pi_i^{(t)}(1 - \pi_i^{(t)})]\boldsymbol{X})^{-1}
$$

The square root elements of \\(\text{cov}(\hat{\boldsymbol{\theta}})\\) is \\(\text{s.e.}(\hat{\boldsymbol{\theta}})\\).

And the confidence interval for \\(\boldsymbol{\theta}\\) is \\([\hat{\boldsymbol{\theta}} - z_{\alpha / 2}\text{s.e.}(\hat{\boldsymbol{\theta}}), \hat{\boldsymbol{\theta}} + z_{\alpha / 2}\text{s.e.}(\hat{\boldsymbol{\theta}})]\\).
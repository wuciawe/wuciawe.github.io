---
layout: post
category: [math]
tags: [math, stat, feature engineering]
infotext: "An introduction to the Box-Cox transformation, and the more generalized Power transformation."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In statistics, a __power transform__ is a family of functions that are applied to create a monotonic 
transformation of data using power functions. This is a useful data transformation technique used to 
stabilize variance, make the data more normal distribution-like, improve the validity of measures of 
association such as the Pearson correlation between variables and for other data stabilization 
procedures.

Let's first have a look at the __Box-Cox transformation__.

### Box-Cox transformation

Assume we have a collection of bivariate data \\(\mathcal{D} = \{x_i, y_i\}\_{i = 1}^n\\), we want to 
explore the relationship between \\(x\\) and \\(y\\). If by selecting \\(\lambda\\) properly, we have 
simple linear relationship in the form

$$
y = b_0 + b_1 x^\lambda
$$

or

$$
y^\lambda = b_0 + b_1 x
$$

Then, we may consider changing the measurement scale for the rest of the statistical analysis. Following 
is the __Tukey's ladder of transformation__:

$$
y = \begin{cases}x^\lambda\quad\text{if}\lambda \gt 0\\\log x\quad\text{if}\lambda = 0\\-x^\lambda\quad\text{if}\lambda \lt 0\end{cases}
$$

The goal is to find a value of λ that makes the scatter diagram of transformed \\(\mathcal{D}\\) as 
linear as possible. One approach might be to fit a straight line to the transformed points and try to 
minimize the residuals. However, an easier approach is based on the fact that the correlation 
coefficient, \\(r\\), is a measure of the linearity of a scatter diagram. In particular, if the 
points fall on a straight line then their correlation will be \\(r = 1\\). (We need not worry about 
the case when \\(r = −1\\) since we have defined the Tukey transformed variable \\(x^\lambda\\) to be 
positively correlated with \\(x\\) itself.)

Later, the __Box-Cox transformation__ was introduced as

$$
x_\lambda = \frac{x^\lambda - 1}{\lambda}
$$

When \\(\lambda \neq 0\\), this formula keeps the order of the transformed data; when \\(\lambda = 0\\), 
with L'Hopital's rule, we have \\(\lim_{\lambda \rightarrow 0}x_\lambda = \log x\\).

We apply the same rule to find the best \\(\lambda\\) as in the Tukey's transformation.

In regression analysis, for the model

$$
y = \beta_0 + \beta_1x_1 + \beta_2x_2 + \dots + \beta_px_p + \epsilon
$$

and the fitted model

$$
\hat{y} = \beta_0 + \beta_1x_1 + \beta_2x_2 + \dots + \beta_px_p
$$

each of the predictor variable \\(x_j\\) can be transformed. The usual criterion is the variance of 
the residuals, given by

$$
\frac{1}{n}\sum_{i = 1}^n(y_i - \hat{y}_i)^2
$$

Occasionally, the response variable \\(y\\) may be transformed. In this case, the variance of the 
residuals is not comparable as the \\(\lambda\\) varies. The transformed response is defined as

$$
y_\lambda = \frac{y^\lambda - 1}{\lambda \bar{g}_y^{\lambda - 1}}
$$

where \\(\bar{g}_y = (\prod\_{i = 1}^ny_i)^{\frac{1}{n}}\\) is the geometric mean of the response 
variable.

When \\(\lambda = 0\\), \\(y_0 = \bar{g}_y\log y\\).

### Power transformation

Here is the definition of power transformation, for data vectors \\((y_1, y_2, \dots, y_n)\\) in which 
each \\(y_i \gt 0\\), the power transformation is

$$
y^{(\lambda)}_i = \begin{cases}\frac{y_i^\lambda - 1}{\lambda(GM(y))^{\lambda - 1}}\quad&\text{if}\lambda \neq 0\\GM(y)\log y_i\quad&\text{if}\lambda = 0\end{cases}
$$

where \\(GM(y) = (y_1 \cdot y_2 \cdot \dots \cdot y_n)^{\frac{1}{n}}\\) is the geometric mean of the 
observations.

Following is from [wiki](https://en.wikipedia.org/wiki/Power_transform){:target='_blank'}, not quite 
understood, especially the part of the definition of Jacobian.

With Jacobian

$$
\mathcal{J}(\lambda; y_1, y_2, \dots, y_n) = \prod_{i = 1}^n|\frac{d y^{(\lambda)}_i}{d y}| = \prod_{i = 1}^n y_i^{\lambda - 1} = GM(y)^{n(\lambda - 1)}
$$

then the normal log-likelihood at the maximum is

$$
\begin{array}
{}\log(\mathcal{L}(\hat{\mu}, \hat{\delta})) &= -\frac{n}{2}(\log(2\pi\hat{\delta}^2) + 1) + n(\lambda - 1)\log(GM(y))\\
&= -\frac{n}{2}(\log\frac{2\pi\hat{\delta}^2}{GM(y)^{2(\lambda - 1)}} + 1)
\end{array}
$$

Absorb \\(GM(y)^{2(\lambda -1)}\\) into the expression for \\(\hat{\sigma}^2\\) produces an 
expression that establishes that minimizing the sum of squares of residuals from \\(y_i^\lambda\\) 
is equivalent to maximizing the sum of the normal log likelihood of deviations from 
\\(\frac{y^\lambda-1}{\lambda}\\) and the log of the Jacobian of the transformation.

The value at \\(y = 1\\) for any \\(\lambda\\) is \\(0\\), and the derivative with respect to \\(y\\) 
there is \\(1\\) for any \\(\lambda\\). Sometimes \\(y\\) is a version of some other variable scaled 
to give \\(y = 1\\) at some sort of average value.

### Reference

[This site](http://onlinestatbook.com/2/transformations/box-cox.html){:target='_blank'} is pretty good for a starter.
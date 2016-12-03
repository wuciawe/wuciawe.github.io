---
layout: post
category: [machine learning, math]
tags: [machine learning, math, regression, loss function, linear regression, regularization]
infotext: 'A simple review on linear regression'
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

### Least Squares Regression

To evaluate the goodness of the mapping, the __squared loss__ of each element 
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
\nabla_\boldsymbol{\theta}\mathcal{L}^{(i)} = (\boldsymbol{\theta}^T \boldsymbol{x}^{(i)} - y^{(i)})\boldsymbol{x}^{(i)}
$$

### Regularization

Sometimes in order to reduce the complexity of the model or shrink the dimension of \\(\boldsymbol{\theta}\\), 
we will apply regularization to the loss function as

$$
\mathcal{L}_{\text{total}} = \mathcal{L}_{\text{model}} + \mathcal{L}_{\text{reg}}
$$

There are three commonly used regularizers: __L2__, __L1__, and __Elastic Net__.

For the parameter \\(\boldsymbol{\theta}\\), the __L2__ regularizer, also known as __ridge loss__, is like:

$$
\mathcal{L}_{\text{reg}} = \frac{1}{2}||\boldsymbol{\theta}||_2^2
$$

And the gradient function is like:

$$
\nabla_\boldsymbol{\theta}\mathcal{L}_{\text{reg}} = \boldsymbol{\theta}
$$

The main usage for __L2__ regularizer is to reduce the model complexity as the __L2__ regularizer is 
apt to add more penalty on those \\(\theta_i\\) with larger value, so as to avoid overfitting.

While, the __L1__ regularizer, the __Lasso__, is like:

$$
\mathcal{L}_{\text{reg}} = ||\boldsymbol{\theta}||_1
$$

And since it's not fully differentiable at every point, we use the sub-gradient function:

$$
\nabla_\boldsymbol{\theta}\mathcal{L}_{\text{reg}} = \text{sign}(\boldsymbol{\theta})
$$

Different from the __L2__ regularizer, the __L1__ regularizer adds more penalty on those \\(\theta_i\\) 
whose value is close to \\(0\\) and is used for feature selection in sparse feature spaces.

The __Elastic Net__ regularizer is the combination of __L2__ and __L1__:

$$
\mathcal{L}_{\text{reg}} = \alpha||\boldsymbol{\theta}||_1 + (1 - \alpha)\frac{1}{2}||\boldsymbol{\theta}||_2^2
$$

As a result, the sub-gradient function is:

$$
\nabla_\boldsymbol{\theta}\mathcal{L}_{\text{reg}} = \alpha\text{sign}(\boldsymbol{\theta}) + (1 - \alpha)\boldsymbol{\theta}
$$

And thanks to the fact that the gradient/sub-gradient is additive, the regularizer is easy to be applied 
in the process of computing optimum in [SGD or L-BFGS]({% post_url 2016-06-06-notes-on-gradient-descent-and-newton-raphson-method %}).

### More on Ridge regression

__Ridge__ is developed based on the idea on constrained minimization:

$$
\begin{align}
\min_\boldsymbol{\theta} \quad& \sum_{i = 1}^m(y^{(i)} - \boldsymbol{\theta}^T\boldsymbol{x}^{(i)})^2\\
s.t. \quad& \sum_{i = 1}^n\theta_i^2 \lt C
\end{align}
$$

And by the __Lagrange Multiplier Method__, the problem can be transformed into following one:

$$
\min_\boldsymbol{\theta} \sum_{i = 1}^m(y^{(i)} - \boldsymbol{\theta}^T\boldsymbol{x}^{(i)})^2 + \lambda_C\sum_{i = 1}^n\theta_i^2
$$

The above problem can also be expressed in matrix notation:

$$
min_\boldsymbol{\theta} (\boldsymbol{Y} - \boldsymbol{X}\boldsymbol{\theta})^T(\boldsymbol{Y} - \boldsymbol{X}\boldsymbol{\theta}) + \lambda\boldsymbol{\theta}^T\boldsymbol{\theta}
$$

And the solution is obtained at the point with zero differential value:

$$
\hat{\boldsymbol{\theta}}_\text{ridge} = (\boldsymbol{X}^T\boldsymbol{X} + \lambda\boldsymbol{I})^{-1}\boldsymbol{X}^T\boldsymbol{Y}
$$

The original least squares solution is unbiased, while the solution of the ridge is biased. On the 
other side, the ridge reduces the variance, which may help reduce the __MSE__, since 
\\(\text{MSE} = \text{Bias}^2 + \text{Variance}\\). And the ridge solution is non-sparse.

### More on Lasso regression

Similar for __Lasso__, instead of Euclidean norm, we use __L1__ norm in the constrained minimization:

$$
\begin{align}
\min_\boldsymbol{\theta} \quad& \sum_{i = 1}^m(y^{(i)} - \boldsymbol{\theta}^T\boldsymbol{x}^{(i)})^2\\
s.t. \quad& \sum_{i = 1}^n|\theta_i| \lt C
\end{align}
$$

And by __Lagrange Multiplier Method__, we get:

$$
\min_\boldsymbol{\theta} \sum_{i = 1}^m(y^{(i)} - \boldsymbol{\theta}^T\boldsymbol{x}^{(i)})^2 + \lambda_C\sum_{i = 1}^n|\theta_i|
$$

Unlike __Ridge__, __Lasso loss function__ is not quadratic, but it's still convex. The solution of __Lasso__ 
is sparse.

### Problem with multicollinearity

When the feature vector is not of full rank, which means some of them are correlated, the linear 
combination of some other features, we will suffer from the multicollinearity. For the least squares 
loss, we can't get the solution via the matrix notation, since the 
\\(\boldsymbol{X}^T\boldsymbol{X}\\) is not invertible. As a result, the value of \\(\boldsymbol{\theta}\\) 
is not identifiable. In this case, we can use __Ridge__ to ensure the intertibility of 
\\(\boldsymbol{X}^T\boldsymbol{X} + \lambda\boldsymbol{I}\\).

### The goodness of the fit of linear regression

In statistics, the coefficient of determination, denoted \\(\mathrm{R}^2\\) or \\(\mathrm{r}^2\\), is 
a number that indicates the proportion of the variance in the dependent variable that is predictable 
from the independent variable.

- For simple linear regression, \\(\mathrm{R}^2\\) is the square of the sample correlation 
\\(r_{xy}\\).
- For multiple linear regression with intercept(which includes simple linear regression), it is 
defined as \\(\mathrm{R}^2 = \frac{\text{SSM}}{\text{SST}}\\).

In either case, \\(\mathrm{R}^2\\) indicates the proportion of variation in the y-variable that 
is due to variation in the x-variables. Many researchers prefer the adjusted \\(\hat{\mathrm{R}}^2\\) 
instead, which is penalized for having a large number of parameters in the model:

$$
\hat{\mathrm{R}}^2 = 1 - \frac{n - 1}{n - p}(1 - \mathrm{R}^2)
$$

As \\(\mathrm{R}^2\\) is defined as \\(1 - \frac{\text{SSE}}{\text{SST}}\\) or 
\\(1 - \mathrm{R}^2 = \frac{\text{SSE}}{\text{SST}}\\). To take into account the number of 
regression parameters \\(p\\), define the adjusted \\(\hat{\mathrm{R}}^2\\) value as

$$
1 - \hat{\mathrm{R}}^2 = \frac{\text{MSE}}{\text{MST}}
$$

where \\(\text{MSE} = \frac{\text{SSE}}{\text{DFE}} = \frac{\text{SSE}}{n-p}\\) and 
\\(\text{MST} = \frac{\text{SST}}{\text{DFT}} = \frac{\text{SST}}{n-1}\\). Thus,

$$
\begin{array}
{}1 - \hat{\mathrm{R}}^2 &= \frac{\frac{\text{SSE}}{n-p}}{\frac{\text{SST}}{n-1}}\\
&= \frac{n - 1}{n - p}\frac{\text{SSE}}{\text{SST}}
\end{array}
$$

so

$$
\begin{array}
{}\hat{\mathrm{R}}^2 &= 1 - \frac{n - 1}{n - p}\frac{\text{SSE}}{\text{SST}}\\
& = 1 - \frac{n - 1}{n - p}(1 - \mathrm{R}^2)
\end{array}
$$

In linear least squares regression with an estimated intercept term, \\(\mathrm{R}^2\\) equals the 
square of the Pearson correlation coefficient between the observed and modeled (predicted) data 
values of the dependent variable. Specifically, \\(\mathrm{R}^2\\) equals the squared Pearson 
correlation coefficient of the dependent and explanatory variable in an univariate linear least 
squares regression.

Under more general modeling conditions, where the predicted values might be generated from a model 
different from linear least squares regression, an R2 value can be calculated as the square of the 
correlation coefficient between the original and modeled data values. In this case, the value is 
not directly a measure of how good the modeled values are, but rather a measure of how good a 
predictor might be constructed from the modeled values (by creating a revised predictor of the 
form \\(\alpha + \beta f_i\\)).

`Note:` here is [the revisit on this topic]({%post_url 2016-09-08-notes-on-regression-revisit%}).

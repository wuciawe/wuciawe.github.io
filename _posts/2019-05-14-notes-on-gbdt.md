---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'why learn gbdt with residual with both regression and classification tasks'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

For more information about trees, see previous posts 
[the Classification And Regression Tree]({% post_url 2016-11-24-notes-on-classification-and-regression-trees %}) and
[ensembles of decision trees]({% post_url 2016-11-25-notes-on-ensembles-of-decision-trees %}).

In this post, I will show the reason of why we use residual as the training target for each subtree in GBDT 
no matter it is regression problem or classification problem.

Suppose the GBDT model is composed of $$K$$ trees

$$
F(x) = \sum_{k=1}^K f_k(x)
$$

- For regression problem, we have $$\hat{y} = F(x)$$.
- For binary classification problem, we have $$P(\hat{y}=1) = \frac{1}{1 + e^{-F(x)}}$$.
- For multi-class classification problem, we have $$P(\hat{y}=m) = \frac{e^{F_m(x)}}{\sum_{i=1}^M e^{F_i(x)}}$$.

And the loss is

$$
\begin{align}
\mathbb{L} &= \sum_{i=1}^n \mathcal{l}(y_i, \hat{y}_i) + \sum_{k=1}^K \mathcal{l}_{reg}(f_k) \\
&= \sum_{i=1}^n \mathcal{loss}(y_i, F(x_i)) + \sum_{k=1}^K \mathcal{l}_{reg}(f_k)
\end{align}
$$

where $$\mathcal{l}_{reg}(f_k)$$ is the regularization of each subtree.

Before we show how to optimize the loss, let's first decompose the GBDT as follows

$$
\begin{align}
F(x)^0 &= 0 \\
F(x)^1 &= f_1(x) = F(x)^0 + f_1(x) \\
F(x)^2 &= f_1(x) + f_2(x) = F(x)^1 + f_2(x) \\
&\vdots \\
F(x)^t &= \sum_{k=1}^t f_k(x) = F(x)^{t-1} + f_t(x) \\
&\vdots \\
F(x) &= \sum_{k=1}^K f_k(x) = F(x)^{K-1} + f_K(x)
\end{align}
$$

The objective function of the $$t$$-th tree is

$$
\begin{align}
\mathbb{L}^t &= \sum_{i=1}^n \mathcal{loss}(y_i, F^t(x_i)) + \sum_{i=1}^t \mathcal{l}_{reg}(f_i) \\
&= \sum_{i=1}^n \mathcal{loss}(y_i, F^{t-1}(x_i) + f_t(x_i)) + \mathcal{l}_{reg}(f_t) + \text{constant}
\end{align}
$$

According to the second-order Taylor polynomial 
$$f(x + \Delta x) \approx f(x) + f'(x)\Delta x + \frac{1}{2}f''(x)\Delta x^2$$, 
we can rewrite the loss function as

$$
\mathbb{L}^t \approx \sum_{i=1}^n[\mathcal{loss}(y_i, F^{t-1}(x_i)) + g_i f_t(x_i) + \frac{1}{2}h_i f_t^2(x_i)] + \mathcal{l}_{reg}(f_t) + \text{constant}
$$

where $$g_i = \partial_{F^{t-1}(x_i)}\mathcal{loss}(y_i, F^{t-1}(x_i))$$, and 
$$h_i = \partial_{F^{t-1}(x_i)}^2 \mathcal{loss}(y_i, F^{t-1}(x_i))$$

To optimise the loss function, we follow the gradient descent method $$\Delta x = -g$$, thus get

$$
f_t(x) = -\eta \partial_{F^{t-1}(x)}\mathcal{loss}(y, F^{t-1}(x))
$$

For regression problem with MSE, we have

$$
\begin{align}
f_t(x) &= -\eta\partial_{F^{t-1}(x)}\mathcal{loss}(y, F^{t-1}(x)) \\
&= -\eta\partial_{F^{t-1}(x)}\left(y - F^{t-1}(x)\right)^2 \\
&= 2\eta(y - F^{t-1}(x))
\end{align}
$$

For binary classification problem with logloss, we have

$$
\begin{align}
f_t(x) &= -\eta\partial_{F^{t-1}(x)}\mathcal{loss}(y, F^{t-1}(x)) \\
&= -\eta\partial_{F^{t-1}(x)}\left( -y\log\hat{y}^{t-1} - (1-y)\log(1-\hat{y}^{t-1}) \right) \\
&= -\eta\partial_{F^{t-1}(x)}\left( -y\log(\frac{1}{1 + e^{-F^{t-1}(x)}}) - (1-y)\log(1-\frac{1}{1 + e^{-F^{t-1}(x)}}) \right) \\
&= -\eta\partial_{F^{t-1}(x)}\left( y\log(1 + e^{-F^{t-1}(x)}) - (1-y)\left(-F^{t-1}(x) - \log(1 + e^{-F^{t-1}(x)})\right) \right) \\
&= -\eta\partial_{F^{t-1}(x)}\left( (1-y)F^{t-1}(x) + \log(1+e^{-F^{t-1}(x)}) \right) \\
&= -\eta\left( (1-y) - \frac{e^{-F^{t-1}(x)}}{1+e^{-F^{t-1}(x)}}  \right) \\
&= \eta\left(y - \frac{1}{1+e^{-F^{t-1}(x)}}\right) \\
&= \eta(y - \hat{y})
\end{align}
$$

For multi-class classification problem with logloss, we have

$$
\begin{align}
f_t(x) &= -\eta\partial_{F^{t-1}(x)}\mathcal{loss}(y, F^{t-1}(x)) \\
&= -\eta\partial_{F^{t-1}(x)} \left(-\sum_{m=1}^M\boldsymbol{1}(y=m)\log\frac{e^{F_m(x)}}{\sum_{i=1}^M e^{F_i(x)}}\right) \\
&= \eta(\boldsymbol{1}(y=m) - \frac{e^{F_m(x)}}{\sum_{i=1}^M e^{F_i(x)}}) \\
&= \eta(y - \hat{y})
\end{align}
$$

As shown above, in all three cases the learning target for each subtree is the residual of 
the label and the prediction of previous ensemble tree.

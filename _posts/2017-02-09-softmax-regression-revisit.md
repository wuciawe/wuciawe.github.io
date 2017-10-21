---
layout: post
category: [machine learning, math]
tags: [machine learning, regression, math]
infotext: "revisit on softmax regression, including derivation in details and hierarchical softmax regression."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In [the previous post]({%post_url 2016-09-08-notes-on-regression-revisit%}), I introduced the model 
inference of the softmax regression. In this revisit post, I will discuss it in more details. The 
softmax regression can be viewed as a generalization of the logistic regression from the binary classification 
problem to the multiclass classification problem.

### Inference on the softmax regression

Suppose we have an \\(m\\) class classification task, with input feature vector \\(\vec x \in \mathbb{R}^n\\), 
we encode the real label a one-hot vector \\(\vec y \in \mathbb{R}^m\\) for each input, which leads to \\(n \times m\\) 
parameters \\(\mathbb{\Omega}\\) in the model.

$$
\vec{\hat{y}} = f(\mathbb{\Omega} \vec x) = \frac{1}{\sum_{i = 1}^m e^{\vec \omega_i \vec x}} 
\begin{bmatrix}
e^{\vec \omega_1 \vec x}\\
e^{\vec \omega_2 \vec x}\\
\vdots\\
e^{\vec \omega_m \vec x}
\end{bmatrix}
=
\begin{bmatrix}
P(y_1 = 1|\vec x, \mathbb{\Omega})\\
P(y_2 = 1|\vec x, \mathbb{\Omega})\\
\vdots\\
P(y_m = 1|\vec x, \mathbb{\Omega})
\end{bmatrix}
$$

where \\(\vec{\hat{y}}\\) is the output of the model, and each element \\(\hat{y}_i\\) in it indicates the 
probability of \\(i^{th}\\) class being the real class given a \\(\vec x\\).

#### Likelihood and loss

Now let's derive the loss function of the softmax regression by first introducing the likelihood function 
\\(\mathbb{L}(\mathbb{\omega} | \vec y, \vec x)\\).

$$
\mathbb{L}(\mathbb{\omega} | \vec y, \vec x) = P(\vec y, \vec x|\mathbb{\omega}) = P(\vec y|\vec x, \mathbb{\omega})P(\vec x|\mathbb{\omega}) = P(\vec y|\vec x, \mathbb{\omega})P(\vec x) \propto P(\vec y|\vec x, \mathbb{\omega})
$$

Further more,

$$
P(\vec y|\vec x, \mathbb{\omega}) = \prod_{i = 1}^m \hat{y}_i^{y_i}
$$

In order to optimize the model, we want to maximize the likelihood of the model, which is equivalent to 
minimizing the negative log-likelihood.

$$
-\log\mathbb{L}(\mathbb{\omega}|\vec y, \vec x) \propto -\log\prod_{i = 1}^m\hat{y}_i^{y_i} = -\sum_{i = 1}^m y_i \log \hat{y}_i
$$

We note that this is the cross entropy error function of the model, which means maximizing the likelihood of 
the model conforms to minimizing the loss of the model.

#### Derivative

Now, let's find the derivative of the loss with respect to parameters.

First, for function \\(\vec y = f(\vec z)\\) where \\(y_i = \frac{e^{z_i}}{\sum_{j = 1}^me^{z_j}}\\), 
the partial derivative of \\(\frac{\partial y_i}{\partial z_j}\\) is:

- For \\(i = j\\), we have

$$
\frac{\partial y_i}{\partial z_i} = \frac{\partial \frac{e^{z_i}}{\sum_{j = 1}^me^{z_j}}}{\partial z_i} = 
\frac{\frac{\partial e^{z_i}}{\partial z_i}\sum_{j = 1}^me^{z_j} - e^{z_i}\frac{\partial \sum_{j = 1}^me^{z_j}}{\partial z_i}}{(\sum_{j = 1}^me^{z_j})^2} = 
\frac{e^{z_i} \sum_{j = 1}^me^{z_j} - e^{z_i}e^{z_i}}{(\sum_{j = 1}^me^{z_j})^2} = 
\frac{e^{z_i}}{\sum_{j = 1}^me^{z_j}} (1 - \frac{e^{z_i}}{\sum_{j = 1}^me^{z_j}}) = 
y_i (1 - y_i)
$$

- For \\(i \neq j\\), we have

$$
\frac{\partial y_i}{\partial z_j} = \frac{\partial \frac{e^{z_i}}{\sum_{j = 1}^me^{z_j}}}{\partial z_j} = 
\frac{\frac{\partial e^{z_i}}{\partial z_j}\sum_{j = 1}^me^{z_j} - e^{z_i}\frac{\partial \sum_{j = 1}^me^{z_j}}{\partial z_j}}{(\sum_{j = 1}^me^{z_j})^2} = 
\frac{- e^{z_i}e^{z_j}}{(\sum_{j = 1}^me^{z_j})^2} = 
- \frac{e^{z_i}}{\sum_{j = 1}^me^{z_j}} \frac{e^{z_j}}{\sum_{j = 1}^me^{z_j}} = 
- y_i y_j
$$

And, we can see that \\(\vec z\\) is just a function of \\(\vec x\\) with the relationship

$$
\vec z = \vec \omega_i \vec x
$$

Then, let's derive the derivatives of the original loss function:

$$
\begin{align}
&{}&&\frac{\partial -\log\mathbb{L}(\mathbb{\omega}|\vec y, \vec x)}{\partial \omega_{jk}} = \frac{\partial -\sum_{i = 1}^m y_i \log \hat{y}_i}{\partial \omega_{jk}}
= -\sum_{i = 1}^m y_i \frac{\partial \log \hat{y}_i}{\partial \omega_{jk}}
= -\sum_{i = 1}^m y_i \frac{1}{\hat{y}_i} \frac{\partial \hat{y}_i}{\partial \omega_{jk}}\\
&{}&=& -( y_j \frac{1}{\hat{y}_j} \frac{\partial \hat{y}_j}{\partial \omega_{jk}} + \sum_{i = 1, i \neq j}^m y_i \frac{1}{\hat{y}_i} \frac{\partial \hat{y}_i}{\partial \omega_{jk}} )
= -( y_j \frac{1}{\hat{y}_j} \frac{\partial \hat{y}_j}{\partial z_j}\frac{\partial z_j}{\partial \omega_{jk}} + \sum_{i = 1, i \neq j}^m y_i \frac{1}{\hat{y}_i} \frac{\partial \hat{y}_i}{\partial z_j}\frac{\partial z_j}{\partial \omega_{jk}} )\\
&{}&=& -( y_j \frac{1}{\hat{y}_j} \hat{y}_j (1 - \hat{y}_j) x_k + \sum_{i = 1, i \neq j}^m y_i \frac{1}{\hat{y}_i} (-\hat{y}_i \hat{y}_j) x_k )
= - (y_j - \sum_{i = 1}^m y_i \hat{y}_j) x_k\\
&{}&=& (\hat{y}_j - y_j)x_k
= (\frac{e^{\vec \omega_j \vec x}}{\sum_{i = 1}^m e^{\vec \omega_i \vec x}} - y_j)x_k
\end{align}
$$

Also note that, we omit the contribution of \\(P(\vec x| \mathbb{\Omega})\\) in the likelihood 
function and in the derivative as well. In a mini-batch gradient descent, it's better to take 
it into consideration?

### The hierarchical softmax

In the above derivation, we can see that in order to calculate the derivative of the loss function with 
respect to the parameters, we need to calculate the value of \\(\sum_{i = 1}^m e^{\vec \omega_i \vec x}\\). 
When the total class number \\(m\\) is large, that step will be computational heavy, as it requires 
\\(|n \times m|\\) multiplications involving all the parameters in the model.

The hierarchical softmax is much cheaper in model training phase with respect to the original softmax with 
large \\(m\\).

Suppose we use a balanced binary tree to construct the hierarchical softmax, where every leaf \\(i\\) represents 
the probability of \\(P(y = i | \vec x)\\), with each node representing the probability 
\\(P(\text{left} | \vec x, \text{context})\\). There are \\(m - 1\\) nodes in the tree, and the 
height of the tree is \\(\log_2 m\\).

Given a \\(y = i\\), the path from root to leaf \\(i\\) is determined, which means that in the calculation 
of the derivative of each \\(y\\), we need to do \\(|n * \log_2 m|\\) multiplications as the contribution 
of the parameters not on the path is zero.

Also note that, the hierarchical softmax only accelerate the process of model training, in prediction phase, 
you still need to calculate the probability of all leaves to find a optimal prediction.

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
we encode the real response a one-hot vector \\(\vec y \in \mathbb{R}^m\\), which leads to \\(n \times m\\) 
parameters \\(\mathbb{\omega}\\) in the model.

$$
\vec \tilde{y} = f(\mathbb{\omega} \vec x) = \frac{1}{\sum_{i = 1}^m \e^{\vec \omega_i \vec x}} 
\begin{bmatrix}
\e^{\vec \omega_1 \vec x}\\
\e^{\vec \omega_2 \vec x}\\
\vdots\\
\e^{\vec \omega_m \vec x}
\end{bmatrix}
=
\begin{bmatrix}
P(y_1 = 1|\vec x, \mathbb{\omega})\\
P(y_2 = 1|\vec x, \mathbb{\omega})\\
\vdots\\
P(y_m = 1|\vec x, \mathbb{\omega})
\end{bmatrix}
$$

where \\(\vec\tilde{y}\\) is the output of the model, and each element \\(y_i\\) in it indicates the 
probability of \\(i^{th}\\) class being the real class given a \\(\vec x\\).

#### Likelihood and loss

Now let's derive the loss function of the softmax regression from introducing the likelihood function 
\\(\mathbb{L}(\mathbb{\omega} | \vec y, \vec x)\\).

$$
\mathbb{L}(\mathbb{\omega} | \vec y, \vec x) = P(\vec y, \vec x|\mathbb{\omega}) = P(\vec y|\vec x, \mathbb{\omega})P(\vec x|\mathbb{\omega})
$$

With some fixed \\(\mathbb{\omega}\\), as the input \\(\vec x\\) is always determined, which implies 
\\(P(\vec x|\mathbb{\omega}) = 1\\), we get

$$
\mathbb{L}(\mathbb{\omega} | \vec y, \vec x) = P(\vec y|\vec x, \mathbb{\omega}) = \prod_{i = 1}^mP(y_i|\vec x, \mathbb{\omega}) =
\prod_{i = 1}^m \tilde{y}_i^{y_i}
$$

In order to optimize the model, we want to maximize the likelihood of the model, which is equivalent to 
minimizing the negative log-likelihood.

$$
-\log\mathbb{L}(\mathbb{\omega}|\vec y, vec x) = -\log\prod_{i = 1}^m\tilde{y}_i^{y_i} = -\sum_{i = 1}^m y_i \log \tilde{y}_i
$$

We note that this is the cross entropy error function of the model, which means maximizing the likelihood of 
the model conforms to minimizing the loss of the model.

#### Derivative

Now, let's find the derivative of the loss with respect to parameters.

First, the derivative of \\(\tilde{y}_i = \frac{\e^{z_i}}{\sum_{j = 1}^m\e^{z_j}}\\) is:

- For \\(i = j\\), we have

$$
\frac{\partial \tilde{y}_i}{\partial z_i} = \frac{\partial \frac{\e^{z_i}}{\sum_{j = 1}^m\e^{z_j}}}{\partial z_i} = 
\frac{\frac{\partial \e^{z_i}}{\partial z_i}\sum_{j = 1}^m\e^{z_j} - \e^{z_i}\frac{\partial \sum_{j = 1}^m\e^{z_j}}{\partial z_i}}{(\sum_{j = 1}^m\e^{z_j})^2} = 
\frac{\e^{z_i} \sum_{j = 1}^m\e^{z_j} - \e^{z_i}\e^{z_i}}{(\sum_{j = 1}^m\e^{z_j})^2} = 
\frac{\e^{z_i}}{\sum_{j = 1}^m\e^{z_j}} (1 - \frac{\e^{z_i}}{\sum_{j = 1}^m\e^{z_j}}) = 
\tilde{y}_i(1 - \tilde{y}_i)
$$

- For \\(i \neq j\\), we have

$$
\frac{\partial \tilde{y}_i}{\partial z_j} = \frac{\partial \frac{\e^{z_i}}{\sum_{j = 1}^m\e^{z_j}}}{\partial z_j} = 
\frac{\frac{\partial \e^{z_i}}{\partial z_j}\sum_{j = 1}^m\e^{z_j} - \e^{z_i}\frac{\partial \sum_{j = 1}^m\e^{z_j}}{\partial z_j}}{(\sum_{j = 1}^m\e^{z_j})^2} = 
\frac{- \e^{z_i}\e^{z_j}}{(\sum_{j = 1}^m\e^{z_j})^2} = 
- \frac{\e^{z_i}}{\sum_{j = 1}^m\e^{z_j}} \frac{\e^{z_j}}{\sum_{j = 1}^m\e^{z_j}} = 
-\tilde{y}_i \tilde{y}_j
$$

We can see that \\(\vec z\\) is just a function of \\(\vec x\\) with the relationship

$$
\vec z = \vec \omega_i \vec x
$$

Then, let's derive the derivative of the original loss function:

$$

$$

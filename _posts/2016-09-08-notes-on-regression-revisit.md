---
layout: post
category: [math]
tags: [machine, regression, math]
infotext: "After revisiting the regressions, I feel having a better view on the implementation details of those regressions."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

This is a revisit on regressions ([linear regression]({%post_url 2016-06-04-notes-on-linear-regression%}), 
[logistic regression]({%post_url 2016-06-05-notes-on-logistic-regression%}), and softmax regression), focused on model inference.

### Linear regression

__Problem__: Given a data instance \\(\mathbb{x} = (x_1, x_2, \cdots, x_n)\\), we want to determine 
the corresponding regression value \\(y\\), with the regression model \\(\mathrm{M}\\) where the 
linear regression weights/coefficients are 
\\(\mathbb{\omega} = (\omega_1, \omega_2, \cdots, \omega_n)\\).

__Prediction formula__: 

$$
\hat{y} = \mathbb{\omega}^T\mathbb{x}
$$

__Cost function__: For each instance \\(i\\) the cost function is: 

$$
\text{cost}^{(i)}(\mathbb{\omega}) = \frac{1}{2}(\mathbb{\omega}^T\mathbb{x}^{(i)} - y^{(i)} )^2
$$

__Total cost function__: 

$$
\text{cost}(\mathbb{\omega}) = \frac{1}{m} \sum_{i = 1}^m \text{cost}^{(i)}(\mathbb{\omega})
$$

In order to obtain a better model, we want to minimize the total cost, as 
\\(\underset{\mathbb{\omega}^*}{\arg\min}\thinspace\text{cost}(\mathbb{\omega})\\).

Though there is closed form solution to this problem, here I'd like to introduce the gradient 
descent method, a iterative way for finding a better model in each iteration.

__Gradient__ of each instance is: 

$$
g^{(i)}(\omega_j) = \frac{\partial{\text{cost}^{(i)}(\mathbb{\omega})}}{\partial{\omega_j}} = (\mathbb{\omega}^T\mathbb{x} - y) x_j
$$

### Logistic regression

__Problem__: Given a data instance \\(\mathbb{x} = (x_1, x_2, \cdots, x_n)\\), we want to do 
binary classification for label \\(y\\) with the regression model \\(\mathrm{M}\\) where the 
logistic regression weights/coefficients are 
\\(\mathbb{\omega} = (\omega_1, \omega_2, \cdots, \omega_n)\\).

__Prediction formula__ for \\( y \in \\{0, 1\\} \\): 

$$
P(Y=y|\mathbb{x}; \mathbb{\omega}) = \frac{1}{1 + \mathrm{e}^{-\mathbb{\omega}^T\mathbb{x}}}
$$

__Prediction formula__ for \\( y \in \\{-1, 1\\} \\): 

$$
P(Y=y|\mathbb{x}; \mathbb{\omega}) = \frac{1}{1 + \mathrm{e}^{-y\mathbb{\omega}^T\mathbb{x}}}
$$

__Cost function__: For each instance when \\( y \in \\{0, 1\\} \\): 

$$
\text{cost}^{(i)} = - \left(y \log \frac{1}{1 + \mathrm{e}^{-\mathbb{\omega}^T\mathbb{x}}} + (1 - y) \log \frac{\mathrm{e}^{\mathbb{\omega}^T\mathbb{x}}}{1 + \mathrm{e}^{-\mathbb{\omega}^T\mathbb{x}}}\right)
$$

__Cost function__: For each instance when \\( y \in \\{-1, 1\\} \\): 

$$
\text{cost}^{(i)}(\mathbb{\omega}) = \log (1 + \mathrm{e}^{-y\mathbb{\omega}^T\mathbb{x}})
$$

__Gradient__ of each instance when \\( y \in \\{0, 1\\} \\): 

$$
g^{(i)}(\omega_j) = \left(\frac{1}{1 + \mathrm{e}^{-\mathbb{\omega}^T\mathbb{x}}} - y\right) x_j
$$

__Gradient__ of each instance when \\( y \in \\{-1, 1\\} \\): 

$$
g^{(i)}(\omega_j) = \frac{-y\mathbb{x_j}}{1 + \mathrm{e}^{-y\mathbb{\omega}^T\mathbb{x}}}
$$

### Softmax regression

__Problem__: Given a data instance \\(\mathbb{x} = (x_1, x_2, \cdots, x_n) \\), we want to do 
multiclass classification for label \\(y\\) with the regression model \\(\mathrm{M}\\) where the 
softmax regression weights/coefficients are \\(\mathbb{\Omega}\\), now it is a matrix instead of 
a vector.

$$
\mathbb{\Omega} =
\begin{bmatrix}
\mathbb{\omega}_1^T\\
\mathbb{\omega}_2^T\\
\vdots\\
 \mathbb{\omega}_K^T
\end{bmatrix}
$$

where each \\(\mathbb{\omega_k} = (\omega_{k1}, \omega_{k2}, \cdots, \omega_{kn})\\).

__Prediction formula__ with \\( y \in \{1, 2, \cdots, K\} \\): 

$$
P(y = k | \mathbb{x}; \mathbb{\Omega}) = \frac{\mathrm{e}^{\mathbb{\omega}_k^T\mathbb{x}}}{\sum_{l = 1}^K \mathrm{e}^{\mathbb{\omega}_l^T\mathbb{x}}}
$$

__Cost function__ for each instance: 

$$
\text{cost}^{(i)}(\mathbb{\omega}) = -\sum_{k = 1}^K \delta\{y, k\}\log\frac{\mathrm{e}^{\mathbb{\omega}_k^T\mathbb{x}}}{\sum_{l = 1}^K\mathrm{e}^{\mathbb{\omega}_l^T\mathbb{x}}}
$$

__Derivative__ of each instance w.r.t each \\(\mathbb{\omega}_k\\) is: 

$$
\nabla_{\mathbb{\omega}_k} = -(\delta\{y, k\} - P(y = k| \mathbb{x}; \mathbb{\Omega}))\mathbb{x}
$$

__Gradient__ of each instance: 

$$
g^{(i)}(\omega_{kj}) =  (P(y = k| \mathbb{x}; \mathbb{\Omega}) - \delta\{y, k\})x_j = \left(\frac{\mathrm{e}^{\mathbb{\omega}_k^T\mathbb{x}}}{\sum_{l = 1}^K\mathrm{e}^{\mathbb{\omega}_k^T\mathbb{x}}} - \delta\{y, k\}\right)x_j
$$

__Special property of parameterization__:

Softmax regression has an unusual property that it has a redundant set of parameters.

Explained as bellow:

Given a softmax model \\(\mathrm{M}\\) with weights \\(\mathbb{\Omega}\\), for each 
\\(\mathbb{\omega}_k\\), we subtract an arbitrary fixed vector \\(\mathbb{\psi}\\)
from it, and so that we get a new model \\(\mathrm{M}'\\) with weights \\(\mathbb{\Omega}'\\). 
Now the prediction becomes:

$$
\begin{align}
P'(y = k | \mathbb{x}; \mathbb{\Omega}') &=& \frac{\mathrm{e}^{(\mathbb{\omega}_k - \mathbb{\psi})^T \mathbb{x}}}{\sum_{l = 1}^K \mathrm{e}^{(\mathbb{\omega}_l - \mathbb{\psi})^T \mathbb{x}}} \\
&=& \frac{\mathrm{e}^{\mathbb{\omega}_k^T \mathbb{x}} \mathrm{e}^{-\mathbb{\psi}^T\mathbb{x}}}{\sum_{l = 1}^K \mathrm{e}^{\mathbb{\omega}_l^T \mathbb{x}} \mathrm{e}^{-\mathbb{\psi}^T\mathbb{x}}}\\
&=&\frac{\mathrm{e}^{\mathbb{\omega}_k^T \mathbb{x}}}{\sum_{l = 1}^K \mathrm{e}^{\mathbb{\omega}_l^T \mathbb{x}}}\\
&=& P(y = k | \mathbb{x}; \mathbb{\Omega})
\end{align}
$$

Subtracting \\(\mathbb{\psi}\\) from every \\(\mathbb{\omega}_k\\) gives us identical prediction 
result, which shows that softmax regression's parameters are redundant, or say, overparameterized. 
It means that for any hypothesis we fit to the data, there are multiple parameter settings that 
give rise to exactly the same hypothesis function mapping from input \\(\mathbb{x}\\) to the 
predictions.

It also means that if the cost function is minimized by 
\\((\mathbb{\omega}_1, \mathbb{\omega}_2, \cdots, \mathbb{\omega}_K)\\), then it is also minimized 
by \\((\mathbb{\omega}_1 - \mathbb{\psi}, \mathbb{\omega}_2 - \mathbb{\psi}, \cdots, \mathbb{\omega}_K - \mathbb{\psi})\\) 
for any value of \\(\mathbb{\psi}\\). (Interestingly, the cost function is still convex, and thus 
gradient descent will not run into local optima problems. But the Hessian is singular, which will 
cause a straightforward implementation of Newton's method to run into numerical problems, thus 
penalty is needed for one reason.)

So we can create \\(K - 1\\) binary logistic regression models by choosing one class as reference 
or pivot.

If the last class \\(K\\) is selected as the reference, then the probability of the reference class 
is: 

$$
P(y = K | \mathbb{x}; \mathbb{\Omega}) = 1 - \sum_{k = 1}^{K - 1}P(y = k | \mathbb{x}; \mathbb{\Omega})
$$

Since the general form of the probability is 

$$
P(y = k | \mathbb{x}; \mathbb{\Omega}) = \frac{\mathrm{e}^{\mathbb{\omega}_k^T\mathbb{x}}}{\sum_{l = 1}^K \mathrm{e}^{\mathbb{\omega}_l^T\mathbb{x}}}
$$

Now, with the class \\(K\\) as the reference class, \\(\omega_K = (0, 0, \cdots, 0)^T\\), we have

$$
\sum_{l = 1}^K \mathrm{e}^{\mathbb{\omega}_l^T\mathbb{x}} = \mathrm{e}^{\mathbb{0}} + \sum_{l = 1}^{K - 1}\mathrm{e}^{\mathbb{\omega}_l^T \mathbb{x}} = 1 + \sum_{l = 1}^{K - 1}\mathrm{e}^{\mathbb{\omega}_l^T \mathbb{x}}
$$

In the end, the prediction formula for class \\(k \lt K\\) becomes: 

$$
P(y = k| \mathbb{x}; \mathbb{\Omega}) = \frac{\mathrm{e}^{\mathbb{\omega}_k^T\mathbb{x}}}{1 + \sum_{l = 1}^{K - 1} \mathrm{e}^{\mathbb{\omega}_l^T \mathbb{x}}}
$$

`Notice:` the choice of reference class is not important in maximum likelihood. With penalised 
maximum likelihood, or bayesian inference, it can often be more useful to leave the probabilities 
over-parameterised, let the penalty choose a way of handing the over-parameterisation. This is 
because most penalty functions/priors are not invariant with respect to the choice of reference 
class.
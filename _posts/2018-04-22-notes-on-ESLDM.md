---
layout: post
category: [math]
tags: [math]
infotext: "reading note/report of The elements of statistical learning Data mining, inference, and prediction"
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### 

Let's consider a case of a quantitative output, and place ourselves 
in the world of random variables and probability spaces. Let 
\\(X \in \mathcal{R}^p\\) denote a real valued input vector, and 
\\(Y \in \mathcal{R}\\) a real valued random output variable, with 
joint distribution \\(\text{Pr}(X,Y)\\). We seek a function 
\\(f(X)\\) for predicting \\(Y\\) given values of the input \\(X\\). 
This theory requires a loss function \\(\mathcal{L}(Y,f(X))\\) for
penalizing errors in prediction, and by far the most common and 
convenient is squared error loss: \\(\mathcal{L}(Y,f(X))=(Y-f(X))^2\\). 
This leads us to a criterion for choosing \\(f\\),

$$
\begin{array}
\text{EPE}(f)&=\mathbb{E}(Y-f(X))^2 \\
&= \int (y-f(x))^2\text{Pr}(d, dy)
$$

the expected (squared) prediction error. By conditioning on \\(X\\), 
we can write \\(\text{EPE}\\) as

$$
\text{EPE}(f)=\mathbb{E}_X\mathbb{E}_{Y|X}([Y-f(X)]^2|X)
$$

and we see that it suffices to minimize \\(\text{EPE}\\) pointwise: 

$$
f(x)=\arg\min_c \mathbb{E}_{Y|X}([Y-c]^2|X=x)
$$

The solution is 

$$
f(x)=\mathbb{E}(Y|X=x)
$$

the conditional expression, also known as the regression function. Thus 
the best prediction of \\(Y\\) at any point \\(X=x\\) is the 
conditional mean, when best is measured by average squared error.

The nearest-neighbor methods attempt to directly implement this 
recipe using the training data. At each point \\(x\\), we might ask 
for the average of all those \\(y_i\\)s with input \\(x_i=x\\). Since 
there is typically at most one observation at any point \\(x\\), we 
settle for 

$$
\hat{f}(x)=\text{Ave}(y_i|x_i \in \text{N}_k(x))
$$

where \\(\text{Ave}\\) denotes average, and \\(\text{N}_k(x)\\) is the 
neighborhood containing the \\(k\\) points in \\(T\\) closest to \\(x\\). 
Two approximations are happening here: 

- expectation is approximated by averaging over sample data
- conditioning at a point is relaxed to conditioning on some region 
close to the target

For large training sample size \\(\text{N}\\), the points in the 
neighborhood are likely to be close to \\(x\\), and as \\(k\\) gets 
large the average will get more stable. In fact, under mild regularity 
conditions on the joint probability distribution \\(\text{Pr}(X,Y)\\), 
one can show that as \\(\text{N}, k \rightarrow \infty\\) such that 
\\(k/\text{N} \rightarrow 0\\), 
\\(\hat{f}(x) \rightarrow \mathbb{E}(Y|X=x)\\).

In light of this, why look further, since it seems we have a universal 
approximator? We often do not have very large samples. If the linear 
or some more structured model is appropriate, then we can usually get 
a more stable estimate than k-nearest neighbors, although such 
knowledge has to be learned from the data as well. There are otehr 
problems though, sometimes disastrous. When the dimension \\(p\\) gets 
large, so does the metric size of the k-nearest neighborhood. So 
settling for nearest neighborhood as a surrogate for conditioning will 
fail us miserably. The convergence above still holds, but the rate of 
convergence decreases as the dimension increases.

How does linear regression fit into this framework? The simplest 
explanation is that one assumes that the regression function 
\\(f(x)\\) is approximately linear in its arguments:

$$
f(x) \approx x^T\beta
$$

This is a model-based approach, we specify a model for the regression 
function. Plugging this linear model for \\(f(x)\\) into 
\\(\text{EPE}\\) and differentiating we can solve for \\(\beta\\) 
theoretically:

$$
\beta = [\mathbb{E}(XX^T)]^{-1}\mathbb{E}(XY)
$$

Note we have not conditioned on \\(X\\); rather we have used our 
knowledge of the functional relationship to pool over values of 
\\(X\\). The least squares solution amounts to replacing the 
expectation by average over the training data.

So both k-nearest neighbors and least squares end up approximating 
conditional expectations by averages. But they differ dramatically 
in terms of model assumptions:

- Least squares assumes \\(f(x)\\) is well approximated by a globally 
linear function.
- k-nearest neighbors assumes \\(f(x)\\) is well approximated by a 
locally constant function.

### Curse of dimensionality

Consider the nearest-neighbor procedure for inputs uniformly 
distributed in a p-dimensionality unit hypercube. Suppose we send out 
a hypercubical neighborhood about a target point to capture a 
fraction \\(r\\) of the observations. Since this corresponds to a 
fraction \\(r\\) of the unit volume, the expected edge length will 
be \\(e_p(r)=r^{1/p}\\). In ten dimensions \\(e_{10}(0.01)=0.63\\) 
and \\(e_{10}(0.1)=0.8\\), while the entire range for each input is 
only \\(1.0\\). So to capture \\(1\%\\) or \\(10\%\\) of the data 
to form a local average, we must cover \\(63\%\\) or \\(80\%\\) of 
the range of each input variable. Such neighborhoods are no longer 
local. Reducing \\(r\\) dramatically does not help much either, 
since the fewer observations we average, the higher is the variance 
of our fit.

Another consequence of the sparse sampling in high dimensions is 
that all sample points are close to an edge of the sample. Consider 
\\(N\\) data points uniformly distributed in a p-dimensional unit 
ball centered at the origin. Suppose we consider a nearest-neighbor 
estimate at the origin. The median distance from the origin to 
the closest data point is given by the expression

$$
d(p, N) = (1 - \frac{1}{2}^{1/N})^{1/p}
$$

Hence most data points are closer to the boundary of the sample 
space than to any other data point. The reason that this presents 
a problem is that prediction is much more difficult near the edges 
of the training sample. One must extrapolate from neighboring 
sample points rather than interpolate between them.

Another manifestation of the curse is that the sampling density is 
proportional to \\(N^{1/p}\\), where \\(p\\) is the dimension of 
the input space and \\(N\\) is the sample size. Thus, if 
\\(N_1=100\\) represents a dense sample for a single input problem, 
then \\(N_{10}=100^{10}\\) is the sample size required for the same 
sampling density with \\(10\\) inputs. Thus in high dimensions all 
feasible training samples sparsely populate the input space.

The complexity of functions of many variables can grow exponentially 
with the dimension, and if we wish to be able to estimate such 
functions with the same accuracy as function in low dimensions, then 
we need the size of our training set to grow exponentially as well.

### Soft thresholding & hard thresholding

Ridge regression does a proportional shrinkage. Lasso translates each 
coefficient by a constant factor \\(\lambda\\), truncating at zero. 
This is called soft thresholding, and is used in the context of 
wavelet-based smoothing. Best-subset selection drops all variables 
with coefficients smaller than the Mth largest; this is a form of 
hard thresholding.

### Smoothing methods

Adaptive wavelet filtering and smoothing spline

### The Bias-Variance Decomposition

If we assume that \\(Y=f(X)+\epsilon\\) where 
\\(\mathbb{E}(\epsilon) = 0\\) and 
\\(\text{Var}(\epsilon)=\sigma_\epsilon^2\\), we can derive an 
expression for the expected prediction error of a regression fit 
\\(\hat{f}(X)\\) at an input point \\(X=x_0\\), using squared-error 
loss: 

$$
\begin{array}
\text{Err}(x_0) &= \mathbb{E}[(Y-\hat{f}_k(x_0))^2|X=x_0]\\
&= \sigma_\epsilon^2 + [\mathbb{E}\hat{f}(x_0) - f(x_0)]^2 + \mathbb{E}[\hat{f}(x_0) - \mathbb{E}\hat{f}(x_0)]^2\\
&= \sigma_\epsilon^2 + \text{Bias}^2(\hat{f}(x_0)) +\text{Var}(\hat{f}(x_0))\\
&= \text{Irreducible Error} + \text{Bias}^2 + \text{Variance}
\end{array}
$$

The first term is the variance of the target around its true mean 
\\(f(x_0)\\), and cannot be avoided no matter how well we estimate 
\\(f(x_0)\\), unless \\(\sigma_\epsilon^2=0\\). The second term is the 
squared bias, the amount by which the average of our estimate differs 
from the true mean. The last term is the variance, the expected 
squared deviation of \\(\hat{f}(x_0)\\) around its mean. Typically 
the more complex we make the model \\(\hat{f}\\), the lower the 
(squared) bias but the higher the variance.

For the k-nearest neighbor regression fit, these expressions have 
the simple form

$$
\begin{array}
\text{Err}(x_0) &= \mathbb{E}[(Y-\hat{f}_k(x_0))^2|X=x_0]\\
&= \sigma_\epsilon^2 + \left[f(x_0)-\frac{1}{k}\sum_{\mathcal{l}=1}^k f(x_{(\mathcal{l})})\right]^2 + \frac{\sigma_\epsilon^2}{k}
\end{array}
$$

Here we assume for simplicity that training inputs \\(x_i\\) are 
fixed, and the randomness arises from the \\(y_i\\). The number of 
neighbors \\(k\\) is inversely related to the model complexity. For 
small \\(k\\), the estimate \\(\hat{f}_k(x)\\) can potentially 
squared difference between \\(f(x_0)\\) and the average of \\(f(x)\\) 
at the k-nearest neighbors will typically increase, while the 
variance decreases.

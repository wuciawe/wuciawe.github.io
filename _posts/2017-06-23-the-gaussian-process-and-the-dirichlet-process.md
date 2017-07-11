---
layout: post
category: [math]
tags: [math, stat]
infotext: 'Of cause, these two random processes are not so much closely related. I just read about them recently.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### The Gaussian Process

We have a training set \\(\mathbb{D}\\) of \\(n\\) obeservations, 
\\(\mathbb{D}=\{(\boldsymbol{x}_i,y_i) | i=1,\cdots,n\}\\), where \\(\boldsymbol{x}\\) dentoes an 
input vector (covariates) of dimension \\(D\\) and \\(y\\) denotes a scalar output or 
target (dependent variable); the columnm vector inputs for all \\(n\\) cases are aggreated in the 
\\(D \times n\\) design matrix \\(X\\), and the targets are collected in the vector \\(\boldsymbol{y}\\), 
so we can write \\(\mathbb{D}=(X,y)\\). In the regression setting the targets are real values. We 
are interested in making inferences about the relationship between inputs and targets, i.e. the 
conditional distribution of the targets given the inputs (but we are not interested in modeling 
the input distribution itself).

Let's review the Bayesian analysis of the standard linear regression model with Gaussian noise

$$
f(\boldsymbol{x}) = \boldsymbol{x}^T\boldsymbol{w}
$$

$$
y = f(\boldsymbol{x}) + \epsilon
$$

where \\(\boldsymbol{x}\\) is the input vector, \\(\boldsymbol{w}\\) is a vector of weights of the 
linear model, \\(f\\) is the function value and \\(y\\) is the observed target value. We have assumed 
that the observed values \\(y\\) differs from the function values \\(f(\boldsymbol{x})\\) by additive 
noise, and we further assume that this noise follows an independent, identically distributioned 
Gaussian distribution with zero mean and variance \\(\sigma_n^2\\)

$$
\epsilon \sim \mathcal{N}(0, \sigma_n^2)
$$

This noise assumption together with the model directly gives rise to the likelihood, the probability 
density of the observations given the parameters, which is factored over cases in the training set to 
give

$$
\begin{align}
p(\boldsymbol{y}|X,\boldsymbol{w}) &= \prod_{i=1}^n p(y_i|\boldsymbol{x}_i, \boldsymbol{w}) = \prod_{i=1}^n \frac{1}{\sqrt{2\pi}\sigma_n} \exp(-\frac{(y_i - \boldsymbol{x}^T\boldsymbol{w})^2}{2\sigma_n^2}) \\
&= \frac{1}{(2\pi\sigma_n^2)^{\frac{n}{2}}} \exp (-\frac{1}{2\sigma_n^2}|\boldsymbol{y} - X^T\boldsymbol{w}|^2) \\
&= \mathcal{N}(X^T\boldsymbol{w}, \sigma_n^2I)
\end{align}
$$

In the Bayesian formalism we need to specify a prior over the parameters, expressing our beliefs about 
the parameters before we look at the observations. We put a zero mean Gaussian prior with covariance 
matrix \\(\Sigma_p\\) on the weights

$$
\boldsymbol{w} \sim \mathcal{N}(\boldsymbol{0}, \Sigma_p)
$$

Inference in the Bayesian linear model is based on the posterior distribution over the weights, 
computed by Bayes' rule

$$
\text{posterior} = \frac{\text{likelihood} \times \text{prior}}{\text{marginal likelihood}}
$$

$$
p(\boldsymbol{w}|\boldsymbol{y},X) = \frac{p(\boldsymbol{y}|X,\boldsymbol{w})}{p(\boldsymbol{y}|X)}
$$

where the normalizing constant, also known as the marginal likelihood, is independent of the weights 
and given by

$$
p(\boldsymbol{y}|X) = \int p(\boldsymbol{y}|X,\boldsymbol{w})p(\boldsymbol{w}) d\boldsymbol{w}
$$

The posterior combines the likelihood and the prior, and captures everything we know about the 
parameters.

$$
\begin{align}
p(\boldsymbol{w}|X,\boldsymbol{y}) & \propto \exp (-\frac{1}{2\sigma_n^2}(\boldsymbol{y} - X^T\boldsymbol{w})^T(\boldsymbol{y} - X^T\boldsymbol{w})) \exp (-\frac{1}{2} \boldsymbol{w}^T\Sigma_p^{-1}\boldsymbol{w})\\
& \propto \exp(-\frac{1}{2}(\boldsymbol{w} - \bar{\boldsymbol{w}})^T(\frac{1}{\sigma_n^2 XX^T + \Sigma_p^{-1}})(\boldsymbol{w} - \bar{\boldsymbol{w}}))
\end{align}
$$

where \\(\bar{\boldsymbol{w}} = \sigma_n^{-2}(\sigma_n^2XX^T + \Sigma_p^{-1})^{-1}X\boldsymbol{y}\\), 
and we recognize the from of the posterior distribution as Gaussian with mean \\(\bar{\boldsymbol{w}}\\) 
and covariance matrix \\(A^{-1}\\)

$$
p(\boldsymbol{w}|X,\boldsymbol{y}) \sim \mathcal{N}(\bar{\boldsymbol{w}} = \frac{1}{\sigma_n^2} A^{-1}X\boldsymbol{y}, A^{-1})
$$

where \\(A = \sigma_n^{-2}XX^T + \Sigma_p^{-1}\\). Notice that for this model (indeed for any Gaussian 
posterior) the mean of the posterior distribution \\(p(\boldsymbol{w}|\boldsymbol{y},X)\\) is also its 
mode, which also called the maximum a posteriori estimate of \\(\boldsymbol{w}\\).

In a non-Baysian setting the negative log prior is sometimes thought of as penalty term, and the 
MAP point is known as the penalized maximum likelihood estimate of the weights, and this may cause some 
confusion between the two approaches. Note that in the Bayesian setting the MAP estimate plays no 
special role. The penalized maximum likelihood procedure is known in this case as ridge regression 
because of the effect of the quadratic penalty term \\(\frac{1}{2}\boldsymbol{w}^T\Sigma_p^{-1}\boldsymbol{w}\\) 
from the log error.

To make predictions for a test case we average over all possible parameter values, weighted by 
their posterior probability. This is in contrast to non-Bayesian schemes, where a single parameter 
is typically chosen by some criterion.

$$
\begin{align}
p(f_*|\boldsymbol{x}_*,X,\boldsymbol{y}) &= \int p(f_*|\boldsymbol{x}_*,\boldsymbol{w})p(\boldsymbol{w}|X,\boldsymbol{y})d\boldsymbol{w} \\
&= \mathcal{N}(\frac{1}{\delta_n^2} \boldsymbol{x}_*^TA^{-1}X\boldsymbol{y}, \boldsymbol{x}_*^TA_{-1}\boldsymbol{x}_*)
\end{align}
$$

The predictive distribution is again Gaussian, with a mean given by the posterior mean of the weights 
multiplied by the test input, as one would expect from symmetry considerations. The predictive variance 
is a quadratic form of the test input with the posterior covariance matrix, showing that the predictive 
uncertainties grow with the magnitude of the test input, as one would expect for a linear model.

#### Projections of Inputs into Feature Space

Let's introduce the function \\(\phi(\boldsymbol{x})\\) which maps a \\(D\\)-dimensional input vector 
\\(\boldsymbol{x}\\) into an \\(N\\) dimensional feature space. Further let the matrix \\(\Phi(X)\\) be 
the aggregation of columns of \\(\phi(\boldsymbol{x})\\) for all cases in the training set. Now the 
model is 

$$
f(\boldsymbol{x}) = \phi(\boldsymbol{x})^T\boldsymbol{w}
$$

where the vector of parameters now has length \\(N\\).

The predictive distribution becomes

$$
f_*|\boldsymbol{x}_*,X,\boldsymbol{y} \sim \mathcal{N}(\frac{1}{\sigma_n^2}\phi(\boldsymbol{x}_*)^TA^{-1}\Phi\boldsymbol{y},\phi(\boldsymbol{x}_*)^TA^{-1}\phi(\boldsymbol{x}_*))
$$

with \\(\Phi = \Phi(X)\\) and \\(A = \delta_n^{-2}\Phi\Phi^T + \Sigma_p^{-1}\\). To make predictions 
using this equation we need to invert the \\(A\\) matrix of size \\(N \times N\\) which may not be 
convenient if \\(N\\) is large. However, we can rewrite as

$$
f_*|\boldsymbol{x}_*,X,\boldsymbol{y} \sim \mathbb{N}(\phi_*^T\Sigma_p\Phi(K + \delta_n^2I)^{-1}\boldsymbol{y}, \phi_*^T\Sigma_p\phi_* - \phi_*^T\Sigma_p\Phi(K+\delta_n^2I)^{-1}\Phi^T\Sigma_*\phi_*)
$$

where we have used the shorthand \\(\phi(\boldsymbol{x}\_\*) = \phi\_\*\\) and defined 
\\(K = \Phi^T\Sigma_p\Phi\\).

To show this for the mean, using the definitions of \\(A\\) and \\(K\\), we have 
\\(\delta_n^{-2}\Phi(K+\delta_n^2I) = \delta_n^{-2}\Phi(\Phi^T\Sigma_p\Phi + \delta_n^2I) = A\Sigma_p\Phi\\). 
Now multiplying through by \\(A^{-1}\\) from left and \\((K+\delta_n^2I)^{-1}\\) from the right gives 
\\(\delta_n^{-2}A^{-1}\Phi = \Sigma_p\Phi(K + \delta_n^2I)^{-1}\\). For the variance we use the 
matrix inversion lemma, setting \\(Z^{-1} = \Sigma_p\\),\\(W^{-1}=\delta_n^2I\\) and \\(V = U = \Phi\\) 
therein. In the new equation we need to invert matrices of size \\(n \times n\\) which is more 
convenient when \\(n < N\\). Geometrically, note that \\(n\\) datapoints can span at most \\(n\\) 
dimensions in the feature space.

##### The matrix inversion lemma, also known as the Woodbury, Sherman & Morrison formula

$$
(Z+UWV^T)^{-1} = Z^{-1} - Z^{-1}U(W^{-1}+V^TZ^{-1}U)^{-1}V^TZ^{-1}
$$

Notice that in the new equation the feature space always enters in the form of \\(\Phi^T\Sigma_p\Phi\\), 
\\(\phi\_\*^T\Sigma_p\Phi\\), or \\(\phi\_\*^T\Sigma_p\phi\_\*\\); thus the entries of these matrices 
are invariably of the form \\(\phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')\\). Let us define 
\\(k(\boldsymbol{x},\boldsymbol{x}') = \phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')\\). We 
call \\(k(\cdot,\cdot)\\) a covariance function or kernel. Notice that \\(\phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')\\) 
is an inner product with respect to \\(\Sigma_p\\). As \\(\Sigma_p\\) is positive definite we can define 
\\(\Sigma_p^{1/2}\\) so that \\((\Sigma_p^{1/2})^2 = \Sigma_p\\); for example if the SVD of \\(Sigma_p = UDU^T\\), 
where \\(D\\) is diagonal, then one form for \\(\Sigma_p^{1/2}\\) is \\(UD^{1/2}U^T\\). Then defining 
\\(\psi(\boldsymbol{x}) = \Sigma_p^{1/2}\phi(\boldsymbol{x})\\) we obtain a simple dot product 
representation \\(k(\boldsymbol{x},\boldsymbol{x}') = \psi(\boldsymbol{x})\cdot\psi(\boldsymbol{x}')\\).

If an algorithm is defined solely in terms of inner products in input space then it can be lifted 
into feature space by replacing occurrences of those inner products by \\(k(\boldsymbol{x},\boldsymbol{x}')\\); 
this is sometimes called the __kernel trick__.

#### Function space view

To use a Gaussian Process to describe a distribution over functions.

A Gaussian Process is a collection of random variables, any finite of which have a joint Gaussian 
distribution.

A Gaussian process is completely specified by its mean funciton and covariance function. We define 
mean function \\(m(\boldsymbol{x})\\) and the covariance function \\(k(\boldsymbol{x},\boldsymbol{x}')\\) 
of a real process \\(f(\boldsymbol{x})\\) as 

$$
m(\boldsymbol{x}) = \mathbb{E}[f(\boldsymbol{x})]
$$

$$
k(\boldsymbol{x},\boldsymbol{x}') = \mathbb{E}[(f(\boldsymbol{x}) - m(\boldsymbol{x}))(f(\boldsymbol{x})') - m(\boldsymbol{x}'))]
$$

and will write the Gaussian process as

$$
f(\boldsymbol{x}) \sim \mathcal{GP}(m(\boldsymbol{x}), k(\boldsymbol{x}, \boldsymbol{x}'))
$$

Here the index set \\(\mathbb{X}\\) is the set of possible inputs, which could be more general, 
\\(\mathbb{R}^D\\). For notational convenience we use the enumeration of the cases in the training 
set to identify the random variables such that \\(f_i = f(\boldsymbol{x}_i)\\) is the random 
variable corresponding to the case \\(\boldsymbol{x}_i, y_i\\) as would be expected.

A Gaussian process is defined as a collection of random variables. Thus, the definition 
automatically implies a consistency requirement, which is also sometimes known as the marginalization 
property. This property simply means that if the GP specifies \\((y_1,y_w) \sim \mathcal{N}(\boldsymbol{\mu}, \Sigma)\\), 
then it must also specify \\(y_1 \sim \mathcal{N}(\mu_1, \Sigma_{11})\\) where \\(\Sigma_{11}\\) is 
the relevant submatrix of \\(\Sigma\\). In other words, examination of a larger set of variables 
does not change the distribution of the smaller set. Notice that the consistency requirement is 
automatically fulfilled if the covariance function specifies entries of the covariance matrix. The 
definition does not exclude Gaussian processes with finite index sets (which would be simply 
Gaussian distributions), but these are not particularly interesting for our purposes.

A simple example of a Guassian process can be obtained from our Bayesian linear regression model 
\\(f(\boldsymbol{x}) = \phi(\boldsymbol{x})^T\boldsymbol{w}\\) with prior 
\\(\boldsymbol{w} \sim \mathcal{N}(\boldsymbol{0}, \Sigma_p)\\). We have for the mean and covariance 

$$
\mathbb{E}[f(\boldsymbol{x})] = \phi(\boldsymbol{x})^T\mathbb{E}[\boldsymbol{w}] = 0
$$

$$
\mathbb{E}[f(\boldsymbol{x})f(\boldsymbol{x}')] = \phi(\boldsymbol{x})^T\mathbb{E}[\boldsymbol{w}\boldsymbol{w}^T]\phi(\boldsymbol{x}') = \phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')
$$

Thus \\(f(\boldsymbol{x})\\) and \\(f(\boldsymbol{x}')\\) are jointly Gaussian with zero mean and 
covariance given by \\(\phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')\\). Indeed, the function 
values \\(f(\boldsymbol{x}_1), \cdots, f(\boldsymbol{x}_n)\\) corresponding to any number of input 
points \\(n\\) are jointly Gaussian, although if \\(N < n\\) then this Gaussian is singular.

The squared exponential covariance function specifies the covariance between pairs of random variables 

$$
\text{cov}(f(\boldsymbol{x}_p), f(\boldsymbol{x}_q)) = k(\boldsymbol{x}_p, \boldsymbol{x}_q) = \exp (-\frac{1}{2}|\boldsymbol{x}_p - \boldsymbol{x}_q|^2)
$$

Note that the covariance between the outputs is written as a function of the inputs. For this 
particular covariance function, we see that the covariance is almost unity between variables whose 
corresponding inputs are very close, and decreases as their distance in the input space increases.

The squared exponential covariance function corresponds to a Bayesian linear regression model with 
an infinite number of basis functions. Indeed for every positive definite covariance function 
\\(k(\cdot, \cdot)\\), there exists a (possibly infinite) expansion in terms of basis functions.

#### prediction using noisy observation

It is typical for more realistic modelling situations that we do not have access to function values 
themselves, but only noisy versions thereof \\(y = f(\boldsymbol{x}) + \epsilon\\). Assuming additive 
independent identically distributed Gaussian noise \\(\epsilon\\) with variance \\(\sigma_n^2\\), the 
prior on the noisy observations becomes

$$
\text{cov}(y_p, y_q) = k(\boldsymbol{x}_p, \boldsymbol{x}_q) + \sigma_n^2\delta_{pq}
$$

or

$$
\text{cov}(\boldsymbol{y}) = K(X, X) + \sigma_n^2 I
$$

where \\(\delta_{pq}\\) is a Kronecker delta which is one iff \\(p = q\\) and zero otherwise. It 
follows from the independence assumption about the noise, that a diagonal matrix is added, in 
comparison to the noise free case. Introducing the noise term we can write the joint distribution 
of the observed target values and function values at the test locations under the  prior as

$$
\begin{bmatrix}\boldsymbol{y} \\ \boldsymbol{f}_*\end{bmatrix} \sim \mathcal{N}\left(\boldsymbol{0}, 
\begin{bmatrix}K(X, X) + \sigma_n^2I & K(X, X_*) \\ K(K_*, X) & K(X_*, K_*)\end{bmatrix}\right)
$$

And we have

$$
\boldsymbol{f}_*|X, \boldsymbol{y}, X_* \sim \mathcal{N}(\bar{\boldsymbol{f}_*}, \text{cov}(\boldsymbol{f}_*))
$$

where 

$$
\bar{\boldsymbol{f}_*} = \mathbb{E}[\boldsymbol{f}_*|X, \boldsymbol{y}, X_*] = K(X_*, X)[K(X, X) + \sigma_n^2I]^{-1}\boldsymbol{y}
$$

$$
\text{cov}(\boldsymbol{f}_*) = K(X_*, X_*) - K(X_*, X)[K(X, X) + \sigma_n^2I]^{-1}K(X, X_*)
$$

For notation simplicity, we take the notation

$$
\bar{f_*} = \boldsymbol{k}_*^T(K + \sigma_n^2I)^{-1}\boldsymbol{y}
$$

$$
\mathbb{V}[f_*] = k(\boldsymbol{x}_*, \boldsymbol{x}_*) - \boldsymbol{k}_*^T(K + \sigma_n^2I)^{-1}\boldsymbol{k}_*
$$

Note that the mean prediction is a linear combination of observations \\(\boldsymbol{y}\\); this is 
sometimes referred to as linear predictor. Another way to look at this equation is to see it as a 
linear combination of \\(n\\) kernel functions, each one centered on a training point, by writing

$$
\bar{f}(\boldsymbol{x}_*) = \sum_{i=1}^n \alpha_i k(\boldsymbol{x}_i, \boldsymbol{x}_*)
$$

where \\(\boldsymbol{\alpha} = (K + \sigma_n^2I)^{-1}\boldsymbol{y}\\).

The variance does not depend on the observed targets, but only on the inputs; this is a property 
of the Gaussian distribution. The variance is the difference between two terms: the first term 
\\(K(X\_\*, X\_\*)\\) is simply the prior covariance; from that is subtracted a (positive) term, 
representing the information the observations gives us about the function. We can compute the 
predictive distribution of test targets \\(\boldsymbol{y}\_\*\\) by adding \\(\sigma_n^2I\\) to the 
variance in the expression for \\(\text{cov}(\boldsymbol{f}\_\*)\\).

The marginal likelihood is the integral of the likelihood times the prior

$$
p(\boldsymbol{y}|X) = \int p(\boldsymbol{y}|\boldsymbol{f}, X)p(\boldsymbol{f}|X)d\boldsymbol{f}
$$

The term merginal likelihood refers to the marginalization over the function values \\(\boldsymbol{f}\\). 
Under the Gaussian process model the prior is Gaussian, \\(\boldsymbol{f}|X \sim \mathcal{N}(\boldsymbol{0}, K)\\), or 

$$
\log p(\boldsymbol{f}|X) = -\frac{1}{2} \boldsymbol{f}^TK^{-1}\boldsymbol{f} - \frac{1}{2}\log|K| - \frac{n}{2}\log 2\pi
$$

and the likelihood is a factorized Gaussian \\(\boldsymbol{y}|\boldsymbol{f} \sim \mathcal{N}(\boldsymbol{f}, \sigma_n^2I)\\) so 
we have the log marginal likelihood

$$
\log p(\boldsymbol{y}|X) = -\frac{1}{2}\boldsymbol{y}^T(K+\sigma_n^2I)^{-1}\boldsymbol{y} - \frac{1}{2}\log|K+\sigma_n^2I| - \frac{n}{2}\log 2\pi
$$

This result can also be obtained directly by observing that \\(\boldsymbol{y} \sim \mathcal{N}(\boldsymbol{0}, K+\sigma_n^2I)\\).

In practical applications, we are often forced to make a decision about how to act, i.e. we need a 
point-like prediction which is optimal in some sense. To this end, we need a loss function 
\\(\mathcal{L}(y_{\text{true}}, y_{\text{guess}})\\), which specifies the loss incurred by guessing the value 
\\(y_{\text{guess}}\\) when the true value is \\(y_{\text{true}}\\).

Notice that we computed the predictive distribution with out reference to the loss function. In non-Bayesian 
paradigms, the model is typically trained by minimizing the empirical risk (or loss). In contrast, in the 
Bayesian setting there is a clear separation between the likelihood function (used for training, in 
addition to the prior) and the loss function. The likelihood function describes how the noisy measurements 
are assumed to deviate from the underlying noisefree function. The loss function, on the other hand, 
captures the consequences of making a specific choice, given an actual true state. The likelihoood and loss 
function need not have anything in common.

We minimize the expected loss or risk, by averaging w.r.t. our model's opinion as to what the truth might be 

$$
\tilde{R}_{\mathcal{L}}(y_{\text{guess}}|\boldsymbol{x}_*) = \int \mathcal{L}(y_*, y_{\text{guess}}) p(y_*|\boldsymbol{x}_*, \mathbb{D}) dy_*
$$

Thus our best guess, in the sense that it minimizes the expected loss, is

$$
y_{\text{optimal}}|\boldsymbol{x}_* = \arg\min_{y_{\text{guess}}} \tilde{R}_{\mathcal{L}}(y_{\text{guess}}|\boldsymbol{x}_*)
$$

In general the value of \\(y_{\text{guess}}\\) that minimizes the risk for loss function 
\\(|y_{\text{guess}} - y\_\*|\\) is the median of \\(p(y\_\*|\boldsymbol{x}\_\*, \mathbb{D})\\), while 
for the squared loss \\((y_{\text{guess}} - y\_\*)^2\\) it is the mean of this distribution. When the 
predictive distribution is Gaussian the mean and the median coincide, and indeed for any symmetric 
loss function and symmetric predictive distribution we always get \\(y_{\text{guess}}\\) as the 
mean of the predictive distribution.

#### Generate samples

To generate samples \\(\boldsymbol{x} \sim \mathcal{N}(\boldsymbol{m}, K)\\) with arbitrary mean 
\\(\boldsymbol{m}\\) and covariance matrix \\(K\\) using a scalar Gaussian generator we proceed as 
follows: first compute the Cholesky decomposition (also known as the matrix square root) \\(L\\) of 
the positive definite symmetric covariance matrix \\(K = LL^T\\), where \\(L\\) is a lower triangular 
matrix. Then generate \\(\boldsymbol{u} \sim \mathcal{N}(\boldsymbol{0}, I)\\) by multiple separate 
calls to the scalar Gaussian generator. Compute \\(\boldsymbol{x} = \boldsymbol{m} + L\boldsymbol{u}\\), 
which has the desired distribution with mean \\(\boldsymbol{m}\\) and covariance 
\\(L\mathbb{E}[\boldsymbol{u}\boldsymbol{u}^T]L^T = LL^T = K\\) (by the independence of the 
elements of \\(\boldsymbol{u}\\).

In practice it may be necessary to add a small multiple of the identity matrix \\(\epsilon I\\) to the 
covariance matrix for numerical reasons. This is because the eigenvalues of the matrix \\(K\\) can 
decay very rapidly and without this stabilization the Cholesky independent noise of variance 
\\(\epsilon\\). From the context \\(\epsilon\\) can usually be chosen to have inconsequential effects 
on the samples, while ensuring numerical stability.

###

Dirichlet processes are a class of Bayesian nonparametric models. Dirichlet processes are used for: 
density estimation, semiparametric modelling, and sidestepping model selection/averaging.

#### Function Estimation

Parametric function estimation (regression, classification)

Data: \\(\boldsymbol{x} = \{x_1, x_2, \cdots\}\\), \\(\boldsymbol{y} = \{y_1, y_2, \cdots\}\\)

Model: \\(y_i = f(x_i | w) + \mathcal{N}(0, \sigma^2)\\)

prior over parameters \\(p(w)\\)

posterior over parameters \\(p(w | \boldsymbol{x}, \boldsymbol{y}) = \frac{p(w)p(\boldsymbol{y}|\boldsymbol{x}, w)}{p(\boldsymbol{y} | \boldsymbol{x})}\\)

prediction with posteriors \\(p(y_\* | x_\*, \boldsymbol{x}, \boldsymbol{y}) = \int p(y_\* | x_\*, w)p(w | \boldsymbol{x}, \boldsymbol{y}) dw\\)

Bayesian nonparametric function estimation with Gaussian processes

Data: \\(\boldsymbol{x} = \{x_1, x_2, \cdots\}\\), \\(\boldsymbol{y}=\{y_1,y_2,\cdots\}\\)

Model: \\(y_i = f(x_i) + \mathcal{N}(0, \sigma^2)\\)

Prior over functions \\(f \sim \mathcal{GP}(\mu, \Sigma)\\)

Posterior over functions \\(p(f | \boldsymbol{x}, \boldsymbol{y}) = \frac{p(f)p(\boldsymbol{y}|\boldsymbol{x}, f)}{p(\boldsymbol{y}|\boldsymbol{x})}

Prediction with posteriors \\(p(y_\*|x_\*,\boldsymbol{x},\boldsymbol{y}) = \int p(y_\*|x_\*, f)p(f|\boldsymbol{x},\boldsymbol{y}) df\\)

#### Density Estimation

Parametric density estimation (Gaussian, mixture models)

Data: \\(\boldsymbol{x} = \{x_1, x_2, \cdots\}\\)

Model: \\(x_i | w \sim F(\cdot | w)\\)

Prior over parameters \\(p(w)\\)

Posterior over parameters \\(p(w|\boldsymbol{x}) = \frac{p(w)p(\boldsymbol{x}|w)}{p(\boldsymbol{x})}\\)

Prediction with posteriors \\(p(x_\* | \boldsymbol{x}) = \int p(x_\*|w)p(w|\boldsymbol{x}) dw\\)

Bayesian nonparametric density estimation with Dirichlet processes

Data: \\(\boldsymbol{x} = \{x_1, x_2, \cdots\}\\)

Model: \\(x_i \sim F\\)

Prior over distributions \\(F \sim \mathcal{DP}(\alpha, H)\\)

Posterior over distributions \\(p(F|\boldsymbol{x})=\frac{p(F)p(\boldsymbol{x}|F)}{p(\boldsymbol{x})}\\)

Prediction with posteriors \\(p(x_\*|\boldsymbol{x}) = \in p(x_\*|F)p(F|\boldsymbol{x}) dF = \int F'(x_\*)p(F|\boldsymbol{x}) dF\\)

#### Semiparametric Modelling

Linear regression model for inferring effectiveness of new medical treatments.

$$
y_{ij} = \beta^Tx_{ij} + b_i^Tz_{ij} + \epsilon_{ij}
$$

where \\(y_{ij}\\) is outcome of \\(i\\)th subject, \\(x_{ij}\\),\\(z_{ij}\\) are predictors, \\(\beta\\) are 
fixed-effects coefficients, \\(b_i\\) are random-effects subject-specific coefficients, \\(\epsilon_{ij}\\) 
are noise terms.

Care about inferring \\(\beta\\). If \\(x_{ij}\\) is treatment, we want to determine \\(p(\beta > 0|\boldsymbol{x}, \boldsymbol{y})\\).

Usually we assume Gaussian noise \\(\epsilon_{ij} \sim \mathcal{GP}(0, \sigma^2)\\). Is this a sensible prior? 
Over-dispersion, skewness, etc. May be better to model 
noise nonparametrically:

$$
\epsilon_{ij} \sim F
$$

$$
F \sim \mathcal{DP}
$$

Also possible to model subject-specific random effects nonparametrically:

$$
b_i \sim G
$$

$$
G \sim \mathcal{DP}
$$

#### Model Selection / Averaging

Data: \\(\boldsymbol{x} = \{x_1, x_2, \cdots\}\\)

Models: \\(p(\theta_k|M_k)\\), \\(p(\boldsymbol{x}|\theta_k, M_k)\\)

Marginal likelihood \\(p(\boldsymbol{x}|M_k) = \int p(\boldsymbol{x}|\theta_k,M_k)p(\theta_k|M_k) d\theta_k\\)

Model selection \\(M = \arg\max_{M_k} p(\boldsymbol{x}|M_k)\\)

Model averaging \\(p(x_\*|\boldsymbol{x}) = \sum_{M_k} p(x_\*|M_k)p(M_k|\boldsymbol{x}) = \sum_{M_k}p(x_\*|M_k)\frac{p(\boldsymbol{x}|M_k)p(M_k)}{p(\boldsymbol{x})}\\)

Marginal likelihood is usually extremely hard to compute

$$
p(\boldsymbol{x}|M_k) = \int p(\boldsymbol{x}|\theta_k,M_k)p(\theta_k|M_k) d\theta_k
$$

Model selection/averaging is to prevent underfitting and overfitting. Use a really large model \\(M_\infty\\) 
instead, and let the data spreak for themselves.

#### Gaussian Processes

A Gaussian process is a distribution over functions \\(f: \mathbb{X} \mapsto \mathbb{R}\\)

Denote \\(f \sim \mathcal{Gp}\\) if \\(f\\) is a \\(\mathcal{GP}\\)-distributed random function.

For any finite set of input points \\(x_1, \cdots, x_n\\), we require \\((f(x_1), \cdots, f(x_n))\\) to be 
a multivariate Gaussian. The \\(\mathcal{GP}\\) is parametrized by its mean \\(m(x)\\) and covariance 
\\(c(x, y)\\) functions.

#### Dirichlet Processes

#### Dirichlet Distributions

A Dirichlet distribution is a distribution over the \\(K\\)-dimensional probability simplex:

$$
\Delta_K = \{(\pi_1, \cdots, \pi_K): \pi_k \geq 0, \Sigma_k \pi_k = 1\}
$$

We say \\((\pi_1, \cdots, \pi_K)\\) is Dirichlet distributed, \\((\pi_1, \cdots, \pi_K) \sim \text{Dirichlect}(\alpha_1, \cdots, \alpha_K)\\) with parameters \\((\alpha_1, \cdots, \alpha_k)\\), if

$$
p(\pi_1, \cdots, \pi_K) = \frac{\Gamma(\sum_k \alpha_k)}{\prod_k \Gamma(\alpha_k)}\prod_{k=1}^n \pi_k^{\alpha_k - 1}
$$

Combining entries of probability vectors preserves Dirichlet property, for example:

$$
(\pi_1, \cdots, \pi_K) \sim \text{Dirichlet}(\alpha_1, \cdots, \alpha_K)\\
\Rightarrow (\pi_1 + \pi_2, \pi_3, \cdots, \pi_K) \sim \text{Dirichlet}(\alpha_1 + \alpha_2, \alpha_3, \cdots, \alpha_K)
$$

Generally, if \\((I_1, \cdots, I_j)\\) is a partition of \\((1, \cdots, n)\\):

$$
\left(\sum_{i \in I_1}\pi_i, \cdots, \sum_{i \in I_j}\pi_i\right) \sim \text{Dirichlet}\left(\sum_{i \in I_1}\alpha_i, \cdots, \sum_{i \in I_j} \alpha_i\right)
$$

The converse of the agglomerative property is also true, for example if:

$$
(\pi_1, \cdots, \pi_K) \sim \text{Dirichlet}(\alpha_1, \cdots, \alpha_K)\\
(\tau_1, \tau_2) \sim \text{Dirichlet}(\alpha_1\beta_1, \alpha_1\beta_2)\\
\text{with } \beta_1 + \beta_2 = 1\\
\Rightarrow (\pi_1\tau_1, \pi_1\tau_2, \pi_2, \cdots, \pi_K) \sim \text{Dirichlet}(\alpha_1\beta_1, \alpha_2\beta_2, \alpha_2, \cdots, \alpha_K)
$$

#### Dirichlet Processes

A Dirichlet process is an infinitely decimated Dirichlet distribution:

$$
1 \sim \text{Dirichlet}(\alpha)\\
(\pi_1, \pi_2) \sim \text{Dirichlet}(\alpha/2, \alpha/2) \qquad \pi_1 + \pi_2 = 1\\
(\pi_{11}, \pi_{12}, \pi_{21}, \pi_{22}) \sim \text{Dirichlet}(\alpha/4, \alpha/4, \alpha/4, \alpha/4) \qquad \pi_{i1} + \pi_{i2} = \pi_i
$$

Each decimation step involves drawing from a Beta distribution and multiplying into the relevant entry.

A probability measure is a function from subsets of a space \\(\mathbb{X}\\) to \\(\[0,1\]\\) satisfying 
certain properties. A Dirichlet Process is a distribution over probability measures. Denote 
\\(G \sim \mathcal{DP}\\) if \\(G\\) is a \\(\mathcal{DP}\\)-distributed random probability measure. For 
any finite set of partitions \\(A_1 \dot{\cup} \cdots \dot{\cup} A_K = \mathbb{X}\\), we require 
\\((G(A_1), \cdots, G(A_K))\\) to be Dirichlet distributed.

A \\(\mathcal{DP}\\) has two parameters:

- Base distribution \\(H\\), which is like the mean of the \\(\mathcal{DP}\\)
- Strength parameter \\(\alpha\\), which is like an inverse-variance of the \\(\mathcal{DP}\\).

We write: \\(G \sim \mathcal{DP}(\alpha, H)\\)

if for any partition \\((A_1, \cdots, A_K)\\) of \\(\mathbb{X}\\): \\(G(A_1), \cdots, G(A_K)) \sim \text{Dirichlet}(\alpha H(A_1), \cdots, \alhpa H(A_K))\\)

The first two ocumulants of the \\(\mathcal{DP}\\): 

- Expectation: \\(\mathbb{E}[G(A)] = H(A)\\)
- Variance: \\(\mathbb{V}[G(A)] = \frac{H(A)(1-H(A))}{\alhpa+1}\\)

where \\(A\\) is any measurable subset of \\(\mathbb{X}\\).

Suppose \\(G\\) is Dirichlet process distributed: \\(G \sim \mathcal{DP}(\alpha, H)\\), \\(G\\) is a 
(random) probability measure over \\(\mathbb{X}\\). We can treat it as a distribution over \\(\mathbb{X}\\). 
Let \\(\theta \sim G\\) be a random variable with distribution \\(G\\). We are interested in:

$$
p(\theta) = \int p(\theta|G)p(G) dG
$$

$$
p(G|\theta) = \frac{p(\theta|G)p(G)}{p(\theta)}
$$

Consider:

$$
(\pi_1, \cdots, \pi_K) \sim \text{Dirichlet}(\alpha_1, \cdots, \alpha_K)
$$

$$
z|(\pi_1, \cdots, \pi_K) \sim \text{Dirichlet}(\pi_1, \cdots, \pi_K)
$$

\\(z\\) is a multinomial variate, taking on value \\(i \in \{1, \cdots, n\}\\) with probability \\(\pi_i\\).

Then:

$$
z \sim \text{Discrete}(\frac{\alpha1}{\sum_i \alpha_i}, \cdots, \frac{\alpha_K}{\sum_i \alpha_i})
$$

$$
(\pi_1, \cdots, \pi_K) | z \sim \text{Dirichlet}(\alpha_1 + \delta_1(z), \cdots, \alpha_K + \delta_K(z))
$$

where \\(\delta_i(z)=1\\) if \\(z\\) takes on value \\(i\\), \\(0\\) otherwise.

Converse also true.

Fix a partition \\((A_1, \cdots, A_K)\\) of \\(\mathbb{X}\\). Then 

$$
(G(A_1), \cdots, G(A_K)) \sim \text{Dirichlet}(\alpha H(A_1), \cdots, \alpha H(A_K))
$$

$$
P(\theta \in A_i | G) = G(A_i)
$$

Using Dirichlet-multinomial conjugacy, 

$$
P(\theta \in A_i) = H(A_i)
$$

$$
(G(A_1), \cdots, G(A_K)) | \theta \sim \text{Dirichlet}(\alpha H(A_1) + \delta_\theta(A_1), \cdots, \alpha H(A_K) + \delta_\theta (A_K))
$$

The above is true for every finite partition of \\(\mathbb{X}\\). In particular, taking a really fine 
partition, \\(p(\theta)d\theta = H(d\theta)\\). Also, the posterior \\(G|\theta\\) is also a Dirichlet 
process: \\(G|\theta \sim \mathcal{DP}(\alpha+1, \frac{\alpha H + \delta_\theta}{\alpha + 1})\\)

##### Blackwell-MacQueen Urn Scheme

Blackwell-MacQueen urn scheme produces a sequence \\(\theta_1, \theta_2, \cdots\\) with the following 
conditions: \\(\theta_n|\theta_{1:n-1} \sim \frac{\alpha H + \sum_{i=1}^{n-1}\delta_{\theta_i}}{\alpha + n -1}\\).

Picking balls of different colors from an urn:

- Start with no balls in the urn
- with probability \\(\propto \alpha\\), draw \\(\theta_n \sim H\\), and add a ball of that color into the urn
- with probability \\(\propto n - 1\\), pick a ball at random from the urn, record \\(\theta_n\\) to be its 
color, return the ball into the urn and place a second ball of same color into urn.

Blackwell-MacQueen urn scheme is like a representer for the \\(\mathcal{DP}\\) - a finite projection of an 
infinite object.

##### Exchangeability and de Finetti's Theorem

Starting with a \\(\mathcal{DP}\\), we constructed Blackwell-MacQueen urn scheme. The reverse is possible 
using de Finetti's Theorem. Since \\(\theta_i\\) are \\(iid \sim G\\), their joint distribution is invariant 
to permutations, thus \\(\theta_1, \theta_2, \cdots\\) are exchangeable. Thus a distribution over measures 
must exist making them \\(iid\\). This is the \\(\mathcal{DP}\\).

##### Chinese Restaurant Process

Draw \\(\theta_1, \cdots, \theta_n\\) from a Blackwell-MacQueen urn scheme. They take on \\(K < n\\) 
distinct values, say \\(\theta_1^\*, \cdots, \theta_K^\*\\). This defines a partition of \\(1, \cdots, n\\) 
into \\(K\\) clusters, such that if \\(i\\) is in cluster \\(k\\), then \\(\theta_i = \theta_k^\*\\). Random 
draws \\(\theta_1, \cdots, \theta_n\\) from a Blackwell-MacQueen urn scheme induces a random partition 
\\(1, \cdots, n\\). The induced distribution over partitions is a Chinese Restaurant Process.

- Generating from the CRP:
  - First customer sits at the first table
  - Customer \\(n\\) sits at:
    - Table \\(k\\) with probability \\(\frac{n_k}{\alpha + n - 1}\\) where \\(n_k\\) is the number of 
    customers at table \\(k\\)
    - A new table \\(K + 1\\) with probability \\(\frac{\alpha}{\alpha + n - 1}\\)
  - Customers \\(\Rightarrow\\) integers, tables \\(\Rightarrow\\) clusters
- The CRP exhibits the clustering property of the \\(\mathcal{DP}\\)

To get back from the CRP to Blackwell-MacQueen urn scheme, simply draw \\(\theta_k^\* \sim H\\) for 
\\(k=1, \cdots, K\\), then for \\(i = 1, \cdots, n\\) set \\(\theta_i = \theta_{z_i}^\*\\) where 
\\(z_i\\) is the table that customer \\(i\\) sat at.

##### Stick-breaking Construction

Returning to the posterior process:

$$
G \sim \mathcal{DP}(\alpha,H) \Leftrightarrow \theta \sim H \\
\theta|G \sim G \Leftrightarrow G|\theta \sim \mathcal{DP}(\alpha + 1, \frac{\alpha H + \delta_\theta}{\alpha + 1})
$$

Consider a partition \\((\theta, \mathbb{X}\\theta\\) of \\(\mathbb{X}\\). We have

$$
\begin{aligh}
(G(\theta), G(\mathbb{X}\\theta)) &\sim \text{Dirichlet}((\alpha+1)\frac{\alpha H + \delta_\theta}{\alpha + 1}(\theta), (\alpha+1)\frac{\alpha H + \delta_\theta}{\alpha + 1} (\mathbb{X}\\theta))\\
&=\text{Dirichlet}(1, \alpha)
\end{align}
$$

\\(G\\) has a point mass located at \\(\theta\\): \\(G=\beta \delta_\theta + (1 - \beta)G'\\) with 
\\(\beta \sim \text{Beta}(1, \alpha)\\) and \\(G'\\) is the (renormalized) probability measure with the 
point mass removed.

Consider a further paritition \\((\theta, A_1, \cdots, A_K)\\) of \\(\mathbb{X}\\):

$$
(G(\theta), G(A_1), \cdots, G(A_K)) = (\beta, (1 - \beta)G'(A_1), \cdots, (1 - \beta)G'(A_K)) \sim \text{Dirichlect}(1, alpha H(A_1), \cdots, \alpha H(A_K))
$$

The agglomerative/decimative property of Dirichlet implies:

$$
(G'(A_1), \cdots, G'(A_K)) \sim \text{Dirichlet}(\alpha H(A_1), \cdots, \alpha H(A_K))\\
G' \sim \mathcal{DP}(\alhpa, H)
$$

We have:

$$
G \sim \mathcal{DP}(\alpha,H)\\
G=\beta_1\delta_{\theta_1^\*} + (1-\beta_1)G_1\\
G=\beta_1\delta_{\theta_1^\*} + (1-\beta_1)(\beta_2\delta_{\theta_2^\*} + (1 - \beta_2)G_2)\\
\vdots\\
G=\sum_{k=1}^\infty \pi_k\delta_{\theta_k^\*}
$$

where \\(\pi_k = \beta_k\prod_{i=1}^{k-1}(1-\beta_1)\\), \\(\beta_k \sim \text{Beta}(1,\alpha)\\), 
\\(\theta_k^\* \sim H\\).

This is the stick-breaking construction.

##### Density Estimation

Recall the approach to density estimation with Dirichlet process:

$$
G \sim \mathcal{DP}(\alpha, H)\\
x_i \sim G
$$

The problem is that \\(G\\) is a discrete distribution; inparticular it has no density. To solve this, 
convole the \\(\mathcal{DP}\\) with a smooth distribution:

$$
G=\sum_{k=1}^\infty \pi_k \delta_{\theta_k^\*}\\
F_x(\cdot) = \sum_{k=1}^\infty \pi_k F(\cdot|\theta_k^\*)\\
x_i \sim F_x
$$

Usually, \\(F(\cdot|\mu,\Sigma)\\) is Gaussian with mean \\(\mu\\), covariance \\(\Sigma\\). \\(H(\mu, \Sigma)\\) 
is Gaussian-inverse-Wishart conjugate prior.

##### Clustering

$$
G=\sum_{k=1}^\infty \pi_k \delta_{\theta_k^\*}\\
F_x(\cdot) = \sum_{k=1}^\infty \pi_k F(\cdot|\theta_k^\*)\\
x_i \sim F_x
$$

is equivalent to

$$
z_i \sim \text{Discrete}(\pi)\\
\theta_i = \theta_{z_i}^\*\\
x_i|z_i \sim F(\cdot|\theta_i) = F(\cdot|\theta_{z_i}^\*)
$$

This is simply a mixture model with an infinite number of components. This is called a \\(\mathcal{DP}\\) 
mixture model.

### References

[link1](http://katbailey.github.io/post/gaussian-processes-for-dummies/){:target="_blank"}, 
[link2](https://www.stats.ox.ac.uk/~teh/teaching/npbayes/mlss2007.pdf){:target="_blank"}


Of cause, these two random processes are not so much closely related. I just read about them recently.

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
Gaussian distribution with zero mean and variance \\(\delta_n^2\\)

$$
\epsilon \sim \mathbb{N}(0, \delta_n^2)
$$

This noise assumption together with the model directly gives rise to the likelihood, the probability 
density of the observations given the parameters, which is factored over cases in the training set to 
give

$$
p(\boldsymbol{y}|X,\boldsymbol{w}) = \prod_{i=1}^n p(y_i|\boldsymbol{x}_i, \boldsymbol{w}) = \prod_{i=1}^n \frac{1}{\sqrt{2\pi}\delta_n} \exp(-\frac{(y_i - \boldsymbol{x}^T\boldsymbol{w})^2}{2\delta_n^2}) \\
= \frac{1}{(2\pi\delta_n^2)^{\frac{n}{2}} \exp (-\frac{1}{2\delta_n^2}|\boldsymbol{y} - X^T\boldsymbol{w}|^2) = \mathbb{N}(X^T\boldsymbol{w}, \delta_n^2I)
$$

In the Bayesian formalism we need to specify a prior over the parameters, expressing our beliefs about 
the parameters before we look at the observations. We put a zero mean Gaussian prior with covariance 
matrix \\(\Sigma_p\\) on the weights

$$
\boldsymbol{w} \sim \mathbb{N}(\boldsymbol{0}, \Sigma_p)
$$

Inference in the Bayesian linear model is based on the posterior distribution over the weights, 
computed by Bayes' rule

$$
\text{posterior} = \frac{\text{likelihood} \times \text{prior}}{\text{marginal likelihood}}
$$
$$
p(\boldsymbol{w}|\boldsymbol{y},X) = \frac{p(\boldysmbol{y}|X,\boldsymbol{w})}{p(\boldsymbol{y}|X)}
$$

where the normalizing constant, also known as the marginal likelihood, is independent of the weights 
and given by

$$
p(\boldsymbol{y}|X) = \int p(\boldsymbol{y}|X,\boldsymbol{w})p(\boldsymbol{w}) d\boldsymbol{w}
$$

The posterior combines the likelihood and the prior, and captures everything we know about the 
parameters.

$$
p(\boldsymbol{w}|X,\boldsymbol{y}) \propto \exp (-\frac{1}{2\delta_n^2}(\boldsymbol{y} - X^T\boldsymbol{w})^T(\boldsymbol{y} - X^T\boldsymbol{w})) \exp (-\frac{1}{2} \boldsymbol{w}^T\Sigma_p^{-1}\boldsymbol{w})
\propto \ext(-\frac{1}{2}(\boldsymbol{w} - \bar{\boldsymbol{w}})^T(\frac{1}{\delta_n^2 XX^T + \Sigma_p^{-1}})(\boldsymbol{w} - \bar{\boldsymbol{w}}))
$$

where \\(\bar{\boldsymbol{w}} = \delta_n^{-2}(\delta_n^2XX^T + \Sigma_p^{-1})^{-1}X\boldsymbol{y}\\), 
and we recognize the from of the posterior distribution as Gaussian with mean \\(\bar{\boldsymbol{w}}\\) 
and covariance matrix \\(A^{-1}\\)

$$
p(\boldsymbol{w}|X,\boldsymbol{y}) \sim \mathbb{N}(\bar{\boldsymbol{w}} = \frac{1}{\delta_n^2} A^{-1}X\boldsymbol{y}, A^{-1})
$$

where \\(A = \delta_n^{-2}XX^T + \Sigma_p^{-1}\\). Notice that for this model (indeed for any Gaussian 
posterior) the mean of the posterior distribution \\(p\boldsymbol{w}|\boldsymbol{y},X)\\) is also its 
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
p(f_*|\boldsymbol{x}_*,X,\boldsymbol{y}) = \int p(f_*|\boldsymbol{x}_*,\boldsymbol{w})p(\boldsymbol{w}|X,\boldsymbol{y})d\boldsymbol{w} \\
= \mathbb{N}(\frac{1}{\delta_n^2} \boldsymbol{x}_*^TA^{-1}X\boldsymbol{y}, \boldsymbol{x}_*^TA_{-1}\boldsymbol{x}_*)
$$

The predictive distribution is again Gaussian, with a mean given by the posterior mean of the weights 
multiplied by the test input, as one would expect from symmetry considerations. The predictive variance 
is a quadratic form of the test input with the posterior covariance matrix, showing that the predictive 
uncertainties grow with the magnitude of the test input, as one would expect for a linear model.

#### Projections of Inputs into Feature Space

Let's introduce the function \\(\phi(\boldsymbol{x})\\) which maps a \\(D\\)-dimensional input vector 
\\(boldsymbol{x}\\) into an \\(N\\) dimensional feature space. Further let the matrix \\(\Phi(X)\\) be 
the aggregation of columns of \\(\phi(\boldsymbol{x})\\) for all cases in the training set. Now the 
model is 

$$
f(\boldsymbol{x}) = \phi(\boldsymbol{x})^T\boldsymbol{w}
$$

where the vector of parameters now has length \\(N\\).

The predictive distribution becomes

$$
f_*|\boldsymbol{x}_*,X,\boldsymbol{y} \sim \mathbb{N}(\frac{1}{\delta_n^2}\phi(\boldsymbol{x}_*)^TA^{-1}\Phi\boldsymbol{y},\phi(\boldsymbol{x}_*)^TA^{-1}\phi(\boldsymbol{x}_*))
$$

with \\(\Phi = \Phi(X)\\) and \\(A = \delta_n^{-2}\Phi\Phi^T + \Sigma_p^{-1}\\). To make predictions 
using this equation we need to invert the \\(A\\) matrix of size \\(N \times N\\) which may not be 
convenient if \\(N\\) is large. However, we can rewrite as

$$
f_*|\boldsymbol{x}_*,X,\boldsymbol{y} \sim \mathbb{N}(\phi_*^T\Sigma_p\Phi(K + \delta_n^2I)^{-1}\boldsymbol{y}, \phi_*^T\Sigma_p\phi_* - \phi_*^T\Sigma_p\Phi(K+\delta_n^2I)^{-1}\Phi^T\Sigma_*\phi_*)
$$

where we have used the shorthand \\(\phi(\boldsymbol{x}_*) = \phi_*\\) and defined 
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
\\(\phi_*^T\Sigma_p\Phi\\), or \\(\phi_*^T\Sigma_p\phi_*\\); thus the entries of these matrices 
are invariably of the form \\(\phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')\\). Let us define 
\\(k(\boldsymbol{x},\boldsymbol{x}') = \phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')\\). We 
call \\(k(\cdot,\cdot)\\) a covariance function or kernel. Notice that \\(\phi(\boldsymbol{x})^T\Sigma_p\phi(\boldsymbol{x}')\\) 
is an inner product with respect to \\(\Sigma_p\\). As \\(Sigma_p\\) is positive definite we can define 
\\(\Sigma_p^{1/2}\\) so that \\((\Sigma_p^{1/2})^2 = \Sigma_p\\); for example if the SVD of \\(Sigma_p = UDU^T\\), 
where \\(D\\) is diagonal, then one form for \\(\Sigma_p^{1/2}\\) is \\(UD^{1/2}U^T\\). Then defining 
\\(\psi(\boldsymbol{x}) = \Sigma_p^{1/2}\phi(\boldsymbol{x})\\) we obtain a simple dot product 
representation \\(k(\boldsymbol{x},\boldsymbol{x}') = \psi(\boldsymbol{x})\cdot\psi(\boldsymbol{x}')\\).

If an algorithm is defined solely in terms of inner products in input space then it can be lifted 
into feature space by replacing occurrences of those inner products by \\(k(\boldsymbol{x},\boldsymbol{x}')\\); 
this is sometimes called the kernel trick.

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
f(\boldsymbol{x}) \sim \mathbb{GP}(m(\boldsymbol{x}), k(\boldsymbol{x}, \boldsymbol{x}'))
$$

Here the index set \\(\mathbb{X}\\) is the set of possible inputs, which could be more general, 
\\(\mathbb{R}^D\\). For notational convenience we use the enumeration of the cases in the training 
set to identify the random variables such that \\(f_i = f(\boldsymbol{x}_i)\\) is the random 
variable corresponding to the case \\(\boldsymbol{x}_i, y_i\\) as would be expected.

A Gaussian process is defined as a collection of random variables. Thus, the definition 
automatically implies a consistency requirement, which is also sometimes known as the marginalization 
property. This property simply means that if the GP specifies \\((y_1,y_w) \sim \mathbb{N}(\boldsymbol{\mu}, \Sigma)\\), 
then it must also specify \\(y_1 \sim \mathbb{N}(\mu_1, \Sigma_{11})\\) where \\(\Sigma_{11}\\) is 
the relevant submatrix of \\(\Sigma\\). In other words, examination of a larger set of variables 
does not change the distribution of the smaller set. Notice that the consistency requirement is 
automatically fulfilled if the covariance function specifies entries of the covariance matrix. The 
definition does not exclude Gaussian processes with finite index sets (which would be simply 
Gaussian distributions), but these are not particularly interesting for our purposes.

A simple example of a Guassian process can be obtained from our Bayesian linear regression model 
\\(f(\boldsymbol{x}) = \phi(\boldsymbol{x})^T\boldsymbol{w}\\) with prior 
\\(\boldsymbol{w} \sim \mathbb{N}(\boldsymbol{0}, \Sigma_p)\\). We have for the mean and covariance 

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
independent identically distributed Gaussian noise \\(epsilon\\) with variance \\(\delta_n^2\\), the 
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
\begin{bmatrix}\boldsymbol{y} \\ \boldsymbol{f}_*\end{bmatrix} \sim \mathbb{N}(\boldsymbol{0}, [
\begin{bmatrix}K(X, X) + \sigma_n^2I & K(X, X_*) \\ K(K_*, X) & K(X_*, K_*)\end{bmatrix}
])
$$

And we have

$$
\boldsymbol{f}_*|X, \boldsymbol{y}, X_* \sim \mathbb{N}(\bar{\boldsymbol{f}_*}, \text{cov}(\boldsymbol{f}_*))
$$

where 

$$
\bar{\boldsymbol{f}_*} = \mathbb{E}[\boldsymbol{f}_*|X, \boldsymbold{y}, X_*] = K(X_*, X)[K(X, X) + \sigma_n^2I]^{-1}\boldsymbol{y}
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
\\(K(X_*, X_*)\\) is simply the prior covariance; from that is subtracted a (positive) term, 
representing the information the observations gives us about the function. We can compute the 
predictive distribution of test targets \\(\boldsymbol{y}_*\\) by adding \\(\sigma_n^2I\\) to the 
variance in the expression for \\(\text{cov}(\boldsymbol{f}_*)\\).

The marginal likelihood is the integral of the likelihood times the prior

$$
p(\boldsymbol{y}|X) = \int p(\boldsymbol{y}|\boldsymbol{f}, X)p(\boldsymbol{f}|X)d\boldsymbol{f}
$$

The term merginal likelihood refers to the marginalization over the function values \\(\boldsymbol{f}\\). 
Under the Gaussian process model the prior is Gaussian, \\(\boldsymbol{f}|X \sim \mathbb{N}(\boldsymbol{0}, K)\\), or 

$$
\log p(\boldsymbol{f}|X) = -\frac{1}{2} \boldsymbol{f}^TK^{-1}\boldsymbol{f} - \frac{1}{2}\log|K| - \frac{n}{2}\log 2\pi
$$

and the likelihood is a factorized Gaussian \\(\boldsymbol{y}|\boldsymbol{f} \sim \mathbb{N}(\boldsymbol{f}, \sigma_n^2I)\\) so 
we have the log marginal likelihood

$$
\log p(\boldsymbol{y}|X) = -\frac{1}{2}\boldsymbol{y}^T(K+\sigma_n^2I)^{-1}\boldsymbol{y} - \frac{1}{2}\log|K+\sigma_n^2I| - \frac{n}{2}\log 2\pi
$$

This result can also be obtained directly by observing that \\(\boldsymbol{y} \sim \mathbb{N}(\boldsymbol{0}, K+\sigma_n^2I)\\).

In practical applications, we are often forced to make a decision about how to act, i.e. we need a 
point-like prediction which is optimal in some sense. To this end, we need a loss function 
\\(\mathbb{L}(y_{\text{true}}, y_{\text{guess}})\\), which specifies the loss incurred by guessing the value 
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
\tilde{R}_{\mathbb{L}}(y_{\text{guess}}|\boldsymbol{x}_*) = \int \mathbb{L}(y_*, y_{\text{guess}}) p(y_*|\boldsymbol{x}_*, \mathbb{D}) dy_*
$$

Thus our best guess, in the sense that it minimizes the expected loss, is

$$
y_{\text{optimal}}|\boldsymbol{x}_* = \arg\min_{y_{\text{guess}}} \tilde{R}_{\mathbb{L}}(y_{\text{guess}}|\boldsymbol{x}_*)
$$

In general the value of \\(y_{\text{guess}}\\) that minimizes the risk for loss function 
\\(|y_{\text{guess}} - y_*|\\) is the median of \\(p(y_*|\boldsymbol{x}_*, \mathbb{D})\\), while 
for the squared loss \\((y_{\text{guess}} - y_*)^2\\) it is themean of this distribution. When the 
predictive distribution is Gaussian the mean and the median coincide, and indeed for any symmetric 
loss function and symmetric predictive distribution we always get \\(y_{\text{guess}}\\) as the 
mean of the predictive distribution.

#### Generate samples

To generate samples \\(\boldsymbol{x} \sim \mathbb{N}(\boldsymbol{m}, K)\\) with arbitrary mean 
\\(\boldsymbol{m}\\) and covariance matrix \\(K\\) using a scalar Gaussian generator we proceed as 
follows: first compute the Cholesky decomposition (also known as the matrix square root) \\(L\\) of 
the positive definite symmetric covariance matrix \\(K = LL^T\\), where \\(L\\) is a lower triangular 
matrix. Then generate \\(\boldsymbol{u} \sim \mathbb{N}(\boldsymbol{0}, I)\\) by multiple separate 
calls to the scalar Gaussian generator. Compute \\(\boldsymbol{x} = \boldsymbol{m} + L\boldsymbol{u}\\), 
which has the desired distribution with mean \\(\boldsymbol{m}\\) and covariance 
\\(L\mathbb{E}[\boldsymbol{u}\boldsymbol{u}^T]L^T = LL^T = K\\) (by the independence of the 
elements of \\(\boldsymbol{u}\\).

In practice it may be necessary to add a small multiple of the identity matrix \\(\epsilonI\\) to the 
covariance matrix for numerical reasons. This is because the eigenvalues of the matrix \\(K\\) can 
decay very rapidly and without this stabilization the Cholesky independent noise of variance 
\\(\epsilon\\). From the context \\(\epsilon\\) can usually be chosen to have inconsequential effects 
on the samples, while ensuring numerical stability.

http://katbailey.github.io/post/gaussian-processes-for-dummies/

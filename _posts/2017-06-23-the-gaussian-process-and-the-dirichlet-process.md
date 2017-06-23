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



---
layout: post
category: [math]
tags: [math]
infotext: "reading note/report of Machine learning a probabilistic perspective"
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Generative and discriminative

One way to build a probabilistic classifier is to create a joint model 
of the form \\(p(y,x)\\) and then to condition on \\(x\\), thereby 
deriving \\(p(y|x)\\). This is called the generative approach. An 
alternative approach is to fit a model of the form \\(p(y|x)\\) directly. 
This is called the discriminative approach.

### Line search

Perhaps the simplest algorithm for unconstrained optimization is 
gradient descent, also known as steepest descent. This can be written 
as follows:

$$
\theta_{k+1}=\theta_k - \eta_k g_k
$$

where \\(\eta_k\\) is the step size or learning rate. The main issue 
in gradient descent is: how would we set the step size? Let us develop 
a more stable method for picking the step size, so that the method is 
guaranteed to converge to a local optimum no matter where we start. 
This property is called global convergence, which should not be 
confused with convergence to the global optimum. By Taylor's theorem, 
we have

$$
f(\theta+\eta d) \approx f(\theta) + \eta g^T d
$$

where \\(d\\) is the descent direction. So if \\(\eta\\) is chosen 
small enough, then \\(f(\theta+\eta d) < f(\theta)\\), since the 
gradient will be negative. But we don't want to choose the step size 
\\(\eta\\) too small, or we will move very slowly and may not reach 
the minimum. So let us pick \\(\eta\\) to minimize

$$
\phi(\eta) = f(\theta_k + \eta d_k)
$$

This is called line minimization or line search.

The steepest descent path with exact line searches exhibits a characteristic 
zig-zag behavior. Note that an exact line search satisfies 
\\(\eta_k = \arg\min_{\eta > 0}(\phi(\eta))\\). A necessary condition 
for the optimum is \\(\phi'(\eta)=0\\). By the chain rule, 
\\(\phi'(\eta)=d^T g\\), where \\(g=f'(\theta+\eta d)\\) is the gradient 
at the end of the step. So we either have \\(g=0\\), which means we have 
found a stationary point, or \\(g \perp d\\), which means that exact 
search stops at a point where the local gradient is perpendicular to the 
search direction. Hence consecutive directions will be orthogonal. This 
explains the zig-zag behavior.

One simple heuristic to reduce the effect of zig-zagging is to add a 
momentum term, \\((\theta_k - \theta_{k-1})\\), as follows:

$$
\theta_{k+1}=\theta_k - \eta_k g_k + \mu_k(\theta_k - \theta_{k-1})
$$

where \\(0 \leq \mu_k \leq 1\\) controls the importance of the momentum 
term. In the optimization community, this is known as the heavy ball 
method.

An alternative way to minimize "zig-zagging" is to use the method of 
conjugate gradients. This is the method of choice for quadratic 
objectives of the form \\(f(\theta)=\theta^TA\theta\\), which arise 
when solving linear systems. However, non-linear CG is less popular.

### QQ-plot

It is sometimes useful to detect data cases which are outliers. This 
is called residual analysis or case analysis. In a regression setting, 
this can be performed by computing \\(r_i=y_i-\hat{y}_i\\), where 
\\(\hat{y}_i=\hat{w}^Tx_i\\). There values should follow a 
\\(\mathcal{N}(0,\sigma^2)\\) distribution, if the modelling assumptions 
are correct. This can be assessed by creating a qq-plot, where we plot 
the N theoretical quantiles of a Gaussian distribution against the N 
empirical quantiles of the \\(r_i\\). Points that deviate from the 
straightline are potential outliers.

### Online learning

Traditionally machine learning is performed offline, which means we 
have a batch of data, and we optimize an equation of the following form 

$$
f(\theta)=\frac{1}{N}\sum_{i=1}^Nf(\theta,z_i)
$$

where \\(z_i=(x_i, y_i)\\) in the supervised case, or just \\(x_i\\) 
in the unsupervised case, and \\(f(\theta, z_i)\\) is some kind of 
loss function.

However, if we have streaming data, we need to perform online learning, 
so we can update our estimates as each new data point arrives rather 
than waiting until the end. And even if we have a batch of data, we 
might want to treat it like a stream if it is too large to hold in main 
memory.

Suppose that at each step, "nature" presents a sample \\(z_k\\) and 
the "learner" must respond with a parameter estimate \\(\theta_k\\). 
In the theoretical machine learning community, the objective used in 
online learning is the regret, which is the averaged loss incurred 
relative to the best we could have gotten in hindsight using a single 
fixed parameter value:

$$
\text{regret}_k \triangleq \frac{1}{k}\sum_{t=1}^k f(\theta_t, z_t) - \min_{\theta^* \in \Theta}\frac{1}{k}\sum_{t=1}^k f(\theta_*, z_t)
$$

One simple algorithm for online learning is online gradient descent, 
which is as follows: at each step \\(k\\), update the parameters using 

$$
\theta_{k+1}=\text{proj}_\Theta(\theta_k - \eta_k g_k)
$$

where \\(\text{proj}\_\mathcal{V}(v) = \arg\min\_{w \in \mathcal{V}}||w-v||_2\\) 
is the projection of vector \\(v\\) onto space \\(\mathcal{V}\\), 
\\(g_k=\nabla f(\theta_k,z_k)\\) is the gradient, and \\(\eta_k\\) is 
the step size.

Now suppose that instead of minimizing regret with respect to the past, 
we want to minimize expected loss in the future, as is more common in 
(frequentist) statistical learning theory. That is, we want to minimize 

$$
f(\theta)=\mathbb{E}[f(\theta, z)]
$$

where the expectation is taken over future data. Optimizing functions 
where some of the variables in the objective are random is called 
stochastic optimization.

Suppose we receive an infinite stream of samples from the distribution. 
One way to optimize stochastic objectives is to perform the update as 
in previous equation at each step. This is called stochastic gradient 
descent or SGD. Since we typically want a single parameter estimate, 
we can use a running average:

$$
\bar{\theta}_k = \frac{1}{k}\sum_{t=1}^k\theta_t
$$

This is called Polyak-Ruppert averaging, and can be implemented 
recursively as follows:

$$
\bar{\theta}_k = \bar{\theta}_{k-1}-\frac{1}{k}(\bar{\theta}_{k-1} - \theta_k)
$$

We now discuss some sufficient conditions on the learning rate to 
guarantee convergence of SGD. These are known as the Robbins-Monro 
conditions:

$$
\sum_{k=1}^\infty \eta_k = \infty\\
\sum_{k=1}^\infty \eta_k^2 < \infty
$$

The set of values of \\(\eta_k\\) over time is called the learning 
rate schedule.

One drawback of SGD is that is uses the same step size for all 
parameters. The method adagrad is similar in spirit to a diagonal 
Hessian approximation. In particular, if \\(\theta_i(k)\\) is parameter 
\\(i\\) at time \\(k\\), and \\(g_i(k)\\) is its gradient, then we 
make an update as follows:

$$
\theta_i(k+1)=\theta_i(k)-\eta\frac{g_i(k)}{\tau_0+\sqrt{s_i(k)}}
$$

where the diagonal step size vector is the gradient vector squared, 
summered over all time steps. This can be recursively updated as 
follows:

$$
s_i(k) = s_i(k-1) + g_i(k)^2
$$

The result is a per-parameter step size that adapts to the curvature 
of the loss function. This method was original derived for the regret 
minimization case, but it can be applied more generally.

Another approach to online learning is to adopt a Bayesian view. This 
is conceptually quite simple: we just apply Bayes rule recursively:

$$
p(\theta|D_{1:k}) \propto p(D_k|\theta)p(\theta|D_{1:k-1})
$$

This has the obvious advantage of returning a posterior instead of 
just a point estimate. It also allows for the online adaptation of 
hyper-parameters, which is important since cross-validation cannot be 
used in an online setting. Finally, it has the advantage that it can 
be quicker than SGD. Note that by modeling the posterior variance of 
each parameter in addition to its mean, we effectively associate a 
different learning rate for each parameter, which is a simple way to 
model the curvature of the space. These variances can then be adapted 
using the usual rules of probability theory. By contrast, getting 
second-order optimization methods to work online is more tricky.

### Dimension reduction

Discriminant analysis is a generative approach to classification, 
which requires fitting an MVN to the features. This can be problematic 
in high dimensions. An alternative approach is to reduce the 
dimensionality of the features \\(x\in\mathbb{R}^D\\) and then fit an 
MVN to the resulting low-dimensional features \\(z\in\mathbb{R}^L\\). 
The simplest approach is to use a linear projection matrix, 
\\(z=Wx\\), where \\(W\\) is a \\(L \times D\\) matrix. One approach 
to finding \\(W\\) would be to use PCA; the result would be very 
similar to RDA, since SVD and PCA are essentially equivalent. However, 
PCA is an unsupervised technique that does not take class labels into 
account. Thus the resulting low dimensional features are not 
necessarily optimal for classification. An alternative approach is to 
find the matrix \\(W\\) such that the low-dimensional data can be 
classified as well as possible using a Gaussian class-conditional 
density model. The assumption of Gaussianity is reasonable since we 
are computing linear combinations of (potentially non-Gaussian) 
features. This approach is called Fisher's linear discriminant 
analysis, or FLDA.

### Exponential family

A pdf or pmf \\(p(x|\theta)\\), for 
\\(x=(x_1,\dots,x_m) \in \mathcal{X}^m\\) and 
\\(\theta \in \Theta \subseteq \mathbb{R}^d\\), is saied to be in the 
exponential family if it is of the form

$$
\begin{array}
p(x|\theta) &= \frac{1}{Z(\theta)}h(x)\exp[\theta^T\phi(x)]\\
&= h(x)\exp[\theta^T\phi(x) - A(\theta)]
\end{array}
$$

where 

$$
Z(\theta) = \int_{\mathcal{X}^m} h(x) \exp [\theta^T\phi(x)]dx\\
A(\theta) = \log Z(\theta)
$$

Here \\(\theta\\) are called the natural parameters or canonical 
parameters, \\(\phi(x) \in \mathbb{R}^d\\) is called a vector of 
sufficient statistics, \\(Z(\theta)\\) is called the partition function, 
\\(A(\theta)\\) is called the log partition function or cumulant 
function, and \\(h(x)\\) is a scaling constant, often \\(1\\). If 
\\(\phi(x)=x\\), we say it is a natural exponential family.

The equation can be generalized by writing

$$
p(x|\theta)=h(x)\exp[\eta(\theta)^T\phi(x) - A(\eta(\theta))]
$$

where \\(\eta\\) is a function that maps the parameters \\(\theta\\) 
to canonical parameters \\(\eta=\eta(\theta)\\). If 
\\(\text{dim}(\theta) < \text{dim}(\eta(\theta))\\), it is called a 
curved exponential family, which means we have more sufficient 
statistics than parameters. If \\(\eta(\theta)=\theta\\), the model 
is said to be in canonical form.

### The EM algorithm

For many models in machine learning and statistics, computing the ML 
or MAP parameter estimate is easy provided we observe all the values 
of all the relevant variables, i.e., if we have complete data. However, 
if we have missing data and/or latent variables, then computing the 
ML/MAP estimate becomes hard.

One approach is to use a generic gradient-based optimizer to find a 
local minimum of the negative log likelihood or NLL, given by

$$
NLL(\theta) \triangleq -\frac{1}{N} \log p(D|\theta)
$$

However, we often have to enforce constraints, such as the fact that 
covariance matrices must be positive definite, mixing weights must 
sum to one, etc., which can be tricky. In such cases, it is often much 
simpler (but not always faster) to use an algorithm called expectation 
maximization, or EM for short. This is a simple iterative algorithm, 
often with closed-form updates at each step. Furthermore, the algorithm 
automatically enforce the required constraints.

EM exploits the fact that if the data were fully observed, then the 
ML/MAP estimate would be easy to compute. In particular, EM is an 
iterative algorithm which alternates between inferring the missing 
values given the parameters (E step), and then optimizing the parameters 
given the "filled in" data (M step). 

Let \\(x_i\\) be the visible or observed variables in case \\(i\\), and 
let \\(z_i\\) be the hidden or missing variables. The goal is to 
maximize the log likelihood fo the observed data:

$$
\mathcal{l}(\theta) = \sum_{i=1}^N \log p(x_i|\theta) = \sum_{i=1}^N\log[\sum_{z_i}p(x_i, z_i|\theta)]
$$

unfortunately this is hard to optimize, since the log cannot be pushed 
inside the sum.

EM gets around this problem as follows. Define the complete data log 
likelihood to be 

$$
\mathcal{l}_c(\theta)\triangleq \sum_{i=1}^N \log p(x_i, z_i|\theta)
$$

This cannot be computed, since \\(z_i\\) is unknown. So let us define 
the expected complete data log likelihood as follows:

$$
Q(\theta, \theta^{t-1})=\mathbb{E}[\mathcal{l}_c(\theta)|D, \theta^{t-1}]
$$

where \\(t\\) is the current iteration number. \\(Q\\) is called the 
auxiliary function. The expected is taken wrt the old parameters, 
\\(\theta^{t-1}\\), and the observed data \\(D\\). The goal of the 
E step is to compute \\(Q(\theta, \theta^{t-1})\\), or rather, the 
terms inside of it which the MLE depends on; these are known as the 
expected sufficient statistics or ESS. In the M step, we optimize the 
\\(Q\\) function wrt \\(\theta\\):

$$
\theta^t = \arg\max_{\theta} Q(\theta, \theta^{t-1})
$$

To perform MAP estimation, we modify the M step as follows:

$$
\theta^t = \arg\max_{\theta} Q(\theta, \theta^{t-1}) + \log p(\theta)
$$

The E step remains unchanged.

Now, let's show that EM monotonically increases the observed data log 
likelihood until it reaches a local maximum (or saddle point, although 
such points are usually unstable).

Consider an arbitrary distribution \\(q(z_i)\\) over the hidden variables. 
The observed data log likelihood can be written as follows:

$$
\mathcal{l}(\theta) \triangleq \sum_{i=1}^N \log [\sum_{z_i} p(x_i, z_i|\theta)]=\sum_{i=1}^N \log [\sum_{z_i} q(z_i)\frac{p(x_i,z_i|\theta)}{q(z_i)}]
$$

Now \\(\log(u)\\) is a concave function, so from Jensen's inequality we 
have the following lower bound:

$$
\mathcal{l}(\theta) \geq \sum_i\sum_{z_i} q_i(z_i) \log \frac{p(x_i,z_i|\theta)}{q_i(z_i)}
$$

Let us denote this lower bound as follows:

$$
Q(\theta, q) \triangleq \sum_i\mathbb{E}_{q_i}[\log p(x_i, z_i|\theta)] + \mathbb{H}(q_i)
$$

where \\(\mathbb{H}(q_i)\\) is the entropy of \\(q_i\\).

The above argument holds for any positive distribution \\(q\\). 
Intuitively we should pick the \\(q\\) that yields the tightest 
lower bound. The lower bound is a sum over \\(i\\) of terms of 
the following form:

$$
\begin{array}
\mathcal{L}(\theta, q_i) &= \sum_{z_i}q_i(z_i)\log\frac{p(x_i,z_i|\theta)}{q_i(z_i)}\\
&= \sum_{z_i}q_i(z_i)\log\frac{p(z_i|x_i,\theta)p(x_i|\theta)}{q_i(z_i)}\\
&= \sum_{z_i}q_i(z_i)\log\frac{p(z_i,x_i|\theta)}{q_i(z_i)}+\sum_{z_i}q_i(z_i)\log p(x_i|\theta)\\
&= -\mathbb{KL}(q_i(z_i)||p(z_i|x_i,\theta))+\log p(x_i|\theta)
\end{array}
$$

The \\(p(x_i|\theta)\\) term is independent of \\(q_i\\), so we 
can maximize the lower bound by setting 
\\(q_i(z_i)=p(z_i|x_i,\theta)\\). Of course, \\(\theta\\) is 
unknown, so instead we use \\(q_i^t(z_i)=p(z_i|x_i,\theta^t)\\), 
where \\(\theta^t\\) is our estimate of the parameters at 
iteration \\(t\\). This is the output of the E step.

Plugging this in to the lower bound we get

$$
Q(\theta, q^t)=\sum_i \mathbb{E}_{q_i^t}[\log p(x_i,z_i|\theta)] + \mathbb{H}(q_i^t)
$$

we recognize the first term as the expected complete data log 
likelihood. The second term is a constant wrt \\(\theta\\). So 
the M step becomes

$$
\theta^{t+1}=\arg\max_{\theta}Q(\theta,\theta^t)=\arg\max_{\theta}\sum_i \mathbb{E}_{q_i^t}[\log p(x_i, z_i|\theta)]
$$

as usual.

Now comes the punchline. Since we used \\(q_i^t(z_i)=p(z_i|x_i,\theta^t)\\), 
the KL divergence becomes zero, so \\(\mathcal{L}(\theta^t,q_i)=\log p(x_i|\theta^t)\\), 
and hence

$$
Q(\theta^t,\theta^t)=\sum_i\log p(x_i|\theta^t)=\mathcal{l}(\theta^t)
$$

We see that the lower bound is tight after the E step. Since 
the lower bound "touches" the function, maximizing the lower 
bound will also "push up" on the function itself. That is, 
the M step is guaranteed to modify the parameters so as to 
increase the likelihood of the observed data (unless it is 
already at a local maximum).

We now prove that EM monotonically increases the observed data 
log likelihood until it reaches a local optimum. We have

$$
\mathcal{l}(\theta^{t+1})\geq Q(\theta^{t+1},\theta^t)\geq Q(\theta^t, \theta^t)=\mathcal{l}(\theta^t)
$$

where the first inequality follows since \\(Q(\theta, \cdot)\\) 
is a lower bound on \\(\mathcal{l}(\theta)\\); the second 
inequality follows since, by definition, 
\\(Q(\theta^{t+1},\theta^t)=\max_{\theta}Q(\theta,\theta^t)\geq Q(\theta^t, \theta^t)\\).

As a consequence of this result, if you do not observe 
monotonic increase of the observed data log likelihood, 
you must have an error in your math and/or code. (If you 
are performing MAP estimation, you must add on the log 
prior term to the objective.) This is a surprisingly 
powerful debugging tool.

In the above, we show that the optimal thing to do in the 
E step is to make \\(q_i\\) be the exact posterior over 
the latent variables, \\(q_i^t(z_i)=p(z_i|x_i,\theta^t)\\). 
In this case, the lower bound on the log likelihood will 
be tight, so the M step will "push up" on the log-likelihood 
itself. However, sometimes it is computationally intractable 
to perform exact inference in the E step, but we may be 
able to perform approximate inference. If we can ensure that 
the E step is performing inference based on a lower bound 
to the likelihood, then the M step can be seen as monotonically 
increasing this lower bound. This is called variational EM.

Sometimes we can perform the E step exactly, but we cannot 
perform the M step exactly. However, we can still monotonically 
increase the log likelihood by performing a "partial" M step, 
in which we merely increase the expected complete data log 
likelihood, rather than maximizing it. For example, we might 
follow a few gradient steps. This is called the generalized EM 
or GEM algorithm. (This is an unfortunate term, since there 
are many ways to generalize EM.)

Consider latent variable models of the form 
\\(z_i \rightarrow x_i \leftarrow \theta\\). This includes mixtures 
models, PCA, HMMs, etc. There are now two kinds of unknowns: 
parameters \\(\theta\\), and latent variables, \\(z_i\\). 
It is common to fit such models using EM, where in the E 
step we infer the posterior over the latent variables, 
\\(p(z_i|x_i,\theta)\\), and in the M step, we compute 
a point estimate of the parameters, \\(\theta\\). The 
justification for this is two-fold. First, it results in 
simple algorithms. Second, the posterior uncertainty in 
\\(\theta\\) is usually less than in \\(z_i\\), since the 
\\(\theta\\) are informed by all \\(N\\) data cases, whereas 
\\(z_i\\) is only informed by \\(x_i\\); this makes a MAP 
estimate of \\(\theta\\) more reasonable than a MAP estimate 
of \\(z_i\\).

However, VB provides a way to be "more Bayesian", by 
modeling uncertainty in the parameters \\(\theta\\) as 
well in the latent variables \\(z_i\\), at a computational 
cost that is essentially the same as EM. This method is 
known as variational Bayes EM or VBEM. The basic idea is to 
use mean field, where the approximate posterior has the 
form

$$
p(\theta,z_{1:N}|D) \approx q(\theta)q(z) = q(\theta)\prod_i q(z_i)
$$

The first factorization, between \\(\theta\\) and \\(z\\), is a 
crucial assumption to make the algorithm tractable. The 
second factorization follows from the model, since the 
latent variables are iid conditional on \\(\theta\\).

In VBEM, we alternate between updating \\(q(z_i|D)\\) (the 
variational E step) and updating \\(q(\theta|D)\\) (the 
variational M step). We can recover standart EM from VBEM 
by approximating the parameter posterior using a delta 
function, \\(q(\theta|D)\approx\delta_{\hat{\theta}}(\theta)\\).

The variational E step is simialr to a standart E step, 
except instead of plugging in a MAP estimate of the parameters 
and computing \\(p(z_i|D,\hat{\theta})\\), we need to average 
over the paramters. Roughly speaking, this can be computed by 
plugging in the posterior mean of the parameters instead 
of the MAP estimate, and then computing \\(p(z_i|D,\hat{\theta})\\) 
using standard algorithms, such as forwards-backwards. 
Unfortunately, things are not quite this simple, but this is 
the basic idea. The details depend on the from of the models.

The variational M step is similar to a standard M step, except 
instead of computing a point estimate of the parameters, we 
update the hyper-parameters, using the expected sufficient 
statistics. This process is usually very similar to MAP 
estimation in regular EM. Again, the details on how to do 
this depend on the form of the model.

The principle advantage of VBEM over regular EM is that by 
marginalizing out the parameters, we can compute a lower 
bound on the marginal likelihood, which can be used for 
model selection. VBEM is also "egalitarian", since it 
treats parameters as "first class citizens", just like any 
other unknown quantity, whereas EM makes an artificial 
distinction between parameters and latent variables.

The mean field methods, at least of the fully-factorized 
variety, are all very similar: just compute each node's 
full conditional, and average out the neighbors. This is 
very similar to Gibbs sampling, except the derivation of 
the equations is usually a bit more work. Fortunately it 
is possible to derive a general purpose set of udpate 
equations that work for any DGM for which all CPDs are in 
the exponential family, and for which all parent nodes 
have conjugate distributions. One can then sweep over the 
graph, updating nodes one at a time, in a manner similar 
to Gibbs sampling. This is known as variational message 
passing or VMP, and has been implemented in the open-source 
program VIBES. This is a VB analog to BUGS, which is a 
popular generic program for Gibbs sampling.

VMP/mean field is best-suited to inference where one or 
more of the hidden nodes are continuous. For models where 
all the hidden nodes are discrete, more accurate 
approximate inference algorithms can be used.

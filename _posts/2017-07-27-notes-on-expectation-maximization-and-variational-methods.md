It has been almost six years since I first meet EM optimization algorithm. 
It is a pity that I did never take it seriously in these years. Recently, 
I re-pick it up and find that it is really classic and well studied.

### Bayesian Networks

A Bayesian network is a probabilistic graphical model that represents a set 
of random variables and their conditional dependencies via a directed acyclic 
graph.

A Bayesian network is a complete model for the variables and their relationship. 
It can be used to answer probabilistic queries about them. For example, the 
network can be used to find out updated knowledge of the state of a subset of 
variables when other variables are observed. This process of computing the 
posterior distribution of variables given evidence is called probabilistic 
inference. The posterior gives a universal sufficient statistic for detection 
applications, when one wants to choose values for the variable subset which 
minimize some expected loss function.

In order to fully specify the Bayesian network and thus fully represent the 
joint probability distribution, it is necessary to specify for each node 
\\(X\\) the probability distribution for \\(X\\) conditional upon \\(X\\)' 
parents. The distribution of \\(X\\) conditional upon its parents may have 
any form. Often there conditional distributions include parameters which are 
unknown and must be estimated from data, sometimes using the maximum likelihood 
approach. Direct maximization of the likelihood (or of the posterior probability) 
is often complex when there are unobserved variables. A classical approach to this 
problem is the expectation-maximization algorithm which alternates computing 
expected values of the unobserved variables conditional on observed data, 
with maximizing the complete likelihood (or posterior) assuming that previously 
computed expected values are correct.

A more fully Bayesian approach to parameters is to treat parameters as additional 
unobserved variables and to compute a full posterior distribution over all nodes 
conditional upon observed data, then to integrate out the parameters. This approach 
can be expensive and lead to large dimension models.

### Expectation Maximization

Given visible variables \\(\mathbb{y}\\), hidden variables \\(\mathbb{x}\\) and model 
parameter \\(\mathbb{\theta}\\), maximizing the likelihood w.r.t. \\(\mathbb{\theta}\\):

$$
\mathcal{L}(\mathbb{\theta}) = \log p(\mathbb{y}|\mathbb{\theta}) = \log \int p(\mathbb{x}, \mathbb{y} | \mathbb{\theta}) d \mathbb{x}
$$

which is the marginal for the visibles written in terms of the integral over the joint 
distribution for hidden and visible varialbes.

Using Jensen's inequality, any distribution over hidden variables \\(q(\mathbb{x})\\) gives 

$$
\mathcal{L}(\mathbb{\theta}) = \log \int q(\mathbb{X}) \frac{p(\mathbb{x}, \mathbb{y} | \mathbb{\theta})}{q(\mathbb{X})} d \mathbb{x} 
\geq \int q(\mathbb{x}) \log \frac{p(\mathbb{x}, \mathbb{y}|\mathbb{\theta})}{q(\mathbb{x})} d \mathbb{x} = \mathcal{F}(q(\mathbb{x}), \mathbb{\theta})
$$

defining the \\(\mathcal{F}(q(\mathbb{x}), \mathbb{\theta})\\) functional, which is a lower bound on the log-likelihood.

In the EM, we alternatively optimize \\(\mathcal{F}(q(\mathbb{x}), \mathbb{\theta})\\) w.r.t. \\(q(\mathbb{x})\\) and \\(\mathbb{\theta}\\), 
and we can prove that this will never decrease \\(\mathcal{L}(\mathbb{\theta})\\).

The lower bound on the log-likelihood:

$$
\mathcal{F}(q(\mathbb{x}), \mathbb{\theta}) = \int q(\mathbb{x})\log\frac{p(\mathbb{x}, \mathbb{y}|\mathbb{\theta})}{q(\mathbb{x})} d \mathbb{x} = \int q(\mathbb{x})\log p(\mathbb{x}, \mathbb{y}|\mathbb{\theta}) d \mathbb{x} + \mathcal{H}(q(\mathbb{x}))
$$

where \\(\mathbb{H}(q(\mathbb{x})) = \int q(\mathbb{x})\log q(\mathbb{x})d\mathbb{x}\\) is the entropy of \\(q(\mathbb{x})\\).

- __E step__: maximize \\(\mathcal{F}(q(\mathbb{x}), \mathbb{\theta})\\) w.r.t. distribution over hidden variables given the parameters:

$$
q^{(k)}(\mathbb{x}) := \arg\max_{q(\mathbb{x})} \mathcal{F}(q(\mathbb{x}), \mathbb{\theta}^{(k-1)})
$$

- __M step__: maximize \\(\mathcal{F}(q(\mathbb{x}), \mathbb{\theta})\\) w.r.t. the parameters given the hidden distribution:

$$
\mathbb{\theta}^{(k)} := \arg\max_{\mathbb{\theta}} \mathcal{F}(q(\mathbb{x}), \mathbb{\theta}) = \arg\max_{\mathbb{\theta}} \int q^{(k)}(\mathbb{x})\log p(\mathbb{x}, \mathbb{y}|\mathbb{\theta})d\mathbb{x}
$$

which is equivalent to optimizing __the expected complete-data__ likelihood \\(p(\mathbb{x},\mathbb{y}|\mathbb{\theta})\\), 
since the entropy of \\(q(\mathbb{x})\\) does not depend on \\(\mathbb{\theta}\\).

The difference between the log-likelihood and the bound:

$$
\begin{align}
\mathcal{L}(\mathbb{\theta}) - \mathcal{F}(q(\mathbb{x}), \mathbb{\theta}) &= \log p(\mathbb{y}|\mathbb{\theta}) - \int q(\mathbb{x})\log\frac{p(\mathbb{x}, \mathbb{y}|\mathbb{\theta})}{q(\mathbb{x})}d\mathbb{x}\\
&= \log p(\mathbb{x}|\mathbb{\theta}) - \int q(\mathbb{x})\log\frac{p(\mathbb{x}, \mathbb{y}|\mathbb{\theta})}{q(\mathbb{x})}d\mathbb{x}\\
&= -\int q(\mathbb{x})\log\frac{p(\mathbb{x}, \mathbb{y}|\mathbb{\theta})}{q(\mathbb{x})}d\mathbb{x}\\
&= \text{KL}(q(\mathbb{x}), p(\mathbb{x}|\mathbb{y}, \mathbb{\theta}))
\end{align}
$$

The KL divergence is non-negative and zero if and only if \\(q(\mathbb{x}) = p(\mathbb{x}|\mathbb{y}, \mathbb{\theta})\\) 
(thus is the E step). Although we are working with a bound on the likelihood, the likelihood is non-decreasing 
in every iteration:

$$
\mathcal{L}(\mathbb{\theta}^{(k-1)}) \underset{\text{E step}}{=} \mathcal{F}(q^{(k)}(\mathbb{x}), \mathbb{\theta}^{(k-1)}) \underset{\text{M step}}{\leq} \mathcal{F}(q^{(k)}(\mathbb{x}), \mathbb{\theta}^{(k)}) \underset{\text{Jensen}}{\leq} \mathcal{L}(\mathbb{\theta}^{(k)})
$$

Usually EM converges to a local optimum of \\(\mathcal{L}(\mathbb{\theta})\\). (of course, there are exceptions.)

### Variational Approximations

Let's first reform EM in the case where \\(\mathbb{x}\\) is discrete: to maximize 
likelihood \\(\ln p(\mathbb{y}\|\mathbb{\theta}\\), andy distribution \\(q(\mathbb{x})\\) 
over the hidden variables defines a lower bound on \\(\ln p(\mathbb{y}\|\mathbb{\theta})\\).

$$
\ln p(\mathbb{y}|\mathbb{\theta}) \geq \sum_{\mathbb{x}} q(\mathbb{x})\ln\frac{p(\mathbb{x},\mathbb{y}|\mathbb{\theta})}{q(\mathbb{x})}=\mathcal{F}(q(\mathbb{x}), \mathbb{\theta})
$$

The key difference in the variational approximations is to constrain \\(q(\mathbb{x})\\) to be of 
a particular tractable form and maximize \\(\mathcal{F}\\) subject to this constraint.

- __E step__: maximize \\(\mathcal{F}(q(\mathbb{x}), \mathbb{\theta})\\) w.r.t. \\(q(\mathbb{x})\\) 
with \\(\mathbb{\theta}\\) fixed, subject to subject to the constraint on \\(q(\mathbb{x})\\), 
equivalently minimize:

$$
\ln p(\mathbb{y}|\mathbb{\theta}) - \mathcal{F}(q(\mathbb{x}), \mathbb{\theta}) = \sum_{\mathbb{x}}q(\mathbb{x})\ln\frac{q(\mathbb{x})}{p(\mathbb{x}|\mathbb{y},\mathbb{\theta})} = \text{KL}(q || p)
$$

- __M step__: maximize \\(\mathcal{F}(q(\mathbb{x}), \mathbb{\theta})\\) w.r.t. \\(\mathbb{\theta}\\) 
with \\(q(\mathbb{x})\\) fixed (related to mean-field approximations)

#### Use Bayesian Occam's Razor to learn model structure

Supppose in a task, the model has \\(m\\) classes, in order to do model selection w.r.t. 
best \\(m\\), we solve for \\(m\\) that gives the highest probability given data \\(\mathbb{y}\\):

$$
p(m|\mathbb{y}) = \frac{p(\mathbb{y}|m)p(m)}{p(\mathbb{y})}
$$

$$
p(\mathbb{y}|m) = \int p(\mathbb{y}|\mathbb{\theta},m)p(\mathbb{\theta}|m)d\mathbb{\theta}
$$

Interpretation of the marginal likelihood (evidence) is the probability that 
randomly selected parameters from the prior would generate \\(mathbb{y}\\).

The presence of the latent variables results in additional dimensions that 
need to be marginalized out:

$$
p(\mathbb{y}|m) = \int\int p(\mathbb{y},\mathbb{x}|\mathbb{\theta},m)p(\mathbb{\theta}|m)d\mathbb{x}d\mathbb{\theta}
$$

The likelihood term can be complicated. There are following practical approaches to 
evaluate it:

- Laplace approximiations
- Large sample approximations (BIC)
- MCMC
- Variational approximations

With variational approximations, we are lower bounding the marginal likelihood: 

$$
\ln p(\mathbb{y}|m) = \ln\int p(\mathbb{y},\mathbb{x},\mathbb{\theta}|m)d\mathbb{x}d\mathbb{\theta} = \ln\int q(\mathbb{x},\mathbb{\theta})\frac{p(\mathbb{y},\mathbb{x},\mathbb{\theta}|m)}{q(\mathbb{x},\mathbb{\theta})}d\mathbb{x}d\mathbb{\theta} \geq \int q(\mathbb{x},\mathbb{\theta})\ln\frac{p(\mathbb{y},\mathbb{x},\mathbb{\theta}|m)}{q(\mathbb{x},\mathbb{\theta})}\d\mathbb{x}d\mathbb{\theta}
$$

Using a simpler, factorised approximation to \\(q(\mathbb{x},\mathbb{\theta}) \approx q_x(\mathbb{x})q_\theta(\mathbb{\theta})\\): 

$$
\ln p(\mathbb{y}|m) \geq \int q_x(\mathbb{x})q_\theta(\mathbb{\theta})\ln\frac{p(\mathbb{y},\mathbb{x},\mathbb{\theta}|m)}{q_x(\mathbb{x})q_\theta(\mathbb{\theta})}d\mathbb{x}d\mathbb{\theta} = \mathcal{F}_m(q_x(\mathbb{x}), q_\theta{\mathbb{\theta}), \mathbb{y})
$$

#### Variational Bayesian learning

Maximizing the above lower bound \\(\mathcal{F}_m\\) leads to EM-like iterative updates:

- __E-like step__: 

$$
q_x^{(t+1)}(\mathbb{x}) \propto \exp[\int\ln p(\mathbb{x},\mathbb{y}|\mathbb{\theta},m)q_\theta^{(t)}(\mathbb{\theta})d\mathbb{\theta}]
$$

- __M-like step__: 

$$
q_\theta^{(t+1)}(\mathbb{\theta}) \propto p(\mathbb{\theta}|m)\exp[\int\ln p(\mathbb{x},\mathbb{y}|\mathbb{\theta},m)q_x^{(t+1)}(\mathbb{x})d\mathbb{x}]
$$

Maximizing \\(\mathcal{F}_m\\) is equivalent to minimizing KL divergence between the approximate posterior 
\\(q_\theta(\mathbb{\theta})q_x(\mathbb{x})\\) and the true posterior \\(p(\mathbb{\theta},\mathbb{x}|\mathbb{y},m)\\): 

$$
\ln p(\mathbb{y}|m) - \mathcal{F}_m(q_x(\mathbb{x}),q_\theta(\mathbb{\theta}),\mathbb{y}) = \int q_x(\mathbb{x})q_\theta(\mathbb{\theta})\ln\frac{q_x(\mathbb{x})q_\theta(\mathbb{\theta})}{p(\mathbb{\theta}, \mathbb{x}|\mathbb{y},m)}d\mathbb{x}d\mathbb{\theta} = \text{KL}(q || p)
$$

#### Compared with EM for MAP

|----+----|
| EM for MAP | Variational Bayesian EM |
+----|----+
| __Goal__: maximize \\(p(\mathbb{\theta}|\mathbb{y},m) w.r.t. \mathbb{\theta} | __Goal__: lower bound \\(p(\mathbb{y}|m)\\) |
| __E step__: Compute \\(q_x^{(t+1)}(\mathbb{x})=p(\mathbb{x}|\mathbb{y},\mathbb{\theta}^{(t)})\\) | __VB-E step__: compute \\(q_x^{(t+1)}(\mathbb{x})=p(\mathbb{x}|\mathbb{y},\bar{\mathbb{\phi}}^{(t)})\\) |
| __M step__: \\(\mathbb{\theta}^{t+1} = \arg\max_{\mathbb{\theta}}\int q_x^{(t+1)}(\mathbb{x})\ln p(\mathbb{x},\mathbb{y},\mathbb{\theta})d\mathbb{x}\\) | __VB-M step__: \\(q_\theta^{(t+1)}(\mathbb{\theta}) \propto \exp [\int q_x^{(t+1)}(\mathbb{x})\ln p(\mathbb{x},\mathbb{y},\mathbb{\theta})d\mathbb{x}]\\) |
|----+----|

It has following properties:

- Reduces to the EM if \\(q_\theta(\mathbb{\theta}) = \delta(\mathbb{\theta} - \mathbb{\theta}^\*)\\)
- \\(\mathcal{F}_m\\) increases monotonically, and incorporates the model complexity penaly
- VB-E step has the same complexity as corresponding E step
- we can use junction tree, belief propagation, Kalman filter, etc algorithms in the VB-E step, 
but using expected natural parameters \\(\bar{\mathbb{\phi}}\\)

#### Conjugate-Exponential models

The conjugate-exponential models follows two conditions:

1. The joint probability over variables is in the exponential families: 

$$
p(\mathbb{x}, \mathbb{y} | \mathbb{\theta}) = f(\mathbb{x}, \mathbb{y}) g(\mathbb{\theta}) \exp\{\mathbb{\phi(\theta)}^T\mathbb{u(x,y)}\}
$$

where \\(\mathbb{\phi(\theta)}\\) is the vector of natural parameters, \\(\mathbb{u(x, y)}\\) are 
sufficient statistics.

2. The prior over parameters is conjugate to this joint probability:

$$
p(\mathbb{\theta}| \eta, \mathbb{\upsilon}) = h(\eta, \mathbb{\upsilon}) g(\mathbb{\theta})^\eta \exp\{\mathbb{\phi(\theta)}^T\mathbb{\upsilon}\}
$$

  where \\(\eta\\) and \\(\mathbb{\upsilon}\\) are hyperparameters of the prior.
  
  Conjugate priors are computationally convenient and have an intuitive interpretation: 
  
  - \\(\eta\\): number of pseudo-observations
  - \\(\mathbb{\upsilon}\\): value of pseudo-observations

#### Annealed Importance Sampling (AIS)

AIS is a state-of-the-art method for estimating marginal likelihood, by breaking a difficult 
integral into a series of easier ones. It combines the ideas from importance sampling, 
Markov chain Monte Carlo and annealing:

Define \\(Z_k = \int d\mathbb{\theta} p(\mathbb{\theta}|m)p(\mathbb{y}|\mathbb{\theta}, m)^{\tau(k)} = \int d\mathbb{\theta}f_k(\mathbb{\theta})\\)

with \\(\tau(0) = 0 \Rightarrow Z_0 = \int d\mathbb{\theta} p(\mathbb{\theta}|m) = 1 \leftarrow \text{normalisation factor}\\)

with \\(\tau(K) = 1 \Rightarrow Z_K = p(\mathbb{y}|m) \leftarrow \text{marginal likelihood}\\)

and we have \\(\frac{Z_K}{Z_0} = \frac{Z_1}{Z_0} \cdot \frac{Z_2}{Z_1} \cdots \frac{Z_K}{Z_{K-1}}\\)

To importance sample from \\(f_{k-1}(\mathbb{\theta})\\):

$$
\frac{Z_k}{Z_{k-1}} \equiv \int d\mathbb{\theta} \frac{f_k(\mathbb{\theta})}{f_{k-1}(\mathbb{\theta})}\frac{f_{k-1}(\mathbb{\theta})}{Z_{k-1}} \approx \frac{1}{R}\sum\nolimits_{r=1}{R}\frac{f_k(\mathbb{\theta}^{(r)})}{f_{k-1}(\mathbb{\theta}^{(r)})} = \frac{1}{R} \sum\nolimits_{r=1}^R p(\mathbb{y}|\mathbb{\theta}^{(r)}, m)^{\tau(k) - \tau(k-1)}
$$

with \\(\mathbb{\theta}^{(r)} \sim f_{k-1}(\mathbb{\theta})\\)

### Variational Inference

Supppose in a Bayesian network, we have observed variables \\(\mathbb{V}\\) and 
hidden variables \\(\mathbb{H}\\), with \\(\mathbb{H}\\) including parameters and 
latent variables, the learning/inference process involves finding \\(P(H_1, H_2, \cdots \| \mathbb{V})\\).

$$
P(\mathbb{\theta}|\mathbb{V}) = \frac{P(\mathbb{V}|\mathbb{\theta})P(\mathbb{\theta})}{P(\mathbb{V})} \propto P(\mathbb{V}|\mathbb{\theta})P(\mathbb{\theta})
$$

### Link to Gibbs Sampling

For a joint density \\(f(x, y_1, y_2, \cdots, y_k)\\), we are interested in some features of the marginal 
density.

$$
f(x) = \int\int\cdots\int f(x, y_1, y_2, \cdots, y_k)dy_1dy_2\cdotsdy_k
$$

For instance, the average \\(\mathcal{E}[X] = \int xf(x) dx\\).

If we can sample from the marginal distribution, then we can approximate it with \\(\lim_{n\to\infty}\frac{1}{n}\sum\nolimits_{i=1}^n X_i = \mathcal{E}[X]\\) 
without using \\(f(x)\\) explicitly in integration.

We may take the last \\(n\\) \\(X\\)-values after many Gibbs passes \\(\frac{1}{n}\sum\nolimits_{i=m}^{m+n}X^i \approx \mathcal{E}[X]\\), 
or take the last value \\(x_i^{n_i}\\) of \\(n\\)-many sequences of Gibbs passes \\(\frac{1}{n}\sum\nolimits_{i=i}^n X_i^{n_i} \approx \mathcal{E}[X]\\).

In the EM, \\(\mathcal{L}(\mathbb{\theta}; \mathbb{x})\\) is the likelihood function for 
\\(\mathbb{\theta}\\) w.r.t. the incomplete data \\(\mathbb{x}\\). \\(\mathcal{L}(\mathbb{\theta};(\mathbb{x},\mathbb{z}))\\) 
is the likelihood function for \\(\mathbb{\theta}\\) w.r.t. the complete data \\((\mathbb{x}, \mathbb{z})\\). 
\\(\mathcal{L}(\mathbb{\theta}; \mathbb{z}|\mathbb{x})\\) is the conditional likelihood for 
\\(\mathbb{\theta}\\) w.r.t. \\(\mathbb{z}\\) given \\(\mathbb{x}\\), which is based on 
\\(h(\mathbb{z}|\mathbb{x},\mathbb{\theta})\\) the conditional density for the data \\(\mathbb{z}\\), 
given \\(\mathbb{x}, \mathbb{\theta}\\).

As \\(f(\mathbb{x}|\mathbb{\theta}) = \frac{f(\mathbb{x}, \mathbb{z} | \mathbb{\theta})}{h(\mathbb{z} | \mathbb{x}, \mathbb{\theta})}\\), 
we have:

$$
\log \mathcal{L}(\mathbb{\theta}; \mathbb{x}) = \log \mathcal{L}(\mathbb{\theta}; (\mathbb{x}, \mathbb{z})) - \log \mathcal{L}(\mathbb{\theta}; \mathbb{z}|\mathbb{x}) \label{*}
$$

We use the EM algorithm to compute the MLE \\(\hat{\mathbb{\theta}} = \arg\max_{\mathbb{\theta}} \mathcal{L}(\mathbb{\theta}; \mathbb{x})\\).

With an arbitrary choice of \\(\hat{\mathbb{\theta}}_0\\), define (E step): 

$$
Q(\mathbb{\theta}|\mathbb{x}, \hat{\mathbb{\theta}}_0) = \int h(\mathbb{z}|\mathbb{x}, \hat{\mathbb{\theta}}_0)\log \mathcal{L}(\mathbb{\theta}; \mathbb{x}, \mathbb{z}) d\mathbb{z}
$$

$$
H(\mathbb{\theta}|\mathbb{x}, \hat{\mathbb{\theta}}_0) = \int h(\mathbb{z}|\mathbb{x}, \hat{\mathbb{\theta}}_0)\log \mathcal{L}(\mathbb{\theta}; \mathbb{z}|\mathbb{x}) d\mathbb{z}
$$

Then we have: 

$$
\log \mathcal{L}(\mathbb{\theta};\mathbb{x}) = Q(\mathbb{\theta}|\mathbb{x},\mathbb{\theta}_0) - H(\mathbb{\theta}|\mathbb{x}, \mathbb{\theta}_0)
$$

As we integrated out \\(\mathbb{z}\\) from \\(\ref{*}\\) using the conditional 
density \\(h(\mathbb{z}|\mathbb{x}, \hat{\mathbb{\theta}}_0)\\).

The EM algorithm is an iteration of 

1. __E step__: determine the integral \\(Q(\mathbb{\theta}|\mathbb{x}, \hat{\mathbb{\theta}}_j)\\)
2. __M step__: define \\(\hat{\mathbb{\theta}}_{j+1}\\) as \\(\arg\max_{\mathbb{\theta}} Q(\mathbb{\theta}|\mathbb{x}, \hat{\mathbb{\theta}}_j)\\)

continue until there is convergence of the \\(\hat{\mathbb{\theta}}_j\\).

#### Generalized EM algorithm

Let \\(p(\mathbb{z})\\) be any distribution over the augumented data \\(\mathbb{z}\\), with 
density \\(p(\mathbb{z})\\).

Define 

$$
\mathcal{F}(\mathbb{\theta}, p(\mathbb{z})) = \int p(\mathbb{z})\log\mathcal{L}(\mathbb{\theta};\mathbb{x}, \mathbb{z})d\mathbb{z} - \int p(\mathbb{z})\log p(\mathbb{z}) d\mathbb{z} = \mathcal{E}_p[\log \mathcal{L}(\mathbb{\theta}; \mathbb{x}, \mathbb{z})] - \mathcal{E}_p[\log p(\mathbb{z})]
$$

when \\(p(\mathbb{z}) = h(\mathbb{z}|\mathbb{x}, \hat{\mathbb{\theta}}_0)\\) from above, the 
\\(\mathcal{F}(\mathbb{\theta}, p(\mathbb{z})) = \log\mathcal{L}(\mathbb{\theta}; \mathbb{x})\\).

__Claim__: for a fixed (arbitrary) value \\(\mathbb{\theta} = \hat{\mathbb{\theta}}_0\\), 
\\(\mathcal{F}(\hat{\mathbb{\theta}}_0, p(\mathbb{z}))\\) is maximized over distribution 
\\(p(\mathbb{z})\\) by choosing \\(p(\mathbb{z}) = h(\mathbb{z}|\mathbb{x},\hat{\mathbb{\theta}}_0)\\).

Thus the EM algorithm is a sequence of M-M steps: 

- the old E step now is a max over the second term in \\(\mathcal{F}(\hat{\mathbb{\theta}}_0, p(\mathbb{z}))\\), 
given the first term

- the second step remains (as in EM) a max over \\(\mathbb{\theta}\\) for a fixed second term, which does 
not involve \\(\mathbb{\theta}\\)

Suppose that the augumented data \\(\mathbb{z}\\) are multidimensional, consider the GEM approach and, 
instead of maximizing the choice of \\(p(\mathbb{z})\\) over all of the augumented data - instead of 
the old E step - instead maximize over only one coordinate of \\(\mathbb{z}\\) at a time, alternating 
with the (old) M step.

This gives the link with Gibbs algorithm: instead of maximizing at each of these two steps, use the 
conditional distributions, we sample from them.

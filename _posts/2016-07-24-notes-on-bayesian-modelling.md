---
layout: post
category: [math]
tags: [stat, bayesian, math]
infotext: "notes on bayesian modelling"
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

So after a long time, I finally re-pick up Bayesian Analysis that it is so basic and powerful and 
easy to use that you can hardly avoid using it.

In the application of hierarchical models to represent latent process variables, letting 
\\([\mathrm{A}, \mathrm{B}]\\) and \\([\mathrm{A}|\mathrm{B}]\\) denote joint and conditional 
densities respectively, the paradigm for a hierarchical model specifies

$$
\begin{align}
[\text{Process}, \text{Parameters}|\text{Observations}] \propto& [\text{Observations}|\text{Process}, \text{Parameters}]\\
{}& [\text{Process}|\text{Parameters}] [\text{Parameters}]
\end{align}
$$

based on an assumption that observations are imperfect realisations of an underlying process and 
that units are exchangeable. Usually the observations are considered conditionally independent 
given the process and parameters.

### Prior, Likelihood, and Posterior densities

#### Prior densities

In classical inference the sample data \\(y\\) are taken as random while population parameters 
\\(\boldsymbol{\theta}\\), of dimension \\(p\\), are taken as fixed. In Bayesian analysis, 
parameters themselves follow a probability distribution, knowledge about which (before considering 
the data at hand) is summarised in a prior distribution \\(\pi(\boldsymbol{\theta})\\). In many 
situations it might be beneficial to include in this prior density cumulative evidence about a 
parameter from previous scientific studies.

In many situations, existing knowledge may be difficult to summarise or elicit in the form of an 
informative prior, and to reflect such essentially prior ignorance, resort is made to 
non-informative priors. Examples are flat priors (e.g. that a parameter is uniformly distributed 
between \\(-\infty\\) and \\(+\infty\\)) and Jeffreys prior 
\\(\pi(\boldsymbol{\theta}) \propto \text{det}\\{I(\boldsymbol{\theta})\\}^{0.5}\\), where 
\\(I(\boldsymbol{\theta})\\) is the expected information1 matrix. It is possible that a prior is 
improper (does not integrate to \\(1\\) over its range). Such priors may add to identifiability 
problems, especially in hierarchical models with random effects intermediate between 
hyperparameters and data.

An alternative strategy is to adopt vague (minimally informative) priors which are 'just proper'. 
This strategy is considered below in terms of possible prior densities to adopt for the variance 
or its inverse. An example for a parameter distributed over all real values might be a normal with 
mean zero and large variance. To adequately reflect prior ignorance while avoiding impropriety, 
it is suggested a prior standard deviation at least an order of magnitude greater than the 
posterior standard deviation.

#### Update knowledge based on data

In classical approaches such as maximum likelihood, inference is based on the likelihood of the 
data alone. In Bayesian models, the likelihood of the observed data \\(y\\), given a set 
of parameters \\(\boldsymbol{\theta} = (\theta_1, \dots, \theta_d)\\), denoted 
\\(p(y|\boldsymbol{\theta})\\) or equivalently \\(\mathrm{L}(\boldsymbol{\theta}|y)\\), is used to 
modify the prior beliefs \\(\pi(\boldsymbol{\theta})\\). Updated knowledge based on the observed 
data and the information contained in the prior densities is summarised in a posterior density, 
\\(\pi(\boldsymbol{\theta}|y)\\). 

The relationship between these densities follows from standard probability relations. Thus 

$$
p(y, \boldsymbol{\theta}) = p(y|\boldsymbol{\theta})\pi(\boldsymbol{\theta}) = \pi(\boldsymbol{\theta}|y)p(y)
$$

and therefore the posterior density can be written

$$
\pi(\boldsymbol{\theta}|y) = \frac{p(y|\boldsymbol{\theta})\pi(\boldsymbol{\theta})}{p(y).}
$$

The denominator \\(p(y)\\) is a known as the marginal likelihood of the data, and found by 
integrating the likelihood over the joint prior density

$$
p(y) = \int p(y | \boldsymbol{\theta}) \pi(\boldsymbol{\theta}) d\boldsymbol{\theta}
$$

This quantity plays a central role in formal approaches to Bayesian model choice, but for the 
present purpose can be seen as an unknown proportionality factor, so that 

$$
\pi(\boldsymbol{\theta}|y) \propto p(y | \boldsymbol{\theta})\pi(\boldsymbol{\theta})
$$

or equivalently

$$
\pi(\boldsymbol{\theta}|y) = \mathrm{k} p(y|\boldsymbol{\theta})\pi(\boldsymbol{\theta})
$$

The product \\(\pi_u(\boldsymbol{\theta}|y) = p(y|\boldsymbol{\theta})\pi(\boldsymbol{\theta})\\) 
is sometimes called the un-normalised posterior density.

From the Bayesian perspective, the likelihood is viewed as a function of \\(\boldsymbol{\theta}\\) 
given fixed data \\(y\\) and so elements in the likelihood that are not functions of 
\\(\boldsymbol{\theta}\\) become part of the proportionality constant.

Similarly, for a hierarchical model, let \\(Z\\) denote latent variables depending on 
hyperparameters \\(\boldsymbol{\theta}\\). Then one has

$$
\pi(Z, \boldsymbol{\theta}|y) = \frac{p(y | Z, \boldsymbol{\theta})p(Z|\boldsymbol{\theta})\pi(\boldsymbol{\theta})}{p(y)}
$$

or equivalently

$$
\pi(Z, \boldsymbol{\theta}|y) = \mathrm{k} p(y | Z, \boldsymbol{\theta}) p(Z | \boldsymbol{\theta}) \pi(\boldsymbol{\theta})
$$

It expresses mathematically the process whereby updated beliefs are a function of prior knowledge 
and the sample data evidence.

#### The full conditional density for individual parameter

The notion of the full conditional density for individual parameters (or parameter blocks) 
\\(\theta_j\\), is

$$
p(\theta_j | \theta_{[j]}, y) = \frac{p(\boldsymbol{\theta} | y)}{p(\theta_{[j]} | y)}
$$

, where \\(\theta_{[j]} = (\theta_1, \dots, \theta_{j-1}, \theta_{j+1}, \dots, \theta_p)\\) denotes 
the parameter set excluding \\(\theta_j\\). These densities are important in MCMC sampling.

The full conditional density can be abstracted from the un-normalised posterior density 
\\(\pi_u(\boldsymbol{\theta} | y)\\) by regarding all terms except those involving \\(\theta_j\\) 
as constants.

### Prediction

Before the study a prediction would be based on random draws from the prior density of parameters 
and is likely to have little precision. Part of the goal of a new study is to use the data as a 
basis for making improved predictions or evaluation of future options.

Thus in a meta-analysis of mortality odds ratios (e.g. for a new as against conventional therapy), 
it may be useful to assess the likely odds ratio \\(y_{\text{rep}}\\) in a hypothetical future 
study on the basis of findings from existing studies. Such a prediction is based on the likelihood 
of \\(y_{\text{rep}}\\) averaged over the posterior density based on \\(y\\):

$$
p(y_{\text{rep}} | y) = \int p(y_{\text{rep}} | \boldsymbol{\theta}) \pi(\boldsymbol{\theta}|y) d\boldsymbol{\theta}
$$

where the likelihood of \\(p(y_{\text{rep}})\\), \\(p(y_{\text{rep}} | \boldsymbol{\theta})\\), 
usually takes the same form as adopted for the observations themselves.

In a hierarchical model, one has

$$
p(y_{\text{rep}} | y) = \int_{\boldsymbol{\theta}} \int_Z p(y_{\text{rep}} | \boldsymbol{\theta}, Z) p(\boldsymbol{\theta}, Z | y) d\boldsymbol{\theta}dZ
$$

One may also derive

$$
p(y_i | y_{[i]}) = \int p(y_i | \boldsymbol{\theta})\pi(\boldsymbol{\theta}|y_{[i]})\pi(\boldsymbol{\theta})d\boldsymbol{\theta}
$$

, namely the probability of \\(y_i\\) given the rest of the data. This is known as the conditional 
predictive ordinate (CPO) and is equivalent to the leave-one-out posterior predictive distribution 

$$
p(y_{\text{rep},i} | y_{[i]}) = \int p(y_{\text{rep}, i} | \boldsymbol{\theta})\pi(\boldsymbol{\theta}|y_{[i]})\pi(\boldsymbol{\theta})d\boldsymbol{\theta}
$$

evaluated at the observed value \\(y_i\\). Observations with low CPO values are not well fitted by 
the model. Predictive checks may be made comparing \\(y_i\\) and \\(y_{\text{rep}, i}\\), providing 
cross-validatory posterior p-values 

$$
\text{Pr}(y_i \gt y_{\text{rep}, i} | y_{[i]})
$$

, to assess whether predictions tend to be larger or smaller than the observed values.

### Sampling parameters

To update knowledge about the parameters requires that one can sample from the posterior density. 
From the viewpoint of sampling from the density of a particular parameter \\(\theta_j\\), it 
follows that things in the likelihood which are not functions of \\(\theta_j\\) may be omitted.

In more general situations, with many parameters in \\(\boldsymbol{\theta}\\) and with possibly 
non-conjugate priors, analytic forms of the posterior density are typically unavailable, but the 
goal is still to estimate the marginal posterior of a particular parameter \\(\theta_j\\) given 
the data. This involves integrating out all the parameters but this one

$$
p(\theta_j | y) = \int p(\theta_j | \theta_{[j]})p(\theta_{[j]}|y)d\theta_{[j]}
$$

Such integrations in the past involved demanding methods such as numerical quadrature.

MCMC methods use various techniques to sample repeatedly from the joint posterior of all the 
parameters \\(p(\theta_1, \theta_2, \dots, \theta_d|y)\\), without undertaking such integrations. 
Note, however, that unlike simple Monte Carlo sampling, estimation is complicated by features 
such as correlation between samples.

#### The Metropolis–Hastings algorithm

Assume a preset initial parameter value \\(\boldsymbol{\theta}^{(0)}\\). Then MCMC methods involve 
generating a correlated sequence of sampled values \\(\boldsymbol{\theta}^{(t)} (t = 1, \dots, T)\\), 
with updated values \\(\boldsymbol{\theta}^{(t)}\\) drawn from a transition sequence

$$
\mathrm{K}(\boldsymbol{\theta}^{(t)} | \boldsymbol{\theta}^{(0)}, \dots, \boldsymbol{\theta}^{(t-1)}) = \mathrm{K}(\boldsymbol{\theta}^{(t)} | \boldsymbol{\theta}^{(t-1)})
$$

that is Markovian in the sense of depending only on \\(\boldsymbol{\theta}^{(t-1)}\\).

The transition kernel \\(\mathrm{K}(\boldsymbol{\theta}^{(t)} | \boldsymbol{\theta}^{(t-1)})\\) is 
required to satisfy certain conditions (irreducibility, aperiodicity, positive recurrence) to ensure 
that the sequence of sampled parameters has the joint posterior density 
\\(p(\boldsymbol{\theta}|y)\\) as its stationary distribution. These conditions amount to 
requirements on the proposal distribution and acceptance rule used to generate new parameters.

The Metropolis−Hastings algorithm is the baseline for MCMC sampling schemes. Let 
\\(\boldsymbol{\theta}'\\) be a candidate parameter value generated by a proposal density 
\\(q(\boldsymbol{\theta}'|\boldsymbol{\theta}^{(t)})\\). The candidate value has probability of 
acceptance

$$
\alpha(\boldsymbol{\theta}', \boldsymbol{\theta}^{(t)}|y) = \min (1, \frac{p(\boldsymbol{\theta}'|y)q(\boldsymbol{\theta}^{(t)}|\boldsymbol{\theta}')}{p(\boldsymbol{\theta}^{(t)}|y)q(\boldsymbol{\theta}'|\boldsymbol{\theta}^{(t)})})
$$

with transition kernel 
\\(\mathrm{K}(\boldsymbol{\theta}^{(t)}|\boldsymbol{\theta}^{(t-1)}) = \alpha(\boldsymbol{\theta}', \boldsymbol{\theta}^{(t)}|y)q(\boldsymbol{\theta}' | \boldsymbol{\theta}^{(t)})\\)
. If the chosen proposal density is symmetric, so that 
\\(q(\boldsymbol{\theta}'|\boldsymbol{\theta}^{(t)}) = q(\boldsymbol{\theta}^{(t)}|\boldsymbol{\theta})'\\)
, then the M-H algorithm reduces to the Metropolis algorithm whereby

$$
\alpha(\boldsymbol{\theta}', \boldsymbol{\theta}^{(t)}|y) = \min (1, \frac{p(\boldsymbol{\theta}'|y)}{p(\boldsymbol{\theta}^{(t)}|y)})
$$

A particular symmetric density in which 
\\(q(\boldsymbol{\theta}'|\boldsymbol{\theta}^{(t)}) = q(|\boldsymbol{\theta}^{(t)}-\boldsymbol{\theta}'|)\\) 
leads to random walk Metropolis updating. Typical Metropolis updating schemes use uniform and 
normal densities.

##### Take an example

A normal proposal with variance \\(\delta^2_q\\) involves standard normal samples 
\\(h_t \sim \mathrm{N}(0, 1)\\). A uniform random walk samples uniform variates 
\\(h_t \sim \mathrm{U}(−1, 1)\\) and scales these to form a proposal
$$
\boldsymbol{\theta}' = \boldsymbol{\theta}^{(t)} + \kappa h_t
$$

, with the value of \\(\kappa\\) determining the potential shift. Parameters \\(\delta_q\\) and 
\\(\kappa\\) may be varied to achieve a target acceptance rate for proposals. A useful 
modification of random walk Metropolis for constrained (e.g. positive or probability) parameters 
involves reflexive random walks. For example, suppose \\(\theta\\) is a probability and a value 
\\(\theta' = \theta^{(t)} + u^{(t)}\\), where \\(u^{(t)} \sim \mathrm{U}(-\kappa, \kappa)\\), is 
sampled. Then if \\(-1 \lt \theta' \lt 0\\), one sets \\(\theta' = |\theta'|\\), and if 
\\(|\theta'| \gt 1\\), one sets \\(\theta' = 1\\). Truncated normal sampling can also be used, 
as in

$$
\theta' \sim \mathrm{N}(\theta^{(t)}, \delta_q^2)\mathrm{I}(0, 1)
$$

Evaluating the ratio of \\(\frac{p(\boldsymbol{\theta}'|y)}{p(\boldsymbol{\theta}^{(t)} | y)}\\) in 
practice involves a comparison of the unstandardised posterior densityt. In practice also the 
parameters are updated individually or in sub-blocks of the overall parameter set. In fact, for 
updating a particular parameter, with proposed value \\(\theta'\_j\\) from a proposal density 
specific to \\(\theta_j\\), all other parameters than the jth can be regarded as fixed. So all 
terms in the ratio \\(\frac{p(\boldsymbol{\theta}'|y)}{p(\boldsymbol{\theta}^{(t)} | y)}\\) cancel 
out, apart from those in the full conditional densities \\(p(\theta_j|y, \theta_{[j]})\\). So for 
updating parameter \\(j\\), one may consider the ratio of full conditional densities evaluated at 
the candidate and current values respectively

$$
\frac{p(\boldsymbol{\theta}'_j|y, \theta_{[j]})q(\boldsymbol{\theta}^{(t)}|\boldsymbol{\theta}^*)}{p(\boldsymbol{\theta}^{(t)}_j|y,\theta_{[j]})q(\boldsymbol{\theta}^*|\boldsymbol{\theta}^{(t)})}
$$

where \\(\boldsymbol{\theta}^* = (\theta_1, \dots, \theta_{j-1}, \theta'\_j, \theta_{j+1}, \dots, \theta_p)\\). 
It may in practice be easier (if not strictly necessary) to program using the ratio

$$
\frac{\mathrm{L}(\boldsymbol{\theta}^*|y)\pi(\boldsymbol{\theta}^*)q(\boldsymbol{\theta}|\boldsymbol{\theta}^*)}{\mathrm{L}(\boldsymbol{\theta}|y)\pi(\boldsymbol{\theta})q(\boldsymbol{\theta}^*|\boldsymbol{\theta})}
$$

If the proposal \\(\boldsymbol{\theta}'\\) is rejected, the parameter value at iteration \\(t + 1\\) 
is the same as at iteration \\(t\\). The acceptance rate for proposed parameters depends on how 
close \\(\boldsymbol{\theta}'\\) is to \\(\boldsymbol{\theta}^{(t)}\\), which is influenced by the 
variance of the proposal density. For a normal proposal density, 
\\(q(\boldsymbol{\theta}'|\boldsymbol{\theta}^{(t)}) = \mathrm{N}(\boldsymbol{\theta}^{(t)}, \delta_q^2)\\)
, a higher acceptance rate follows from reducing \\(\delta_q\\), but this implies slower exploration 
of the posterior density.

#### Gibbs sampling

The Gibbs sampler is a special componentwise M-H algorithm whereby the proposal density for 
updating \\(\theta_j\\) is the full conditional \\(p(\theta_j|y, \theta_{[j]})\\), so that 
proposals are accepted with probability \\(1\\). Successive samples from full conditional 
densities may involve sampling from analytically defined densities (gamma, normal, Student t, 
etc.), or by sampling from non-standard densities.

In some instances the full conditionals may be converted to simpler forms by introducing
latent data \\(w_i\\), either continuous or discrete, a device known as data augmentation. 

#### INLA approximations

Integrated nested Laplace approximations (INLA) are an alternative to estimation and inference 
via MCMC in latent Gaussian models, which are a particular form of hierarchical model. This 
includes a wide class of models, including generalised linear models, spatial data applications, 
survival data, and time series.

Denote the observations as \\(\boldsymbol{y}\\), and Gaussian distributed random effects (or latent 
Gaussian field) as \\(\boldsymbol{x}\\). Then with \\(\boldsymbol{\theta}\\) denoting 
hyperparameters, the assumed hierarchical model is

$$
y_i | x_i \sim p(y_i | x_i, \theta_1)
$$

$$
x_i | \theta_2 \sim \pi(\boldsymbol{x}|\theta_2) = \mathrm{N}(., Q^{-1}(\theta_2))
$$

$$
\boldsymbol{\theta} \sim \pi(\boldsymbol{\theta})
$$

with posterior density

$$
\pi(\boldsymbol{x}, \boldsymbol{\theta} | \boldsymbol{y}) \propto \pi(\boldsymbol{\theta})\pi(\boldsymbol{x}|\theta_2)\prod_i p(\boldsymbol{y}_i|\boldsymbol{x}_i, \theta_1)
$$

Integrated nested Laplace approximation is a deterministic algorithm, as opposed to a stochastic 
algorithm such as MCMC, specifially designed for latent Gaussian models. The focus in the algorithm 
is on posterior density of the hyperparameters,

$$
\pi(\boldsymbol{\theta}|\boldsymbol{y})
$$

and on the conditional posterior of the latent field

$$
\pi(x_i | \boldsymbol{\theta}, \boldsymbol{y})
$$

The algorithm uses a Laplace approximation for the posterior density of the hyperparameters, denoted 

$$
\pi(\boldsymbol{\theta}|y)
$$

and a Taylor approximation for the conditional posterior of the latent field, denoted 

$$
\pi(x_i | \boldsymbol{\theta}, \boldsymbol{y})
$$

From these approximations, marginal posteriors are obtained as

$$
\tilde{\pi}(x_i | \boldsymbol{y}) = \int \pi(\boldsymbol{\theta}|\boldsymbol{y})\pi(x_i|\boldsymbol{\theta}, \boldsymbol{y})d\boldsymbol{\theta}
$$

$$
\tilde{\pi}(\theta_j|\boldsymbol{y}) = \int \pi(\boldsymbol{\theta}|\boldsymbol{y})d\theta_{[j]}
$$

where \\(\theta_{[j]}\\) denotes \\(\boldsymbol{\theta}\\) excluding \\(\theta_j\\), and 
integrations are carried out numerically. An estimate for the marginal likelihood is provided by 
the normalising constant for \\(\tilde{\pi}(\boldsymbol{\theta}|\boldsymbol{y})\\).

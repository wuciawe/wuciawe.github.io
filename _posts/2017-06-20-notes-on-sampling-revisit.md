In previous post [efficient sampling from known distribution]({%post_url 2016-08-24-efficient-sampling-from-known-distribution%}), 
I have introduced how to perform sampling from a distribution. In this post, I will talk about 
some different kinds of sampling algorithms.

### Monte Carlo Sampling

Monte Carlo sampling is often used in two kinds of problems:

- Sampling from a distribution \\(p(x)\\), which is often a posterior distribution
- Approximating integrals of the form \\(\int f(x)p(x) dx\\) by computing expectation of 
\\(f(x)\\) with density \\(p(x)\\).

Suppose \\(\{x^{(i)}\}\\) is an i.i.d. random sample drawn from \\(p(x)\\). Then the __strong 
law of large numbers__ has:

$$
\frac{1}{N}\sum_{i=1}^N f(x^{(i)}) \stackrel{\text{a.s}}{\longrightarrow} \int f(x)p(x)dx
$$

Moreover, the rate of convergence is proportional to \\(\sqrt{N}\\). However, the proportionality 
constant increases exponentially with the dimension of the integral.

### Rejection Sampling

Suppose we want to sample from the density \\(p(x)\\) as shown in 
[!](2017-06-20-notes-on-sampling-revisit/reject_sampling.jpg). 
If we can sample uniformly 
from the 2-D region under the curve, then this process is the same as sampling from \\(p(x)\\). 
In rejection sampling, another density \\(q(x)\\) is considered from which we can sample directly 
under the restriction that \\(p(x) < M q(x)\\) where \\(M > 1\\) is an appropriate bound on 
\\(\frac{p(x)}{q(x)}\\). The rejection sampling algorithm is described below.

i <- 0
while i \neq N do
  x^{(i)} \sim q(x)
  u \sim U(0,1)
  if u < \frac{p(x^{(i)})}{M q(x^{(i)})} then
    accept x^{(i)}
    i <- i + 1
  else
    reject x^{(i)}
  end if
end while

Informally, all this process does is sampling \\(x^{(i)}\\) from some distribution and then it 
decides whether to accept it or reject. The main problem with this process is that \\(M\\) is 
generally large in high-dimensional spaces and since \\(p(accept) \propto \frac{1}{M}\\), 
rejection rate will be large.

### Importance Sampling

The goal is to compute \\(I(f) = \int f(x)p(x) dx\\). If we have a density \\(q(x)\\) which is 
easy to sample from, we can sample \\(x^{(i)} \sim q(x)\\). Define the importance weight as:

$$
w(x^{(i)}) = \frac{p(x^{(i)})}{q(x^{(i)})}
$$

Consider the weighted Monte Carlo sum:

$$
\frac{1}{N}\sum_{i=1}^N f(x^{(i)}) w(x^{(i)}) = \frac{1}{N} \sum_{i=1}^N f(x^{(i)}) \frac{p(x^{(i)})}{q(x^{(i)})}\\
\stackrel{\text{a.s}}{\longrightarrow} \int (f(x)\frac{p(x)}{q(x)}) q(x) dx \\
= \int f(x)p(x) dx
$$

In principle, we can sample from any distribution \\(q(x)\\). In practice, we would like 
to choose \\(q(x)\\) as close as possible to \\(|f(x)|w(x)\\) to reduce the variance of 
our estimator.

Remark 1. We do not need to know the normalization constants for \\(p(x)\\) and \\(q(x)\\). 
Sine \\(w = \frac{p}{q}\\), we can compute 

$$
\int f(x)p(x) dx \approx \frac{\sum_{i=1}^N f(x^{(i)})w(x^{(i)})}{\sum_{i=1}^N w(x^{(i)})}
$$

where because of the ratio, the normalizing constants will cancel.

Thus, we can now compute integrals using importance sampling. However, we do not directly 
get samples from \\(p(x)\\). To get samples from \\(p(x)\\), we must sample from the weighted 
sample from our importance sampler. This process is called __Sampling Importance Re-sampling__, 
which is described below.

Now, combing back to the question of how to pick \\(q(x)\\). Ideally, we would like to pick 
\\(q(x)\\) such that the variance of \\(f(x)w(x)\\) is minimum.

$$
Var_{q(x)} f(x)w(x) = \mathbb{E}_{q(x)} {f(x)}^2{w(x)}^2 - {I(f)}^2
$$
$$
\mathbb{E}_{q(x)}{f(x)}^2{w(x)}^2 \geq (\mathbb{E}|f(x)|w(x))^2 (Jensen's Inequality)\\
= (\int |f(x)|p(x) dx)^2
$$

The term \\({I(f)}^2\\) is independent of \\(q\\). So, the best \\(q^*(x)\\) which 
makes the variance minimum is given by:

$$
q^*(x) = \frac{|f(x)|p(x)}{\int |f(x)|p(x) dx}
$$

One with picking \\(q(x)\\) is that since \\(p(x)\\) was hard to sample from thus, 
\\(|f(x)|p(x)\\) usually would also be hard to sample from.

### Sampling Importance Re-sampling

SIR is simply sampling

$$
x^{(i)*} \sim \hat{p}_N(x) = \frac{1}{N} \sum_{i=1}^N w(x^{(i)})\delta_{x^{i}}(x)
$$

This generates a sample from \\(p(x)\\) and is really just sampling with replacement from 
collection \\(\{x^{(i)}\}\\) with probability proportional to normalized weights.

$$
\hat{\hat{p}}_N (x) = \frac{1}{N} \sum_{i=1}^N \delta_{x^{(i)*}}(x)
$$

Statistically, there is no advantage in working with SIR because of the introduction of 
variance again in re-sampling.
$$

### Metropolis-Hastings

In Metropolis-Hastings sampling, samples mostly move towards higher density regions, but 
sometimes also move downhill. In comparison to rejection sampling where we always throw 
away the rejected samples, here we sometimes keep those samples as well.

Init x^{(0)}
for i = 0 to N-1 do
  u \sim U(0,1)
  x^* \sim q(x^* | x^{(i)})
  if u < \min{1, \frac{p(x^*)q(x^{(i)}|x^*)}{p(x^{(i)})q(x^*|x^{(i)})}} then 
    x^{(i+1)} <- x^*
  else
    x^{(i+1)} <- x^{(i)}
  end if
end for

Remark 2. In line 5 of the algorithm, if \\(q\\) is symmetric then \\(\frac{q(x^{(i)}|x^*)}{q(x^*|x^{(i)})}=1\\). 
This term was later introduced to the original Metropolis algorithm by Hastings.

https://people.eecs.berkeley.edu/~jordan/courses/260-spring10/lectures/lecture17.pdf

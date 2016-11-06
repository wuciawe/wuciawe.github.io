---
layout: post
category: [math]
tags: [stat, math]
infotext: "The distribution of order statistics and the confidence interval for percentile."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

Sample statistics such as sample median, sample quartiles and sample minimum and maximum play a 
prominent role in the analysis using empirical data.

### The distribution of order statistics

Let \\(X_1,X_2, \cdots, X_n\\) be a random sample of size \\(n\\) from a continuous distribution 
with distribution function \\(F(x)\\). We order the random sample in increasing order and obtain 
\\(Y_1,Y_2, \cdots, Y_n\\).

The order statistic \\(Y_i\\) is called the \\(i^{th}\\) order statistic. Since we are working 
with a continuous distribution, we assume that the probability of two sample items being equal is 
zero. Thus we can assume that \\(Y_1 < Y_2 < \cdots < Y_n\\). That is, the probability of a tie is 
zero among the order statistics.

#### The Distribution Functions of the Order Statistics

The distribution function of \\(Y_i\\) is an upper tail of a binomial distribution. If the event 
\\(Y_i \le y\\) occurs, then there are at least \\(i\\) many \\(X_j\\) in the sample that are less 
than or equal to \\(y\\). Consider the event that \\(X \le y\\) as a success and 
\\(F(y) = P\left(X \le y\right)\\) as the probability of success. Then the drawing of each sample 
item becomes a Bernoulli trial (a success or a failure). We are interested in the probability of 
having at least \\(i\\) successes. Thus the following is the distribution function of \\(Y_i\\):

$$
F_{Y_i}(y) = P\left(Y_i \le y\right) = \sum \limits_{k=i}^{n} \binom{n}{k} F(y)^k [1-F(y)]^{n-k}
$$

The following relationship is used in deriving the probability density function:

$$
F_{Y_i}(y) = F_{Y_{i-1}}(y)-\binom{n}{i-1} F(y)^{i-1} [1-F(y)]^{n-i+1}
$$

#### The Probability Density Functions of the Order Statistics

The probability density function of \\(Y_i\\) is given by:
     
$$
f_{Y_i}(y)=\frac{n!}{(i-1)! (n-i)!} \thinspace F(y)^{i-1} \thinspace [1-F(y)]^{n-i} f_X(y)
$$

It can be proved by induction, see [more detailed induction](https://probabilityandstats.wordpress.com/2010/02/20/the-distributions-of-the-order-statistics/){:target='_blank'}.

Note that in \\(F(y)^{i-1} \thinspace f_X(y) \thinspace [1-F(y)]^{n-i}\\), the first term is the 
probability that there are \\(i - 1\\) sample items below \\(y\\). The middle term indicates that 
one sample item is right around \\(y\\). The third term indicates that there are \\(n - i\\) items 
above \\(y\\). Thus the following multinomial probability is the pdf:

$$
f_{Y_i}(y)=\frac{n!}{(i-1)! 1! (n-i)!} \thinspace F(y)^{i-1} \thinspace f_X(y) \thinspace [1-F(y)]^{n-i}
$$

### The Order Statistics of the Uniform Distribution

Suppose that the random sample \\(X_1,X_2, \cdots, X_n\\) are drawn from \\(U(0,1)\\). Since the 
distribution function of \\(U(0,1)\\) is \\(F(y)=y\\) where \\(0 < y < 1\\), the probability density 
function of the \\(i^{th}\\) order statistic is:

$$
f_{Y_i}(y) = \frac{n!}{(i-1)! (n-i)!} \thinspace y^{i-1} \thinspace [1-y]^{n-i} \text{where} 0 < y < 1
$$

The above density function is from the family of beta distributions. In general, the pdf of a beta 
distribution and its mean and variance are:

$$
f_{W}(w) = \frac{\Gamma(a+b)}{\Gamma(a) \Gamma(b)} \thinspace w^{a-1} \thinspace [1-w]^{b-1} \\
\text{where} 0<w<1 \text{where} \Gamma(\cdot) \text{is the gamma function}\\
\mathrm{E}[W] = \frac{a}{a+b} \\
\mathrm{Var}[W] = \frac{ab}{(a+b)^2 (a+b+1)}
$$

Then, the following shows the pdf of the \\(i^{th}\\) order statistic of the uniform distribution on 
the unit interval and its mean and variance:

$$
f_{Y_i}(y) = \frac{\Gamma(n+1)}{\Gamma(i) \Gamma(n-i+1)} \thinspace y^{i-1} \thinspace [1-y]^{(n-i+1)-1} \text{where} 0<y<1 \\
\mathrm{E}[Y_i] = \frac{i}{i+(n-i+1)}=\frac{i}{n+1} \\
\mathrm{Var}[Y_i] = \frac{i(n-i+1)}{(n+1)^2 (n+2)}
$$

### Estimation of Percentiles

In descriptive statistics, we define the sample percentiles using the order statistics.

Suppose we have a random sample of size \\(n\\) from an arbitrary continuous distribution. The 
order statistics listed in ascending order are:

$$
Y_1 < Y_2 < Y_3 < \cdots < Y_n
$$

For each \\(i \le n\\), consider \\(W_i = F(Y_i)\\). Since the distribution function \\(F(x)\\) is 
a non-decreasing function, the \\(W_i\\) are also increasing:

$$
W_1 < W_2 < W_3 < \cdots < W_n
$$

Note that \\(F(Y_i)\\) can be interpreted as an area under the density curve:

$$
W_i = F(Y_i) = \int_{-\infty}^{Y_i}f(x) dx
$$

It can be shown that if \\(F(x)\\) is a distribution function of a continuous random variable \\(X\\), 
then the transformation \\(F(X)\\) follows the uniform distribution \\(U(0,1)\\). Then the following 
transformed random sample:

$$
F(X_1), F(X_2), \cdots, F(X_n)
$$

are drawn from the uniform distribution \\(U(0,1)\\). Furthermore, \\(W_i\\) are the order 
statistics for this random sample.

By the preceding discussion, we have \\(\mathrm{E}[W_i] = \mathrm{E}[F(Y_i)] = \frac{i}{n+1}\\). 
Note that \\(F(Y_i)\\) is the area under the density function \\(f(x)\\) and to the left of \\(Y_i\\). 
Thus \\(F(Y_i)\\) is a random area and \\(\mathrm{E}[W_i] = \mathrm{E}[F(Y_i)]\\) is the expected 
area under the density curve \\(f(x)\\) to the left of \\(Y_i\\). Recall that \\(f(x)\\) is the 
common density function of the original sample \\(X_1, X_2, \cdots, X_n\\).

Furthermore, \\(\mathrm{E}[W_i - W_{i-1}]\\) is the expected area under the density curve and 
between \\(Y_i\\) and \\(Y_{i-1}\\). This expected area is:

$$
\mathrm{E}[W_i - W_{i-1}] = \mathrm{E}[F(Y_i)]-\mathrm{E}[F(Y_{i-1})] = \frac{i}{n+1}-\frac{i-1}{n+1}=\frac{1}{n+1}
$$

The expected area under the density curve and above the maximum order statistic \\(Y_n\\) is:

$$
\mathrm{E}[1-F(Y_n)] = 1-\frac{n}{n+1} = \frac{1}{n+1}
$$

Consequently here is an interesting observation about the order statistics 
\\(Y_1 < Y_2 < Y_3 < \cdots < Y_n\\). The order statistics \\(Y_i\\) divides the the area under 
the density curve \\(f(x)\\) and above the x-axis into \\(n + 1\\) areas. On average each of these 
area is \\(\frac{1}{n+1}\\).

As a result, it makes sense to use order statistics as estimator of percentiles. For example, we 
can use \\(Y_i\\) as the \\((100p)^{th}\\) percentile of the sample where \\(p = \frac{i}{n+1}\\). 
Then \\(Y_i\\) is an estimator of the population percentile \\(\tau_{p}\\) where the area under 
the density curve \\(f(x)\\) and to the left of \\(\tau_{p}\\) is \\(p\\). In the case that 
\\((n+1)p\\) is not an integer, then we interpolate between two order statistics. 

### Confidence interval for percentile

The construction of confidence intervals for percentiles is based on the probability 
\\(P[Y_i < \tau_p < Y_j]\\) where \\(\tau_p\\) is the \\((100p)^{th}\\) percentile.

The following computes the probability \\(P[Y_i < \tau_p < Y_j]\\) where \\(\tau_p\\) is the 
\\((100p)^{th}\\) percentile and \\(p = P[X < \tau_p]\\).

$$
P[Y_i < \tau_{p} < Y_j] = \sum \limits_{k=i}^{j-1} \binom{n}{k} p^k (1-p)^{n-k} = 1-\alpha
$$

Then the interval \\((Y_i,Y_j)\\) is taken to be the \\(100(1-\alpha)\%\\) confidence interval 
for the unknown population percentile \\(\tau_p\\). The above probability is based on the 
binomial distribution with parameters \\(n\\) and \\(p = P(X < \tau_p)\\). Its mean is \\(np\\) and 
its variance is \\(np(1-p)\\).

Note that the wider the interval estimates, the more confidence can be attached. On the other hand, 
the more precise the interval estimate, the less confidence can be attached to the interval. This 
is true for parametric methods and is also true for the non-parametric method at hand.
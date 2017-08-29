---
layout: post
category: [math]
tags: [stat, math, hypothesis, significance test, type of error]
infotext: 'illustrate the idea about statistical significance test'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

Once sample data has been gathered through an observational study or 
experiment, statistical inference allows analysts to assess evidence in 
favor or some claim about the population from which the sample has been 
drawn. The methods of inference used to support or reject claims based on 
sample data are known as __tests of significance__.

### The null hypothesis and alternative hypotheses

A null hypothesis \\(H_0\\) represents a theory that has been put forward, 
either because it is believed to be true or because it is to be used as a 
basis for argument, but has not been proved.

The alternative hypothesis \\(H_a\\) is a statement of what a statistical 
hypothesis test is set up to establish.

The final conclusion once the test has been carried out is always given in 
terms of the null hypothesis. We either "reject \\(H_0\\) in favor of 
\\(H_a\\)" or "do not reject \\(H_0\\)".

If we conclude "do not reject \\(H_0\\)", this does not necessarily mean 
that the null hypothesis is true, it only suggests that there is not 
sufficient evidence against \\(H_0\\) in favor of \\(H_a\\); rejecting the null 
hypothesis \\(H_0\\) suggests that the alternative hypothesis \\(H_a\\) may 
be true.

Hypotheses are always stated in terms of population parameter, such as 
the mean \\(\mu\\). An alternative hypothesis may be one-tail or two-tail. 
A one-tail hypothesis claims that a parameter is either larger or smaller 
than the value given by the null hypothesis. A two-tail hypothesis claims 
that a parameter is simply not equal to the value given by the null 
hypothesis -- the direction does not matter.

### Confidence interval

A confidence interval gives an estimated range of values which is likely to 
include an unknown population parameter, the estimated range being 
calculated from a given set of sample data.

### p-value

A p-value stands the probability that a value at least as extreme as the 
test statistic would be observed under the null hypothesis.

Given the null hypothesis that the population mean \\(\mu\\) is equal to a 
given value \\(0\\), the p-values for testing \\(H_0\\) against each of 
the possible alternative hypotheses are (t-statistic):

$$
P(Z \gt z) for H_a: \mu \gt 0
$$
$$
P(Z \lt z) for H_a: \mu \lt 0
$$
$$
2P(Z \gt |z|) for H_a: \mu = 0.
$$

### Significance levels

The significance level \\(\alpha\\) for a given hypothesis test is a value 
for which a p-value less than or equal to \\(\alpha\\) is considered 
statistically significant. Typical values for \\(\alpha\\) are 0.1, 0.05, 
and 0.01. These values correspond to the probability of observing such an 
extreme value by chance.

Another interpretation of the significance level \\(\alpha\\), based in 
decision theory, is that \\(\alpha\\) corresponds to the value for which 
one chooses to reject or accept the null hypothesis \\(H_0\\). If we 
conclude to reject the null hypothesis \\(H_0\\), then the probability that 
this decision is a mistake -- that, in fact, the null hypothesis is true 
-- is less than \\(\alpha\\). In decision theory, this is known as a 
__Type I__ error. The probability of a Type I error is equal to the 
significance level \\(\alpha\\), and the probability of rejecting the 
null hypothesis when it is in fact false(a correct decision) is equal to 
\\(1 - \alpha\\). To minimize the probability of Type I error, the 
significance level is generally chosen to be small.

Decision theory is also concerned with a second error possible in 
significance testing, known as __Type II__ error. Contrary to Type I error, 
Type II error is the error made when the null hypothesis is incorrectly 
accepted. The probability of correctly rejecting the null hypothesis when 
it is false, the complement of the Type II error, is known as the power of 
a test. Formally defined, the power of a test is the probability that a 
fixed level \\(\alpha\\) significance test will reject the null hypothesis 
\\(H_0\\) when a particular alternative value of the parameter is true.

### Matched Pairs

In many experiments, one wishes to compare measurements from two 
populations. This is common in medical studies involving control groups, 
for example, as well as in studies requiring before-and-after measurements. 
Such studies have a __matched pairs__ design, where the difference between 
the two measurements in each pair is the parameter of interest.

Analysis of data from a matched pairs experiment compares the two 
measurements by subtracting one from the other and basing test hypotheses 
upon the differences. Usually, the null hypothesis H0 assumes that the mean 
of these differences is equal to \\(0\\), while the alternative hypothesis 
\\(H_a\\) claims that the mean of the differences is not equal to \\(0\\)
(the alternative hypothesis may be one-tail or two-tail, depending on the 
experiment). Using the differences between the paired measurements as 
single observations, the standard \\(t\\) procedures with \\(n-1\\) degrees 
of freedom are followed.

### The Sign Test

Another method of analysis for matched pairs data is a distribution-free 
test known as the __sign test__. This test does not require any normality 
assumptions about the data, and simply involves counting the number of 
positive differences between the matched pairs and relating these to a 
binomial distribution. The concept behind the sign test reasons that if 
there is no true difference, then the probability of observing an 
increase in each pair is equal to the probability of observing a decrease 
in each pair: \\(p = \frac{1}{2}\\). Assuming each pair is independent, the null 
hypothesis follows the distribution \\(B(n, \frac{1}{2})\\), where \\(n\\) 
is the number of pairs where some difference is observed.

To perform a sign test on matched pairs data, take the difference between 
the two measurements in each pair and count the number of non-zero 
differences \\(n\\). Of these, count the number of positive differences 
\\(X\\). Determine the probability of observing \\(X\\) positive 
differences for a \\(B(n, \frac{1}{2})\\) distribution, and use this 
probability as a p-value for the null hypothesis.

### Some illustration

Suppose now we want to do some significance test on some property of a 
sample data \\(\\{x\\}_{i = 1}^n\\), say \\(X_x\\), we set up the null 
hypothesis \\(H_0\\) as \\(X = X_0\\), the one-tail alternative 
hypothesis \\(H_a\\) as \\(X \gt X_0\\), and the corresponding statistic 
test value for \\(X_x\\) is \\(t(X_x)\\) where for any \\(X' \gt X\\) the 
statistic test value \\(t(X') \gt t(X)\\).

With the definition of p-value and the purpose to test \\(H_0\\) against 
\\(H_a\\), the observed sample data \\(\{x\}_{i = 1}^n\\) is extreme, and 
the probability of more extreme is \\(P(t(X) \gt t(X_x) | X_0)\\). If the 
p-value is small, then it means there is statistical significant difference 
between the observed data and the null hypothesis and we should reject the 
\\(H_0\\) which means we accept the \\(H_a\\) and it will result in a larger 
value in the probability of more extreme in term with 
\\(P(t(X) \gt t(X_x) | X'; X' \gt X_0)\\).

### References

For more readings, check [link 1](http://www.stat.yale.edu/Courses/1997-98/101/sigtest.htm){:target='_blank'} which contains most content of this article, 
[link 2](http://www.stomponstep1.com/p-value-null-hypothesis-type-1-error-statistical-significance/){:target='_blank'} which illustrate \\(\beta\\) and power, 
[link 3](https://www.ma.utexas.edu/users/mks/statmistakes/errortypes.html){:target='_blank'} which contains great pictures for type I and type II error.

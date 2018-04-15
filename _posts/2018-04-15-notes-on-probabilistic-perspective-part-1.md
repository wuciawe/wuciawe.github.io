---
layout: post
category: [math]
tags: [math]
infotext: "reading note/report of Machine learning a probabilistic perspective & The elements of statistical learning Data mining, inference, and prediction"
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### View point on probability

What is probability? There are actually at least two different 
interpretations of probability. One is called the frequentist 
interpretation. In this view, probabilities represent long run 
frequencies of events. The other interpretation is called the Bayesian 
interpretation of probability. In this view, probability is used to 
quantify our uncertainty about something; hence it is fundamentally 
related to information rather than repeated trials.

One big advantage of the Bayesian interpretation is that it can be 
used to model our uncertainty about events that do not have long term 
frequencies.

### Central limit theorem

Consider \\(N\\) random variables which pdf's \\(p(x)\\), each 
with mean \\(\mu\\) and variance \\(\sigma^2\\). We assume each 
variable is independent and identically distributed or iid for 
short. Let \\(S_N=\sum_{i=1}^NX_i\\) be the sum of the rv's. This 
is a simple but widely used transformation of rv's. One can show 
that, as \\(N\\) increases, the distribution of this sum approaches

$$
p(S_N=s) = \frac{1}{\sqrt{2\pi N\sigma^2}}\exp\left(-\frac{(s-N_\mu)^2}{2N\sigma^2}\right)
$$

Hence the distribution of the quantity

$$
Z_N \triangleq \frac{S_N - N_\mu}{\sigma\sqrt{N}} = \frac{\bar{X} - \mu}{\sigma / \sqrt{N}}
$$

converges to the standard normal, where \\(\bar{X}=\frac{1}{N}\sum_{i=1}^N x_i\\) is the 
sample mean. This is called the central limit theorem.

### The Gaussian distribution

The most widely used distribution in statistics and machine learning 
is the Gaussian or normal distribution. Its pdf is given by

$$
\mathcal{N}(x|\mu,\sigma^2) \triangleq \frac{1}{\sqrt{2\pi\sigma^2}} e^{-\frac{1}{2\sigma^2}(x-\mu)^2}
$$

Here \\(\mu=\mathbb{E}[X]\\) is the mean (and mode), and 
\\(\sigma^2=\text{var}{[X]}\\) is the variance. \\(\sqrt{2\pi\sigma^2}\\) 
is the normalization constant needed to ensure the density integrates 
to \\(1\\).

We write \\(X \sim \mathcal{N}(\mu, \sigma^2)\\) to denote that 
\\(p(X=x)=\mathcal{N}(x|\mu,\sigma^2)\\). If 
\\(X \sim \mathcal{N}(0,1)\\), we say \\(X\\) follows a standard 
normal distribution. This is sometimes called the bell curve.

The cumulative distribution function or cdf of the Gaussian is 
defined as

$$
\Phi(x;\mu,\sigma^2) \triangleq \int_{-\infty}^x \mathcal{N}(z|\mu,\sigma^2)dz
$$

This integral has no closed form expression, but is built in to most 
software packages. In particular, we can compute it in terms of the 
error function (erf):

$$
\Phi(x;\mu,\sigma^2)=\frac{1}{2}[1+\text{erf}(\frac{z}{\sqrt{2}})]
$$

where \\(z=(x-\mu)/\sigma\\) and 

$$
\text{erf}(x) \triangleq \frac{2}{\sqrt{\pi}}\int_0^x e^{-t^2}dt
$$

The Gaussian distribution is the most widely used distribution in 
statistics. There are several reasons for this. First, it has two 
parameters which are easy to interpret, and which capture some of 
the most basic properties of a distribution, namely its mean and 
variance. Second, the central limit theorem tells us that sums of 
independent random variables have an approximately Gaussian 
distribution, making it a good choice for modeling residual errors 
or "noise". Third, the Gaussian distribution makes the least number 
of assumptions (has maximum entropy), subject to the constraint of 
having a specified mean and variance; this makes it a good default 
choice in many cases. Finally, it has a simple mathematical form, 
which results in easy to implement, but often highly effective, 
methods.

### Dirac delta function

In the limit that \\(\sigma^2 \rightarrow 0\\), the Gaussian becomes 
an infinitely thin spike centered at \\(\mu\\):

$$
\lim_{\sigma^2 \rightarrow 0} \mathcal{N}(x|\mu,\sigma^2) = \delta(x-\mu)
$$

where \\(\delta\\) is called a Dirac delta function, and is defined as

$$
\delta(x) = 
\begin{cases}
\infty &\text{if}\quad x=0\\
0 &\text{if}\quad x \neq 0
\end{cases}
$$

such that 

$$
\int_{-\infty}^{\infty}\delta(x)dx=1
$$

A useful property of delta functions is the sifting property, which 
selects out a single term from a sum of integral:

$$
\int_{-\infty}^{\infty} f(x)\delta(x-\mu)dx = f(\mu)
$$

since the integrand is only non-zero if \\(x-\mu=0\\).

### Student t distribution

One problem with the Gaussian distribution is that it is sensitive 
to outliers, since the log-probability only decays quadratically 
with distance from the center. A more robust distribution is the 
Student t distribution. Its pdf is as follows:

$$
\mathcal{T}(x|\mu,\sigma^2,\nu) \propto \left[1+\frac{1}{\nu}\left(\frac{x-\mu}{\sigma}\right)^2\right]^{-(\frac{\nu+1}{2})}
$$

where \\(\mu\\) is the mean, \\(\sigma^2 > 0\\) is the scale parameter, 
and \\(\nu>0\\) is called that the degrees of freedom. The distribution 
has following properties:

$$
\text{mean}=\mu\\
\text{mode}=\mu\\
\text{var}=\frac{\nu\sigma^2}{(\nu - 2)}
$$

the variance is only defined if \\(\nu > 2\\). The mean is only defined 
if \\(\nu > 1\\).

If \\(\nu=1\\), this distribution is known as the Cauchy or Lorentz 
distribution. This is notable for having such heavy tails that the 
integral that defines the mean does not converge.

To ensure finite variance, we require \\(\nu > 2\\). It is common to use 
\\(\nu=4\\), which gives good performance in a range of problems. For 
\\(\nu \gg 5\\), the Student distribution rapidly approaches a Gaussian 
distribution and loses its robustness properties.

### The Laplace distribution

Another distribution with heavy tails is the Laplace distribution, also 
known as the double sided exponential distribution. This has the 
following pdf:

$$
\text{Lap}(x|\mu,b) \triangleq \frac{1}{2b}\exp\left(-\frac{|x-\mu|}{b}\right)
$$

Here \\(\mu\\) is a location parameter and \\(b > 0\\) is a scale 
parameter. This distribution has the following properties:

$$
\text{mean}=\mu\\
\text{mode}=\mu\\
\text{var}=2b^2
$$

### The gamma distribution

The gamma distribution is a flexible distribution for positive real 
valued rv's, \\(x > 0\\). It is defined in terms of two parameters, 
called the shape \\(a > 0\\) and the rate \\(b > 0\\):

$$
\text{Ga}(T|a, b) \triangleq \frac{b^a}{\Gamma(a)}T^{a-1}e^{-Tb}
$$

where \\(\Gamma(a)\\) is the gamma function:

$$
\Gamma(x) \triangleq \int_0^\infty u^{x-1}e^{-u}du
$$

The distribution has the following properties:

$$
\text{mean}=\frac{a}{b}\\
\text{mode}=\frac{a-1}{b}\\
\text{var}=\frac{a}{b^2}
$$

There are several distributions which are just special cases of the 
Gamma:

- Exponential distribution: This is defined by 
\\(\text{Expon}(x|\lambda)\triangleq\text{Ga}(x|1,\lambda)\\), 
where \\(\lambda\\) is the rate parameter. This distribution describes 
the times between events in a Poisson process, i.e. a process in 
which events occur continuously and independently at a constant 
average rate \\(\lambda\\).
- Erlang distribution: This is the same as the Gamma distribution 
where \\(a\\) is an integer. It is common to fix \\(a=2\\), yielding 
the one-parameter Erlang distribution, 
\\(\text{Erlang}(x|\lambda)=\text{Ga}(x|2,\lambda)\\), where 
\\(\lambda\\) is the rate parameter.
- Chi-squared distribution: This is defined by 
\\(\mathcal{X}^2(x|\nu)\triangleq\text{Ga}(x|\frac{\nu}{2},\frac{1}{2})\\).
This is the distribution of the sum of squared Gaussian random 
variables. More precisely, if \\(Z_i\sim\mathcal{N}(0,1)\\), and 
\\(S=\sum_{i=1}^\nu Z_i^2\\), then \\(S\sim\mathcal{X}_\nu^2\\).

Another useful result is the following: If \\(X \sim \text{Ga}(a,b)\\), 
then one can show that \\(\frac{1}{x}\sim\text{IG}(a,b)\\), where 
\\(\text{IG}\\) is the inverse gamma distribution defined by

$$
\text{IG}(x|a,b) \triangleq \frac{b^a}{\Gamma(a)}x^{-(a+1)}e^{-\frac{b}{x}}
$$

The distribution has these properties:

$$
\text{mean}=\frac{b}{a-1}\\
\text{mode}=\frac{b}{a+1}\\
\text{var}=\frac{b^2}{(a-1)^2(a-2)}
$$

The mean only exists if \\(a>1\\). The variance only exists if \\(a>2\\).

### The beta distribution

The beta distribution has support over the interval \\([0,1]\\) and 
is defined as follows:

$$
\text{Beta}(x|a,b)=\frac{1}{\text{B}(a,b)}x^{a-1}(1-x)^{b-1}
$$

Here \\(\text{B}(p,q)\\) is the beta function,

$$
\text{B}(a,b)\triangleq\frac{\Gamma(a)\Gamma(b)}{\Gamma(a+b)}
$$

We require \\(a,b > 0\\) to ensure the distribution is integrable 
(i.e. to ensure \text{B}(a,b) exists). If \\(a=b=1\\), we get the 
uniform distribution. If \\(a\\) and \\(b\\) are both less than 
\\(1\\), we get a bimodal distribution with spikes at \\(0\\) and 
\\(1\\); if \\(a\\) and \\(b\\) are both greater than \\(1\\), the 
distribution is unimodal. The distribution has the following 
properties:

$$
\text{mean}=\frac{a}{a+b}\\
\text{mode}=\frac{a-1}{a+b-2}\\
\text{var}=\frac{ab}{(a+b)^2(a+b+1)}
$$

### Pareto distribution

The Pareto distribution is used to model the distribution of quantities 
that exhibit long tails, also called heavy tails. The Pareto pdf is 
defined as follow:

$$
\text{Pareto}(x|k,m)=km^kx^{-(k+1)}\mathbb{I}(x\geq m)
$$

This density asserts that \\(x\\) must be greater than some constant 
\\(m\\), but not too much greater, where \\(k\\) controls what is 
"too much". As \\(k \rightarrow \infty\\), the distribution approaches 
\\(\delta(x-m)\\). If we plot the distribution on a log-log scale, it 
forms a straight line, of the form \\(\log p(x)=a\log x + c\\) for 
some constants \\(a\\) and \\(c\\). This is known as a power law. This 
distribution has the following properties:

$$
\text{mean}=\frac{km}{k-1} \text{if } k > 1\\
\text{mode}=m\\
\text{var}=\frac{m^2k}{(k-1)^2(k-2)} \text{if } k > 2
$$

### Correlation and covariance

If \\(x\\) is a \\(d\\)-dimensional random vector, its covariance 
matrix is defined to be the following symmetric, positive definite 
matrix:

$$
\begin{array}
\text{cov}[x] &\triangleq \mathbb{E}[(x-\mathbb{E}[x])(x-\mathbb{E}[x]^T)]\\
&=\left(\begin{matrix}
\text{var}[X_1] &\text{cov}[X_1,X_2] &\dots &\text{cov}[X_1,X_d]\\
\text{cov}[X_2,X_1] &\text{var}[X_2] &\dots &\text{cov}[X_2, X_d]\\
\vdots &\vdots &{} &\vdots\\
\text{cov}[X_d,X_1] &\text{cov}[X_d,X_2] &\dots &\text{var}[X_d]
\end{matrix}\right)
\end{array}
$$

Covariances can be between \\(0\\) and infinity. Sometimes it is more 
convenient to work with a normalized measure, with a finite upper 
bound. The (Pearson) correlation coefficient between \\(X\\) and 
\\(Y\\) is defined as

$$
\text{corr}[X,Y]\triangleq\frac{\text{cov}[X,Y]}{\sqrt{\text{var}[X]\text{var}[Y]}}
$$

A correlation matrix has the form

$$
R=\left(\begin{matrix}
  \text{corr}[X_1,X_1] &\text{corr}[X_1,X_2] &\dots &\text{corr}[X_1,X_d]\\
  \text{corr}[X_2,X_1] &\text{corr}[X_2,X_2] &\dots &\text{corr}[X_2, X_d]\\
  \vdots &\vdots &{} &\vdots\\
  \text{corr}[X_d,X_1] &\text{corr}[X_d,X_2] &\dots &\text{corr}[X_d,X_d]
  \end{matrix}\right)
$$

One can show that \\(-1 \leq \text{corr}[X,Y] \leq 1\\). Hence in a 
correlation matrix, each entry on the diagonal is \\(1\\), and the 
other entries are between \\(-1\\) and \\(1\\).

One can show that \\(\text{corr}[X,Y]=1\\) if and only if 
\\(Y=aX+b\\) for some parameters \\(a\\) and \\(b\\), i.e., if 
there is a linear relationship between \\(X\\) and \\(Y\\). Intuitively 
one might expect the correlation coefficient to be related to the slope 
of the regression line, i.e., the coefficient \\(a\\) in the expression 
\\(Y=aX+b\\). However, the regression coefficient is in fact given by 
\\(a=\text{cov}[X,Y]/\text{var}[X]\\). A better way to think of the 
correlation coefficient is as a degree of linearity.

If \\(X\\) and \\(Y\\) are independent, meaning \\(p(X,Y)=p(X)p(Y)\\), 
then \\(\text{cov}[X,Y]=0\\), and hence \\(\text{corr}[X,Y]=0\\) so 
they are uncorrelated. However, the converse is not true: uncorrelated 
does not imply independent. A more general measure of dependence between 
random variables is mutual information. This is only zero if the 
variables truly are independent.

### Entropy

The entropy of a random variable \\(X\\) with distribution \\(p\\), 
denoted by \\(\mathbb{H}(X)\\) or sometimes \\(\mathbb{H}(p)\\), is 
a measure of its uncertainty. In particular, for a discrete variable 
with \\(K\\) states, it is defined by

$$
\mathbb{H}(X) \triangleq -\sum_{k=1}^K p(X=k)log_2 p(X=k)
$$

Usually we use log base \\(2\\), in which case the units are called 
bits. If we use log base \\(e\\), the units are called nats.

The discrete distribution with maximum entropy is the uniform 
distribution. Conversely, the distribution with minimum entropy is 
any delta-function that puts all its mass on one state. Such a 
distribution has no uncertainty.

### KL divergence

One way to measure the dissimilarity of two probability distributions, 
\\(p\\) and \\(q\\), is known as the Kullback-Leibler divergence or 
relative entropy. This is defined as follows:

$$
\mathbb{KL}(p||q) \triangleq \sum_{k=1}^K p_k \log \frac{p_k}{q_k}
$$

where the sum gets replaced by an integral for pdfs. We can rewrite 
this as

$$
\mathbb{KL}(p||q)=\sum_k p_k \log p_k - \sum_k p_k\log q_k = -\mathbb{H}(p) + \mathbb{H}(p, q)
$$

where \\(\mathbb{H}(p,q)\\) is called the cross entropy,

$$
\mathbb{H}(p,q)\triangleq -\sum_k p_k \log q_k
$$

One can show that the cross entropy is the average number of bits needed 
to encode data coming from a source with distribution \\(p\\) when we 
use model \\(q\\) to define our codebook. Hence the regular entropy 
\\(\mathbb{H}(p)=\mathbb{H}(p,p)\\) is the expected number of bits if 
we use the true model, so the KL divergence is the difference between 
these. In other words, the KL divergence is the average number of extra 
bits needed to encode the data, due to the fact that we used distribution 
\\(q\\) to encode the data instead of the true distribution \\(p\\).

The "extra number of bits" interpretation should make it clear that 
\\(\mathbb{KL}(p||q)\geq 0\\), and that the KL is only equal to zero 
iff \\(q=p\\).

### Mutual information

Consider two random variables, \\(X\\) and \\(Y\\). Suppose we want to 
know how much knowing one variable tells us about the other. We could 
compute the correlation coefficient, but this is only defined for 
real-valued random variables, and furthermore, this is a very limited 
measure of dependence. A more general approach is to determine how 
similar the joint distribution \\(p(X,Y)\\) is to the factored 
distribution \\(p(X)p(Y)\\). This is called the mutual information, 
and is defined as follows:

$$
\mathbb{I}(X;Y)\triangleq\mathbb{KL}(p(X,Y)||p(X)p(Y))=\sum_x\sum_yp(x,y)\log\frac{p(x,y)}{p(x)p(y)}
$$

We have \\(\mathbb{I}(X;Y)\geq 0\\) with equality iff \\(p(X,Y)=p(X)p(Y)\\). 
That is, the MI is zero iff the variables are independent.

to gain insight into the meaning of MI, it helps to re-express it 
in terms of joint and conditional entropies. One can show that the 
above expression is equivalent to the following:

$$
\mathbb{I}(X;Y)=\mathbb{H}(X)-\mathbb{H}(X|Y)=\mathbb{H}(Y)-\mathbb{H}(Y|X)
$$

where \\(\mathbb{H}(Y|X)\\) is the conditional entropy, defined as 
\\(\mathbb{H}(Y|X)=\sum_xp(x)\mathbb{H}(Y|X=x)\\). Thus we can interpret 
the MI between \\(X\\) and \\(Y\\) as the reduction in uncertainty 
about \\(X\\) after observing \\(Y\\), or, by symmetry, the reduction 
in uncertainty about \\(Y\\) after observing \\(X\\).

A quantity which is closely related to MI is the pointwise mutual 
information or PMI. For two events \\(x\\) and \\(y\\), this is defined 
as

$$
\text{PMI}(x,y)=\log\frac{p(x|y)}{p(x)}=\log\frac{p(y|x)}{p(y)}
$$

This is the amount we learn from updating the prior \\(p(x)\\) into 
the posterior \\(p(x|y)\\), or equivalently, updating the prior 
\\(p(y)\\) into the posterior \\(p(y|x)\\).

### Classifying documents using bag of words

Document classification is the problem of classifying text documents 
into different categories. One simple approach is to represent each 
document as a binary vector, which records whether each word is 
present or not, so \\(x_{ij}=1\\) iff word \\(j\\) occurs in document 
\\(i\\), otherwise \\(x_{ij}=0\\). We can then use the following class 
conditional density:

$$
p(x_i|y_i=c,\theta)=\prod_{j=1}^D\text{Ber}(x_{ij}|\theta_{jc})=\prod_{j=1}^D\theta_{jc}^{\mathbb{I}(x_{ij})}(1-\theta_{jc})^{\mathbb{I}(1-x_{ij})}
$$

This is called the Bernoulli product model, or the binary independence model.

However, ignoring the number of times each word occurs in a document 
loses some information. A more accurate representation counts the 
number of occurrences of each word. Specifically, let \\(x_i\\) be a 
vector of counts for document \\(i\\), so \\(x_{ij}\in\{0,1,\dots,N_i\}\\), 
where \\(N_i\\) is the number of terms in document \\(i\\) (so 
\\(\sum_{j=1}^Dx_{ij}=N_i\\)). For the class conditional densities, we 
can use a multinomial distribution:

$$
p(x_i|y_i=c,\theta)=\text{Mu}(x_i|N_i,\theta_c)=\frac{N_i!}{\prod_{j=1}^Dx_{ij}!}\prod_{j=1}^D\theta_{jc}^{x_{ij}}
$$

where we have implicitly assumed that the document length \\(N_i\\) is 
independent of the class. Here \\(\theta_jc\\) is the probability of 
generating work \\(j\\) in documents of class \\(c\\); there parameters 
satisfy the constraint that \\(\sum_{j=1}^D\theta_{jc}=1\\) for each 
class \\(c\\).

Although the multinomial classifier is easy to train and easy to use at 
test time, it does not work particularly well for document classification. 
One reason for this is that it does not take into account the burstiness 
of word usage. This refers the phenomenon that most words never appear 
in any given document, but if they do appear once, they are likely to 
appear more than once, i.e., words occur in bursts.

Suppose we simply replace the multinomial class conditional density with 
the Dirichlet Compound Multinomial or DCM density, defined as follows:

$$
p(x_i|y_i=c,\alpha)=\int\text{Mu}(x_i|N_i,\theta_c)\text{Dir}(\theta_c|\alpha_c)d\theta_c=\frac{N_i!}{\prod_{j=1}^Dx_{ij}!}\frac{\text{B}(x_i+\alpha_c)}{\text{B}(\alpha_c)}
$$

Surprisingly this simple change is all that is needed to capture the 
burstiness phenomenon. The intuitive reason for this is as follows: 
After seeing one occurence of a word, say word \\(j\\), the posterior 
counts on \\(\theta_j\\) gets updated, making another occurence of 
word \\(j\\) more likely. By contrast, if \\(\theta_j\\) is fixed, then 
the occurences of each word are independent. The multinomial model 
corresponds to drawing a ball from an urn with \\(K\\) colors of ball, 
recording its color, and then replacing it. By contrast, the DCM model 
corresponds to drawing a ball, recording its color, and then replacing 
it with one additional copy; this is called the Polya urn.

The rich get richer. Also related with the Bose-Einstein condensate.

### Credible interval and Confidence interval

In addition to point estimates, we often want a measure of confidence. 
A standard emasure of donfidence in some (scalar) quantity \\(\theta\\) 
is the "width" of its posterior distribution. This can be measured 
using a \\(100(1 - \alpha)%\\) credible interval, which is a (contiguous) 
region \\(C=(\mathcal{l}, \mathcal{u})\\) (standing for lower and 
upper) which contains \\(1-\alpha\\) of the posterior probability mass, i.e.,

$$
C_\alpha(D)=(\mathcal{l}, \mathcal{u}): P(\mathcal{l}\leq\theta\leq\mathcal{u}|D)=1-\alpha
$$

There may be many such intervals, so we choose one such that there is 
\\((1-\alpha)/2\\) mass in each tail; this is called a central interval.

If the posterior has a known functional form, we can compute the 
posterior central interval using \\(\mathcal{l}=F^{-1}(\alpha/2)\\) and 
\\(\mathcal{u}=F^{-1}(1-\alpha/2)\\), where \\(F\\) is the cdf of the 
posterior.

If we don't know the functional form, but we can draw samples from the 
posterior, then we can use a Monte Carlo approximation to the posterior 
quantiles: we simply sort the \\(S\\) samples, and find the one that 
occurs at location \\(\alpha/S\\) along the sorted list.

People often confuse Bayesian credible intervals with frequentist 
confidence intervals. However, they are not the same thing. In general, 
credible intervals are usually what people want to compute, but 
confidence intervals are usually what they actually compute, because 
most people are taught frequentist statistics but not Bayesian statistics.

A confidence interval is an interval derived from the sampling distribution 
of an estimator (whereas a Bayesian credible interval is derived from 
the posterior of a parameter). More precisely, a frequentist confidence 
interval for some parameter \\(\theta\\) is defined by the following 
expression:

$$
C_{\alpha}'(\theta)=(\mathcal{l},\mathcal{u}): P(\mathcal{l}(\tilde{D})\leq\theta\leq\mathcal{u}(\tilde{D})|\tilde{D}\sim\theta)=1-\alpha
$$

That is, if we sample hypothetical future data \\(\tilde{D}\\) from 
\\(\theta\\), then \\((\mathcal{l}(\tilde{D}), \mathcal{u}(\tilde{D}))\\), 
is a confidence interval if the parameter \\(\theta\\) lies inside this 
interval \\(1-\alpha\\) percent of the time.

In Bayesian statistics, we condition on what is known -- namely the 
observed data, \\(D\\) -- and average over what is not known, namely 
the parameter \\(\theta\\). In frequentist statistics, we do exactly 
the opposite: we condition on what is unknown -- namely the true 
parameter value \\(\theta\\) -- and average over hypothetical future 
data sets \\(\tilde{D}\\).

### p-values considered harmful

Suppose we want to decide whether to accept or reject some baseline 
model, which we will call the null hypothesis. We need to define 
some decision rule. In frequentist statistics, it is standard to first 
compute a quantity called the p-value, which is defined as the 
probability (under the null) of observing some test statistic 
\\(f(D)\\) (such as the chi-squred statistic) that is as large or 
larger than that actually observed:

$$
\text{pvalue}(D) \triangleq P(f(\tilde{D}) \geq f(D)|\tilde{D} \sim H_0)
$$

This quantity relies on computing a tail area probability of the 
sampling distribution.

Given the p-value, we define our decision rule as follows: we reject 
the null hypothesis iff the p-value is less than some threshold, such 
as \\(\alpha=0.05\\). If we do reject it, we say the difference between 
the observed test statistic and the expected test statistic is 
statistically significant at level \\(\alpha\\). This approach is 
known as null hypothesis significance testing, or NHST.

This procedure guarantees that our expected type I (false positive) error 
rate is at most \\(\alpha\\). This is sometimes interpreted as saying 
that frequentist hypothesis testing is very conservative, since it is 
unlikely to accidently reject the null hypothesis. But in fact the 
opposite is the case: because this method only worries about trying 
to reject the null, it can never gather evidence in favor of the null, 
no matter how large the sample size. Because of this, p-value tend to 
overstate the evidence against the null, and are thus very "trigger happy".

In general there can be huge differences between p-values and the quantity 
that we really care about, which is the posterior probability of the null 
hypothesis given the data, \\(p(H_0|D)\\).

Another problem with p-values is that their computation depends on 
decisions you make about when to stop collecting data, even if these 
decisions don't change the data you actually observed.

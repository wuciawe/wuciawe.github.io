---
layout: post
category: [math]
tags: [stat, math, hypothesis, significance test]
infotext: "A more detailed view on sign test, which is a statistical method to test for consistent differences between pairs of observations."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In the previous post [(significance test)]({% post_url 2016-06-13-significance-test %}), the sign 
test is roughly mentioned, here are a more detailed explanation and more examples on the sign test.

We would use t-test to inference on the mean of an obviously non-normal population if the sample 
size is large. It is because that the sampling distribution of sample mean \\(\bar{X}\\) is close 
to normal. If the sample size is small and so that the sampling distribution is not normal, we would 
use sign test to inference on the median of the population. The sign test is distribution-free 
inference procedure, since it makes no assumptions about the underlying distribution of the data 
measurement.

Take the example of a matched pair data problem, the matched pairs t-test is to test the hypothesis 
that there is "no difference" between two continuous random variables \\(X\\) and \\(Y\\) that are 
paired. 

Suppose that \\((X,Y)\\) is a pair of continuous random variables. Suppose that a random sample of 
paired data \\((X_1,Y_1), (X_2,Y_2), \cdots, (X_n,Y_n)\\) is obtained. We omit the observations 
\\((X_i,Y_i)\\) where \\(X_i = Y_i\\). Let \\(m\\) be the number of pairs for which \\(X_i \ne Y_i\\). 
For each of these \\(m\\) pairs, we make a note of the sign of the difference \\(X_i - Y_i\\) 
(\\(+\\) if \\(X_i > Y_i\\) and \\(-\\) if \\(X_i < Y_i\\)). Let \\(W\\) be the number of \\(+\\) 
signs out of these \\(m\\) pairs. The sign test is also called the binomial test since the statistic 
\\(W\\) has a binomial distribution.

Let \\(p = P\left(X > Y\right)\\). Note that this is the probability that a data pair \\((X,Y)\\) 
has a \\(+\\) sign. If \\(p = \frac{1}{2}\\), then any random pair \\((X,Y)\\) has an equal 
chance of being a \\(+\\) or a \\(-\\) sign. The null hypothesis \\(H_0: p = \frac{1}{2}\\) is the 
hypothesis of "no difference". Under this hypothesis, there is no difference between the two 
measurements \\(X\\) and \\(Y\\). The sign test is test the null hypothesis \\(H_0: p = \frac{1}{2}\\) 
against any one of the following alternative hypotheses:

$$
H_1: p < \frac{1}{2} \text{(Left-tailed)} \\
H_1: p > \frac{1}{2} \text{(Right-tailed)} \\
H_1: p \ne \frac{1}{2} \text{(Two-tailed)} \\
$$

The statistic \\(W\\) can be considered a series of m independent trials, each of which has 
probability of success \\(p = P\left(X > Y\right)\\). Thus \\(W \sim binomial(m,p)\\). When \\(H_0\\) 
is true, \\(W \sim binomial(m, \frac{1}{2})\\). Thus the binomial distribution is used for 
calculating significance. The left-tailed P-value is of the form \\(P\left(W \le w\right)\\) and the 
right-tailed P-value is \\(P\left(W \ge w\right)\\). Then the two-tailed P-value is twice the 
one-sided P-value.

The sign test can also be viewed as testing the hypothesis that the median of the differences is 
zero. Let \\(m_d\\) be the median of the differences \\(X - Y\\). The null hypothesis 
\\(H_0: p = \frac{1}{2}\\) is equivalent to the hypothesis \\(H_0: m_d = 0\\). For the alternative 
hypotheses, we have the following equivalences:

$$
H_1: p < \frac{1}{2} \equiv H_1: m_d < 0\\
H_1: p > \frac{1}{2} \equiv H_1: m_d > 0\
H_1: p \ne \frac{1}{2} \equiv H_1: m_d \ne 0
$$

### Example 1

Use sign test for testing whether a running training program improves run time, the data is as 
follows:

$$
\begin{pmatrix} 
\text{Runner}&\text{Pre-training}&\text{Post-training}&\text{Diff} \\
{1}&57.5&54.9&2.6 \\
{2}&52.4&53.5&-1.1 \\
{3}&59.2&49.0&10.2 \\
{4}&27.0&24.5&2.5 \\
{5}&55.8&50.7&5.1 \\
{6}&60.8&57.5&3.3 \\
{7}&40.6&37.2&3.4 \\
{8}&47.3&42.3&5.0 \\
{9}&43.9&47.3&-3.4 \\
{10}&43.7&34.8&8.9 \\
{11}&60.8&53.3&7.5 \\
{12}&43.9&33.8&10.1 \\
{13}&45.6&41.7&3.9 \\
{14}&40.6&41.5&-0.9 \\
{15}&54.1&52.5&1.6 \\
{16}&50.7&52.4&-1.7 \\
{17}&25.4&25.9&-0.5 \\
{18}&57.5&54.7&2.8 \\
{19}&43.9&38.7&5.2 \\
{20}&43.9&39.9&4.0 
\end{pmatrix}
$$

For a given runner, let \\(X\\) be a random pre-training running time and \\(Y\\) be a random 
post-training running time. The hypotheses to be tested are:

$$
H_0: p = \frac{1}{2} \\
H_1: p > \frac{1}{2} \text{where} p = P\left(X > Y\right)
$$

Under the null hypothesis \\(H_0\\), there is no difference between the pre-training run time and 
post-training run time. The difference is equally likely to be a plus sign or a minus sign. Let 
\\(W\\) be the number of runners in the sample for which \\(X_i - Y_i > 0\\). Then 
\\(W \sim \text{Binomial}(20,0.5)\\). The observed value of the statistic \\(W\\) is \\(w = 15\\). 
Since this is a right-tailed test, the following is the P-value:

$$
\text{P-value} = P\left(W \ge 15\right) = \sum \limits_{k=15}^{20} \binom{20}{k} \biggl(\frac{1}{2}\biggr)^{20}=0.02069
$$

Because of the small P-value, the result of \\(15\\) out of \\(20\\) runners having improved run 
time cannot be due to random chance alone. So we reject \\(H_0\\) and we have good reason to 
believe that the training program reduces run time.

### Example 2

There are two statistics instructors who are both sought after by students in a local college. 
Let’s call them instructor A and instructor B. The math department conducted a survey to find out 
who is more popular with the students. In surveying \\(15\\) students, the department found that 
\\(11\\) of the students prefer instructor B over instructor A. Use the sign test to test the 
hypothesis of no difference in popularity against the alternative hypothesis that instructor B is 
more popular.

More than \\(\frac{2}{3}\\) of the students in the sample prefer instructor B over A. This seems 
like convincing evidence that B is indeed more popular. Let perform some calculation to confirm 
this. Let \\(W\\) be the number of students in the sample who prefer B over A. The null hypothesis 
is that A and B are equally popular. The alternative hypothesis is that B is more popular. If the 
null hypothesis is true, then \\(W \sim \text{binomial}(15,0.5)\\). Then the P-value is:

$$
\text{P-value} = P\left(W \ge 11\right) = \sum \limits_{k=11}^{15} \binom{15}{k} \biggl(\frac{1}{2}\biggr)^{15}=0.05923
$$

This P-value suggests that we have strong evidence that instructor B is more popular among the 
students.

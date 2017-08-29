---
layout: post
category: [machine learning, math]
tags: [machine learning, math, stat, linear regression, significance test]
infotext: 'significance test for single regressor and subset of regressors for linear regression'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### The significance test for single regressor with t-statistic

(quoted from [wiki](https://en.wikipedia.org/wiki/T-statistic){:target='_blank'})

In statistics, the __t-statistic__ is a ratio of the departure of an estimated parameter from its 
notional value and its standard error. It is used in hypothesis testing, for example in the 
Student’s t-test, in the augmented Dickey–Fuller test, and in bootstrapping.

Let \\(\hat{\beta}\\) be an estimator of parameter \\(\beta\\) in some statistical model. Then a 
t-statistic for this parameter is any quantity of the form

$$
t_\hat{\beta} = \frac{\hat{\beta} - \beta_0}{\mathrm{s.e.}(\hat{\beta})} 
$$

where \\(\beta_0\\) is a non-random, known constant, and \\(\mathrm{s.e.}(\hat{\beta})\\) is the 
standard error of the estimator \\(\hat{\beta}\\). By default, statistical packages report 
t-statistic with \\(\beta_0 = 0\\) (these t-statistics are used to test the significance of 
corresponding regressor). However, when t-statistic is needed to test the hypothesis of the form 
\\(H_0: \beta = \beta_0\\), then a non-zero \\(\beta_0\\) may be used.

If \\(\hat{\beta}\\) is an ordinary least squares estimator in the classical linear regression model 
(that is, with normally distributed and homoskedastic error terms), and if the true value of 
parameter \\(\beta\\) is equal to \\(\beta_0\\), then the sampling distribution of the t-statistic 
is the Student's t-distribution with \\((n − k)\\) degrees of freedom, where \\(n\\) is the number of 
observations, and \\(k\\) is the number of regressors (including the intercept).

In the majority of models the estimator \\(\hat{\beta}\\) is consistent for \\(\beta\\) and 
distributed asymptotically normally. If the true value of parameter \\(\beta\\) is equal to 
\\(\beta_0\\) and the quantity \\(\mathrm{s.e.}(\hat{\beta})\\) correctly estimates the asymptotic 
variance of this estimator, then the t-statistic will have asymptotically the standard normal 
distribution.

In some models the distribution of t-statistic is different from normal, even asymptotically. For 
example, when a time series with unit root is regressed in the augmented Dickey–Fuller test, the 
test t-statistic will asymptotically have one of the Dickey–Fuller distributions (depending on the 
test setting).

#### Prediction interval

Given a normal distribution \\(\mathcal{N}(\mu, \sigma^2)\\) with unknown mean and variance, the 
t-statistic of a future observation \\(X_{n+1}\\), after one has made \\(n\\) observations, is an 
ancillary statistic – a pivotal quantity (does not depend on the values of \\(\mu\\) and \\(\delta^2\\)) 
that is a statistic (computed from observations). This allows one to compute a frequentist 
prediction interval (a predictive confidence interval), via the following t-distribution:

$$
\frac{X_{n+1} - \bar{X}_n}{s_n\sqrt{1 + n^{-1}}} \sim T^{n-1}
$$

Solving for \\(X_{n+1}\\) yields the prediction distribution

$$
\bar{X}_n + s_n\sqrt{1 + n^{-1}} \cdot T^{n-1}
$$

from which one may compute predictive confidence intervals – given a probability \\(p\\), one may 
compute intervals such that \\(100p\%\\) of the time, the next observation \\(X_{n+1}\\) will fall 
in that interval.

### Linear model

The linear model is written as
$$
\boldsymbol{y} = X\boldsymbol{\beta} + \boldsymbol{\epsilon}
$$

where \\(\boldsymbol{y}\\) denotes the vector of responses, \\(\boldsymbol{\beta}\\) is the vector of 
fixed effects parameters, \\(X\\) is the corresponding design matrix whose columns are the values of 
the explanatory variables, and \\(\epsilon \sim \mathcal{N}(0, \delta^2I)\\) is the vector of random 
errors.

An estimate of \\(\boldsymbol{\beta}\\) is given by

$$
\hat{\boldsymbol{\beta}} = (X^TX)^{−1}X^T\boldsymbol{y}
$$

Hence
$$
\text{Var}(\hat{\boldsymbol{\beta}}) = (X^TX)^{−1}X^T\delta^2IX(X^TX)^{−1} = \delta^2(X^TX)^{−1}
$$

(\\(\text{Var}(A\boldsymbol{X}) = A\text{Var}(X)A^T\\), for some random vector \\(\boldsymbol{X}\\) 
and some non-random matrix A)

so that

$$
\hat{\text{Var}}(\hat{\beta}) = \delta^2(X^TX)^{−1}
$$

where \\(\delta^2\\) can be obtained by the Mean Square Error(MSE) in the ANOVA table.

And the t-statistic is calculated by \\(t = \frac{\hat{\beta}\_i}{\hat{\delta}\_i}\\), where the standard 
error for each coefficient estimate \\(\hat{\delta}\_i = (\hat{\delta}^2[(X^TX)^{-1}]\_{ii})^{\frac{1}{2}}\\).

#### Case for single explanatory variable

$$
y_i = \beta_0 + \beta_1x_i + \epsilon_i, \quad i = 1, \cdots, n
$$

Then

$$
X = \left(\begin{matrix}1 &x_1\\1 &x_2\\\vdots &\vdots\\1 &x_n\end{matrix}\right)
$$

and

$$
\boldsymbol{\beta} = \left(\begin{matrix}\beta_0\\\beta_1\end{matrix}\right)
$$

so that

$$
(X^TX)^{-1} = \frac{1}{n\sum x_i^2 - (\sum x_i)^2}\left(\begin{matrix}\sum x_i^2 & -\sum x_i\\-\sum x_i & n\end{matrix}\right)
$$

The standard error of estimated slope is

$$
\sqrt{\hat{\text{Var}}(\hat{\beta})} = \sqrt{[\hat{\delta}^2(X^TX)^{-1}]_{22}} = \sqrt{\frac{n\hat{\delta}^2}{n\sum x_i^2 - (\sum x_i)^2}}
$$

For more on __ordinary least squares__, see [this wiki](https://en.wikipedia.org/wiki/Ordinary_least_squares){:target='_blank'}.

### The significance test for subset of regressors with f-test

An F-test is any statistical test in which the test statistic has an F-distribution under the null 
hypothesis. It is most often used when comparing statistical models that have been fitted to a data 
set, in order to identify the model that best fits the population from which the data were sampled. 
Exact "F-tests" mainly arise when the models have been fitted to the data using least squares.

Most F-tests arise by considering a decomposition of the variability in a collection of data in 
terms of sums of squares. The test statistic in an F-test is the ratio of two scaled sums of 
squares reflecting different sources of variability. These sums of squares are constructed so that 
the statistic tends to be greater when the null hypothesis is not true. In order for the statistic 
to follow the F-distribution under the null hypothesis, the sums of squares should be statistically 
independent, and each should follow a scaled chi-squared distribution. The latter condition is 
guaranteed if the data values are independent and normally distributed with a common variance.

#### Multiple-comparison ANOVA problems

The F-test in one-way analysis of variance is used to assess whether the expected values of a 
quantitative variable within several pre-defined groups differ from each other. The advantage of 
the ANOVA F-test is that we do not need to pre-specify which treatments are to be compared, and we 
do not need to adjust for making multiple comparisons. The disadvantage of the ANOVA F-test is that 
if we reject the null hypothesis, we do not know which treatments can be said to be significantly 
different from the others, nor, if the F-test is performed at level \\(\alpha\\) we can state that 
the treatment pair with the greatest mean difference is significantly different at level \\(\alpha\\).

The formula for the one-way ANOVA F-test statistic is

$$
F = \frac{\text{explained variance}}{\text{unexplained variance}} = \frac{\text{between-group variability}}{\text{within-group variability}} = \frac{\sum_in_i(\bar{Y}_i - \bar{Y})^2/(K - 1)}{\sum_{ij}(Y_{ij} - \bar{Y}_i)^2/(N - K)}
$$

where \\(\bar{Y}\_i\\) is the sample mean in the \\(i\_{\mathrm{th}}\\) group, \\(n_i\\) is the 
number of observations in the \\(i\_{\mathrm{th}}\\) group, \\(\bar{Y}\\) denotes the overall mean 
of the data, and \\(K\\) denotes the number of groups. And \\(Y_{ij}\\) is the \\(j\_{\mathrm{th}}\\) 
observation in the \\(i\_{\mathrm{th}}\\) out of \\(K\\) groups and \\(N\\) is the overall sample 
size. This F-statistic follows the F-distribution with\\((K - 1, N - K)\\) degrees of freedom under 
the null hypothesis. The statistic will be large if the between-group variability is large relative 
to the within-group variability, which is unlikely to happen if the population means of the groups 
all have the same value.

When there are only two groups for the one-way ANOVA F-test, \\(F = t^2\\) where \\(t\\) is the 
Student's t statistic.

Definitions for Regression with Intercept

- \\(n\\) is the number of observations, \\(p\\) is the number of regression parameters.
- Corrected Sum of Squares for Model (sum of squares for regression): \\(\text{SSM} = \sum_{i = 1}^n(\hat{y}_i - \bar{y})^2\\)
- Sum of Squares for Error (sum of squares for residuals): \\(\text{SSE} = \sum_{i = 1}^n(y_i - \hat{y}_i)^2\\)
- Corrected Sum of Squares Total: \\(\text{SST} = \sum_{i = 1}^n(y_i - \bar{y})^2\\), sample variance of the y-variable 
multiplied by \\(n - 1\\)
- For multiple regression models, \\(\text{SSM} + \text{SSE} = \text{SST}\\)
- Corrected Degrees of Freedom for Model: \\(\text{DFM} = p - 1\\)
- Degrees of Freedom for Error:  \\(\text{DFE} = n - p\\)
- Corrected Degrees of Freedom Total: \\(\text{DFT} = n - 1\\)
- For multiple regression models with intercept, \\(\text{DFM} + \text{DFE} = \text{DFT}\\)
- Mean of Squares for Model: \\(\text{MSM} = \frac{\text{SSM}}{\text{DFM}}\\)
- Mean of Squares for Error: \\(\text{MSE} = \frac{\text{SSE}}{\text{DFE}}\\), sample variance of 
the residuals
- Similar as \\(s^2\\) is unbiased for \\(\delta^2\\), the \\(\text{MSE}\\) is unbiased for 
\\(\delta^2\\) for multiple regression models
- Mean of Squares Total: \\(\text{MST} = \frac{\text{SST}}{\text{DFT}}\\), sample variance of the 
y-variable

#### Overall F-test for regression

$$
H_0: \beta_1 = \beta_2 = \dots = \beta_{p - 1} = 0
$$
$$
H_a: \exists \beta_j \neq 0 \quad for \quad j \in [1, p - 1]
$$

The test statistic is calculated as

$$
F = \frac{\text{MSM}}{\text{MSE}} = \frac{\text{explained variance}}{\text{unexplained variance}}
$$

If \\(H_0\\) is true and the residuals are unbiased, homoscedastic, independent, and normal:

- \\(\frac{\text{SSE}}{\delta^2}\\) has a \\(\chi^2\\) distribution with \\(\text{DFE}\\) degrees of 
freedom.
- \\(\frac{\text{SSM}}{\delta^2}\\) has a \\(\chi^2\\) distribution with \\(\text{DFM}\\) degrees of 
freedom.
- \\(\text{SSE}\\) and \\(\text{SSM}\\) are independent random variables.

If \\(u\\) is a \\(\chi^2\\) random variable with \\(n\\) degrees of freedom, \\(v\\) is a 
\\(\chi^2\\) random variable with \\(m\\) degrees of freedom, and \\(u\\) and \\(v\\) are 
independent, then if \\(F = \frac{\frac{u}{n}}{\frac{v}{m}}\\) has an \\(F\\) distribution with 
\\((n,m)\\) degrees of freedom.

By the previous information, if \\(H_0\\) is true, 
\\(F = \frac{\frac{\text{SSM}/\delta}{\text{DFM}}}{\frac{\text{SSE}/\delta}{\text{DFE}}}\\) has an F 
distribution with \\((\text{DFM}, \text{DFE})\\) degrees of freedom.

But \\(F = \frac{\frac{\text{SSM}/\delta}{\text{DFM}}}{\frac{\text{SSE}/\delta}{\text{DFE}}} = \frac{\frac{\text{SSM}}{\text{DFM}}}{\frac{\text{SSE}}{\text{DFE}}} = \frac{\text{MSM}}{\text{MSE}}\\), 
so \\(F\\) is independent of \\(\delta\\).

### F-test for subset of x

The complete model:

$$
y = \beta_0 + \beta_1x_1 + \beta_2x_2 + \dots + \beta_{p - 1}x_{p - 1} + \beta_px_p + \dots + \beta_{k - 1}x_{k - 1}
$$

The reduced model:

$$
y = \beta_0 + \beta_1x_1 + \beta_2x_2 + \dots + \beta_{p - 1}x_{p - 1}
$$

The null hypothesis \\(H_0\\):

$$
\beta_p = \dots = \beta{k - 1} = 0
$$

The alternative hypothesis \\(H_a\\):

$$
\exists \beta_i \neq 0 \quad for \quad i \in [p, k - 1]
$$

The test statistic:

$$
F = \frac{\frac{(\text{SSE}_r - \text{SSE}_c)}{k - p}}{\frac{\text{SSE}_c}{n - k}} = \frac{\frac{(\text{SSE}_r - \text{SSE}_c)}{\text{number of \beta tested}}}{\text{MSE}_c}
$$

Rejection region:

$$
F \gt F_\alpha
$$

Note that the overall F-test is a special case for subset test.

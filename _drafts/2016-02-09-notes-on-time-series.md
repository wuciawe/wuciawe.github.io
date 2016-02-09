---
layout: post
category: [math]
tags: [stat, time series]
infotext: "notes on time series analysis, containing the very basic concepts, some of them recall me of the course 'digital signal processing'"
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

According to [wiki]( https://en.wikipedia.org/wiki/Time_series ){:target="_blank"}, time series is a sequence of data points that 

- consists of successive measurements made over a time interval
- the time interval is continuous
- the distance in this time interval between any two consecutive data point is the same
- each time unit in the time interval has at most one data point

In probability theory, a stochastic (/stoʊˈkæstɪk/) process, or often random process, is a collection of random variables, representing the evolution of some system of random values over time. This is the probabilistic counterpart to a deterministic process (or deterministic system).

In mathematics and statistics, a stationary process (or strict(ly) stationary process or strong(ly) stationary process) is a stochastic process whose joint probability distribution does not change when shifted in time. Consequently, parameters such as the mean, variance and autocorrelation , if they are present, also do not change over time and do not follow any trends.

Following are three ways to achieve a stationary series:
- differentiate the data, to remove the trend
- make a simple fit, then model on the residuals from the fit, so as to remove the long term trend
- for non-constant variance series, taking the logarithm or square root of the series may stabilize the variance

In statistics, a unit root test tests whether a time series variable is non-stationary using an autoregressive model. A well-known test that is valid in large samples is the augmented Dickey–Fuller test. The optimal finite sample tests for a unit root in autoregressive models were developed by Denis Sargan and Alok Bhargava. Another test is the Phillips–Perron test. These tests use the existence of a unit root as the null hypothesis.

In econometrics and signal processing, a stochastic process is said to be ergodic if its statistical properties can be deduced from a single, sufficiently long, random sample of the process. The reasoning is that any collection of random samples from a process must represent the average statistical properties of the entire process. In other words, regardless of what the individual samples are, a birds-eye view of the collection of samples must represent the whole process. Conversely, a process that is not ergodic is a process that changes erratically at an inconsistent rate.

Univariate time series

Let \\( \\{y_t\\} = \\{ \dots, y_{t-1}, y_t, y_{t+1}, \dots \\} \\) denotes a time series. And suppose \\( \\{y_t\\} \\) is covariance stationary, then

-   \\( \operatorname{E}[y_t] = \mu \quad \forall t \\)
-   \\( \operatorname{cov}(y_t, y_{t-j}) = \operatorname{E}[(y_t - \mu)(y_{t-j} - \mu)] = \gamma_j \quad \forall t, j \\)

Stationary time series have time invariant first and second moments. And \\( \gamma_j \\) is called the \\( j^{th} \\) order or lag \\( j \\) autocovariance of \\( \\{ y_t \\} \\), and a plot of \\( \gamma_j \\) against \\( j \\) is called the autocovariance function.

The autocorrelations of \\( \\{ y_t \\} \\) are defined by:

$$
\begin{equation*}
\rho_j = \frac{\operatorname{cov}(y_t, y_{t-j})}{\sqrt{\operatorname{var}(y_t)\operatorname{var}(y_{t-j})}} = \frac{\gamma_j}{\gamma_0}
\end{equation*}
$$

And a plot of \\( \rho_j \\) against \\( j \\) is called the autocorrelation function (ACF).

Any function of a stationary time series is also stationary, that is, if \\( \\{ y_t \\} \\) is stationary, then \\( \\{ z_t \\} = \\{ g(y_t) \\} \\) is stationary for any function \\( g(\dot) \\).

The lag \\( j \\) sample autocovariance and lag \\( j \\) sample autocorrelation are defined as

$$
\begin{equation*}
\hat{\gamma}_j = \frac{1}{T}\sum_{t = j + 1}^T(y_t - \bar{y})(y_{t-j} - \bar{y})
\end{equation*}
$$

$$
\begin{equation*}
\hat{\rho_j} = \frac{\hat{\gamma}_j}{\hat{\gamma}_0}
\end{equation*}
$$

where \\( \bar{y} = \frac{1}{T}\sum_{t=1}^Ty_t \\) is the sample mean. To see why \\( \hat{\gamma}_j \\) is achieved by deviding \\( T \\) instead of \\( T - j \\), click [here]( http://stats.stackexchange.com/questions/56238/question-about-sample-autocovariance-function ){:target="_blank"}.

A stationary time series \\( \\{ y_t \\} \\) is ergodic if sample moments converge in probability to population moments, i.e. \\( \bar{y} \overset{P}{\to} \mu \\), \\( \hat{\gamma}_j \overset{P}{\to} \gamma_j \\), and \\( \hat{\rho}_j \overset{P}{\to} \rho_j \\).

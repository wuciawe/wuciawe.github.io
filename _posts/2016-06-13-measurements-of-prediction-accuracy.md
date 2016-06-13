---
layout: post
category: [machine learning, math]
tags: [machine learning, stat, math, prediction accuracy]
infotext: 'simple overview on prediction accuracy measurements'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### MSE and RMSE

In statistics, the mean squared error(MSE) or mean squared deviation(MSD) of an estimator measures 
the average of the squares of the errors or deviations, that is, the difference between the 
estimator and what is estimated. MSE is a risk function, corresponding to the expected value of the 
squared error loss or quadratic loss. The difference occurs because of randomness or because the 
estimator doesn't account for information that could produce a more accurate estimate.

The MSE is the second moment(about the origin) of the error, and thus incorporates both the variance 
of the estimator and its bias. For an unbiased estimator, the MSE is the variance of the estimator. 
Like the variance, MSE has the same units of measurement as the square of the quantity being 
estimated. In an analogy to standard deviation, taking the square root of MSE yields the 
root mean square error or root mean square deviation(RMSE or RMSD), which has the same units as the 
quantity being estimated; for an unbiased estimator, the RMSE is the square root of the variance, 
known as the standard deviation.

The mean squared error is given by

$$
MSE = \frac{1}{n}\sum_{i = 1}^n(\hat{y}_i - y_i)^2
$$

And the root mean squared error is given by

$$
RMSE = \sqrt{\frac{1}{n}\sum_{i = 1}^n(\hat{y}_i - y_i)^2}
$$

where \\(y_i\\) is the actual value, \\(\hat{y}_i\\) is the forecast value.

### MAE

In statistics, the mean absolute error(MAE) or mean absolute deviation(MAD) is a quantity used to 
measure how close forecasts or predictions are to the eventual outcomes. The mean absolute error 
is given by

$$
MAE = \frac{1}{n}\sum_{t = 1}^n|\hat{y}_i - y_i| = \frac{1}{n}\sum_{i = 1}^n|e_i|
$$

where \\(y_i\\) is the actual value, \\(\hat{y}_i\\) is the forecast value.

### MAPE

The mean absolute percentage error(MAPE), also known as mean absolute percentage deviation(MAPD), is 
a measure of prediction accuracy of a forecasting method in statistics. It usually expresses accuracy 
as a percentage, and is defined by the formula:

$$
MAPE = \frac{1}{n}\sum_{i = 1}^n\Big|\frac{\hat{y}_i - y_i}{y_i}\Big|
$$

where \\(y_i\\) is the actual value, \\(\hat{y}_i\\) is the forecast value.

Note that the MAPE works when the sequence contains no zero value as it is not defined with zero 
values.

### MASE

In statistics, the mean absolute scaled error(MASE) is a measure of the accuracy of forecasts .

The mean absolute scaled error has the following desirable properties:

- Scale invariance: The mean absolute scaled error is independent of the scale of the data, so can 
be used to compare forecasts across data sets with different scales.
- Predictable behavior as \\(y_i \rightarrow 0\\) : Percentage forecast accuracy measures such as 
the Mean absolute percentage error(MAPE) rely on division of \\(y_i\\), skewing the distribution of 
the MAPE for values of \\(y_i\\) near or equal to \\(0\\).
- Symmetry: The mean absolute scaled error penalizes positive and negative forecast errors equally, 
and penalizes errors in large forecasts and small forecasts equally. In contrast, the MAPE and 
median absolute percentage error(MdAPE) fail both of these criteria, while the "symmetric" sMAPE and 
sMdAPE fail the second criterion.
- Interpretability: The mean absolute scaled error can be easily interpreted, as values greater 
than one indicate that in-sample one-step forecasts from the naïve method perform better than the 
forecast values under consideration.
- Asymptotic normality of the MASE: The Diebold-Mariano test for one-step forecasts is used to test 
the statistical significance of the difference between two sets of forecasts. To perform hypothesis 
testing with the Diebold-Mariano test statistic, it is desirable for \\(DM \sim \mathcal{N}(0,1)\\), 
where \\(DM\\) is the value of the test statistic. The DM statistic for the MASE has been 
empirically shown to approximate this distribution, while the mean relative absolute error(MRAE), 
MAPE and sMAPE do not.

For a non-seasonal time series, the MASE is given by:

$$
MASE = \frac{1}{n}\sum_{i = 1}^n\Big(\frac{|\hat{y}_i - y_i|}{\frac{1}{n - 1}\sum_{i = 2}^n|y_{i - 1} - y_i|}\Big) = \frac{\frac{1}{n}\sum_{i = 1}^n|e_i|}{\frac{1}{n - 1}\sum_{i = 2}^n|y_{i - 1} - y_i|}
$$

And for a seasonal time series with season period \\(m\\), the MASE is given by:

$$
MASE = \frac{1}{n}\sum_{i = 1}^n\Big(\frac{|\hat{y}_i - y_i|}{\frac{1}{n - m}\sum_{i = m + 1}^n|y_{i - m} - y_i|}\Big) = \frac{\frac{1}{n}\sum_{i = 1}^n|e_i|}{\frac{1}{n - m}\sum_{i = m + 1}^n|y_{i - m} - y_i|}
$$

where \\(y_i\\) is the actual value, \\(\hat{y}_i\\) is the forecast value. Actually the non-seasonal 
one is the special case of the seasonal one with season period equals \\(1\\).
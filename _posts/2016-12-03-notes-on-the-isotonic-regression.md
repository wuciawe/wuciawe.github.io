---
layout: post
category: [machine learning, math]
tags: [machine learning, math, regression]
infotext: "The isotonic regression is used to fit monotonic curve, and classifier calibration is a typical use case."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

The isotonic regression, also called the monotonic regression, is the technique of fitting a 
free-form line to a sequence of observations under the following constraints: the fitted free-form 
line has to be non-decreasing everywhere, and it has to lie as close to the observations as possible.

### Inference

In the above constraints, one indicates the regression is monotonic, the other requires the final 
regression should fit the observations well. The goodness of the fitting is usually measured by the 
squared loss function.

Given a sequence \\(\\{a_1, a_2, \cdots, a_n\\}\\) with weights \\(\\{w_1, w_2, \cdots, w_n\\}\\), 
ordered by the indexes \\(\\{1, 2, \cdots, n\\}\\), the isotonic regression is to find the regression 
sequence \\(\\{x_1, x_2, \cdots, x_n\\}\\) following the quadratic problem:

$$
\min \sum\limits_{i = 1}^n w_i (x_i - a_i)^2 \\
\text{ s.t. } \forall i < j \text{, } x_i \leq x_j
$$

There is a \\(O(n)\\) algorithm solving the above problem that is called the pool adjacent violators 
algorithm. The algorithm is based on the following theorem:

For an optimal solution, if \\(a_i > a_{i+1}\\), then \\(x_i = x_{i+1}\\).

Suppose the opposite, \\(\exists x_i < x_{i+1}\\), then for sufficiently small \\(\epsilon\\), we 
can set 

$$
x_i^\mathrm{new} = x_i + w_{i+1} \epsilon \\
x_{i+1}^\mathrm{new} = x_{i+1} - w_i \epsilon
$$

which decreases the cost function \\(\sum\nolimits_i w_i (x_i-a_i)^2\\) without violating the 
constraints. Therefore, our original solution was not optimal. Contradiction!

Since \\(x_i = x_{i+1}\\), we can combine both points \\(a_i\\) and \\(a_{i+1}\\) to a new point 
\\(\frac{w_i a_i + w_{i + 1} a_{i + 1}}{w_i + w_{i + 1}}\\) with new weight \\(w_i + w_{i+1}\\).

### Classifier Calibration Usage

One application of the isotonic regression is to calibrate the classifier output's probability.

For example, the Naive Bayes and the Support Vector Machine both provide the classification result 
with a score, where the score is the \\(P(c | \vec x)\\) for the Naive Bayes and is the distance 
to the hyperplane for the Support Vector Machine. In the case of the Naive Bayes, the 
\\(P(c | \vec x)\\) is only used for making decision and is a bad estimation for the real 
probability \\(P(c | \vec x)\\). In the case of the Support Vector Machine, there is no estimation 
for \\(P(c | \vec x)\\), only thing we are sure about is that a larger distance to the hyperplane 
indicates a larger \\(P(c | \vec x)\\).

In such situations, we can use the empirical probability and the isotonic regression to gain a good 
estimation for the probability \\(P(c | \vec x)\\).

Suppose the classifier provides the scores \\(\\{s_1, s_2, \cdots, s_m\\}\\), the empirical 
probability \\(P(c | s_i)\\) is calculated as:

$$
P(c | s_i) = \frac{\sharp \text{data with label } c \text{ given } s_i}{\sharp \text{data given } s_i} = r_i
$$

With a sorted sequence \\(\\{s_1, s_2, \cdots, s_m\\}\\), we have a sequence of corresponding empirical 
probabilities \\(\\{r_1, r_2, \cdots, r_m\\}\\). Apply the isotonic regression to the empirical 
probability sequence, we have a sequence \\(\\{x_1, x_2, \cdots, x_m\\}\\). Now given a classification 
result with score \\(s_i\\), we use the corresponding \\(x_i\\) as the estimation of the 
classification probability \\(P(c | \vec x)\\). If \\(s_i\\) is not the exact value in sequence 
\\(\\{s_1, s_2, \cdots, s_m\\}\\), we use the interpolation of \\(x_a\\) and \\(x_b\\) as the 
estimation of the lassification probability \\(P(c | \vec x)\\), where \\(s_a < s\\) and \\(s < s_b\\).

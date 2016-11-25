---
layout: post
category: [machine learning, math]
tags: [machine learning, math, decision tree]
infotext: "Introduction to the random forest decision tree, the gradient boosting regression tree, and the adaptive boosting classification tree."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In the previous post, I introduced [the Classification And Regression Tree]({% post_url 2016-11-24-notes-on-classification-and-regression-trees %}), 
and also mentioned that a decision tree with too deep depth may cause overfitting. In this post, I will 
introduce the ensembles of decision trees, which ensemble a lot of shallow decision trees into very 
strong decision trees.

In this post, I will introduce two ways to ensemble decision trees, one is the bagging method, the 
other is the boosting method.

### Bagging Approach

The random forest decision tree is one example of the bagging ensembles of trees. It trains a log of 
shallow decision trees each with a small part of data. So the construction of the random forest can 
be easily parallelized. For classification problem, it generates the final result via majority 
voting, while for regression problem, it generates the final result via averaging.

### Boosting Approach

The gradient boosting regression tree is an example of the boosting ensembles of trees for the 
regression problem. It trains a lot of shallow regression trees with following procedure:

$$
\text{for } n = 1, 2, \cdots, N - 1 \text{ , generate } \mathrm{tree}_{n+1} = \frac{1}{w_{n+1}} \bigl(y - \sum\limits_{i=1}^n w_n\mathrm{tree}_n\bigr)
$$

where \\(w_i\\) is the weight. Note that for each shallow tree, all of the data are used for training.

The adaptive boosting classification tree, also known as adaboost regression tree, is an example 
of the boosting ensembles of trees for the classification problem.

For label \\(y \in \\{-1, 1\\}\\), it trains a lot of shallow classification trees with following 
procedure:

$$
\text{for } n = 1, 2, \cdots, N \\
\quad \text{total error } \mathbb{E}_n = \sum\nolimits_i w_n^i e^{-y^i \alpha_n k_n(x^i)} = \sum\limits_{y^i = k_n(x^i)} w_n^i e^{-\alpha_n} + \sum\limits_{y^i \neq k_n(x^i)} w_n^i e^{\alpha_n} \\
\quad \text{classifier weight } \alpha_n = \frac{1}{2} \ln \frac{\sum\limits_{y^i = k_n(x^i)} w_n^i}{\sum\limits_{y^i \neq k_n(x^i)} w_n^i} = \frac{1}{2} \ln \frac{1-\epsilon_n}{\epsilon_n} \\

$$

where \\(w_n^i=e^{-y^iC_{n-1}(x^i)}\\) is the weight for each data point, and \\(C_n = \sum\limits_{i=1}^n \alpha_i k_i\\) 
is the ensemble in the step \\(n\\), and \\(k_n\\) is the week classifier in the step \\(n\\). Similar 
to the gradient boosting regression tree, in each step the adaboost approach uses all the data for 
training.

So in the gradient boosting approach, it focuses on compensating the prediction difference in each 
step. While in the adaptive boosting approach, it focuses on the amplifying the effect of wrongly 
classified data points in each step.

The gradient boosting decision tree can be extended for classification problem with proper loss function, 
similarly the adaboost decision tree can be extended for regression problem.

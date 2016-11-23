---
layout: post
category: [machine learning, math]
tags: [machine learning, math, stat]
infotext: 'notes on the Naive Bayes Classifier'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

The **Naive Bayes classifier**s are a family of simple probabilistic classifiers based on applying 
Bayes' theorem with strong(naive) independence assumptions between the features.

A Naive Bayes classifier considers each feature to contribute independently to the final probability, 
regardless of any possible correlations between the features.

For some types of probability models, the Naive Bayes classifiers can be trained very efficiently in 
a supervised learning setting. In many practical applications, parameter estimation for Naive Bayes 
models uses the method of maximum likelihood; in other words, one can work with the Naive Bayes model 
without accepting Bayesian probability or using any Bayesian methods.

### Probabilistic model

Abstractly, Naive Bayes is a conditional probability model: given a problem instance to be 
classified, represented by a vector \\(\mathbf{x} = (x_1, \dots, x_n)\\) representing some \\(n\\) 
features(independent variables), it assigns to this instance probabilities 
\\(p(\mathrm{C}_k | x_1, \dots, x_n)\\), for each of \\(\mathrm{K}\\) possible outcomes or classes.

The problem with the above formulation is that if the number of features \\(n\\) is large or if a 
feature can take on a large number of values, then basing such a model on probability tables is 
infeasible. We therefore reformulate the model to make it more tractable. Using Bayes' theorem, the 
conditional probability can be decomposed as

$$
p(\mathrm{C}_k | \mathbf{x}) = \frac{p(\mathrm{C}_k)p(\mathbf{x} | \mathrm{C}_k)}{p(\mathbf{x})}
$$

In plain English, using Bayesian probability terminology, the above equation can be written as

$$
\text{posterior} = \frac{\text{prior} \times \text{likelihood}}{\text{evidence}}
$$

In practice, there is interest only in the numerator of that fraction, because the denominator does 
not depend on \\(\mathrm{C}\\) and the values of the features \\(f_i\\) are given, so that the 
denominator is effectively constant. The numerator is equivalent to the joint probability model

$$
\begin{array}
{}p(\mathrm{C}_k, x_1, \dots, x_n) &= p(x_1, \dots, x_n, \mathrm{C}_k)\\
&= p(x_1 | x_2, \dots, x_n, \mathrm{C}_k)p(x_2, \dots, x_n, \mathrm{C}_k)\\
(\text{chain rule}) \Rightarrow &= \cdots\\
(\text{naive conditional} &= p(x_1 | x_2, \dots, x_n, \mathrm{C}_k)p(x_2 | x_3 \dots, x_n, \mathrm{C}_k) \cdots p(x_n | \mathrm{C}_k)p(\mathrm{C}_k)\\
\text{independence} &= p(x_1 | \mathrm{C}_k)p(x_2 | \mathrm{C}_k) \cdots p(x_n | \mathrm{C}_k)p(\mathrm{C}_k)\\
\text{assumptions}) &= p(\mathrm{C}_k) \prod_{i = 1}^n p(x_i | \mathrm{C}_k)
\end{array}
$$

Thus the joint conditional probability model can be expressed as

$$
\begin{array}
{}p(\mathrm{C}_k | x_1, \dots, x_n) &\propto p(\mathrm{C}_k, x_1, \dots, x_n)\\
&\propto p(\mathrm{C}_k) \prod_{i = 1}^n p(x_i | \mathrm{C}_k)\\
&= \frac{1}{Z} p(\mathrm{C}_k) \prod_{i = 1}^n p(x_i | \mathrm{C}_k)
\end{array}
$$

where the evidence \\(Z = p(\mathbf{x})\\) is a factorization factor dependent only on 
\\(x_1, \dots, x_n\\), that is, a constant if the values of the feature variables are known.

The naive Bayes classifier combines the above model with a decision rule. One common rule is to pick 
the hypothesis that is most probable; this is known as the maximum a posteriori or MAP decision rule. 
The corresponding classifier, a Bayes classifier, is the function that assigns a class label 
\\(\hat{y} = \mathrm{C}_k\\) for some \\(k\\) as follows:

$$
\hat{y} = {\arg\max}_{k \in \{1, \dots, K\}}p(\mathrm{C}_k)\prod_{i=1}^n p(x_i | C_k)
$$

### Parameter estimation and Event models

A class' prior may be calculated by assuming equiprobable classes(i.e. 
\\(\text{priors} = \frac{1}{\text{number of classes}}\\), or by calculating an estimate for the class 
probability from the training set(i.e. \\(\text{prior for class} = \frac{\text{number of samples in the class}}{\text{total number of samples}}\\). 
To estimate the parameters for a feature's distribution, one must assume a distribution or generate 
nonparametric models for the features from the training set.

The assumptions on distributions of features are called the event model of the Naive Bayes 
classifier. For discrete features, multinomial and Bernoulli distributions are popular. These 
assumptions lead to two distinct models, which are often confused.

#### Gaussian Naive Bayes

When dealing with continuous data, a typical assumption is that the continuous values associated 
with each class are distributed according to a Gaussian distribution. For a countinuous attribute 
\\(x\\), the probability distribution of \\(x\\) equals some value \\(v\\), \\(x = v\\), given a 
class \\(c\\) can be calculated as

$$
p(x = v|c) = \frac{1}{\sqrt{2\pi\sigma^2_c}}e^{-\frac{(v-\mu_c)^2}{2\sigma^2_c}}
$$

where \\(\mu_c\\) is the sample mean of \\(x\\) associated with class \\(c\\), and \\(\delta^2\\) is 
the sample variance of \\(x\\) associated with class \\(c\\).

#### Multinomial Naive Bayes

With a multinomial event model, samples(feature vectors) represent the frequencies with which 
certain events have been generated by a multinomial \\((p_1, \dots, p_n)\\) where \\(p_i\\) is the 
probability that event \\(i\\) occurs(or \\(\mathrm{K}\\) such multinomials in the multiclass case). 
A feature vector \\(\mathbf{x} = (x_1, \dots, x_n)\\) is then a histogram, with \\(x_i\\) counting 
the number of times event \\(i\\) was observed in a particular instance. The likelihood of observing 
a histogram \\(\mathbf{x}\\) is given by

$$
p({\mathbf{x}} | \mathrm{C}_k) = \frac{(\sum_i x_i)!}{\prod_i x_i!} \prod_i p_{ki}^{x_i}
$$

The Multinomial Naive Bayes classifier becomes a linear classifier when expressed in log-space:

$$
\begin{array}
\log p(\mathrm{C}_k | \mathbf{x}) &\propto \log \left(p(\mathrm{C}_k) \prod_{i = 1}^n p_{ki}^{x_i}\right)\\
&= \log p(\mathrm{C}_k) + \sum_{i = 1}^nx_i \cdot \log p_{ki}\\
&= b + \mathbf{w}_k^T\mathbf{x}
\end{array}
$$

where \\(b = \log p(\mathrm{C}\_k)\\) and \\(w\_{ki} = \log p\_{ki}\\).

If a given class and feature value never occur together in the training data, then the 
frequency-based probability estimate will be zero. This is problematic because it will wipe out all 
information in the other probabilities when they are multiplied. Therefore, it is often desirable 
to incorporate a small-sample correction, called pseudocount, in all probability estimates such that 
no probability is ever set to be exactly zero. This way of regularizing naive Bayes is called 
__Laplace smoothing__ when the pseudocount is one, and __Lidstone smoothing__ in the general case.

#### Bernoulli Naive Bayes

In the multivariate Bernoulli event model, features are independent booleans(binary variables) 
describing inputs. If \\(x_i\\) is a boolean expressing the occurrence or absence of the \\(i\\)'th 
term from the vocabulary, then the likelihood of a document given a class \\(\mathrm{C}_k\\) is 
given by

$$
p(\mathbf{x} | \mathrm{C}_k) = \prod_{i = 1}^np_{ki}^{x_i}(1 - p_{ki})^{(1 - x_i)}
$$

where \\(p_{ki}\\) is the probability of class \\(\mathrm{C}_k\\) generating the term \\(w_i\\). 

Note that a Naive Bayes classifier with a Bernoulli event model is not the same as a multinomial Naive 
Bayes classifier with frequency counts truncated to one. In the multinomial Naive Bayes classifier, 
non-occurrence features don't contribute to the final probability, while in the Bernoulli Naive Bayes 
classifier those non-occurrence features contribute to the final probability.

### Relation to Logistic Regression

In the case of discrete inputs(indicator or frequency features for discrete events), Naive Bayes 
classifiers form a generative-discriminative pair with(multinomial) logistic regression classifiers: 
each Naive Bayes classifier can be considered a way of fitting a probability model that optimizes 
the joint likelihood \\(p(\mathrm{C}, \mathbf{x})\\), while logistic regression fits the same 
probability model to optimize the conditional \\(p(\mathrm{C} | \mathbf{x})\\).

The link between the two can be seen by observing that the decision function for naive Bayes(in the 
binary case) can be rewritten as "predict class \\(\mathrm{C}_1\\) if the odds of 
\\(p(\mathrm{C}_1 | \mathbf{x})\\) exceed those of \\(p(\mathrm{C}_2 | \mathbf{x})\\)". Expressing 
this in log-space gives:

$$
\log \frac{p(\mathrm{C}_1 | \mathbf{x})}{p(\mathrm{C}_2 | \mathbf{x})} = \log p(\mathrm{C}_1 | \mathbf{x}) - \log p(\mathrm{C}_2 | \mathbf{x}) \gt 0
$$

The left-hand side of this equation is the log-odds, or logit, the quantity predicted by the linear 
model that underlies logistic regression. Since naive Bayes is also a linear model for the two 
"discrete" event models, it can be reparametrised as a linear function 
\\(b + \mathbf{w}^T \mathbf{x} \gt 0\\). Obtaining the probabilities is then a matter of applying 
the logistic function to \\(b + \mathbf{w}^T \mathbf{x}\\), or in the multiclass case, the softmax 
function.

Discriminative classifiers have lower asymptotic error than generative ones; however, in some cases 
Naive Bayes can outperform logistic regression because it reaches its asymptotic error faster.

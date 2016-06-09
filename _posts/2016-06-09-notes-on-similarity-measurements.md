---
layout: post
category: [machine learning, math]
tags: [machine learning, math, stat, similarity]
infotext: "A simple list for several kinds of commonly used similarity measurements."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In statistics and related fields, a similarity measure or similarity function is a real-valued 
function that quantifies the similarity between two objects. Although no single definition of a 
similarity measure exists, usually such measures are in some sense the inverse of distance metrics: 
they take on large values for similar objects and either zero or a negative value for very dissimilar 
objects.

### Euclidean distance

The __Euclidean distance__ between vector \\(\boldsymbol{x}\\) and vector \\(\boldsymbol{y}\\) is 
defined as

$$
d_{\text{euclidean}}(\boldsymbol{x}, \boldsymbol{y}) = ||\boldsymbol{x} - \boldsymbol{y}||_2^2
$$

A similarity measure based on the Euclidean distance can be defined as

$$
s_{\text{euclidean}}(\boldsymbol{x}, \boldsymbol{y}) = -d_{\text{euclidean}}(\boldsymbol{x}, \boldsymbol{y}) = -||\boldsymbol{x} - \boldsymbol{y}||_2^2
$$

### Cosine similarity

Another commonly used similarity measure is the __Cosine similarity__, which is a measure of 
similarity between two vectors of an inner product space that measures the cosine of the angle 
between them. It is defined as

$$
s_{\text{cosine}}(\boldsymbol{x}, \boldsymbol{y}) = \frac{\boldsymbol{x}\boldsymbol{y}}{||\boldsymbol{x}|| \cdot ||\boldsymbol{y}||} = \frac{\sum_{i = 1}^n\boldsymbol{x}_i\boldsymbol{y}_i}{\sqrt{\sum_{i = 1}^n\boldsymbol{x}_i^2}\sqrt{\sum_{i = 1}^n\boldsymbol{y}_i^2}}
$$

The cosine similarity is very efficient to calculate, especially for sparse vectors, since only the 
non-zero dimensions need to be considered.

And the distance can be defined as

$$
d_{\text{cosine}}(\boldsymbol{x}, \boldsymbol{y}) = 1 - s_{\text{cosine}}(\boldsymbol{x}, \boldsymbol{y})
$$

It is important to note, however, that this is not a proper distance metric as it does not have the 
triangle inequality property and it violates the coincidence axiom; to repair the triangle inequality 
property while maintaining the same ordering, it is necessary to convert to angular distance.

The __Angular distance__ is

$$
d_{\text{angular}}(\boldsymbol{x}, \boldsymbol{y}) = \frac{\cos^{-1}(s_{\text{cosine}}(\boldsymbol{x}, \boldsymbol{y}))}{\pi}
$$

And the angular similarity is then

$$
s_{\text{angular}}(\boldsymbol{x}, \boldsymbol{y}) = 1 - d_{\text{angular}}(\boldsymbol{x}, \boldsymbol{y})
$$

### Ochiai coefficient

The __Ochiai coefficient__ is defined as

$$
K = \frac{n(A \bigcap B)}{n(A)\times n(B)}
$$

where \\(A\\) and \\(B\\) are sets, and \\(n(A)\\) is the number of elements in \\(A\\). If sets are 
represented as bit vectors, the Ochiai coefficient can be seen to be the same as the cosine 
similarity.

### Tanimoto metric

The __Tanimoto metric__ is a specialised form of a similarity coefficient with a similar algebraic form 
with the __Cosine similarity__:

$$
T(A, B) = \frac{\sum_i(A_i \bigwedge B_i)}{\sum_i(A_i \bigvee B_i)} = \frac{A\cdot B}{||A||^2 + ||B||^2  - A \cdot B}
$$

In fact, this algebraic form was first defined as a mechanism for calculating the __Jaccard 
coefficient__ in the case where the sets being compared are represented as bit vectors. While the 
formula extends to vectors in general, it has quite different properties from __Cosine similarity__ 
and bears little relation other than its superficial appearance.

And the distance is:

$$
d_{\text{tanimoto}}(A, B) = -\log_2(T(A, B))
$$

This coefficient is, deliberately, not a distance metric. It is chosen to allow the possibility of 
two specimens, which are quite different from each other, to both be similar to a third. It is easy 
to construct an example which disproves the property of triangle inequality.

### Jaccard index

The __Jaccard index__, also known as the __Jaccard similarity coefficient__, is a statistic used for 
comparing the similarity and diversity of sample sets. The __Jaccard coefficient__ measures similarity 
between finite sample sets, and is defined as the size of the intersection divided by the size of the 
union of the sample sets:

$$
J(A, B) = \frac{|A \bigcap B|}{|A \bigcup B|} = \frac{|A \bigcap B|}{|A| + |B| - |A \bigcap B|}
$$

(If both \\(A\\) and \\(B\\) are empty, define \\(J(A, B) = 1\\).)

Then the distance is defined as

$$
d_{\text{jaccard}}(A, B) = 1 - J(A, B) = \frac{|A \bigcup B| - |A \bigcap B|}{|A \bigcup B|} = \frac{A \Delta B}{|A \bigcup B|}
$$

where \\(A \Delta B\\) denotes the symmetric difference.

### Pearson coefficient

The population correlation coefficient \\(\rho_{X,Y}\\) between two random variables \\(X\\) and 
\\(Y\\) with expected values \\(\mu_X\\) and \\(\mu_Y\\) and standard deviations \\(\delta_X\\) and 
\\(\delta_Y\\) is defined as:

$$
\rho_{X,Y} = \text{corr}(X, Y) = \frac{\text{cov}(X, Y)}{\delta_X \delta_Y} = \frac{\mathcal{E}[(X - \mu_X)(Y - \mu_Y)]}{\delta_X \delta_Y}
$$

While the __sample correlation coefficient__ can be used to estimate the __population Pearson 
correlation__ \\(r\\) between \\(X\\) and \\(Y\\):

$$
r_{x, y} = \frac{\sum_{i = 1}^n(x_i - \bar{x})(y_i - \bar{y})}{ns_xs_y} = \frac{\sum_{i = 1}^n(x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\sum_{i = 1}^n(x_i - \bar{x})^2\sum_{i = 1}^n(y_i - \bar{y})^2}}\\
$$

which can also be viewed as:

$$
r_{x, y} = \frac{\sum_{i = 1}^nx_iy_i - \bar{x}\bar{y}}{ns_xs_y} = \frac{n\sum_{i = 1}^nx_iy_i - \sum_{i = 1}^nx_i\sum_{i = 1}^ny_i}{\sqrt{n\sum_{i = 1}^nx_i^2 - (\sum_{i = 1}^nx_i)^2}\sqrt{n\sum_{i = 1}^ny_i^2 - (\sum_{i = 1}^ny_i)^2}}
$$

### Spearman's rank correlation coefficient

In statistics, __Spearman's rank correlation coefficient__ or __Spearman's \\(\rho\\)__ is a 
nonparametric measure of rank correlation (statistical dependence between the ranking of two 
variables). It assesses how well the relationship between two variables can be described using a 
monotonic function.

The Spearman correlation between two variables is equal to the Pearson correlation between the rank 
values of those two variables; while Pearson's correlation assesses linear relationships, 
Spearman's correlation assesses monotonic relationships (whether linear or not). If there are no 
repeated data values, a perfect Spearman correlation of \\(+1\\) or \\(−1\\) occurs when each of the 
variables is a perfect monotone function of the other.

The Spearman correlation coefficient is defined as the Pearson correlation coefficient between the 
ranked variables.

For a sample of size \\(n\\), the \\(n\\) raw scores \\(X_i\\), \\(Y_i\\)  are converted to ranks 
\\(\operatorname{rg} X_i\\), \\(\operatorname{rg} Y_i\\), and \\(r_s\\) is computed from:

$$
r_s = \rho_{\operatorname{rg}X, \operatorname{rg}Y} = \frac{\text{cov}(\operatorname{rg}X, \operatorname{rg}Y)}{\delta_{\operatorname{rg}X}\delta_{\operatorname{rg}Y}}
$$

where \\(\rho\\) denotes the Pearson correlation coefficient, \\(\text{cov}(\operatorname{rg}X, \operatorname{rg}Y)\\) 
denotes the covariance of the rank variables, \\(\delta_{\operatorname{rg}X}\\) and \\(\delta_{\operatorname{rg}Y}\\) 
denote the standard deviations of the rank variables.

Only if all \\(n\\) ranks are distinct integers, it can be computed using the popular formula

$$
r_s = 1 - \frac{6\sum_i d_i^2}{n(n^2 - 1)}
$$

where \\(d_i = \operatorname{rg}X_i - \operatorname{rg}Y_i\\) is the difference between the two ranks 
of each observation.

### Hamming distance

In information theory, the __Hamming distance__ between two strings of equal length is the number of 
positions at which the corresponding symbols are different. In another way, it measures the minimum 
number of substitutions required to change one string into the other, or the minimum number of 
errors that could have transformed one string into the other.

A major application is in coding theory, more specifically to block codes, in which the equal-length 
strings are vectors over a finite field.
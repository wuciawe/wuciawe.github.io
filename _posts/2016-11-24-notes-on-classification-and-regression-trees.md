---
layout: post
category: [machine learning, math]
tags: [machine learning, math, decision tree]
infotext: "A very rough view on the CART, without the mention of implementation details."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

CART, abbreviation for the Classification And Regression Tree, is a kind of decision trees, which is 
able to classify or regress the data as its own name indicated. Naive implementation follows a 
greedy fashion.

Given a dataset \\(\boldsymbol{D} = \\{(\vec x_1, y_1), (\vec x_2, y_2), \cdots, (\vec x_n, y_n)\\}\\), 
where each \\(\vec x_i\\) is a \\(k\\) dimensional feature, and \\(y_i\\) is a continuous number for 
regression problem or categorical label for classification problem, the CART algorithm builds a 
binary tree, where each root node best splits the tree node with respect to maximizing the 
information gain among all the possible splits. Also note that the features \\(\vec x_i\\) can be 
either continuous or discrete, both kinds of feature are easy to be used for splitting.

The leaf nodes of the tree contain an output variable \\(\hat y\\) which is used to make a prediction. 
In the prediction procedure, the data \\(\vec x\\) walks down the binary tree according to the 
splitting conditions at each root node, and finally reaches a leaf, whose \\(\hat y\\) is the 
prediction result.

### Node impurity and information gain

The node impurity is a measure of the homogeneity of the labels at the node. The Gini impurity and 
entropy are usually for classification, while variance is usually for regression.

{:.table.table-condensed}
|----------+------+---------+-------------|
| Impurity | Task | Formula | Description |
|----------|------|---------|-------------|
| Gini Impurity | Classification | \\(\sum\limits_{i=1}^C f_i(1 - f_i)\\)  | \\(f_i\\) is the frequency of label \\(i\\) at a node and \\(C\\) is the number of unique labels | 
| Entropy       | Classification | \\(\sum\limits_{i=1}^C -f_i \log f_i\\) | \\(f_i\\) is the frequency of label \\(i\\) at a node and \\(C\\) is the number of unique labels |
| Variance      | Regression     | \\(\frac{1}{N}\sum\limits_{i=1}^N(y_i−\mu)^2\\) | \\(y_i\\) is numerical value for an instance, \\(N\\) is the number of instances and \\(\mu\\) is the mean given by \\(\frac{1}{N}\sum\limits_{i=1}^N y_i\\) |

The information gain is the difference between the parent node impurity and the weighted sum of the 
two child node impurities. Assuming that a split \\(s\\) partitions the dataset \\(\boldsymbol{D}\\) 
of size \\(N\\) into two datasets \\(\boldsymbol{D}\_\text{left}\\) and \\(\boldsymbol{D}\_\text{right}\\) 
of sizes \\(N_\text{left}\\) and \\(N_\text{right}\\), respectively, the information gain is: 

$$
IG(\boldsymbol{D},s) = \text{Impurity}(\boldsymbol{D}) − \frac{N_\text{left}}{N} \text{Impurity}(\boldsymbol{D}_\text{left}) − \frac{N_\text{right}}{N} \text{Impurity}(\boldsymbol{D}_\text{right})
$$

### Split candidates

#### Continuous features

For small datasets, the split candidates for each continuous feature are typically the unique values 
for the feature. Some implementations sort the feature values and then use the ordered unique values 
as split candidates for faster tree calculations.

For large datasets, it is reasonable to perform a quantile calculation over a sampled fraction of 
the data for computing the approximate set of split candidates.

#### Categorical features

For a categorical feature with \\(M\\) possible values (categories), one could come up with \\(2^{M−1}\\) 
split candidates. For binary classification and regression, we can reduce the number of split 
candidates to \\(M−1\\) by ordering the categorical feature values by the average label.

### Stopping rule

Usually, the recursive tree construction is stopped at a node when one of the following conditions 
is met:

- The node depth is equal to the maximum depth
- No split candidate leads to an information gain greater than the minimum information gain threshold
- No split candidate produces child nodes which each have at least minimum instances

Note that, a too deep decision tree may surfer from overfitting.

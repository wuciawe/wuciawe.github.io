---
layout: post
category: [math]
tags: [stat, math]
infotext: "It is the number of ways to partition a set of objects into non-empty subsets."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In the study of paritions, a Stirling number of the second type, \\(\{n \brace k\}\\), denotes the 
number of ways to partition a set of \\(n\\) objects into \\(k\\) non-empty subsets.

The Stirling numbers of the second type can be calculated with the explicit formula:

$$
{n \brace k} = \frac{1}{k!}\sum\limits_{i = 0}^k (-1)^{k - i} {k \choose i} i^n
$$

#### Recursive form

The Stirling numbers of the second type can also be expressed in a recursive form:

$$
{n + 1 \brace k} = k{n \brace k} + {n \brace k - 1}
$$

with initial conditions

$$
{0 \brace 0} = 1 \text{, and } {n \brace 0} = {0 \brace n} = 1
$$

To understand this recurrence, observe that a partition of the \\(n + \\)1 objects into \\(k\\) 
nonempty subsets either contains the \\({n + 1}^{th}\\) object as a singleton or it does not. The 
number of ways that the singleton is one of the subsets is given by
\\(\{n \brace k - 1\}\\)
, since we must partition the remaining \\(n\\) objects into the available \\(k - 1\\) subsets. 

In the other case the \\({n + 1}^{th}\\) object belongs to a subset containing other objects. The 
number of ways is given by
\\(k \{n \brace k\}\\)
, since we partition all objects other than the \\({n + 1}^{th}\\) into \\(k\\) subsets, and then 
we are left with \\(k\\) choices for inserting object \\(n + 1\\).

Summing these two values gives the desired result.

Some more recurrences are as follows:

$$
{n + 1 \brace k + 1} = \sum\limits_{j = k}^n {n \choose j} {j \brace k}
$$

$$
{n + 1 \brace k + 1} = \sum\limits_{j = k}^n (k + 1)^{n - j} {j \brace k}
$$

$$
{n + k + 1 \brace k} = \sum\limits_{j = 0}^k j {n + j \brace j}
$$

#### Proof of the explicit form

Following is the a combinatoric proof of the Stirling numbers of the second type:

In the proof, we count the number, \\(\mathrm{N}\\), of onto functions \\(f\\) from the set 
\\(S_1 = \\{1, 2, \cdots, n\\}\\) to \\(S_2 = \\{1, 2, \cdots, k\\}\\) in two ways.

__First count__. We will express this in terms of \\(\{n \brace k\}\\). To do so, we partition 
\\(S_1\\) into \\(k\\) disjoint parts \\(P_i\\) and let \\(f(x) = i\\) for all \\(x \in P_i\\). 
By definition, this can be done in \\(\{n \brace k\}\\) ways. Then we permute the \\(k\\) partitions 
\\(P_i\\), which gives us the following result: \\(N = k!\{n \brace k\}\\).

__Second count__. Count the number with the help of 
[the inclusion exclusion principle]({% post_url 2016-11-13-notes-on-the-inclusion-exclusion-principle %}).

$$
\lvert \bigcup\limits_{j = 1}^n S_j \lvert = \sum\limits_{k = 1}^n \Big[(−1)^{k + 1} \sum\limits_{1 \leq j_1 < \cdots < j_k \leq n} \lvert S_{j_1} \cap \cdots \cap S_{j_k} \lvert \Big]
$$

Let \\(\mathrm{X}\\) be the set of all functions \\(f: S_1 \rightarrow S_2\\). Then it is clear that 
\\(\lvert \mathrm{X} \lvert = k^n\\), since for each of the \\(n\\) elements in \\(S_1\\), we have 
\\(k\\) choices. Now, for each \\(j\\) such that \\(1 \leq j \leq k_1 \leq j \leq k\\), let 
\\(X_j = \\{f: S_1 \rightarrow S_2 \text{ such that } f \text{ does not have } j \text{ in its range}\\}\\).

Since we want to count \\(N\\), the number of onto functions (that is, functions with all elements 
of \\(S_2\\) in their ranges),

$$
N = \lvert \bigcap\limits_{j = 1}^k (\mathrm{X} − \mathrm{X}_j) \lvert = \lvert \mathrm{X} − \bigcup\limits_{j = 1}^k \mathrm{X}_j \lvert = k^n − \lvert \bigcup\limits_{j = 1}^k \mathrm{X}_j \lvert
$$

By an argument similar to before, we have 

$$
\lvert \mathrm{X}_j \lvert = (k − 1)^n \lvert \mathrm{X}_j \lvert = (k − 1)^n
$$

and 

$$
\sum\limits_{1 \leq i_1 < \cdots < i_j \leq k} \lvert \mathrm{X}_{i_1} \cap \mathrm{X}_{i_2} \cap \cdots \cap \mathrm{X}_{i_j} \lvert = {k \choose j}(k - j)^n
$$

Finally, by the principle of inclusion exclusion, we have

$$
\mathrm{N} = k^n − (\sum\limits_{j = 1}^k (−1)^{j + 1} {k \choose j} (k − j)^n) = \sum\limits_{j = 0}^k (−1)^j {k \choose j} (k − j)^n
$$

__Equating__. With two kinds of expression of \\(\mathrm{N}\\), we have

$$
k!{n \brace k} = \sum\limits_{j = 0}^k (−1)^j {k \choose j} (k − j)^n
$$

which is equivalent to 

$$
{n \brace k} = \frac{1}{k!} \sum\limits_{j = 0}^k (−1)^j {k \choose j} (k − j)^n
$$

and with substituting \\(j = k - i\\), we have

$$
{n \brace k} = \frac{1}{k!} \sum\limits_{i = 0}^k (−1)^{k - i} {k \choose k - i} i^n = \frac{1}{k!} \sum\limits_{i = 0}^k (−1)^{k - i} {k \choose i} i^n
$$

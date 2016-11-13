---
layout: post
category: [math]
tags: [stat, math]
infotext: "The inclusion-exclusion principle is a generalized technique for finding the cardinality of the union of sets."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

For finite sets \\(A_1, A_2, \cdots, A_n\\), we have the identity:

$$
\lvert A_1 \cup A_2 \cup \cdots \cup A_n \lvert = \sum \limits_{m = 1}^n (-1)^{m + 1} S_m
$$

where 

$$
S_1 = \sum \limits_{i=1}^n \lvert A_i \lvert \\
S_2 = \sum \limits_{i<j} \lvert A_i \cap A_j\lvert \\
S_m = \sum \limits_{i(1)< \cdots <i(m)} \lvert A_{i(1)} \cap \cdots \cap A_{i(m)}\lvert
$$

In words, to count the number of elements in a finite union of finite sets, first sum the 
cardinalities of the individual sets, then subtract the number of elements which appear in more 
than one set, then add back the number of elements which appear in more than two sets, then 
subtract the number of elements which appear in more than three sets, and so on. This process 
naturally ends since there can be no elements which appear in more than the number of sets in the 
union.

In applications it is common to see the principle expressed in its complementary form. That is, 
letting \\(S\\) be a finite universal set containing all of the Ai and letting \\(\bar{A}_i\\) 
denote the complement of \\(A_i\\) in \\(S\\), by De Morgan's laws we have

$$
\lvert \bigcap_{i = 1}^{n} \bar{A_i} \lvert = \lvert S - \bigcup_{i = 1}^{n} A_i \lvert = \lvert S \lvert - \lvert \bigcup_{i = 1}^{n} A_i \lvert = \lvert S \vert - \sum_{i = 1}^{n} \lvert A_i \lvert + \sum_{1 \leq i < j \leq n} \lvert A_i \cap A_j \lvert - \cdots + (-1)^{n} \lvert A_1 \cap \cdots \cap A_n \lvert
$$

#### Example - Counting Integers

How many integers in \\(\{1, \cdots, 100\}\\) are not divisible by \\(2\\), \\(3\\) or \\(5\\)?

Let \\(S = \{1, \cdots, 100\}\\) and \\(P_1\\) the property that an integer is divisible by \\(2\\), 
\\(P_2\\) the property that an integer is divisible by \\(3\\) and \\(P_3\\) the property that an 
integer is divisible by \\(5\\). Letting \\(A_i\\) be the subset of \\(S\\) whose elements have 
property \\(P_i\\) we have by elementary counting: \\(\lvert A_1 \lvert = 50\\), \\(\lvert A_2 \lvert = 33\\), 
and \\(\lvert A_3 \lvert = 20\\). There are \\(16\\) of these integers divisible by \\(6\\), \\(10\\) 
divisible by \\(10\\) and \\(6\\) divisible by \\(15\\). Finally, there are just \\(3\\) integers 
divisible by \\(30\\), so the number of integers not divisible by any of \\(2\\), \\(3\\) or \\(5\\) 
is given by:

$$
100 − (50 + 33 + 20) + (16 + 10 + 6) − 3 = 26.
$$

In the above example, we are using the De Morgan's law to solve the problem, since it's hard to find 
the integers not divisible by \\(2\\), \\(3\\) or \\(5\\) directly, we find the complementary events 
that the integers divisible by \\(2\\), \\(3\\) or \\(5\\).

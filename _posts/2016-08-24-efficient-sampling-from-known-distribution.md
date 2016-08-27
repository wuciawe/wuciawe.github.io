---
layout: post
category: [math]
tags: [math, stat]
infotext: 'Alias table: an efficient sampling method from known distribution.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

When reading some implementation of LDA, I meet the term `Alias table`. After some 
searching, it is a family of efficient algorithms for sampling from a discrete 
probability distribution, which requires \\(O(n \log n)\\) or \\(O(n)\\) time for 
preprocessing, and \\(O(1)\\) time for generating each sample.

Directly reading Vose's paper makes me feel a little confused, after reading [this 
article (by Keith Schwarz)](http://www.keithschwarz.com/darts-dice-coins/){:target='_blank'}, 
everything turns out to be very clear.

I will discuss the way to sample from known distribution step by step.

### Sample from known distribution directly

`Assume: ` we have a uniform random number generator at hand. And this assumption is hold 
for whole article.

Suppose we want to sample numbers between \\([0, 1)\\), imagine there is a segment, and we can 
uniformly select points from that segment. Suppose the segment is composed with sub-segments, 
which are mutually disjoint with each other, the probability we select the sub-segment is 
proportional to its length. The longer the sub-segment, the more probably our selected point 
belongs to it.

There are two straight forward ways to sample from a known distribution with uniform random 
number generator, one is based one least common multiple, the other is based on searching with 
the ordered accumulated probabilities.

#### LCM way

Suppose the probabilities \\(\\{p_1, \cdots, p_n\\}\\) are rational numbers. Following is the 
description of algorithm:

$$
\begin{align}
\mbox{Algorithm:}\\
&\cdot \mbox{ Initialization:}\\
&\qquad 1.\; \mbox{Find the } LCM \mbox{ of the denominators of the probabilities } p_1, p_2, \dots, p_n \mbox{.}\\
&\qquad 2.\; \mbox{Allocate an array } A \mbox{ of size } LCM \mbox{ mapping to the indexes of probabilities.}\\
&\qquad 3.\; \mbox{For each probability } i \mbox{ , in any order:}\\
&\qquad \qquad 1.\; \mbox{Set the next } LCM \cdot p_i \mbox{ entries of } A \mbox{ to be } i \mbox{.}\\
&\cdot \mbox{ Generation:}\\
&\qquad 1.\; \mbox{Generate an integer } S \mbox{ in } [0, LCM - 1] \mbox{.}\\
&\qquad 2.\; \mbox{Return } A[S]\mbox{.}
\end{align}
$$

![LCM based](/files/2016-08-24-efficient-sampling/lcm-array.png)

Above is an example for sampling from \\(\\{\frac{1}{2}, \frac{1}{3}, \frac{1}{12}, \frac{1}{12}\\}\\).

This algorithm requires \\(O(\prod_i d_i)\\) initialization time, 
\\(\Theta(1)\\) sampling time, and \\(O(\prod_i d_i)\\) space.

#### Searching way

This algorithm is also called Roulette Wheel Selection. Following is the description of algorithm:

$$
\begin{align}
\mbox{Algorithm:}\\
&\cdot \mbox{Initialization:}\\
&\qquad 1.\; \mbox{Allocate an array } A \mbox{ of size } n \mbox{.}\\
&\qquad 2.\; \mbox{Set } A[0] = p_1 \mbox{.}\\
&\qquad 3.\; \mbox{For each probability } i \mbox{ from } 2 \mbox{ to } n \mbox{.}\\
&\qquad \qquad 1.\; \mbox{Set } A[i - 1] = A[i - 2] + p_n \mbox{.}\\
&\cdot \mbox{Generation:}\\
&\qquad 1.\; \mbox{Generate an integer } x \mbox{ in } [0, 1) \mbox{.}\\
&\qquad 2.\; \mbox{Binary search the index } i \mbox{ of the smallest element in } A \mbox{ larger than } x \mbox{.}\\
&\qquad 3.\; \mbox{Return } i + 1 \mbox{.}
\end{align}
$$

![Roulette Wheel Selection](/files/2016-08-24-efficient-sampling/rws.png)

Above is an example for sampling from \\(\\{\frac{1}{4}, \frac{1}{5}, \frac{1}{8}, \frac{1}{8}, \frac{1}{8}, \frac{1}{10}, \frac{1}{10}, \frac{1}{10}\\}\\).

This algorithm requires \\(\Theta(n)\\) initialization time, \\(\Theta(\log(n))\\) sampling time, 
and \\(\Theta(n)\\) space.

It is possible to improve the expected sampling performance by building an unbalanced binary 
search tree, which is extremely well-studied and is called [the optimal binary search tree problem](https://en.wikipedia.org/wiki/Binary_search_tree#Optimal_binary_search_trees){:target='_blank'}. 
There are many algorithms for solving this problem; it is known that an exact solution can be 
found in time \\(O(n^2)\\) using dynamic programming, and there exist good linear-time algorithms 
that can find approximate solutions. Additionally, [the splay tree data structure](https://en.wikipedia.org/wiki/Splay_tree){:target='_blank'}, 
a self-balancing binary search tree, can be used to get to within a constant factor of the 
optimal solution.

### Sample from known distribution with rejection

Now, imagine we are going to sample \\(n\\) numbers with probabilities \\(\\{p_1, \cdots, p_n\\}\\) 
from a bounding box, which is composed as follows: each probability \\(p_i\\) builds up a 
rectangle with width \\(w\\) and height \\(\max(p_i)\\), then the bounding box is splitted by 
\\(n + 1\\) logic components, where \\(n\\) rectangle components corresponding to \\(n\\) 
probabilities, and a remaining area.

Following is an example for bounding box of probabilities 
\\(\\{\frac{1}{2}, \frac{1}{3}, \frac{1}{12}, \frac{1}{12}\\}\\):

![Bounding Box](/files/2016-08-24-efficient-sampling/boundingbox.png)

Then we sample points from the bounding box, when the sampled point belongs to the rectangle built 
by a probability, keep it, or discard it and keep going on sampling until getting one belongs to a 
rectangle.

Following is the description of algorithm:

$$
\begin{align}
\mbox{Algorithm:}\\
&\cdot \mbox{Initialization:}\\
&\qquad 1.\; \mbox{Find the maximum value of } p_i \mbox{ as } p_{max} \mbox{.}\\
&\qquad 2.\; \mbox{Allocate an array } A \mbox{ of length } n \mbox{.}\\
&\qquad 3.\; \mbox{For each probability } p_i \mbox{.}\\
&\qquad \qquad 1.\; \mbox{Set } A[i] = \frac{p_i}{p_{max}}\\
&\cdot \mbox{Generation:}\\
&\qquad 1.\; \mbox{Until a value is found}\\
&\qquad \qquad 1.\; \mbox{Generate an integer } i \mbox{ in the range } [0, n - 1] \mbox{.}\\
&\qquad \qquad 2.\; \mbox{Generate a number } x \mbox{ in } [0, 1) \mbox{.}\\
&\qquad 3.\; \mbox{If } x \le A[i] \mbox{, return } i \mbox{.}
\end{align}
$$

This algorithm requires \\(\Theta(n)\\) initialization time, 
\\(\Theta(\log(n))\\) expected sampling time, and \\(\Theta(n)\\) space.

### The Alias Table Method

The alias table method improves above algorithm by building up an alias table so as to avoid 
rejection and re-sampling in the sampling process.

It can be shown that the height of the rectangles doesn't impact the result. So first scale the 
heights of the rectangles as the probabilities with the number of probabilities, such that the 
total area of all the rectangles becomes \\(1\\). Then we rearrange the rectangles so as to build 
up a rectangle bounding box with area \\(1\\).

Following is an example for \\(\\{\frac{1}{2}, \frac{1}{3}, \frac{1}{12}, \frac{1}{12}\\}\\)

![Alias Table Method](/files/2016-08-24-efficient-sampling/aliastable.png)

#### Naive Alias Table Method

The naive alias table method builds up the bounding box with a straight forward way.

Following is the description of algorithm:

$$
\begin{align}
\mbox{Algorithm:}\\
&\cdot \mbox{Initialization:}\\
&\qquad 1.\; \mbox{Multiply each probability } p_i \mbox{ by } n \mbox{.}\\
&\qquad 2.\; \mbox{Create arrays } Alias \mbox{ and } Prob \mbox{ each of size } n \mbox{.}\\
&\qquad 3.\; \mbox{For } j = 1 \mbox{ to } n - 1\\
&\qquad \qquad 1.\; \mbox{Find a probability } p_l \mbox{ satisfying } p_l \le 1 \mbox{.}\\
&\qquad \qquad 2.\; \mbox{Find a probability } p_g \mbox{ (with } l \neq g \mbox{) satisfying } p_g \ge 1 \mbox{.}\\
&\qquad \qquad 3.\; \mbox{Set } Prob[l] = p_l \mbox{.}\\
&\qquad \qquad 4.\; \mbox{Set } Alias[l] = g \mbox{.}\\
&\qquad \qquad 5.\; \mbox{Remove } p_l \mbox{ from the list of initial probabilities.}\\
&\qquad \qquad 6.\; \mbox{Set } p_g := p_g - (1 - p_l) \mbox{.}\\
&\qquad \qquad 7.\; \mbox{Let } i \mbox{ be the last probability remaining, which must have weight } 1 \mbox{.}\\
&\qquad \qquad 8.\; \mbox{Set } Prob[i] = 1 \mbox{.}\\
&\cdot \mbox{Generation:}\\
&\qquad 1.\; \mbox{Generate an integer } i \mbox{ in the range } [0, n - 1] \mbox{.}\\
&\qquad 2.\; \mbox{Generate a number } x \mbox{ in } [0, 1) \mbox{.}\\
&\qquad 3.\; \mbox{If } x \le Prob[i] \mbox{, return } i \mbox{.}\\
&\qquad 4.\; \mbox{Otherwise, return } Alias[i] \mbox{.}
\end{align}
$$

It is clear that this algorithm requires \\(O(n^2)\\) initialization time, 
\\(\Theta(1)\\) expected sampling time, and \\(\Theta(n)\\) space.

#### Vose's Alias Table Method

The Vose's alias table method further improves the performance in the initialization step.

Following is the description of algorithm:

$$
\begin{align}
\mbox{Algorithm:}\\
&\cdot \mbox{Initialization:}\\
&\qquad 1.\; \mbox{Create arrays } Alias \mbox{ and } Prob \mbox{ each of size } n \mbox{.}\\
&\qquad 2.\; \mbox{Create two worklists, } Small \mbox{ and } Large \mbox{.}\\
&\qquad 3.\; \mbox{Multiply each probability by } n \mbox{.}\\
&\qquad 4.\; \mbox{For each scaled probability } p_i \mbox{.}\\
&\qquad \qquad 1.\; \mbox{If } p_i \lt 1 \mbox{, and } i \mbox{ to } Small \mbox{.}\\
&\qquad \qquad 2.\; \mbox{Otherwise, add } i { to } Large \mbox{.}\\
&\qquad 5.\; \mbox{While } Small \mbox{ is not empty}\\
&\qquad \qquad 1.\; \mbox{Remove the first element } l \mbox{ from } Small \mbox{.}\\
&\qquad \qquad 2.\; \mbox{Remove the first element } g \mbox{ from } Large \mbox{.}\\
&\qquad \qquad 3.\; \mbox{Set } Prob[l] = p_l \mbox{.}\\
&\qquad \qquad 4.\; \mbox{Set } Alias[l] = g \mbox{.}\\
&\qquad \qquad 5.\; \mbox{Set } p_g := p_g - (1 - p_l) \mbox{.}\\
&\qquad \qquad 6.\; \mbox{If } p_g \lt 1 \mbox{, add } g \mbox{ to } Small \mbox{.}\\
&\qquad \qquad 7.\; \mbox{Otherwise, add } g \mbox{ to } Large \mbox{.}\\
&\qquad 6.\; \mbox{While } Large { is not empty}\\
&\qquad \qquad 1.\; \mbox{Remove the first element } g \mbox{ from } Large \mbox{.}\\
&\qquad \qquad 2.\; \mbox{Set } Prob[g] = 1 \mbox{.}\\
&\qquad 7.\; \mbox{While } Small \mbox{ is not empty: This is only possible due to numerical instability.}\\
&\qquad \qquad 1.\; \mbox{Remove the first element } l \mbox{ from } Small \mbox{.}\\
&\qquad \qquad 2.\; \mbox{Set } Prob[l] = 1 \mbox{.}\\
&\cdot \mbox{Generation:}\\
&\qquad 1.\; \mbox{Generate an integer } i \mbox{ in the range } [0, n - 1] \mbox{.}\\
&\qquad 2.\; \mbox{Generate a number } x \mbox{ in } [0, 1) \mbox{.}\\
&\qquad 3.\; \mbox{If } x \le Prob[i] \mbox{, return } i \mbox{.}\\
&\qquad 4.\; \mbox{Otherwise, return } Alias[i] \mbox{.}
\end{align}
$$

The algorithm requires \\(\Theta(n)\\) initialization time, 
\\(\Theta(1)\\) expected sampling time, and \\(\Theta(n)\\) space.

### Bonus

#### Simulating a biased coin

$$
\begin{align}
\mbox{Algorithm:}\\
&1.\; \mbox{Generate a uniformly-random value } x \mbox{ in the range } [0,1) \\
&2.\; \mbox{If } x \lt p_{heads} \mbox{, return "heads"}\\
&3.\; \mbox{If } x \ge p_{heads} \mbox{, return "tails"}
\end{align}
$$

#### Simulating a fair die with biased coins

$$
\begin{align}
\mbox{Algorithm:}\\
&1.\; \mbox{For } i=0 \mbox{ to } n-1 \\
&\qquad 1.\; \mbox{Flip a biased coin with probability } \frac{1}{n−i} \mbox{ of coming up heads}\\
&\qquad 2.\; \mbox{If it comes up heads, return } i
\end{align}
$$

#### Simulate loaded die from biased coins

$$
\begin{align}
\mbox{Algorithm:}\\
&\cdot \mbox{Initialization:}\\
&\qquad 1.\; \mbox{Store the probabilities } p_i\\
&\cdot \mbox{Generation:}\\
&\qquad 1.\; \mbox{Set } mass = 1\\
&\qquad 2.\; \mbox{For } i = 0 \mbox{ to } n - 1\\
&\qquad \qquad 1.\; \mbox{Flip a biased coin with probability } \frac{p_i}{mass} \mbox{ of coming up heads}\\
&\qquad \qquad 2.\; \mbox{If it comes up heads, return } i\\
&\qquad \qquad 3.\; \mbox{Otherwise, set } mass = mass - p_i\\
\end{align}
$$
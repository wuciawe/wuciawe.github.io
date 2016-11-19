---
layout: post
category: [math]
tags: [stat, math]
infotext: "Basics on combination and permutation."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

When dealing with the problem of placing balls in boxes or choosing balls, it is usually helpful to 
thinking the problem in terms of [the stars and bars problem](https://en.wikipedia.org/wiki/Stars_and_bars_%28combinatorics%29){:target='_blank'}, 
which is a graphical aid for deriving certain combinatorial theorems.

### Placing balls into boxes

Following table lists the possible combinations of the restrictions. Note that the term exclusive means 
that each box contains no more than \\(1\\) ball.

{:.table.table-condensed}
|---+---------------+---------------+-----------+-------------+------------------|
| # | \\(n\\) balls | \\(k\\) boxes | exclusive | empty boxes | \\(\mathrm{N}\\) |
|---|---------------|---------------|-----------|-------------|------------------|
| 1 | dist | dist | with | yes | \\(n!\{k \choose n\} \text{ , } k \geq n\\) | 
| 2 | dist | dist | with | no | \\(\begin{cases} n! \text{ if } k = n \\\\ 0 \text{ if } k \neq n \end{cases}\\) | 
| 3 | dist | dist | without | yes | \\(k^n\\) | 
| 4 | dist | dist | without | no | \\(k!\{n \brace k\} \text{ , } k \leq n\\) | 
| 5 | indist | dist | with | yes | \\(\{k \choose n\} \text{ , } k \geq n\\) | 
| 6 | indist | dist | with | no | \\(\begin{cases} 1 \text{ if } k = n \\\\ 0 \text{ if } k \neq n \end{cases}\\) | 
| 7 | indist | dist | without | yes | \\(\{n + k - 1 \choose n\}\\) | 
| 8 | indist | dist | without | no | \\(\{n - 1 \choose k - 1\} \text{ , } k \leq n\\) | 
| 9 | dist | indist | with | yes | \\(\begin{cases} 1 \text{ if } k \geq n \\\\ 0 \text{ if } k < n \end{cases}\\) | 
| 10 | dist | indist | with | no | \\(\begin{cases} 1 \text{ if } k = n \\\\ 0 \text{ if } k \neq n \end{cases}\\) | 
| 11 | dist | indist | without | yes | \\(B_{\min\\{k, n\\}}\\) | 
| 12 | dist | indist | without | no | \\(\{n \brace k\} \text{ , } k \leq n\\) | 
| 13 | indist | indist | with | yes | \\(\begin{cases} 1 \text{ if } k \geq n \\\\ 0 \text{ if } k < n \end{cases}\\) |
| 14 | indist | indist | with | no | \\(\begin{cases} 1 \text{ if } k = n \\\\ 0 \text{ if } k \neq n \end{cases}\\) | 
| 15 | indist | indist | without | yes | `unknown` | 
| 16 | indist | indist | without | no | \\(P(n, k) \text{ , } k \leq n\\) | 

Reasoning:

1.  permutation, just as P_n^k
2.  \\(n (n - 1) (n - 2) \cdots 1\\)
3.  each ball has \\(k\\) choices
4.  [the Stirling number of the second type]({% post_url 2016-11-17-notes-on-stirling-numbers-of-the-second-type %}) 
with permutation, the same number as the number of onto functions \\(f\\) from 
the set \\(S_1 = \\{1, 2, \cdots, n\\}\\) to \\(S_2 = \\{1, 2, \cdots, k\\}\\)
5.  choose \\(n\\) boxes from \\(k\\) boxes
6.  each box containing an identical ball
7.  \\(n\\) stars and \\(k - 1\\) bars (\\(k\\) boxes), choose \\(n\\) places from \\(n + k - 1\\) 
total places for balls, remaining for bars, or choose \\(k - 1\\) places from \\(n + k - 1\\) 
total places for bars, remaining for balls
8.  \\(n\\) stars and \\(k - 1\\) bars (\\(k\\) boxes), choose \\(k - 1\\) places form \\(n - 1\\) 
possible places for bars
9.  \\(n\\) nonempty boxes, and \\(n - k\\) empty boxes
10.  each box containing a ball
11.  \\(B_n\\) is [the Bell number](https://en.wikipedia.org/wiki/Bell_number){:target='_blank'}, 
\\(B_n = \sum\limits_{k = 0}^n \{n \brace k\}\\), where \\(\{n \brace k\}\\) is the [Stirling 
number of the second type]({% post_url 2016-11-17-notes-on-stirling-numbers-of-the-second-type %})
12.  [the Stirling number of the second type]({% post_url 2016-11-17-notes-on-stirling-numbers-of-the-second-type %})
13.  each box containing an identical ball
14.  each box containing an identical ball
15.  `unknown`
16.  the number of the partitions of \\(n\\) into \\(k\\) parts. The number is denoted by 
\\(P(n, k)\\), which satisfy the recurrence

$$
P(n,k)= P(n−1, k−1) + P(n−k, k)
$$

with initial conditions

$$
P(n, k) = 0 \text{ for } k > n \text{, } P(n, n) = P(n, 0) = [n = 0]
$$

For more information, check the links, 
[link1](https://en.wikipedia.org/wiki/Partition_%28number_theory%29){:target='_blank'} and 
[link2](http://oeis.org/A008284){:target='_blank'}



---
layout: post
category: [math]
tags: [stat, math]
infotext: "A random experiment, also called the matching experiment."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In the previous post [The inclusion exclusion principle]({% post_url 2016-11-13-notes-on-the-inclusion-exclusion-principle %}), 
we learn about the inclusion exclusion principle. The matching problem is an application for the inclusion 
exclusion principle.

Suppose we have a group of cards and shuffle them randomly, what is the probability for the cards staying 
in the same positions as before the shuffling?

There are many colorful descriptions for similar problems:

  - Suppose that \\(n\\) male-female couples are at a party and that the males and females are randomly 
paired for a dance. A match occurs if a couple happens to be paired together.
  - An absent-minded secretary prepares \\(n\\) letters and envelopes to send to \\(n\\) different 
people, but then randomly stuffs the letters into the envelopes. A match occurs if a letter is 
inserted in the proper envelope.
  - \\(n\\) people with hats have had a bit too much to drink at a party. As they leave the party, 
each person randomly grabs a hat. A match occurs if a person gets his or her own hat.

### Solution

Consider the set \\(S = \{1, 2, \cdots, n\}\\). The matching problem corresponds to the random 
selection of all the points in \\(S\\) without replacement. The random selection of points of the 
entire set \\(S\\) results in ordered samples \\((Y_1, Y_2, \cdots, Y_n)\\) where each \\(Y_i \in S\\) 
and \\(Y_i \neq Y_j\\) for \\(i \neq j\\). These ordered samples are precisely the permutations of 
the set \\(S\\) and there are \\(n!\\) such permutations.

A match occurs when some element \\(i \in S\\) is selected in the \\(i^{th}\\) pick. In the card 
example, the \\(i^{th}\\) card is a match when the card that is numbered \\(i\\) is in the \\(i^{th}\\) 
position in the shuffled deck \\((Y_i = i)\\).

For each \\(i \in S\\), we define the following indicator variable \\(I_i\\):

$$
I_i = \begin{cases}
{1}&\thinspace Y_i = i \quad \text{(} i^{th} \text{card is a match)} \\
{0}&\thinspace Y_i \neq i \quad \text{(} i^{th} \text{card is not a match)}
\end{cases}
$$

Furthermore, let \\(X_n = I_1 + I_2 + \cdots + I_n\\). The random variable \\(X_n\\) is the number 
of matches when a deck of \\(n\\) cards (numbered \\(1\\) through \\(n\\)) are shuffled.

For each \\(i\\) in \\(S = \{1, 2, \cdots, n\}\\), let \\(A_i\\) be the event that the \\(i^{th}\\) 
card is a match. The event \\(A_1 \cup \cdots \cup A_n\\) is the event that there is at least one 
match in the deck of \\(n\\) shuffled cards.

So the number of possible cases of at least one match is that:

$$
\sharp \{X_n \geq 1\} = \lvert A_1 \cup A_2 \cup \cdots \cup A_n \lvert = \sum \limits_{m = 1}^n (-1)^{m + 1} S_m
$$

where

$$
S_1 = \sum \limits_{i=1}^n \lvert A_i \lvert \\
S_2 = \sum \limits_{i<j} \lvert A_i \cap A_j\lvert \\
S_m = \sum \limits_{i(1)< \cdots <i(m)} \lvert A_{i(1)} \cap \cdots \cap A_{i(m)}\lvert
$$

Each value \\(A_{i(1)} \cap \cdots \cap A_{i(m)}\\) represents there being at least \\(m\\) matches. 
Note that the number of shuffles with at least \\(m\\) matches only depends on \\(m\\), not on 
the particular values of \\(i(m)\\). Thus there are \\({n \choose m}\\) equal terms in the \\(m^{th}\\) 
summation.

$$
\sharp \{X_n \geq 1\} = \lvert A_1 \cup A_2 \cup \cdots \cup A_n \lvert = \sum \limits_{m = 1}^n (-1)^{m + 1} {n \choose m} \lvert A_{1} \cap \cdots \cap A_{m} \lvert
$$

\\(\lvert A_{1} \cap \cdots \cap A_{m} \lvert\\) is the number of orderings having \\(m\\) specific 
matches, which is equal to the number of ways of ordering the remaining \\(n − m\\) elements, which is 
\\((n − m)!\\). 

Finally, we get

$$
\sharp \{X_n \geq 1\} = \lvert A_1 \cup A_2 \cup \cdots \cup A_n \lvert = \sum \limits_{m = 1}^n (-1)^{m + 1} {n \choose m} (n - m)! = \sum \limits_{m = 1}^n (-1)^{m + 1} \frac{n!}{m!}
$$

and 

$$
\sharp \{X_n = 0\} = n! - \sum \limits_{m = 1}^n (-1)^{m + 1} \frac{n!}{m!} = \sum \limits_{m = 0}^n (-1)^{m} \frac{n!}{m!}
$$

So that the probability for having no matches is

$$
P(X_n = 0) = \frac{\sharp \{X_n = 0\}}{\sharp \{\text{total permutations}\}} = \frac{\sum \limits_{m = 0}^n (-1)^{m} \frac{n!}{m!}}{n!} = \sum \limits_{m = 0}^n \frac{(-1)^{m}}{m!}
$$

The probability for having exact one match is derived with fixing one card with the other \\(n - 1\\) 
cards with no matches, and there are \\({n \choose 1}\\) choices for fixing cards. So the probability 
is

$$
P(X_n = 1) = {n \choose 1} \frac{\sharp \{X_{n - 1} = 0\}}{\sharp \{\text{total permutations}\}} = {n \choose 1} \frac{\sum \limits_{m = 0}^{n - 1} (-1)^{m} \frac{(n - 1)!}{m!}}{n!} = \sum \limits_{m = 0}^{n - 1} \frac{(-1)^{m}}{m!}
$$

The probability for having exact \\(k\\) matches is

$$
P(X_n = k) = {n \choose k} \frac{\sharp \{X_{n - k} = 0\}}{\sharp \{\text{total permutations}\}} = {n \choose k} \frac{\sum \limits_{m = 0}^{n - k} (-1)^{m} \frac{(n - k)!}{m!}}{n!} = \frac{1}{k!} \sum \limits_{m = 0}^{n - k} \frac{(-1)^{m}}{m!}
$$

Note that \\(P(X_n = n - 1) = 0\\), it's impossible to have exact \\(n - 1\\) matches leaving exact 
one card unmatched.

On the other hand \\(P(X_n = n) = \frac{1}{n!}\\), since there is only one case out of \\(n!\\) 
permutation where all cards are matched.

### Relationship with Poisson Distribution

The probability of no matches among \\(n\\) cards is the Taylor expansion of \\(e^{-1}\\). Thus the 
probability of no matches in a shuffled deck of \\(n\\) cards when \\(n\\) is large is about 
\\(0.3678794412\\) and the probability of at least one match is approximately \\(0.6321205588\\).

The density function \\(P(X_n=k)\\) converges to the Poisson distribution with parameter 
\\(\lambda = 1\\), which is \\(\frac{e^{-1}}{k!}\\), and the convergence occurs rapidly.

### Moments

Since \\(P(X_n=k)\\) converges to the Poisson distribution with parameter \\(\lambda=1\\), we might 
guess that the mean and variance of \\(X_n\\) approach \\(\lambda=1\\).

Recall that \\(X_n = I_1 + I_2 + \cdots + I_n\\) where for each \\(j = 1, 2, \cdots, n\\), \\(I_j\\) 
is an indicator variable:

$$
I_j = \begin{cases}
{1}&\thinspace Y_j = j \quad \text{(} j^{th} \text{card is a match)} \\
{0}&\thinspace Y_j \neq j \quad \text{(} j^{th} \text{card is not a match)}
\end{cases}
$$

The event \\((I_j = 1)\\) is the event \\(A_j\\), and there are \\((n - 1)!\\) cases for \\(j^{th}\\) 
card is a match among \\(n!\\) permutations. So we have

$$
P(I_j = 1) = \frac{(n - 1)!}{n!} = \frac{1}{n}
$$

The event \\((I_i = 1, I_j = 1)\\) is the event \\(A_i \cap A_j\\), and \\(\lvert A_i \cap A_j \lvert = (n - 2)!\\). 
So we have the probability that both the \\(i^{th}\\) card and the \\(j^{th}\\) card are matches is

$$
P(I_i = 1, I_j = 1) = \frac{(n - 2)!}{n!} = \frac{1}{n(n - 1)}
$$

It follows that for all \\(j = 1, 2, \cdots, n\\), \\(I_j\\) has the Bernoulli distribution with 
probability of success \\(P(I_j = 1) = \frac{1}{n}\\). So the mean and variance are

$$
\mathrm{E}(I_j) = \frac{1}{n} \\
\mathrm{Var}(I_j) = \frac{1}{n} (1-\frac{1}{n}) = \frac{n-1}{n^2}
$$

Then we can calculate the mean of \\(X_n\\) as

$$
\mathrm{E}(X_n) = \mathrm{E}(I_1 + I_2 + \cdots + I_n) = 1
$$

In order to calculate the variance of \\(X_n\\), we need first to calculate the covariance:

$$
\begin{array}
{}&\mathrm{Cov}(I_i, I_j) &= E(I_i I_j)-E(I_i) E(I_j) \\
{} &&= \biggl(\sum \limits_{x, y = 0, 1} x y P(I_i = x, I_j = y)\biggr) - E(I_i) E(I_j) \\
{} &&= P(I_i = 1, I_j = 1) - E(I_i) E(I_j) \\
{} &&= \frac{1}{n(n-1)} - \frac{1}{n^2} \\
{} &&= \frac{1}{n^2 (n-1)}
\end{array}
$$

Now we calculate the variance of \\(X_n\\) as

$$
\begin{array}
{}&\mathrm{Var}(X_n) &= \sum \limits_{i = 1}^n Var(I_i) + 2 \sum \limits_{i \ne j} Cov(I_i, I_j) \\
{} &&= n \frac{n-1}{n^2} + 2 \binom{n}{2} \frac{1}{n^2 (n - 1)} \\
{} &&= 1
\end{array}
$$

### Other

Following [link](http://www.math.uah.edu/stat/urn/Matching.html){:target='_blank'} contains view of point on sampling.

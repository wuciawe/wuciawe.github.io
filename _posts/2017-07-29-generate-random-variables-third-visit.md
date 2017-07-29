---
layout: post
category: [math]
tags: [math, stat]
infotext: "Let's review the way to generate random variables once more."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In this post, we will revisit three kinds of sampling, two of which have been talked 
about in a previous post, the other one is new.

### Exact Method

In the exact methods, we use the transformation of the CDF to generate continues random 
variables.

Let \\(Y\\) be a continues random variable with CDF \\(F_Y(\cdot)\\). The range of \\(F_Y(\cdot)\\) 
is \\((0, 1)\\), and as random variable \\(F_Y(\cdot)\\) it is distributed \\(U\sim\text{Uniform}(0,1)\\). 
Thus the inverse transformation \\(F_Y^{-1}(U)\\) gives us the desired distribution for \\(Y\\).

For example, if \\(Y\sim\text{Exponential}(\lambda)\\) then \\(F_Y^{-1}(U)=-\lambda\ln(1-U)\\) is 
the desired Exponential.

Let \\(U_j\\) be i.i.d. \\(\text{Uniform}(0,1)\\), so that \\(Y_j=-\lambda\ln(U_j)\\) are i.i.d. 
\\(\text{Exponential}(\lambda)\\), and 

$$
Z=-2\sum_{j=1}^n\ln(U_j) \sim \chi_{2n}^2 \text{ is a Chi-squared distribution on } 2n \text{ degrees of freedom (integer only)}
$$

$$
Z=-\beta\sum_{j=1}^n\ln(U_j) \sim \Gamma(\alpha, \beta) \text{ only integers for } \alpha
$$

$$
Z=\frac{\sum_{j=1}^a\ln(U_j)}{\sum_{j=1}^{a+b}\ln(U_j)} \sim \text{Beta}(a, b) \text{ only integers for } a
$$

### Accept/Reject Method

The accept/reject methods are of approximations using the PDF.

Suppose we want to generate \\(Y\sim\text{Beta}(a, b)\\) for non-integer values of \\(a\\), \\(b\\).

Let \\((U, V)\\) be independent \\(\text{Uniform}(0, 1)\\) random variables. Let 
\\(c \geq \max_yf_Y(y)\\). And calculate \\(p(Y\leq y)\\) as: 

$$
P(V\leq y, U\leq\frac{1}{c}f_Y(V)) = \int_0^y\int_0^{\frac{1}{c}f_Y(v)}dudv = \frac{1}{c}\int_0^yf_Y(v)dv = \frac{1}{c}p(Y\leq y)
$$

The process of generation contains two steps: 

1. generate independent \\((U, V)\\) conforming to \\(\text{Unifrom}(0, 1)\\)
2. if \\(U < \frac{1}{c}f_Y(V)\\), set \\(Y=V\\); otherwise, return to step 1

The waiting time for one value of \\(Y\\) with this algorithm is \\(c\\). So we want \\(c\\) 
small. Thus, choose \\(c=\max_yf_Y(y)\\).

But we waste generated values of \\(U\\), \\(V\\) whenever \\(U\geq\frac{1}{c}f_Y(V)\\), so we want 
to choose a better approximation distribution for \\(V\\) than the uniform.

Let \\(Y\sim f_Y(y)\\) and \\(V\sim f_V(v)\\), assume that \\(M=\sup_y[\frac{f_Y(y)}{f_V(y)}]\\) 
exists, i.e., \\(M<\infty\\), then generate the random variable \\(Y\sim f_Y(y)\\) using, 
\\(U\sim\text{Unifrom}(0,1)\\), \\(V\sim f_V(v)\\), with \\((U, V)\\) independent, as

1. generate values \\((u, v)\\)
2. if \\(u<\frac{1}{M}\frac{f_Y(v)}{f_V(v)}\\), set \\(y=v\\); otherwise, return to step 1 and 
redraw \\((u, v)\\)

### Metropolis Method

This algorithm is used for heavy tailed target densities.

As before, let \\(Y\sim f_Y(y)\\), \\(V\sim f_V(v)\\), \\(U\sim\text{Uniform}(0,1)\\), with 
\\((U, V)\\) independent, assume only that \\(Y\\) and \\(V\\) have a common support.

__step 0__: generate \\(v_0\\) and set \\(z_0=v_0\\)

For \\(i = 1, 2, \cdots\\)

__step \\(i\\)__: generate \\((u_i, v_i)\\), and define 

$$
\rho_i = \min\left\{\frac{f_Y(v_i)}{f_V(v_i)}\frac{f_V(z_{i-1})}{f_Y(z_{i-1})}, 1\right\}
$$

and update \\(z_i\\) as

$$
z_i = \begin{cases}
v_i &\text{ if } u_i \leq \rho_i\\
z_{i-1} &\text{ if } u_i > \rho_i
\end{cases}
$$

Then, as \\(i \rightarrow \infty\\), the random variable \\(Z_i\\) converges in distribution 
to the random variable \\(Y\\).

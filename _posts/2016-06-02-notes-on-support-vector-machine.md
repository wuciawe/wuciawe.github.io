---
layout: post
category: [machine learning, math]
tags: [machine learning, math, quadratic programming, classification]
infotext: '(BTW: That response made me feel great.) This is a very detailed notes on svm, easy to understand as well.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Construction of linearly separable svm

This note is about the inference of the two class classifiction svm.

Suppose we have a set of data \\(\mathbb{D} = \\{(x_i, y_i); i = 1, \dots, m\\}\\), where \\(x_i \in \mathbb{R}^n\\) is the 
feature vector and \\(y_i \in \\{-1, +1\\}\\) is the label, the classifier with hypothesis 
\\(h_{\omega, b}\\) is like:

$$
h_{\omega, b} = g(\omega^T x + b)
$$

where, \\(g(z) = 1\\) if \\(z \ge 0\\), and \\(g(z) = -1\\) if \\(z \lt 0\\).

Based on the above notation, we define __the functional margin__ w.r.t each element in \\(\mathbb{D}\\) as

$$
\hat{\gamma}^{(i)} = y^{(i)}(\omega^T x^{(i)} + b)
$$

Then, if \\(y^{(i)} = 1\\), larger value of \\(\omega^T x^{(i)} + b\\) will make a larger \\(\hat{\gamma}^{(i)}\\), 
similar for the case where \\(y^{(i)} = -1\\).

And with the definition of hypothesis \\(h_{\omega, b}\\), scaling \\(\omega\\) and \\(b\\) will not 
affect the result of the output of the hypothesis, it will only affect the value of \\(\hat{\gamma}^{(i)}\\).

After that, we define the __functional margin__ w.r.t the whole \\(\mathbb{D}\\) as

$$
\hat{\gamma} = \min_{i = 1, \dots, m} \gamma^{(i)}
$$

And the __geometric margin__ \\(\gamma^{(i)}\\) w.r.t each element in \\(\mathbb{D}\\) is defined as the distance of each element 
apart from the hyper plane \\(\omega^T x + b = 0\\). We can see that the projection of the element \\(x^{(i)}\\) on 
the hyper plane equals \\(x^{(i)} - \gamma^{(i)}\frac{\omega}{||\omega||}\\), and since this point is on 
the hyper plane, the following equation holds:

$$
\omega^T(x^{(i)} - \gamma^{(i)}\frac{\omega}{||\omega||}) + b = 0
$$

And we can get

$$
\gamma^{(i)} = \frac{\omega^Tx^{(i)} + b}{||\omega||} = \Big(\frac{\omega}{||\omega||}\Big)^T x^{(i)} + \frac{b}{||\omega||}
$$

Taking the case where \\(y^{(i)} = -1\\) into account, we get

$$
\gamma^{(i)} = y^{(i)}\bigg(\Big(\frac{\omega}{||\omega||}\Big)^T x^{(i)} + \frac{b}{||\omega||}\bigg)
$$

If \\(||\omega|| = 1\\), then the functional margin equals the geometric margin.

And the __geometric margin__ w.r.t the whole \\(\mathbb{D}\\) is

$$
\gamma = \min_{i = 1, \dots, m}\gamma^{(i)}
$$

With the definition of the geometric margin, we can imagine the optimal classification boundary is the 
hyper plane that gains the maximum geometric margin w.r.t the whole \\(\mathbb{D}\\):

$$
\begin{align}
max_{\gamma, \omega, b} \quad& \gamma\\
s.t. \quad& y^{(i)}(\omega^T x^{(i)} + b) \ge \gamma,\quad i = 1, \dots, m\\
& ||\omega|| = 1
\end{align}
$$

which can be transfromed to

$$
\begin{align}
max_{\hat{\gamma}, \omega, b} \quad& \frac{\hat{\gamma}}{||\omega||}\\
s.t. \quad& y^{(i)}(\omega^T x^{(i)} + b) \ge \hat{\gamma},\quad i = 1, \dots, m
\end{align}
$$

where the objective target is changed to minimize the functional margin as 
\\(\gamma = \frac{\hat{\gamma}}{||\omega||}\\). And it can be further transformed as

$$
\begin{align}
min_{\gamma, \omega, b} \quad& \frac{1}{2}||\omega||^2\\
s.t. \quad& y^{(i)}(\omega^T x^{(i)} + b) \ge 1,\quad i = 1, \dots, m
\end{align}
$$

This is because by scaling \\(\omega\\) and \\(b\\), we can get \\(\hat{\gamma}\\) with any magnitude. 
So by setting \\(\hat{\gamma} = 1\\), we get the above convex quadratic optimization problem with 
linear constraints.

### Lagrange duality

Consider a problem of the following form:

$$
\begin{align}
min_{\omega} \quad& f(\omega)\\
s.t. \quad& h_i(\omega) = 0,\quad i = 1, \dots, l
\end{align}
$$

The __Lagrangian__ is defined to be

$$
\mathcal{L}(\omega, \beta) = f(\omega) + \sum_{i = 1}^l\beta_ih_i(\omega)
$$

where \\(\beta_i\\)'s are called the __Lagrange multipliers__. And we can solve for \\(\omega\\) and 
\\(\beta\\) with

$$
\frac{\partial\mathcal{L}}{\partial\omega_i} = 0, \quad \frac{\partial\mathcal{L}}{\partial\beta_i} = 0
$$

The __primal__ optimization problem is defined as

$$
\begin{align}
min_{\omega} \quad& f(\omega)\\
s.t. \quad& g_i(\omega) \le 0,\quad i = 1, \dots, k
& h_i(\omega) = 0,\quad i = 1, \dots, l
\end{align}
$$

And the __generlized Lagrangian__ is defined as

$$
\mathcal{L}(\omega, \alpha, \beta) = f(\omega) + \sum_{i = 1}^k\alpha_ig_i(\omega) + \sum_{i = 1}^l\beta_ih_i(\omega)
$$

where \\(\alpha\\)'s and \\(\beta\\)'s are the __Lagrange multipliers__. Consider the quantity

$$
\theta_\mathcal{P}(\omega) = \max_{\alpha, \beta: \alpha_i \ge 0}\mathcal{L}(\omega, \alpha, \beta)
$$

where \\(\mathcal{P}\\) stands for "primal". We can see that

$$
\theta_\mathcal{P} = \begin{cases} f(\omega) \quad& if \omega satisfies primal constraints\\\infty \quad&otherwise\end{cases}
$$

The primal problem can then be expressed as

$$
p^* = min_\omega\theta_\mathcal{P}(\omega) = min_\omega max_{\alpha, \beta: \alpha_i \ge 0}\mathcal{L}(\omega, \alpha, \beta)
$$

The __dual__ problem is like:

$$
\max_{\alpha, \beta: \alpha_i \ge 0}\theta_\mathcal{D}(\alpha, \beta) = max_{\alpha, \beta: \alpha_i \ge 0} min_\omega \mathcal{L}(\omega, \alpha, \beta)
$$

And we can see that the optimal value of the __dual__ problem has the relationship with the optimal value 
of the __primal__ problem as follows:

$$
d^* = \max_{\alpha, \beta: \alpha_i \ge 0} min_\omega \mathcal{L}(\omega, \alpha, \beta) \le min_\omega max_{\alpha, \beta: \alpha_i \ge 0}\mathcal{L}(\omega, \alpha, \beta) = p*
$$

Suppose \\(f\\) and \\(g_i\\)'s are convex, and \\(h_i\\)'s are affine. Suppose the constraints \\(g_i\\)'s 
are (strictly) feasible; \\(\exists\\) \\(\omega\\) such that \\(g_i(\omega\) \lt 0\\) for all \\(i\\). Then 
there must exists \\(\omega^\*\\), \\(\alpha^\*\\), \\(\beta^\*\\) so that \\(\omega^\*\\) is the solution 
to the __primal__ problem, \\(\alpha^\*\\) and \\(\beta^\*\\) are the solution to the __dual__ problem. And 
\\(p^* = d^* = \mathcal{L}(\omega^\*, \alpha^\*, \beta^\*)\\). And \\(\omega^\*\\), \\(\alpha^\*\\) and \\(\beta^\*\\) 
satisfy the __Karush-Kuhn-Tucker (KKT)__ conditions, which are follows:

$$
\begin{align}
\frac{\partial}{\partial\omega_i}\mathcal{L}(\omega^*, \alpha^*, \beta^*) &= 0,\quad i = 1, \dots, n\\
\frac{\partial}{\partial\beta_i}\mathcal{L}(\omega^*, \alpha^*, \beta^*) &= 0,\quad i = 1, \dots, l\\
\alpha_i^*g_i(\omega^*) &= 0,\quad i = 1, \dots, k\\
g_i(\omega^*) &\le 0,\quad i = 1, \dots, k\\
\alpha^* &\ge 0,\quad i = 1, \dots, k
\end{align}
$$

And any \\(\omega^\*\\), \\(\alpha^\*\\) and \\(\beta^\*\\) satisfy the __KKT__ conditions is the 
solution to the primal and dual problems.

And the third constraint of the __KKT__ conditions is very interesting.

### Solving svm with Lagrange dual

For

$$
\begin{align}
min_{\gamma, \omega, b} \quad& \frac{1}{2}||\omega||^2\\
s.t. \quad& y^{(i)}(\omega^T x^{(i)} + b) \ge 1,\quad i = 1, \dots, m
\end{align}
$$

the Lagrangian is like

$$
\mathcal{L}(\omega, b, \alpha) = \frac{1}{2}||\omega||^2 - \sum_{i = 1}^m\alpha_i\bigg[y^{(i)}\Big(\omega^T x^{(i)} + b\Big) - 1\bigg]
$$

`NOTE:` In the final result, only those __support vector \\(x^{(i)}\\)__'s corresponding \\(\alpha_i\\)'s are 
non-zero.

To solve the dual form of the problem, first minimize \\(\mathcal{L}(\omega, b, \alpha)\\) with respect 
to \\(\omega\\) and \\(b\\) (for fixed \\(\alpha\\)), to get \\(\theta_\mathcal{D}\\), which is achieved 
by setting the derivatives of \\(\mathcal{L}\\) with respect to \\(\omega\\) and \\(b\\) to zero:

$$
\nabla_\omega\mathcal{L}(\omega, b, \alpha) = \omega - \sum_{i = 1}^m\alpha_iy^{(i)}x^{(i)} = 0
$$

which implies that

$$
\omega = \sum_{i = 1}^m\alpha_iy^{(i)}x^{(i)}
$$

As for derivative with respect to \\(b\\), we obtain

$$
\frac{\partial}{\partial b}\mathcal{L}(\omega, b, \alpha) = \sum_{i = 1}^m\alpha_iy^{(i)} = 0
$$

And we substitute those back to the dual problem, and get the following:

$$
\begin{align}
\mathcal{L}(\omega, b, \alpha) &= \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j(x^{(i)})^Tx^{(j)} - b\sum_{i = 1}^m\alpha_i y^{(i)}\\
&= \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j(x^{(i)})^Tx^{(j)}
\end{align}
$$

Finally we obtain the dual optimization problem:

$$
\begin{align}
max_\alpha \quad& F(\alpha) = \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j\langle x^{(i)}, x^{(j)} \rangle\\
s.t. \quad& \alpha_i \ge 0,\quad i = 1, \dots, m\\
& \sum_{i = 1}^m\alpha_i y^{(i)} = 0
\end{align}
$$

After solving \\(\omega^\*\\), the intercept term \\(b\\) can be calculated as

$$
b^* = -\frac{max_{i: y^{(i)} = -1}\langle\omega^*, x^{(i)}\rangle + min_{i: y^{(i)} = 1}\langle\omega^*, x^{(i)}\rangle}{2}
$$

And \\(\omega^T x + b\\) can be calculated as

$$
\omega^T x + b = \Big(\sum_{i = 1}^m\alpha_iy^{(i)}x^{(i)}\Big)^T x + b = \sum_{i = 1}^m\alpha_i y^{(i)} \langle x^{(i)}, x\rangle + b
$$

### Kernel trick

The kernel is defined as

$$
K(x, z) = \phi(x)^T\phi(z)
$$

where \\(\phi(\omega)\\) can be very complicated, while \\(K(x, z)\\) is computationally cheap. With 
the kernel trick, we can map the elements into a higher dimensional space with little extra computation 
by avoiding explicit computing of \\(\phi(\omega)\\)

A valid kernel matrix should be symmetric and semi-definite, vice versa.

### Non-separable case

With __\\(\mathit{l}_1\\) regularization__, we have

$$
\begin{align}
min_{\gamma, \omega, b} \quad& \frac{1}{2}||\omega||^2 + C\sum_{i = 1}^m\xi_i\\
s.t. \quad& y^{(i)}(\omega^T x^{(i)} + b) \ge 1 - \xi_i,\quad i = 1, \dots, m\\
& \xi_i \ge 0,\quad i = 1, \dots, m
\end{align}
$$

Now the elements are permitted to have (functional) margin less than \\(1\\), and if an example 
has functional margin \\(1 - \xi_i\\), there will a cost of the objective function being 
increased by \\(C\xi_i\\). The parameter \\(C\\) controls the relative weighting between the twin 
goals of making the \\(||\omega||^2\\) small and of ensuring that most elements have functional 
margin at least \\(1\\).

The dual form is like:

$$
\begin{align}
max_\alpha \quad& F(\alpha) = \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j\langle x^{(i)}, x^{(j)}\rangle\\
s.t. \quad& 0 \le \alpha_i \le C,\quad i = 1, \dots, m\\
& \sum_{i = 1}^m\alpha_i y^{(i)} = 0
\end{align}
$$

And the KKT dual-complementarity conditions are:

$$
\begin{align}
\alpha_i = 0 &\Rightarrow y^{(i)}(\omega^Tx^{(i)} + b) \ge 1\\
\alpha_i = C &\Rightarrow y^{(i)}(\omega^Tx^{(i)} + b) \le 1\\
0 \lt \alpha_i \lt C &\Rightarrow y^{(i)}(\omega^Tx^{(i)} + b) = 1
\end{align}
$$

Calculation for \\(b^\*\\) mentioned above is not valid here any more.

### The SMO Algorithm

Before talking about the SMO (sequential minimal optimization) algorithm, first introduct the 
coordinate ascent.

For an unconstrained optimization problem

$$
max_\alpha F(\alpha_1, \alpha_2, \dots, \alpha_m)
$$

do following:

$$
\begin{align}
&repeat until convergence:\\
&\quad for \quad i = 1, \dots, m:\\
&\qquad \alpha_i = \arg\max_{\hat{\alpha}_i} F(\alpha_1, \dots, \alpha_{i - 1}, \hat{\alpha}_i, \alpha_{i + 1}, \dots, \alpha_m)
\end{align}
$$

While in the problem of svm:

$$
\begin{align}
max_\alpha \quad& F(\alpha) = \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j\langle x^{(i)}, x^{(j)}\rangle\\
s.t. \quad& 0 \le \alpha_i \le C,\quad i = 1, \dots, m\\
& \sum_{i = 1}^m\alpha_i y^{(i)} = 0
\end{align}
$$

We can't update single \\(\alpha\\) at each step because

$$
\alpha_i y^{(i)} = - \sum_{j = 1, \dots, m, j \neq i}\alpha_j y^{(j)}
$$

\\(\alpha_i\\) is determined by fixing other \\(alpha_j\\)'s. Thus the smo chooses to update two 
\\(\alpha_i\\)'s in each step, such that the constraints will not be violated. Now we have

$$
\alpha_i y^{(i)} + \alpha_j y^{(j)} = - \sum_{k = 1, \dots, m, k \neq i, k\neq j}\alpha_k y^{(k)} = \zeta
$$

which gives us

$$
\alpha_i = (\zeta - alpha_j y^{(j)})y^{(i)}
$$

And the objective function turns out to be

$$
F(\alpha) = F(\alpha_1, \dots, (\zeta - alpha_j y^{(j)})y^{(i)}, \dots, \alpha_j, \dots, \alpha_m)
$$

And \\(\alpha_j\\) is updated with

$$
\alpha_j^{new} = \begin{cases} H \quad& if\quad \alpha_j^{new, unclipped} \gt H\\ \alpha_j^{new, unclipped} \quad& if\quad L \le \alpha_j^{new, unclipped} \le H\\L \quad& if\quad \alpha_j^{new, unclipped} \lt L\end{cases}
$$

After finding the new value of \\(\alpha_j\\), we can then get the new value of \\(\alpha_i\\) with equation \\(\alpha_i = (\zeta - alpha_j y^{(j)})y^{(i)}\\).
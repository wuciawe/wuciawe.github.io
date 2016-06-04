---
layout: post
category: [machine learning, math]
tags: [machine learning, math, quadratic programming, classification, loss function, svm]
infotext: '(BTW: That response made me feel great.) This is a very detailed notes on svm, easy to understand as well.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Construction of linearly separable SVM

This note is about the inference of the two class classification svm.

Suppose we have a set of data \\(\mathbb{D} = \\{(\boldsymbol{x}\_i, y_i)\\}\_{i = 1}^m\\), where 
\\(\boldsymbol{x}\_i \in \mathbb{R}^n\\) is the feature vector and \\(y_i \in \\{-1, +1\\}\\) is the label, 
the classifier with hypothesis \\(h_{\boldsymbol{\omega}, b}\\) is like:

$$
h_{\boldsymbol{\omega}, b}(\boldsymbol{x}) = g(\boldsymbol{\omega}^T \boldsymbol{x} + b)
$$

where, \\(g(z) = 1\\) if \\(z \ge 0\\), and \\(g(z) = -1\\) if \\(z \lt 0\\).

As so, we can image \\(\boldsymbol{\omega}^T \boldsymbol{x} + b = 0\\) as a hyperplane in 
\\(\mathbb{R}^n\\) that split apart the two classes elements into different half spaces as in an 
affine space.

Based on the above notation, we define the __functional margin__ w.r.t each element in 
\\(\mathbb{D}\\) as

$$
\hat{\gamma}^{(i)} = y^{(i)}(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b)
$$

Then, if \\(y^{(i)} = 1\\), larger value of \\(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b\\) 
will make a larger \\(\hat{\gamma}^{(i)}\\), similar for the case where \\(y^{(i)} = -1\\).

And with the definition of hypothesis \\(h_{\boldsymbol{\omega}, b}\\), scaling 
\\(\boldsymbol{\omega}\\) and \\(b\\) will not affect the result of the output of the hypothesis, 
it will only affect the value of \\(\hat{\gamma}^{(i)}\\).

After that, we define the __functional margin__ w.r.t the whole \\(\mathbb{D}\\) as

$$
\hat{\gamma} = \min_{i = 1, \dots, m} \gamma^{(i)}
$$

And the __geometric margin__ \\(\gamma^{(i)}\\) w.r.t each element in \\(\mathbb{D}\\) is defined as 
the distance of each element apart from the hyper plane 
\\(\boldsymbol{\omega}^T \boldsymbol{x} + b = 0\\). We can see that the projection of the element 
\\(\boldsymbol{x}^{(i)}\\) on the hyper plane equals 
\\(\boldsymbol{x}^{(i)} - \gamma^{(i)}\frac{\boldsymbol{\omega}}{||\boldsymbol{\omega}||}\\), and 
since this point is on the hyper plane, the following equation holds:

$$
\boldsymbol{\omega}^T(\boldsymbol{x}^{(i)} - \gamma^{(i)}\frac{\boldsymbol{\omega}}{||\boldsymbol{\omega}||}) + b = 0
$$

And we can get

$$
\gamma^{(i)} = \frac{\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b}{||\boldsymbol{\omega}||} = \Big(\frac{\boldsymbol{\omega}}{||\boldsymbol{\omega}||}\Big)^T \boldsymbol{x}^{(i)} + \frac{b}{||\boldsymbol{\omega}||}
$$

Taking the case where \\(y^{(i)} = -1\\) into account, we get

$$
\gamma^{(i)} = y^{(i)}\bigg(\Big(\frac{\boldsymbol{\omega}}{||\boldsymbol{\omega}||}\Big)^T \boldsymbol{x}^{(i)} + \frac{b}{||\boldsymbol{\omega}||}\bigg)
$$

If \\(\|\|\boldsymbol{\omega}\|\| = 1\\), then the functional margin equals the geometric margin.

And the __geometric margin__ w.r.t the whole \\(\mathbb{D}\\) is

$$
\gamma = \min_{i = 1, \dots, m}\gamma^{(i)}
$$

With the definition of the geometric margin, we can imagine the optimal classification boundary is 
the hyper plane that gains the maximum geometric margin w.r.t the whole \\(\mathbb{D}\\):

$$
\begin{align}
max_{\gamma, \boldsymbol{\omega}, b} \quad& \gamma\\
s.t. \quad& y^{(i)}(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b) \ge \gamma,\quad i = 1, \dots, m\\
& ||\boldsymbol{\omega}|| = 1
\end{align}
$$

which can be transfromed to

$$
\begin{align}
max_{\hat{\gamma}, \boldsymbol{\omega}, b} \quad& \frac{\hat{\gamma}}{||\boldsymbol{\omega}||}\\
s.t. \quad& y^{(i)}(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b) \ge \hat{\gamma},\quad i = 1, \dots, m
\end{align}
$$

where the objective target is changed to minimize the functional margin as 
\\(\gamma = \frac{\hat{\gamma}}{||\boldsymbol{\omega}||}\\). And it can be further transformed as

$$
\begin{align}
min_{\gamma, \boldsymbol{\omega}, b} \quad& \frac{1}{2}||\boldsymbol{\omega}||^2\\
s.t. \quad& y^{(i)}(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b) \ge 1,\quad i = 1, \dots, m
\end{align}
$$

This is because by scaling \\(\boldsymbol{\omega}\\) and \\(b\\), we can get 
\\(\hat{\boldsymbol{\omega}}\\) with any magnitude. So by setting \\(\hat{\gamma} = 1\\), we get 
the above convex quadratic optimization problem with linear constraints.

### Lagrange duality

Consider a problem of the following form:

$$
\begin{align}
min_{\boldsymbol{\omega}} \quad& f(\boldsymbol{\omega})\\
s.t. \quad& h_i(\boldsymbol{\omega}) = 0,\quad i = 1, \dots, l
\end{align}
$$

The __Lagrangian__ is defined to be

$$
\mathcal{L}(\boldsymbol{\omega}, \boldsymbol{\beta}) = f(\boldsymbol{\omega}) + \sum_{i = 1}^l\beta_ih_i(\boldsymbol{\omega})
$$

where \\(\beta_i\\)'s are called the __Lagrange multipliers__. And we can solve for \\(\boldsymbol{\omega}\\) and 
\\(\boldsymbol{\beta}\\) with

$$
\frac{\partial\mathcal{L}}{\partial\omega_i} = 0, \quad \frac{\partial\mathcal{L}}{\partial\beta_i} = 0
$$

The __primal__ optimization problem is defined as

$$
\begin{align}
min_{\boldsymbol{\omega}} \quad& f(\boldsymbol{\omega})\\
s.t. \quad& g_i(\boldsymbol{\omega}) \le 0,\quad i = 1, \dots, k\\
& h_i(\boldsymbol{\omega}) = 0,\quad i = 1, \dots, l
\end{align}
$$

And the __generlized Lagrangian__ is defined as

$$
\mathcal{L}(\boldsymbol{\omega}, \boldsymbol{\alpha}, \boldsymbol{\beta}) = f(\boldsymbol{\omega}) + \sum_{i = 1}^k\alpha_ig_i(\boldsymbol{\omega}) + \sum_{i = 1}^l\beta_ih_i(\boldsymbol{\omega})
$$

where \\(\boldsymbol{\alpha}\\)'s and \\(\boldsymbol{\beta}\\)'s are the __Lagrange multipliers__. Consider the quantity

$$
\theta_\mathcal{P}(\boldsymbol{\omega}) = \max_{\boldsymbol{\alpha}, \boldsymbol{\beta}: \alpha_i \ge 0}\mathcal{L}(\boldsymbol{\omega}, \boldsymbol{\alpha}, \boldsymbol{\beta})
$$

where \\(\mathcal{P}\\) stands for "primal". We can see that

$$
\theta_\mathcal{P} = \begin{cases} f(\boldsymbol{\omega}) \quad& \text{if } \omega \text{ satisfies primal constraints}\\\infty \quad&\text{otherwise}\end{cases}
$$

The primal problem can then be expressed as

$$
p^* = min_\boldsymbol{\omega}\theta_\mathcal{P}(\boldsymbol{\omega}) = min_\boldsymbol{\omega} max_{\boldsymbol{\alpha}, \boldsymbol{\beta}: \alpha_i \ge 0}\mathcal{L}(\boldsymbol{\omega}, \boldsymbol{\alpha}, \boldsymbol{\beta})
$$

The __dual__ problem is like:

$$
\max_{\boldsymbol{\alpha}, \boldsymbol{\beta}: \alpha_i \ge 0}\theta_\mathcal{D}(\boldsymbol{\alpha}, \boldsymbol{\beta}) = max_{\boldsymbol{\alpha}, \boldsymbol{\beta}: \alpha_i \ge 0} min_\boldsymbol{\omega} \mathcal{L}(\boldsymbol{\omega}, \boldsymbol{\alpha}, \boldsymbol{\beta})
$$

And we can see that the optimal value of the __dual__ problem has the relationship with the optimal 
value of the __primal__ problem as follows:

$$
d^* = \max_{\boldsymbol{\alpha}, \boldsymbol{\beta}: \alpha_i \ge 0} min_\boldsymbol{\omega} \mathcal{L}(\boldsymbol{\omega}, \boldsymbol{\alpha}, \boldsymbol{\beta}) \le min_\boldsymbol{\omega} max_{\boldsymbol{\alpha}, \boldsymbol{\beta}: \alpha_i \ge 0}\mathcal{L}(\boldsymbol{\omega}, \boldsymbol{\alpha}, \boldsymbol{\beta}) = p*
$$

Suppose \\(f\\) and \\(g_i\\)'s are convex, and \\(h_i\\)'s are affine. Suppose the constraints 
\\(g_i\\)'s are (strictly) feasible; \\(\exists\\) \\(\boldsymbol{\omega}\\) such that 
\\(g_i(\boldsymbol{\omega}) \lt 0\\) for all \\(i\\). Then there must exists \\(\boldsymbol{\omega}^\*\\), 
\\(\boldsymbol{\alpha}^\*\\), \\(\boldsymbol{\beta}^\*\\) so that \\(\boldsymbol{\omega}^\*\\) is the solution to the 
__primal__ problem, \\(\boldsymbol{\alpha}^\*\\) and \\(\boldsymbol{\beta}^\*\\) are the solution to the __dual__ problem. 
And \\(p^* = d^* = \mathcal{L}(\boldsymbol{\omega}^\*, \boldsymbol{\alpha}^\*, \boldsymbol{\beta}^\*)\\). 
And \\(\boldsymbol{\omega}^\*\\), \\(\boldsymbol{\alpha}^\*\\) and \\(\boldsymbol{\beta}^\*\\) satisfy the __Karush-Kuhn-Tucker (KKT)__ 
conditions, which are follows:

$$
\begin{align}
\frac{\partial}{\partial\omega_i}\mathcal{L}(\boldsymbol{\omega}^*, \boldsymbol{\alpha}^*, \boldsymbol{\beta}^*) &= 0,\quad i = 1, \dots, n\\
\frac{\partial}{\partial\beta_i}\mathcal{L}(\boldsymbol{\omega}^*, \boldsymbol{\alpha}^*, \boldsymbol{\beta}^*) &= 0,\quad i = 1, \dots, l\\
\alpha_i^*g_i(\boldsymbol{\omega}^*) &= 0,\quad i = 1, \dots, k\\
g_i(\boldsymbol{\omega}^*) &\le 0,\quad i = 1, \dots, k\\
\alpha_i^* &\ge 0,\quad i = 1, \dots, k
\end{align}
$$

And any \\(\boldsymbol{\omega}^\*\\), \\(\boldsymbol{\alpha}^\*\\) and \\(\boldsymbol{\beta}^\*\\) satisfy the __KKT__ conditions is the 
solution to the primal and dual problems.

And the third constraint of the __KKT__ conditions is very interesting.

### Solving SVM with Lagrange dual

For

$$
\begin{align}
min_{\gamma, \boldsymbol{\omega}, b} \quad& \frac{1}{2}||\boldsymbol{\omega}||^2\\
s.t. \quad& y^{(i)}(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b) \ge 1,\quad i = 1, \dots, m
\end{align}
$$

the Lagrangian is like

$$
\mathcal{L}(\boldsymbol{\omega}, b, \boldsymbol{\alpha}) = \frac{1}{2}||\boldsymbol{\omega}||^2 - \sum_{i = 1}^m\alpha_i\bigg[y^{(i)}\Big(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b\Big) - 1\bigg]
$$

`NOTE:` In the final result, only those __support vector \\(\boldsymbol{x}^{(i)}\\)__'s corresponding \\(\alpha_i\\)'s are 
non-zero.

To solve the dual form of the problem, first minimize \\(\mathcal{L}(\boldsymbol{\omega}, b, \boldsymbol{\alpha})\\) with 
respect to \\(\boldsymbol{\omega}\\) and \\(b\\) (for fixed \\(\boldsymbol{\alpha}\\)), to get \\(\theta_\mathcal{D}\\), 
which is achieved by setting the derivatives of \\(\mathcal{L}\\) with respect to \\(\boldsymbol{\omega}\\) and 
\\(b\\) to zero:

$$
\nabla_\boldsymbol{\omega}\mathcal{L}(\boldsymbol{\omega}, b, \boldsymbol{\alpha}) = \boldsymbol{\omega} - \sum_{i = 1}^m\alpha_iy^{(i)}\boldsymbol{x}^{(i)} = \boldsymbol{0}
$$

which implies that

$$
\boldsymbol{\omega} = \sum_{i = 1}^m\alpha_iy^{(i)}\boldsymbol{x}^{(i)}
$$

As for derivative with respect to \\(b\\), we obtain

$$
\frac{\partial}{\partial b}\mathcal{L}(\boldsymbol{\omega}, b, \boldsymbol{\alpha}) = \sum_{i = 1}^m\alpha_iy^{(i)} = 0
$$

And we substitute those back to the dual problem, and get the following:

$$
\begin{align}
\mathcal{L}(\boldsymbol{\omega}, b, \boldsymbol{\alpha}) &= \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j(\boldsymbol{x}^{(i)})^T\boldsymbol{x}^{(j)} - b\sum_{i = 1}^m\alpha_i y^{(i)}\\
&= \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j(\boldsymbol{x}^{(i)})^T\boldsymbol{x}^{(j)}
\end{align}
$$

Finally we obtain the dual optimization problem:

$$
\begin{align}
max_\boldsymbol{\alpha} \quad& F(\boldsymbol{\alpha}) = \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j\langle \boldsymbol{x}^{(i)}, \boldsymbol{x}^{(j)} \rangle\\
s.t. \quad& \alpha_i \ge 0,\quad i = 1, \dots, m\\
& \sum_{i = 1}^m\alpha_i y^{(i)} = 0
\end{align}
$$

After solving \\(\boldsymbol{\omega}^\*\\), the intercept term \\(b\\) can be calculated as

$$
b^* = -\frac{max_{i: y^{(i)} = -1}\langle\boldsymbol{\omega}^*, \boldsymbol{x}^{(i)}\rangle + min_{i: y^{(i)} = 1}\langle\boldsymbol{\omega}^*, \boldsymbol{x}^{(i)}\rangle}{2}
$$

And \\(\boldsymbol{\omega}^T \boldsymbol{x} + b\\) can be calculated as

$$
\boldsymbol{\omega}^T \boldsymbol{x} + b = \Big(\sum_{i = 1}^m\alpha_iy^{(i)}\boldsymbol{x}^{(i)}\Big)^T \boldsymbol{x} + b = \sum_{i = 1}^m\alpha_i y^{(i)} \langle \boldsymbol{x}^{(i)}, \boldsymbol{x}\rangle + b
$$

### Kernel trick

The kernel is defined as

$$
K(\boldsymbol{x}, \boldsymbol{z}) = \phi(\boldsymbol{x})^T\phi(\boldsymbol{z})
$$

where \\(\phi(\boldsymbol{\omega})\\) can be very complicated, while \\(K(\boldsymbol{x}, \boldsymbol{z})\\) 
is computationally cheap. With the kernel trick, we can map the elements into a higher dimensional 
space with little extra computation by avoiding explicit computing of \\(\phi(\boldsymbol{\omega})\\).

A valid kernel matrix should be symmetric and semi-definite, vice versa.

### Non-separable case

With __\\(\mathit{l}_1\\) regularization__, we have

$$
\begin{align}
min_{\gamma, \boldsymbol{\omega}, b} \quad& \frac{1}{2}||\boldsymbol{\omega}||^2 + C\sum_{i = 1}^m\xi_i\\
s.t. \quad& y^{(i)}(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b) \ge 1 - \xi_i,\quad i = 1, \dots, m\\
& \xi_i \ge 0,\quad i = 1, \dots, m
\end{align}
$$

Now the elements are permitted to have (functional) margin less than \\(1\\), and if an example 
has functional margin \\(1 - \xi_i\\), there will a cost of the objective function being 
increased by \\(C\xi_i\\). The parameter \\(C\\) controls the relative weighting between the twin 
goals of making the \\(||\boldsymbol{\omega}||^2\\) small and of ensuring that most elements have functional 
margin at least \\(1\\).

The dual form is like:

$$
\begin{align}
max_\boldsymbol{\alpha} \quad& F(\boldsymbol{\alpha}) = \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j\langle \boldsymbol{x}^{(i)}, \boldsymbol{x}^{(j)}\rangle\\
s.t. \quad& 0 \le \alpha_i \le C,\quad i = 1, \dots, m\\
& \sum_{i = 1}^m\alpha_i y^{(i)} = 0
\end{align}
$$

And the KKT dual-complementarity conditions are:

$$
\begin{align}
\alpha_i = 0 &\Rightarrow y^{(i)}(\boldsymbol{\omega}^T\boldsymbol{x}^{(i)} + b) \ge 1\\
\alpha_i = C &\Rightarrow y^{(i)}(\boldsymbol{\omega}^T\boldsymbol{x}^{(i)} + b) \le 1\\
0 \lt \alpha_i \lt C &\Rightarrow y^{(i)}(\boldsymbol{\omega}^T\boldsymbol{x}^{(i)} + b) = 1
\end{align}
$$

Calculation for \\(b^\*\\) mentioned above is not valid here any more.

### The SMO Algorithm

Before talking about the SMO (sequential minimal optimization) algorithm, first introduce the 
coordinate ascent.

For an unconstrained optimization problem

$$
max_\boldsymbol{\alpha} F(\alpha_1, \alpha_2, \dots, \alpha_m)
$$

do following:

$$
\begin{align}
&\text{repeat until convergence: }\{\\
&\quad for \quad i = 1, \dots, m:\{\\
&\qquad \alpha_i = \arg\max_{\hat{\alpha}_i} F(\alpha_1, \dots, \alpha_{i - 1}, \hat{\alpha}_i, \alpha_{i + 1}, \dots, \alpha_m)\\
&\quad \}\\
&\}
\end{align}
$$

While in the problem of svm:

$$
\begin{align}
max_\boldsymbol{\alpha} \quad& F(\boldsymbol{\alpha}) = \sum_{i = 1}^m\alpha_i - \frac{1}{2}\sum_{i, j = 1}^m y^{(i)}y^{(j)}\alpha_i\alpha_j\langle \boldsymbol{x}^{(i)}, \boldsymbol{x}^{(j)}\rangle\\
s.t. \quad& 0 \le \alpha_i \le C,\quad i = 1, \dots, m\\
& \sum_{i = 1}^m\alpha_i y^{(i)} = 0
\end{align}
$$

We can't update single \\(\boldsymbol{\alpha}\\) at each step because

$$
\alpha_i y^{(i)} = - \sum_{\substack{j = 1\\j \neq i}}^m\alpha_j y^{(j)}
$$

\\(\alpha_i\\) is determined by fixing other \\(alpha_j\\)'s. Thus the smo chooses to update two 
\\(\alpha_i\\)'s in each step, such that the constraints will not be violated. Now we have

$$
\alpha_i y^{(i)} + \alpha_j y^{(j)} = - \sum_{\substack{k = 1\\k \neq i, k\neq j}}^m\alpha_k y^{(k)} = \zeta
$$

which gives us

$$
\alpha_i = (\zeta - \alpha_j y^{(j)})y^{(i)}
$$

And the objective function turns out to be

$$
F(\boldsymbol{\alpha}) = F(\alpha_1, \dots, (\zeta - alpha_j y^{(j)})y^{(i)}, \dots, \alpha_j, \dots, \alpha_m)
$$

And \\(\alpha_j\\) is updated with

$$
\alpha_j^{new} = \begin{cases} H \quad& if\quad \alpha_j^{new, unclipped} \gt H\\ \alpha_j^{new, unclipped} \quad& if\quad L \le \alpha_j^{new, unclipped} \le H\\L \quad& if\quad \alpha_j^{new, unclipped} \lt L\end{cases}
$$

After finding the new value of \\(\alpha_j\\), we can then get the new value of \\(\alpha_i\\) with 
equation \\(\alpha_i = (\zeta - alpha_j y^{(j)})y^{(i)}\\).

### Recent method for Hard Margin Linear SVM

The loss function for each element in hard margin linear svm is defined as the __hinge loss__:

$$
\mathcal{L^{(i)}}(\boldsymbol{\omega}) = \max\{0, 1 - y^{(i)}(\boldsymbol{\omega}^T \boldsymbol{x}^{(i)} + b)\}
$$

And the sub-gradient is like

$$
\frac{\partial \mathcal{L^{(i)}}(\boldsymbol{\omega})}{\partial \boldsymbol{\omega}} = \begin{cases}-y^{(i)}\boldsymbol{x}^{(i)} \quad& \text{if } y^{(i)}\boldsymbol{\omega}^T\boldsymbol{x}^{(i)} < 1\\0 \quad& \text{otherwise}\end{cases}
$$

And the objective function is to minimize the total loss

$$
min_\boldsymbol{\omega} \mathcal{L} = min_\boldsymbol{\omega} \sum_{i = 1}^m \mathcal{L^{(i)}}(\boldsymbol{\omega})
$$

which is a convex linear problem, thus can be easily solved by __SGD__ or __L-BFGS__.
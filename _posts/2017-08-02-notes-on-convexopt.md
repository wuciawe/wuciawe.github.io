---
layout: post
category: [math]
tags: [math]
infotext: "Review on convex optimization."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Convex

- Convex Set, A convex set is defined as \\(C\subseteq\mathbb{R}^n\\) such that 
\\(\boldsymbol{x}, \boldsymbol{y} \in C \Rightarrow t\boldsymbol{x}+(1-t)\boldsymbol{y}\in C\\) for 
all \\(0 \leq t\leq 1\\). In other words, a line segment joining any two elements lies entirely in 
the set.

- Convex combination, A convex combination of \\(\boldsymbol{x}\_1, \cdots, \boldsymbol{x}\_k \in \mathbb{R}^n\\) 
is any linear combination: 
$$
\sum_{i=1}^k\theta_i\boldsymbol{x}_i = \theta_1\boldsymbol{x}_1 + \cdots + \theta_k\boldsymbol{x}_k
$$
with \\(\theta_i\geq 0, i = 1,\cdots,k\\) and \\(\sum_{i=1}^k\theta_i=1\\).

- Convex hull, A convex hull of a set \\(C\\) is the set of all convex combination of its elements. 
A convex hull is always convex, and any convex combination of points in \\(\text{conv}(C)\\) is also 

$$
\text{conv}(C)=\{\sum_{i=1}^k\theta_i\boldsymbol{x}_i: k\in\{1,2,\cdots\},\theta_i\geq 0, \sum_{i=1}^k\theta_i=1, \boldsymbol{x}_i\in C\}
$$

norm ball \\(\{\boldsymbol{x}:\|\|\boldsymbol{x}\|\|\leq r\}\\) for a given norm \\(\|\|\cdot\|\|\\), radius \\(r\\)

hyperplane \\(\{\boldsymbol{x}:\boldsymbol{a}^T\boldsymbol{x}=\boldsymbol{b}\}\\) for given vector \\(\boldsymbol{a},\boldsymbol{b}\\)

halfspace \\(\{\boldsymbol{x}:\boldsymbol{a}^T\boldsymbol{x}\leq\boldsymbol{b}\}\\) for given vector \\(\boldsymbol{a},\boldsymbol{b}\\)

affine space \\(\{\boldsymbol{x}: A\boldsymbol{x}=\boldsymbol{b}\}\\) for a given matrix \\(A\\) and vector \\(\boldsymbol{b}\\)

polyhedron \\(\{\boldsymbol{x}: A\boldsymbol{x}\leq\boldsymbol{b}\}\\) for matrix \\(A\\) and vector \\(\boldsymbol{b}\\). 
You can visualize every row of \\(A\\) as a normal vector for each hyperplane involved. 
\\(\{\boldsymbol{x}:A\boldsymbol{x}\leq\boldsymbol{b},C\boldsymbol{x}=\boldsymbol{d}\}\\) is also a polyhedron 
because the equality \\(C\boldsymbol{x}=\boldsymbol{d}\\) can be made into two inequalities 
\\(C\boldsymbol{x}\geq\boldsymbol{d}\\) and \\(C\boldsymbol{x}\leq\boldsymbol{d}\\).

simplex: a special case of polyhedra, given by the convex hull of a set of affinely independent points 
\\(\boldsymbol{x}_0, \cdots, \boldsymbol{x}_k\\) (i.e. \\(\text{conv}\lbrace\boldsymbol{x}_0,\cdots,\boldsymbol{x}_k\rbrace\\)). 
Affinely independent means that \\(\boldsymbol{x}_1-\boldsymbol{x}_0, \cdots, \boldsymbol{x}_k-\boldsymbol{x}_0\\) 
are linearly independent. A canonical example is the probability simplex

$$
\text{conv}\lbrace\boldsymbol{e}_1,\cdots,\boldsymbol{e}_n\rbrace=\lbrace\boldsymbol{w}:\boldsymbol{w}\geq 0, \boldsymbol{1}^T\boldsymbol{w}=1\rbrace
$$

convex cones: A cone is \\(C\in\mathbb{R}^n\\) such that \\(\boldsymbol{x}\in C\Rightarrow t\boldsymbol{x}\in C \text{ for all } t\geq 0\\)

A convex cone is a cone that is also convex \\(\boldsymbol{x}_1,\boldsymbol{x}_2\in C \Rightarrow t_1\boldsymbol{x}_1+t_2\boldsymbol{x}_2\in C \text{ for all } t_1, t_2 \geq 0\\)

A conic combination of points \\(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k\in\mathbb{R}^n\\) is, for any 
\\(\theta_i\geq 0, i=1,\cdots,k\\), any linear combination \\(\theta_1\boldsymbol{x}_1+\cdots+\theta_k\boldsymbol{x}_k\\)

A conic hull collects all conic combinations of \\(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k\\) (or a general set \\(C\\))

$$
\text{conic}(\lbrace\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k\rbrace)=\lbrace\theta_1\boldsymbol{x}_1+\cdots+\theta_k\boldsymbol{x}_k, \theta_i\geq 0, i=1,\cdots, k\rbrace
$$

### convex functions

A convex function is a function \\(f:\mathbb{R}^n\rightarrow\mathbb{R}\\), such that \\(\text{dom}(f)\subseteq\mathbb{R}^n\\) 
is convex, and 

$$
f(t\boldsymbol{x}+(1-t)\boldsymbol{y})\leq tf(\boldsymbol{x})+(1-t)f(\boldsymbol{y}), \text{ for } 0\leq t\leq 1
$$

#### Operations perserving convexity

- Nonnegative linear combination

  \\(f_1,\cdots,f_m\\) convex implies \\(a_1f_1+\cdots+a_mf_m\\) convex for any \\(a_1,\cdots,a_m\geq 0\\)

- Pointwise maximization

  if \\(f_s\\) is convex for any \\(s \in S\\), then \\(f(\boldsymbol{x})=\max_{s\in S}f_s(\boldsymbol{x})\\) 
  is convex. Note that the set \\(S\\) here (number of functions \\(f_s\\)) can be infinite.

- Partial minimization

  if \\(g(\boldsymbol{x},\boldsymbol{y})\\) is convex in \\(\boldsymbol{x},\boldsymbol{y}\\) and \\(C\\) 
  is convex, then \\(f(\boldsymbol{x})=\min_{\boldsymbol{y}\in C}g(\boldsymbol{x}, \boldsymbol{y})\\) is convex.

- Affine combination

  \\(f\\) convex implies \\(g(\boldsymbol{x}=f(A\boldsymbol{x}+b)\\) convex. This is really useful when you want 
  to prove some function convex, and you realize there is a affine transformation in there. Because affine 
  transformation mess up sometimes things like taking gradients or Hessians, making it more complicated. Just 
  do not bother with that, just do it for the case there is no affine transformation, and claim when affine 
  transformation is in there, we will still have convexity

- General composition

  Suppose \\(f=h\cdot g\\), i.e., \\(f(\boldsymbol{x})=h(g(\boldsymbol{x}))\\), where 
  \\(g: \mathbb{R}^n\rightarrow\mathbb{R}, h:\mathbb{R}^n\rightarrow\mathbb{R}\\). Then 

  - \\(f\\) in convex if \\(h\\) is convex and nondecreasing, \\(g\\) is convex
  - \\(f\\) in convex if \\(h\\) is convex and nonincreasing, \\(g\\) is concave
  - \\(f\\) in concave if \\(h\\) is concave and nondecreasing, \\(g\\) is concave
  - \\(f\\) in concave if \\(h\\) is concave and nonincreasing, \\(g\\) is convex

- Vector composition

  Suppose that 

  $$
  f(\boldsymbol{x}=h(g(\boldsymbol{x}))=h(g_1(\boldsymbol{x}),\cdots,g_k(\boldsymbol{x}))
  $$

  where \\(g:\mathbb{R}^n\rightarrow\mathbb{R}^k,h:\mathbb{R}^k\rightarrow\mathbb{R},f:\mathbb{R}^n\rightarrow\mathbb{R}\\). Then 

  - \\(f\\) in convex if \\(h\\) is convex and nondecreasing in each argument, \\(g\\) is convex
  - \\(f\\) in convex if \\(h\\) is convex and nonincreasing in each argument, \\(g\\) is concave
  - \\(f\\) in concave if \\(h\\) is concave and nondecreasing in each argument, \\(g\\) is concave
  - \\(f\\) in concave if \\(h\\) is concave and nonincreasing in each argument, \\(g\\) is convex

### Gradient Descent

Gradient Descent belongs to a group of first-order method, basically, algortihms that update \\(\boldsymbol{x}^{(k)}\\) 
in the following linear space

$$
\boldsymbol{x}^{(0)}+\text{span}\{\nabla f(\boldsymbol{x}^{(0)}),\ldots,\nabla f(\boldsymbol{x}^{(k-1)})\}
$$

The algorithm has \\(O(\frac{1}{\epsilon})\\) rate over problem class of convex, differentiable functions 
with Lipschitz continuous gradients.

Gradient descent is an iterative algorithm producing a minimizing sequence of points 
\\(\boldsymbol{x}^{(0)},\boldsymbol{x}^{(1)},\ldots\\) such that \\(f(\boldsymbol{x}^{(k)})\rightarrow f(\boldsymbol{x}^\*)\\) 
as \\(k\rightarrow\infty\\) by repeating \\(\boldsymbol{x}^{(k)}=\boldsymbol{x}^{(k-1)}-t_k\nabla f(\boldsymbol{x}^{(k-1)})\\), 
where \\(k=1,2,\ldots\\) is iterative number, \\(t_k\\) is step size at iteration \\(k\\), initial \\(\boldsymbol{x}_0\in\mathbb{R}^n\\) 
is usually given.

Strategies to select appropriate step sizes: backtracking line search, exact line search.

### Subgradients

Subgradients are counterpart of gradients for non-differentiable functions. They are closely related 
to the concept of convexity. Recall that a differentiable function \\(f\\) is said to be convex iff: 

$$
f(\boldsymbol{y})\geq f(\boldsymbol{x})+\nabla f(\boldsymbol{x})^T(\boldsymbol{y}-\boldsymbol{x}) \quad\forall \boldsymbol{x},\boldsymbol{y}\in\mathbb{R}^n
$$

In other words, a linear approximation always underestimates \\(f\\). Subgradients are defined in a 
similar manner.

A subgradient of a convex function \\(f\\) at a point \\(\boldsymbol{x}\\) is any \\(\boldsymbol{g}\in\mathbb{R}^n\\) 
such that

$$
f(\boldsymbol{y})\geq f(\boldsymbol{x})+\boldsymbol{g}^T(\boldsymbol{y}-\boldsymbol{x}) \quad\forall \boldsymbol{y}
$$

While gradients may not exist/be undefined for non-differentiable function, subgradients always exist. If the 
function \\(f\\) is differentiable at the point \\(\boldsymbol{x}\\), then the subgradient \\(\boldsymbol{g}\\) 
is unique and \\(\boldsymbol{g}=\nabla f(\boldsymbol{x})\\). This definition works for non-convex functions 
also. However, subgradients sometimes may not exist for non-convex functions.

The subdifferential of a convex function \\(f:\mathbb{R}^n\rightarrow\mathbb{R}\\) at some point 
\\(\boldsymbol{x}\\) is the set of all subgradients of \\(f\\) at \\(\boldsymbol{x}\\): 

$$
\partial f(\boldsymbol{x})=\{\boldsymbol{g}:\boldsymbol{g} \text{ is a subgradient of } f \text{ at } \boldsymbol{x}\}
$$

The subdifferential forms a closed and convex set. This holds even for non-convex functions.

The optimality condition relates the minimizer of a function with the subgradient at the point. For any 
\\(f\\) (convex or not), 

$$
f(\boldsymbol{x}^*) = \min_x f(\boldsymbol{x}) \Leftrightarrow 0 \in \partial f(\boldsymbol{x})
$$

Like in gradient descent, in the subgradient method we start at an initial point \\(\boldsymbol{x}^{(0)}\in\mathbb{R}^n\\) 
and we iteratively update the current solution \\(\boldsymbol{x}^{(k)}\\) by taking small steps. However, in the subgradient 
method, rather than using the gradient of the function \\(f\\) we are minimizing, we can use any subgradient of \\(f\\) 
at the value of \\(\boldsymbol{x}^{(k)}\\). The rule for picking the next iterate in the subgradient method is 
given by: 

$$
\boldsymbol{x}^{(k)}=\boldsymbol{x}^{(k-1)}-t_k\cdot \boldsymbol{g}^{(k-1)}, \text{ where } \boldsymbol{g}^{(k-1)}\in\partial f(\boldsymbol{x}^{(k-1)})
$$

Because moving in the direction of some subgradients can make our solution worse for a given iteration, the 
subgradient method is not necessarily a descent method. Thus, the best solution among all of the iterations 
is used as the final solution: 

$$
f(\boldsymbol{x}_{\text{best}}^{(k)}) = \min_{i=0,\ldots,k} f(\boldsymbol{x}^{(i)})
$$

#### Stochastic subgradient method

Stochastic methods are useful when optimizing the sum of functions instead of a single function. This happends 
almost every time we are doing emperical risk minimization over a number of samples.

Consider minimizing the sum of \\(m\\) functions \\(\min\sum_{i=1}^m f_i (\boldsymbol{x})\\). Recall that 

\\(\partial \sum_{i=1}^mf_i(\boldsymbol{x})=\sum_{i=1}^m\partial f_i(\boldsymbol{x})\\), and subgradient 
method would repeat

$$
\boldsymbol{x}^{(k)}=\boldsymbol{x}^{(k-1)}-t_k\cdot\sum_{i=1}^m\boldsymbol{g}_i^{(k-1)}, k=1,2,3,\ldots
$$

where \\(\boldsymbol{g}_i^{(k-1)}\in\partial f_i(\boldsymbol{x}^{(k-1)})\\), while stochastic subgradient 
method (or incremental subgradient) repeats

$$
\boldsymbol{x}^{(k)}=\boldsymbol{x}^{(k-1)}-t_k\cdot \boldsymbol{g}_{i_k}^{(k-1)}, k=1,2,3,\ldots
$$

where \\(i_k\in\{1,\ldots,m\}\\) is some chosen index at iteration \\(k\\). In other words, rather 
than computing the full subgradient, only the subgradient \\(\boldsymbol{g}_i\\) corresponding to ome 
of the functions \\(f_i\\) is used.

As a special case in which \\(f_i\\), \\(i=1,2,3,\ldots\\) are differentiable, then 
\\(\boldsymbol{g}_i^{(k-1)}=\nabla f_i(\boldsymbol{x}^{(k-1)})\\). This is called stochastic gradient descent.

The convergence rate of usual (batch) is \\(\mathscr{O}(\frac{G^2_{\text{batch}}}{\epsilon^2})\\), while cyclic 
and randomized stochasitc subgradient methods have convergence rates of \\(\mathscr{O}(\frac{m(mG)^2}{\epsilon^2})\\) 
and \\(\mathscr{O}(\frac{mG^2}{\epsilon^2})\\) respectively. This implies that for non-smooth functions 
subgradient method achieves a lower bound of \\(\mathscr{O}(\frac{1}{\epsilon^2})\\) which is very slow.

### Proximal Gradient Descent

Consider a function \\(f\\) that can be decomposed into two functions as \\(f(\boldsymbol{x})=g(\boldsymbol{x})+h(\boldsymbol{x})\\) 
where \\(g\\) is convex, differentiable and \\(\text{dom}(g)=\mathbb{R}^n\\), \\(h\\) is convex and not necessarily 
differentiable, but is simple.

For a differentiable function \\(f\\), the gradient udpate \\(\boldsymbol{x}^+=\boldsymbol{x}-t\nabla f(\boldsymbol{x})\\) 
is derived using quadratic approximation (replace \\(\nabla^2f(\boldsymbol{x})\\) by \\(\frac{1}{t}I\\)): 

$$
\boldsymbol{x}^+=\arg\min_z \tilde{f}_t(\boldsymbol{z}) = \arg\min_z f(\boldsymbol{x})+\nabla f(\boldsymbol{x})^T(\boldsymbol{z}-\boldsymbol{x})+\frac{1}{2t}||\boldsymbol{z}-\boldsymbol{x}||_2^2
$$

For a decomposable function \\(f(\boldsymbol{x})=g(\boldsymbol{x})+h(\boldsymbol{x})\\), let us use this quadratic approximation 
for the differentiable function \\(g\\). Then, 

$$
\begin{align*}
\boldsymbol{x}^+ &= \arg\min_z \tilde{g}_t(\boldsymbol{z})+h(\boldsymbol{z})\\
&=\arg\min_z g(\boldsymbol{x})+\nabla g(\boldsymbol{x})^T(\boldsymbol{z}-\boldsymbol{x})+\frac{1}{2t}||\boldsymbol{z}-\boldsymbol{x}||_2^2 + h(\boldsymbol{z})\\
&= \arg\min_z \frac{1}{2t}||\boldsymbol{z}-(\boldsymbol{x}-t\nabla g(\boldsymbol{x}))||_2^2+h(\boldsymbol{z})
\end{align*}
$$

The first term here signifies staying close to the gradient update for \\(g\\) while at the same time, making the 
value of \\(h\\) small using the second term.

#### Proximal Mapping and Proximal Gradient Descent

Define proximal mapping as a function of \\(h\\) and \\(t\\) as follows: 

$$
\text{prox}_{h,t}(\boldsymbol{x})=\arg\min_z \frac{1}{2t}||\boldsymbol{z}-\boldsymbol{x}||_2^2+h(\boldsymbol{z})
$$

Then we have: 

$$
\begin{align*}
\boldsymbol{x}^+ &= \arg\min_z \frac{1}{2t}||\boldsymbol{z}-(\boldsymbol{x}-t\nabla g(\boldsymbol{x}))||_2^2 + h(\boldsymbol{z})\\
&= \text{prox}_{h,t}(\boldsymbol{x}-t\nabla g(\boldsymbol{x}))
\end{align*}
$$

For simplicity, we write proximal map as a function of \\(t\\) alone. Therefore, proximal gradient 
descent can be defined as follows: Choose inital \\(\boldsymbol{x}^{(0)}\\) and then repeat: 

$$
\boldsymbol{x}^{(k)}=\text{prox}_{t_k}(\boldsymbol{x}^{(k-1)}-t_k\nabla g(\boldsymbol{x}^{(k-1)})), k=1,2,3,\ldots
$$

This can be further expressed in a more familiar form: 

$$
\boldsymbol{x}^{(k)}=\boldsymbol{x}^{(k-1)}-t_k\cdot G_{t_k}(\boldsymbol{x}^{(k-1)})
$$

where \\(G_t\\) is a generalized gradient of \\(f\\), 

$$
G_t(\boldsymbol{x})=\frac{\boldsymbol{x}-\text{prox}_t(\boldsymbol{x}-t\nabla g(\boldsymbol{x}))}{t}
$$

Key points: 

- Proximal mapping \\(\text{prox}_t(\cdot)\\) can be computed analytically for a log of important \\(h\\) functions
- The mapping \\(\text{prox}_t(\cdot)\\) doesn't depend on \\(g\\) at all, only on h
- \\(g\\) can be a complicated function; all we need to do is to compute its gradient
- Each iteration of proximal gradient descent evaluates \\(\text{prox}_t(\cdot)\\) once which can be cheap 
or expensive depending on \\(h\\)

#### Special cases

Proximal gradient descent is also called composite gradietn descent, or generalized gradient descent. The latter 
is because we can see that special cases of proximal gradient descent give some familiar/interesting forms; 
when minimizing \\(f=g+h\\)

- \\(h=0\\) gives gradient descent
- \\(h=I_C\\) gives projected gradient descent
- \\(g=0\\) gives proximal minimization algorithm

All of these have \\(\mathscr{O}(\frac{1}{\epsilon})\\) convergence rate.

#### Accelerated Proximal Gradient Method

Accelerted proximal gradient descent looks like regular proximal gradient descent, but we have 
changed the argument passed to the prox operator and the step at which the gradient update is made 
with respect to \\(g\\).

As before, the problem is: \\(\min g(\boldsymbol{x})+h(\boldsymbol{x})\\), with \\(g\\) convex.

In regular gradient descent, pass \\(\boldsymbol{x}^{(k-1)}-t_k\nabla g(\boldsymbol{x}^{(k-1)})\\) 
to the prox operator and move on.

In accelerated proximal gradient descent, take the last iterate \\(\boldsymbol{x}^{(k-1)}\\) and add a 
momentum term. Instead of just evaluating the prox at \\(\boldsymbol{x}^{(k-1)}\\), this allows for some 
of the history to push us a little bit further.

Choose initial point \\(\boldsymbol{x}^{(0)}=\boldsymbol{x}^{(-1)}\in\mathbb{R}^n\\) and repeat 
\\(k=1,2,3,\ldots\\)

$$
\boldsymbol{v}=\boldsymbol{x}^{(k-1)}+\frac{k-2}{k+1}(\boldsymbol{x}^{k-1}-\boldsymbol{x}^{k-2})\\
\boldsymbol{x}^{(k)}=\text{prox}_{t_k}(\boldsymbol{v}-t_k\nabla g(\boldsymbol{v}))
$$

The choice of constant \\(\frac{k-2}{k+1}\\) is very important for the converge of the algorithm. 
Thus, this is taken as fixed constant (which has to/should be tuned). Although there are other 
convergence strategies, this is provably convergent.

More momentum is applied later on in the steps of the algorithm.

The convergence rate is of \\(\mathscr{O}(\frac{1}{\epsilon})\\).

---
layout: post
category: [machine learning, math, optimization]
tags: [machine learning, math, optimization]
infotext: 'A very simple review on (stochastic) (sub-)gradient descent, Newton-Raphson method, Quasi-Newton method.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Gradient descent

The gradient descent is a first order optimization algorithm. To find a local minimum of a function 
using gradient descent, one takes steps proportional to the negative of the gradient (or of the 
approximate gradient) of the function at the current point. The procedure is then known as gradient 
ascent.

Define a multi-variable function \\(\mathcal{F}(\boldsymbol{x})\\), s.t. \\(\mathcal{F}(\boldsymbol{x})\\) 
is differentiable in a neighborhood of \\(\boldsymbol{a}\\), then \\(\mathcal{F}(\boldsymbol{x})\\) 
decreases fastest if one goes from \\(\boldsymbol{a}\\) in the direction of the negative gradient of 
\\(\mathcal{F}\\) at \\(\boldsymbol{a}\\), \\(-\nabla\mathcal{F}(\boldsymbol{a})\\).

$$
\boldsymbol{b} = \boldsymbol{a} - \eta\nabla\mathcal{F}(\boldsymbol{a})
$$

In the above equation, if \\(\eta\\) is small enough, then \\(\mathcal{F}(\boldsymbol{a}) \ge \mathcal{F}(\boldsymbol{b})\\). 
Consider the sequence \\(\boldsymbol{x}\_0, \boldsymbol{x}\_1, \boldsymbol{x}\_2, \dots\\), s.t. 
\\(\boldsymbol{x}\_{n+1} = \boldsymbol{x}\_n - \eta\nabla\mathcal{F}(\boldsymbol{x}\_n),\quad n \ge 0\\). 
We have

$$
\mathcal{F}(\boldsymbol{x}_0) \ge \mathcal{F}(\boldsymbol{x}_1) \ge \mathcal{F}(\boldsymbol{x}_2) \ge \dots
$$

so hopefully the sequence \\(\mathcal{F}(\boldsymbol{x}_n)\\) converges to a local minimum. Note that the 
__step size__ \\(\eta\\) can vary in each step. With certain assumptions on \\(\mathcal{F}\\) (e.g. 
\\(\mathcal{F}\\) convex, and \\(\nabla\mathcal{F}\\) Lipschitz), and particular choices of \\(\eta\\) 
(e.g. chosen via a line search satisfying the Wolfe conditions), convergence to a local minimum can be 
guaranteed. When \\(\mathcal{F}\\) is convex, the local minimum is the global minimum.

For non-differentiable functions, gradient methods are ill-defined. For locally Lipschitz problems 
and especially for convex minimization problems, bundle methods of descent are well-defined. 
Non-descent methods, like sub-gradient projection methods, may also be used. These methods are 
typically slower than gradient descent. Another alternative for non-differentiable functions is to 
"smooth" the function, or bound the function by a smooth function. In this approach, the smooth 
problem is solved in the hope that the answer is close to the answer for the non-smooth problem 
(occasionally, this can be made rigorous).

### Stochastic gradient descent

Stochastic gradient descent is a stochastic approximation of the gradient descent optimization 
method for minimizing an objective function that is written as a sum of differentiable functions.

Both statistical estimation and machine learning consider the problem of minimizing an objective 
function that has the form of a sum:

$$
\mathcal{F}(\boldsymbol{\omega}) = \sum_{i = 1}^m\mathcal{F}_i(\boldsymbol{\omega})
$$

where \\(\mathcal{F}_i(\boldsymbol{\omega})\\) is associated with the \\(i\text{-th}\\) observation 
in the data set.

To minimize the above function, a gradient descent method would perform the iterations:

$$
\boldsymbol{\omega} := \boldsymbol{\omega} - \eta\nabla\mathcal{F}(\boldsymbol{\omega}) = \boldsymbol{\omega} - \eta\nabla\sum_{i = 1}^m\mathcal{F}_i(\boldsymbol{\omega})
$$

where \\(\eta\\) is the step size (called learning rate in machine learning).

In many cases, the summand functions have a simple form that enables inexpensive evaluations of the 
sum-function and the sum gradient. However, in other cases, evaluating the sum-gradient may require 
expensive evaluations of the gradients from all summand functions. Especially in the large scale learning 
problem, even the simple form summand functions require expensive computation.

In stochastic (or on-line) gradient descent, the true gradient of \\(\mathcal{F}(\boldsymbol{\omega})\\) 
is approximated by a gradient at a single element:

$$
\boldsymbol{\omega} := \boldsymbol{\omega} - \eta\nabla\mathcal{F}_i(\boldsymbol{\omega})
$$

A compromise between computing the true gradient and the gradient at a single element, is to compute 
the gradient against more than one training example (called a "mini-batch") at each step. It may 
result in smoother convergence, as the gradient computed at each step uses more training examples.

When the learning rate \\(\eta\\) decreases with an appropriate rate, and subject to relatively mild 
assumptions, stochastic gradient descent converges almost surely to a global minimum when the 
objective function is convex or pseudoconvex, and otherwise converges almost surely to a local 
minimum. This is in fact a consequence of the Robbins-Siegmund theorem.

### Newton-Raphson method

In numerical analysis, Newton's method is a method for finding successively better approximations to 
the roots (or zeroes) of a real-valued function.

$$
x: f(x) = 0
$$

As the tangent line to curve \\(y = f(x)\\) at point \\(x = x_n\\) (the current approximation) is

$$
y = f'(x_n)(x - x_n) + f(x_n)
$$

where \\(f: \[a, b\] \rightarrow \mathcal{R}^1\\) is a differentiable function defined on the interval 
\\(\[a, b\]\\) with values in the real numbers \\(\mathcal{R}^1\\).

The x-intercept of this line is used as the next approximation to the root, \\(x\_{n+1}\\). In other 
words, setting \\(y\\) to \\(0\\) and \\(x\\) to \\(x\_{n+1}\\) gives

$$
y = f'(x_n)(x_{n+1} - x_n) + f(x_n)
$$

Then we have

$$
x_{n + 1} = x_n - \frac{f(x_n)}{f(x_{n + 1})}
$$

In the case where to find the local minimum or maximum of the objective function 
\\(\mathcal{F}(\boldsymbol{\omega})\\) is convex, the optimum point \\(\boldsymbol{\omega}^\*\\)
is obtained where \\(\nabla\mathcal{F}(\boldsymbol{\omega}) = 0\\). We can apply Newton's method 
to search the optimum point \\(\boldsymbol{\omega}^\*\\):

$$
\boldsymbol{\omega}_{n + 1} = \boldsymbol{\omega}_n - [J_g(\boldsymbol{\omega}_n)]^{-1}g(\boldsymbol{\omega}_n)
$$

where \\(g(\boldsymbol{\omega})\\) is the gradient function w.r.t \\(\boldsymbol{\omega}_n\\), and 
\\(\[J_g(\boldsymbol{\omega}_n)\]^{-1}\\) is the left inverse of the Jacobian matrix \\(J_g(\boldsymbol{\omega}_n)\\) 
of \\(g(\boldsymbol{\omega}_n)\\) evaluated for \\(\boldsymbol{\omega}_n\\).

### Quasi-Newton method

In Newton's method, it could be very computational in computing the value of the Jacobian matrix. So 
Quasi-Newton methods are proposed to avoid exact calculation of Jacobian matrix.

Similar in Newton's method, the Taylor series of \\(\mathcal{F}(\boldsymbol{\omega})\\) around an 
iterate is:

$$
\mathcal{F}(\boldsymbol{\omega}_n + \Delta\boldsymbol{\omega}) \approx \mathcal{F}(\boldsymbol{\omega}_n) + \nabla\mathcal{F}(\boldsymbol{\omega}_n)^T\Delta\boldsymbol{\omega} + \frac{1}{2}\Delta\boldsymbol{\omega}^TB\Delta\boldsymbol{\omega}
$$

where \\(B\\) is an approximation to the Hessian matrix, and the gradient of this approximation w.r.t 
\\(\Delta\boldsymbol{\omega}\\) is

$$
\nabla\mathcal{F}(\boldsymbol{\omega}_n + \Delta\boldsymbol{\omega}) \approx \nabla\mathcal{F}(\boldsymbol{\omega}_n) + B\Delta\boldsymbol{\omega}
$$

and setting this gradient to zero provides the Newton step:

$$
\Delta\boldsymbol{\omega} = -B^{-1}\nabla\mathcal{F}(\boldsymbol{\omega}_n)
$$

The Hessian approximation \\(B\\) is chosen to satisfy

$$
\nabla\mathcal{F}(\boldsymbol{\omega}_n + \Delta\boldsymbol{\omega}) = \nabla\mathcal{F}(\boldsymbol{\omega}_n) + B\Delta\boldsymbol{\omega}
$$
### Continuous Optimisation Problem

- __Unconstrained minimization__: 

  $$
  \min_{\boldsymbol{x}\in\mathbb{R}^n} f(\boldsymbol{x})
  $$
  
  where the objective function \\(f: \mathbb{R}^n \rightarrow \mathbb{R}\\) is sufficiently smooth (
  \\(C^2\\) or \\(C^2\\) with Lipschitz continuous second derivatives).

- __Equality constrained minimization__: 

  $$
  \begin{align*}
  \min_{\boldsymbol{x}\in\mathbb{R}^n} &f(\boldsymbol{x})\\
  \text{s.t. } &c(\boldsymbol{x})=0
  \end{align*}
  $$
  
  where the equality constraints \\(c: \mathbb{R}^n \rightarrow \mathbb{R}^m\\), are defined by 
  sufficiently smooth functions, and \\(m \leq n\\).

- __Inequality constrained minimization__: 

  $$
  \begin{align*}
  \min_{\boldsymbol{x}\in\mathbb{R}^n} &f(\boldsymbol{x})\\
  \text{s.t. } &c_I(\boldsymbol{x})\geq 0\\
  &c_E(\boldsymbol{x})=0
  \end{align*}
  $$
  
  where \\(c_I: \mathbb{R}^n\rightarrow\mathbb{R}^{m_I}\\) and \\(c_E: \mathbb{R}^n\rightarrow\mathbb{R}^{m_E}\\) 
  are sufficiently smooth funcitons, \\(m_E \leq n\\), and \\(m_I\\) may be larger than \\(n\\). We also write 
  \\(c=\begin{smallmatrix}c_I\\c_E\end{smallmatrix}\\).
  
  - Discrete Optimisation
    - Combinatorial Optimisation
    - Integer Programming
    - Mixed Integer Programming
    - NLP with integrality constraints
    - Linear Programming
  - Continuous Optimisation
    - Quadratic Programming
    - Nonlinear Programming
    - Conic Programming
    - Semidefinite Programming
    - Linear Programming
  
  Notations
  
  - the gradient of \\(f\\): \\(g(\boldsymbol{x})=\nabla f(\boldsymbol{x}) = [D_xf(\boldsymbol{x})]^T\\)
  - the Hessian of \\(f\\): \\(H(\boldsymbol{x})=D_{xx}f(\boldsymbol{x})\\)
  - the gradient of the \\(i\\)-th constraint function: \\(a_i(\boldsymbol{x})=\nabla c_i(\boldsymbol{x})\\)
  - the Hessian of the \\(i\\)-th constraint function: \\(H_i(\boldsymbol{x})=D_{xx}c_i(\boldsymbol{x})\\)
  - the Jacobian of \\(c\\): \\(A(\boldsymbol{x})=D_x c(\boldsymbol{x}) = [a_1(\boldsymbol{x}) \cdots a_m(\boldsymbol{x})]^T\\)
  - the Lagrangian function: \\(\mathcal{l}(\boldsymbol{x}, \boldsymbol{y}) = f(\boldsymbol{x}) - \boldsymbol{y}^Tc(\boldsymbol{x})\\)
  - the \\(x\\)-Hessian of \\(\mathcal{l}\\): \\(H(\boldsymbol{x}, \boldsymbol{y})=D_{xx}\mathcal{l}(\boldsymbol{x}, \boldsymbol{y})=H(\boldsymbol{x})-\sum_{i=1}^my_iH_i(\boldsymbol{x})\\)
  
  The variables \\(\boldsymbol{y}\\) that appear in \\(\mathcal{l}\\) and \\(H\\) are called __Lagrange multipliers__.
  
  - __Lipschitz continuity__: Let \\(\mathcal{X}\\) and \\(\mathcal{Y}\\) be open sets in two normed 
  spaces \\((N_{\mathcal{X}}, \|\|\cdot\|\|_{\mathcal{X}})\\) and \\((N_{\mathcal{Y}}, \|\|\cdot\|\|_{\mathcal{Y}})\\). 
  A function \\(F: \mathcal{X} \rightarrow \mathcal{Y}\\) is called
  
    - Lipschitz continuous at \\(\boldsymbol{x} \in \mathcal{X}\\) if there exists a 
    \\(\gamma(\boldsymbol{x}) > 0\\) such that 
    $$
    ||F(\boldsymbol{z})-F(\boldsymbol{x})||_{\mathcal{Y}} \leq \gamma(\boldsymbol{x})||\boldsymbol{z}-\boldsymbol{x}||_{\mathcal{X}} \label{eq:lc}
    $$
    
    - uniformly Lipschitz continuous in \\(\mathcal{X}\\) if there exists a \\(\gamma > 0\\) such 
    that \\(ref{eq:lc}\\) holds true with \\(\gamma(\boldsymbol{x}) = \gamma\\) for all 
    \\(\boldsymbol{x}\in\mathcal{X}\\).
    
  - Taylor Approximation
  
    Let \\(\mathcal{S}\\) be an open subset of \\(\mathbb{R}^n\\), 
    \\(\boldsymbol{x}, \boldsymbol{s} \in \mathbb{R}^n\\) such that 
    \\(\boldsymbol{x}+\theta\boldsymbol{s}\in\mathcal{S}\\) for all \\(\theta\in[0,1]\\).
    
    - If \\(f\in C^1(\mathcal{S},\mathbb{R})\\), and its gradient \\(g(\boldsymbol{s})\\) is Lipschitz 
    continuous at \\(\boldsymbol{x}\\) with Lipschitz constant \\(\gamma^L(\boldsymbol{x})\\), then
    $$
    |f(\boldsymbol{x}+\boldsymbol{s})-m^L(x+s)|\leq\frac{1}{2}\gamma^L(\boldsymbol{x})||s||^2
    $$
    where \\(m^L(\boldsymbol{x}+\boldsymbol{s})=f(\boldsymbol{x})+g(\boldsymbol{x})^T\boldsymbol{s}\\) 
    is the first-order Taylor approximation of \\(f\\) at \\(\boldsymbol{x}\\).
    - (Vectorisation) If \\(F\in C^1(\mathcal{S},\mathbb{R}^m)\\), and its Jocabian 
    \\(D_xF(\boldsymbol{x})\\) is Lipschitz continuous at \\(\boldsymbol{x}\\) with Lipschitz 
    constant \\(\gamma^L(\boldsymbol{x})\\) (using the matrix operator norm induced by the 
    norms on \\(\mathbb{R}^n\\) and \\(\mathbb{R}^m\\)), then
    $$
    ||F(\boldsymbol{x}+\boldsymbol{s})-M^L(\boldsymbol{x}+\boldsymbol{s})||\leq\frac{1}{2}\gamma^L(\boldsymbol{x})||\boldsymbol{s}||^2
    $$
    where \\(M^L(\boldsymbol{x}+\boldsymbol{s})=F(\boldsymbol{x})+D_xF(\boldsymbol{x})\boldsymbol{s}\\)
    is the first-order Taylor approximation of \\(f\\) at \\(\boldsymbol{x}\\).
    - If \\(f\in C^2(\mathcal{S},\mathbb{R})\\), and its Hessian \\(H(\boldsymbol{x})\\) is 
    Lipschitz continuous at \\(\boldsymbol{x}\\) with Lipschitz constant \\(\gamma^Q(\boldsymbol{x})\\), 
    then
    $$
    |f(\boldsymbol{x}+\boldsymbol{s})-m^Q(\boldsymbol{x}+\boldsymbol{s})|\leq\frac{1}{6}\gamma^Q(\boldsymbol{x})||\boldsymbol{s}||^3
    $$
    where \\(m^Q(\boldsymbol{x}+\boldsymbol{s})=f(\boldsymbol{x})+\boldsymbol{s}^Tg(\boldsymbol{x})+\frac{1}{2}\boldsymbol{s}^TH(\boldsymbol{x})\boldsymbol{s}\\) 
    is the second-order Taylor approximation of \\(f\\) at \\(\boldsymbol{x}\\).
  
  A local minimiser for problem (UCM) is a point \\(x^\*\in\mathbb{R}^n\\) for which there 
  exists \\(\rho>0\\) such that \\(f(\boldsymbol{x})\geq f(\boldsymbol{x}^\*)\\) for all 
  \\(\boldsymbol{x}\in B_\rho(\boldsymbol{x}^\*)\\).
  
  - Necessary Optimality Conditions for UCM
  
    Let \\(\boldsymbol{x}^\*\\) be a local minimiser for problem UCM.
    
    - Then the following first order necessary condition must hold
    $$
    g(\boldsymbol{x}^\*) = 0
    $$
    - If furthermore \\(f\in C^2\\), then the following second order necessary condition must 
    also hold
    $$
    \boldsymbol{s}^TH(\boldsymbol{x}^*)\boldsymbol{s}\geq 0 , \boldsymbol{s} \in \mathbb{R}^n
    $$
    that is, \\(H(\boldsymbol{x}^\*\\) is positive semidefinite.
    
- Sufficient Optimality Conditions for UCM

  Let \\(f\in C^2\\), and let \\(\boldsymbol{x}^\*\in\mathbb{R}^n\\) be a point where the following 
  sufficient optimality conditions are satisfied,
  $$
  g(\boldsymbol{x^*} = 0\\
  \boldsymbol{s}^TH(\boldsymbol{x}^*)\boldsymbol{s}>0, (\boldsymbol{s}\in\mathbb{R}^n\\\{0\})
  $$
  that is, \\(H(\boldsymbol{x}^\*)\\) is positive definite. Then \\(\boldsymbol{x}^\*\\) is an 
  isolated local minimiser of \\(f\\).
  
A local minimiser for problem ECM is a point \\(\boldsymbol{x}^\*\in\mathbb{R}^n\\) for which 
there exists \\(\rho>0\\) such that \\(f(\boldsymbol{x})\geq f(\boldsymbol{x}^\*)\\) for all 
\\(\boldsymbol{x}\in B_\rho(\boldsymbol{x}^\*) \cap \{\boldsymbol{x}: c(\boldsymbol{x})=0\}\\).

The linear independence constraint qualification is stasfied at \\(\boldsymbol{x}^\*\\) if the set 
of gradient vectors \\(\{a_i(\boldsymbol{x}^\*): i=1,\cdots,m\}\\) defined by the constraint 
functions is linearly independent.

- Necessary Optimality Conditions for ECM

  Let \\(\boldsymbol{x}^\*\\) be a local minimiser for problem ECM where the LICQ holds.
  - Then the following first order necessary conditions must hold: There exists a vector 
  \\(\boldsymbol{y}^\*\in\mathbb{R}^m\\) of Lagrange multipliers such that
  $$
  c(\boldsymbol{x}^*) = 0 \text{ (primal feasibility)}\\
  \nabla_x\mathcal{l}(\boldsymbol{x}^*, \boldsymbol{y}^*)=g(\boldsymbol{x}^*)-A^T(\boldsymbol{x}^*)\boldsymbol{y}^*=0 \text{ (dual feasibility)}
  $$
  (Recall that \\(g(\boldsymbol{x}^\*)-A^T(\boldsymbol{x}^\*)\boldsymbol{y}^\*=\nabla f(\boldsymbol{x}^\*)-\sum_{i=1}^m\boldsymbol{y}_i^\*\nabla c_i(\boldsymbol{x}^\*)\\), 
  so that dual feasibility says that \\(\nabla f(\boldsymbol{x}^\*)\\) is counterbalanced by linear 
  combination of the \\(\nabla c_i(\boldsymbol{x}^\*)\\)).
  - Furthermore, if \\(f, c \in c^2\\), then for all \\(\boldsymbol{s}\in\mathbb{R}^n\\) such that 
  $$
  \boldsymbol{s}^TH(\boldsymbol{x}^\*, \boldsymbol{y}^\*)\boldsymbol{s} \geq 0
  $$
  that is, \\(H(\boldsymbol{x}^\*)\\) is positive semidefinite in the directions that lie in the 
  tangent space of the feasible manifold.
  
A local minimiser for problem ICM is a point \\(\boldsymbol{x}^\*\in\mathbb{R}^n\\) for which 
there exists \\(\rho > 0\\) such that \\(f(\boldsymbol{x}\geq f(\boldsymbol{x}^\*)\\) for all 
\\(\boldsymbol{x}\in B_\rho (\boldsymbol{x}^\*) \cap \{\boldsymbol{x}: c_E(\boldsymbol{x})=0, c_I(\boldsymbol{x})\geq 0\}\\).

Let \\(\boldsymbol{x}^\*\\) be feasible for ICM. The active set of constraints at \\(\boldsymbol{x}^\*\\) 
is the set of indices

$$
\mathscr{A}(\boldsymbol{x}^*)=E\cup\{i\in I: c_i(\boldsymbol{x}^*)=0\}
$$

The linear independence constraint qualification is satisfied at \\(\boldsymbol{x}^\*\\) if the 
set of vectors \\(\{\nabla c_i (\boldsymbol{x}^\*): i\in\mathscr{A}(\boldsymbol{x}^\*)\}\\) is 
linearly independent.

- Necessary Optimality Conditions for ICM

  Let \\(\boldsymbol{x}^\*\\) be a local minimiser for problem ICM where the LICQ holds.
  - Then the following first order necessary conditions must hold: There exists a vector
  \\(\boldsymbol{y}^\*\in\mathbb{R}^m\\) of Lagrange multipliers such that
  $$
  c_E(\boldsymbol{x}^*)=0 \text{ primal feasibility 1}\\
  c_I(\boldsymbol{x}^*)\geq 0 \text{ primal feasibility 2}\\
  \nabla_x\mathcal{l}(\boldsymbol{x}^*, \boldsymbol{y}^*)=g(\boldsymbol{x}^*)-A^T(\boldsymbol{x}^*)\boldsymbol{y}^*=0 \text{ dual feasibility 1}\\
  y_i^* \geq 0 (i \in I) \text{ dual feasibility 2}\\
  c_i(\boldsymbol{x}^*)y_i^*=0 (i \in E\cup I) \text{ complementarity}
  $$
  These conditions are also called Karush-Kuhn-Tucker (KKT) conditions. Complementarity 
  guarantees that \\(y_i^\*=0\\) for all \\(i \notin \mathscr{A}(\boldsymbol{x}^\*)\\).
  - Furthermore, if \\(f, c \in C^2\\), then for all \\(\boldsymbol{s}\in\mathbb{R}^n\\) such that 
  $$
  a_i(\boldsymbol{x}^*)^T\boldsymbol{s}=0, (i\in E\cup\{i\in I: i\in\mathscr{A}(\boldsymbol{x}^*), y_i^*>0\})\\
  a_i(\boldsymbol{x}^*)^T\boldsymbol{s}\geq 0, (i\in \{i\in I: i\in\mathscr{A}(\boldsymbol{x}^*), y_i^*=0\})
  $$
  the following second order necessary condition must also hold.
  
  The second order optimality analysis is based on the following observation: If \\(\boldsymbol{x}^\*\\) 
  is a local minimiser of ICM, and \\(x(t)\\) is a feasible exit path from \\(\boldsymbol{x}^\*\\) 
  with tangent \\(\boldsymbol{s}\\) at \\(\boldsymbol{x}^\*\\), then \\(\boldsymbol{x}^\*\\) must 
  also be a local minimiser for the univariate constrained optimisation problem: 
  $$
  \min f(x(t))\\
  \text{s.t. } t\geq 0
  $$
  - Sufficient Optimality Conditions for ICM
  Let \\(\boldsymbol{x}^\*\\) be a feasible point for ICM at which the LICQ holds, where it is assumed 
  that \\(f, c \in C^2\\). Let \\(\boldsymbol{y}^\* \in \mathbb{R}^m\\) be a vector of Lagrange 
  multipliers such that \\((\boldsymbol{x}^\*, \boldsymbol{y}^\*)\\) satisfy the KKT conditions. If 
  it is furthermore the case that
  $$
  \boldsymbol{s}^TH(\boldsymbol{x}^\*, \boldsymbol{y}^\*)\boldsymbol{s}>0
  $$
  for all \\(\boldsymbol{s}\in\mathbb{R}^n\\) that satisfy
  $$
  a_i(\boldsymbol{x}^*)^T\boldsymbol{s}=0 (i\in E\cup\{i\in I: i\in\mathscr{A}(\boldsymbol{x}^*), y_i^*>0\})\\
  a_i(\boldsymbol{x}^*)^T\boldsymbol{s}\geq 0 (i\in\{i\in I: i\in\mathscr{A}(\boldsymbol{x}^*), y_i^*=0\})
  $$
  then \\(\boldsymbol{x}^\*\\) is a local minimiser for ICM.
  
  ### Generic Line Search Method
  
  1. Pick an initial iterate \\(\boldsymbol{x}^0\\) by educated guess, set \\(k=0\\)
  2. Until \\(\boldsymbol{x}^k\\) has converged
    1. Calculate a search direction \\(\boldsymbol{p}^k\\) from \\(\boldsymbol{x}^k\\), ensuring 
    that this direction is a descent direction, that is, 
    $$
    [\boldsymbol{g}^k]^T\boldsymbol{p}^k < 0 \text{ if } \boldsymbol{g}^k\neq 0
    $$
    so that for small enough steps away from \\(\boldsymbol{x}^k\\) in the direction 
    \\(\boldsymbol{p}^k\\) the objective function will be reduced.
    2. Calculate a suitable steplength \\(\alpha^k>0\\) so that
    $$
    f(\boldsymbol{x}^k+\alpha^k\boldsymbol{p}^k) < f^k
    $$
    The computation of \\(\alpha^k\\) is called line search, ant this is usually an inner 
    iterative loop.
    3. Set \\(\boldsymbol{x}^{k+1}=\boldsymbol{x}^k+\alpha^k\boldsymbol{p}^k\\).
 
 Actual methods differ from one another in how step 1 and step 2 are computed.
 
#### Backtracking Line Search

1. Given \\(\alpha_{\text{init}} > 0\\) (e.g., \\(\alpha_{\text{init}}=1\\)), let 
\\(\alpha^{(0)}=\alpha_{\text{init}}\\) and \\(l=0\\)
2. Until \\(f(\boldsymbol{x}^k+\alpha^{(l)}\boldsymbol{p}^k) < f^k\\)
  1. set \\(\alpha^{(l+1)}=\tau\alpha^{(l)}\\), where \\(\tau\in(0, 1)\\) is fixed (e.g., \\(\tau=\frac{1}{2}\\))
  2. increment \\(l\\) by \\(1\\)
3. Set \\(\alpha^k = \alpha^{(l)}\\)

This method prevents the step from getting too small, but it does not prevent steps that are too 
long relative to the decrease in \\(f\\).

To improve the method, we need to tighten the requirement \\(f(\boldsymbol{x}^k+\alpha^{(l)}\boldsymbol{p}^k) < f^k\\).

To prevent long steps relative to the decrease in \\(f\\), we require the Armijo condition

$$
f(\boldsymbol{x}^k+\alpha^k\boldsymbol{p}^k)\leq f(\boldsymbol{x}^k)+\alpha^k\beta\cdot[\boldsymbol{g}^k]^T\boldsymbol{p}^k
$$

for some fixed \\(\beta\in(0,1)\\) (e.g., \\(\beta=0.1\\) or even \\(\beta=0.0001\\)).

That is to say, we require that the achieved reduction if \\(f\\) be at least a fixed fraction 
\\(\beta\\) of the reduction promised by the first-order Taylor approximation of \\(f\\) at 
\\(\boldsymbol{x}^k\\).

#### Backtracking-Armijo Line Search

1. Given \\(\alpha_{\text{init}}>0\\) (e.g., \\(\alpha_{\text{init}}=1\\)), let 
\\(\alpha^{(0)}=\alpha_{\text{init}}\\) and \\(l=0\\)
2. Until \\(f(\boldsymbol{x}^k+\alpha^{(l)}\boldsymbol{p}^k)\leq f(\boldsymbol{x}^k) + \alpha^{(l)}\beta\cdot[\boldsymbol{g}^k]^T\boldsymbol{p}^k\\),
  1. set \\(\alpha^{(l+1)}=\tau\alpha^{(l)}\\), where \\(\tau\in(0,1)\\) is fiexed (e.g., \\(\tau=\frac{1}{2}\\))
  2. increment \\(l\\) by \\(1\\)
3. Set \\(\alpha^k=\alpha^{(l)}\\).

- Termination of Backtracking-Armijo

Let \\(f\in C^1\\) with gradient \\(g(\boldsymbol{x})\\) that is Lipschitz continuous with constant 
\\(\gamma^k\\) at \\(\boldsymbol{x}^k\\), and let \\(\boldsymbol{p}^k\\) be a descent direction at 
\\(\boldsymbol{x}^k\\). Then, for fixed \\(\beta\in(0,1)\\),

1. the Armijo condition \\(f(\boldsymbol{x}^k+\alpha\boldsymbol{p}^k)\leq f^k+\alpha\beta\cdot[\boldsymbol{g}^k]^T\boldsymbol{p}^k\\) 
is satisfied for all \\(\alpha \in [0, \alpha_{\text{max}}^k]\\), where
$$
\alpha_{\text{max}}^k = \frac{2(\beta-1)[\boldsymbol{g}^k]^T\boldsymbol{p}^k}{\gamma^k||\boldsymbol{p}^k||_2^2}
$$
2. and furthermore, for fixed \\(\tau\in(0,1)\\) the stepsize generated by the backtracking-Armijo 
line search terminates with
$$
\alpha^k\geq\min\left(\alpha_{\text{init}}, \frac{2\tau(\beta-1)[\boldsymbol{g}^k]^T\boldsymbol{p}^k}{\gamma^k||\boldsymbol{p}^k||_2^2}\right)
$$

We remark that in practive \\(\gamma^k\\) is not known. Therefore, we can not simply compute 
\\(\alpha_{\text{max}}^k\\) and \\(\alpha^k\\) via the explicit formulas given by the theorem, and 
we still need the algorithmm on the previous section.

- Convergence of Generic LSM with B-A steps

Let the gradient \\(\boldsymbol{g}\\) of \\(f \in C^1\\) be uniformly Lipschitz continuous on 
\\(\mathbb{R}^n\\). Then for the iterates generated by the Generic Line Search Method with 
Backtracking-Armijo step lengths, one of the following situations occurs

1. \\(\boldsymbol{g}^k=0\\) for some finite \\(k\\)
2. \\(\lim_{k\rightarrow\infty}f^k=-\infty\\)
3. \\(\lim_{k\rightarrow\infty}\min\left\{\|[\boldsymbol{g}^k]^T\boldsymbol{p}^k\|, \frac{\|[\boldsymbol{g}^k]^T\boldsymbol{p}^k\|}{\|\|\boldsymbol{p}^k\|\|_2}\right\}=0\\)

#### Computing a Search Direction \\(\boldsymbol{p}^k\\)

- Method of steepest descent

  The most straight-forward choice of a search direction, \\(\boldsymbol{p}^k=-\boldsymbol{g}^k\\), is 
  called steepest-descent direction.
  - \\(\boldsymbol{p}^k\\) is a descent direction
  - \\(\boldsymbol{p}^k\\) solves the problem
  $$
  \min_{\boldsymbol{p}\in\mathbb{R}^n} m_k^L(\boldsymbol{x}^k+\boldsymbol{p})=f^k+[\boldsymbol{g}^k]^T\boldsymbol{p}\\
  \text{s.t. } ||\boldsymbol{p}||_2 = ||\boldsymbol{g}^k||_2
  $$
  - \\(\boldsymbol{p}^k\\) is cheap to compute
  
  Any method that usees the steepest-descent direction as a search direction is a method of steepest descent.
  
  Intuitively, it would seem that \\(\boldsymbol{p}^k\\) is the best search-direction one can find. 
  If that were true then much of optimisation theory would not exist.

- Global Convergence of steepest descent

Let the gradient \\(\boldsymbol{g}\\) of \\(f\in C^1\\) be uniformly Lipschitz continuous on 
\\(\mathbb{R}^n\\). Then, for the iterates generated by the Generic LSM with B-A steps and 
steepest-descent search directions, one of the following situations occurs

1. \\(\boldsymbol{g}^k=0\\) for some finit \\(k\\)
2. \\(\lim_{k\rightarrow\infty}f^k=-\infty\\)
3. \\(\lim_{k\rightarrow\infty}\boldsymbol{g}^k=0\\)

- More General Descent Methods

Let \\(B^k\\) be a symmetric, positive definite matrix, and define the search direction \\(\boldsymbol{p}^k\\) 
as the solution to the linear system \\(B^k\boldsymbol{p}^k=-\boldsymbol{g}^k\\)

- \\(\boldsymbol{p}^k\\) is a descent direction, since \\([\boldsymbol{g}^k]^T\boldsymbol{p}^k=-[\boldsymbol{g}^k]^T[B^k]^{-1}\boldsymbol{g}^k<0\\)
- \\(\boldsymbol{p}^k\\) solves the problem \\(\min_{\boldsymbol{p}\in\mathbb{R}^n}m_k^Q(\boldsymbol{x}^k+\boldsymbol{p})=f^k+[\boldsymbol{g}^k]^T\boldsymbol{p}+\frac{1}{2}\boldsymbol{p}^TB^k\boldsymbol{p}\\)
- \\(\boldsymbol{p}^k\\) corresponds to the steepest descent direction if the norm \\(\|\|\boldsymbol{x}\|\|_{B^k} := \sqrt{\boldsymbol{x}^TB^k\boldsymbol{x}}\\) 
is used on \\(\mathbb{R}^n\\) instead of the canonical Euclidean norm. This change of metric can be 
seen as preconditioning that can be chosen so as to speed up the steepest descent method.
- If the Hessian \\(H^k\\) of \\(f\\) at \\(\boldsymbol{x}^k\\) is positive definite, and 
\\(B^k=H^k\\), this is Newton's method
- If \\(B^k\\) changes at every iterate \\(\boldsymbol{x}^k\\), a method based on the search direction 
\\(\boldsymbol{p}^k\\) is called variable metric method. In particular, Newton's method is a 
variable metric method.

- Global Convergence of More General Descent Direction Methods

Let the gradient \\(\boldsymbol{g}\\) of \\(f\in C^1\\) be uniformly Lipschitz continuous on 
\\(\mathbb{R}^n\\). Then, for the iterates generated by the Generic LSM with B-A steps and search 
directions defined by \\(B^k\boldsymbol{p}^k=-\boldsymbol{g}^k\\), one of the following situations 
occurs

1. \\(\boldsymbol{g}^k=0\\) for some finite \\(k\\)
2. \\(\lim_{k\rightarrow\intfy}f^k=-\infty\\)
3. \\(\lim_{k\rightarrow\intfy}\boldsymbol{g}^k=0\\)

provided that the eigenvalues of \\(B^k\\) are uniformly bounded above, and uniformly bounded away 
from zero.

- Local Convergence of Newton's Method

Let the Hessian \\(H\\) of \\(f\in C^2\\) be uniformly Lipschitz continuous on \\(\mathbb{R}^n\\). 
Let iterates \\(\boldsymbol{x}^k\\) be generated via the Generic LSM with B-A steps using 
\\(\alpha_{\text{init}}=1\\) and \\(\beta<\frac{1}{2}\\), and using the Newton search direction 
\\(\boldsymbol{n}^k\\), defined by \\(H^k\boldsymbol{n}^k=-\boldsymbol{g}^k\\). If 
\\((\boldsymbol{x}^k)_{\mathbb{N}}\\) has an accumulation point \\(\boldsymbol{x}^\*\\) where 
\\(H(\boldsymbol{x}^\*) > 0\\) (positive definite) then

1. \\(\alpha^k=1\\) for all \\(k\\) large enough
2. \\(\lim_{k\rightarrow\intfy}\boldsymbol{x}^k=\boldsymbol{x}^\*\\)
3. the sequence converges Q-quadradically, that is, there exists \\(\kappa>0\\) such that 
$$
\lim_{k\rightarrow\infty}\frac{||\boldsymbol{x}^{k+1}-\boldsymbol{x}^*||}{||\boldsymbol{x}^k - \boldsymbol{x}^*||^2} \leq \kappa
$$

The mechanism that makes it work is that once the sequence \\((\boldsymbol{x}^k)_{\mathbb{N}}\\) 
enters a certain domain of attraction of \\(\boldsymbol{x}^\*\\), it can not escape again and 
quadratic convergence to \\(\boldsymbol{x}^\*\\) commences.

Note that this is only a local convergence result, that is, Newton's method is not guaranteed to 
converge to a local minimiser from all starting points.

- Modified Newton Method

The use of \\(B^k=H^k\\) makes only sense at iterates \\(\boldsymbol{x}^k\\) where \\(H^k>0\\). 
Since this is usually not guaranteed to always be the case, we modify the method as follows,

- Choose \\(M^k \geq 0\\) so that \\(H^k + M^k\\) is sufficiently positive definite, with 
\\(M^k=0\\) if \\(H^k\\) itself is sufficiently positive definite.
- Set \\(B^k= H^k+M^k\\) and solve \\(B^k\boldsymbol{p}^k=-\boldsymbol{g}^k\\)

The regularisation term \\(M^k\\) is typically chosen as one of the following

- If \\(H^k\\) has the spectral decomposition \\(H^k=Q^k\land^k[Q^k]^T\\), then
$$
H^k + M^k = Q^k\max\{\epsilon I, |D^k|\}[Q^k]^T
$$
- \\(M^k = \max\{0, -\lambda_{\text{min}}(H^k)\}I\\)
- Modified Cholesky method
  - Compute a factorisation \\(PH^kP^T=LBL^T\\), where \\(P\\) is a permutation matrix, \\(L\\) a 
  unit lower triangular matrix, and \\(B\\) a block diagonal matrix with blocks of size \\(1\\) or 
  \\(2\\)
- Choose a matrix \\(F\\) such that \\(B+F\\) is sufficiently positive definite
- Let \\(H^k+M^k=P^TL(B+F)L^TP\\)

- Other Modifications of Newton's Method

1. Build a cheap approximation \\(B^k\\) to \\(H^k\\): 
  - Quasi-Newton approximation (BFGS, SR1, etc.)
  - or use finite-difference approximation
2. Instead of solving \\(B^k\boldsymbol{p}^k=-\boldsymbol{g}^k\\) for \\(\boldsymbol{p}^k\\), if 
\\(B>0\\) approximately solve the convex quadratic programming problem
$$
\text{(QP) } \boldsymbol{p}^k \approx \arg\min_{\boldsymbol{p}\in\mathbb{R}^n}f^k+\boldsymbol{p}^T\boldsymbol{g}^k+\frac{1}{2}\boldsymbol{p}^TB\boldsymbol{p}
$$

  The conjugate gradient method is a good solver for 2:
  
  1. Set \\(\boldsymbol{p}^{(0)}=0\\), \\(\boldsymbol{g}^{(0)}=\boldsymbol{g}^k\\), 
  \\(\boldsymbol{d}^{(0)}=-\boldsymbol{g}^k\\), and \\(i=0\\)
  2. Until \\(\boldsymbol{g}^{(i)}\\) is sufficiently small or \\(i=n\\), repeat
    1. \\(\alpha^{(i)}=\frac{\|\|\boldsymbol{g}^{(i)}\|\|_2^2}{[\boldsymbol{d}^{(i)}]^TB^k\boldsymbol{d}^{(i)}}\\)
    2. \\(\boldsymbol{p}^{(i+1)}=p^{(i)}+\alpha^{(i)}\boldsymbol{d}^{(i)}\\)
    3. \\(\boldsymbol{g}^{(i+1)}=\boldsymbol{g}^{(i)}+\alpha^{(i)}B^k\boldsymbol{d}^{(i)}\\)
    4. \\(\beta^{(i)}=\frac{\|\|\boldsymbol{g}^{(i+1)}\|\|_2^2}{\|\|\boldsymbol{g}^{(i)}\|\|_2^2}\\)
    5. \\(\boldsymbol{d}^{(i+1)}=-\boldsymbol{g}^{(i+1)}+\beta^{(i)}\boldsymbol{d}^{(i)}\\)
    6. increment \\(i\\) by \\(1\\)
  3. Output \\(\boldsymbol{p}^k\approx\boldsymbol{p}^{(i)}\\)
  
  The important features of the conjugate gradient method
  
  - \\([\boldsymbol{g}^k]^T\boldsymbol{p}^{(i)}<0\\) for all \\(i\\), that is, the algorithm always 
  stops with a descent direction as an approximation to \\(\boldsymbol{p}^k\\)
  - Each iteration is cheap, as it only requires the computation of matrix-vector and vector-vector 
  products
  - Usually, \\(\boldsymbol{p}^{(i)}\\) is a good approximation of \\(\boldsymbol{p}^k\\) well 
  before \\(i=n\\)

### Trust Region

Iterative optimisation algorithms typically solve a much easier optimisation problem than UCM in 
each iteration.

- In the case of the line search methods, the subproblems were eays because they are \\(1\\)-dimensional.
- In the case of the trust-region methods, the subproblems are \\(n\\)-dimensional but based on a 
simpler objective function - a linear or quadratic model - which is trusted in s simple region - a 
ball of specified radius in a specified norm.

Conceptually, the trust-region approach replaces a \\(n\\)-dimensional unconstrained optimisation 
problem by a \\(n\\)-dimensional constrained one. The replacement pays off because: 

1. The subproblem need not be solved to high accuracy, an approximation solution is enough.
2. The model function belongs to a class for which highly effcitive specialised algorithms have 
been developed.

#### Line Search vs Trust Region

- Line Search methods: 
  - pick descent direction \\(\boldsymbol{p}_k\\)
  - pick stepsize \\(\alpha_k\\) to reduce \\(f(\boldsymbol{x}_k+\alpha\boldsymbol{p}_k)\\)
  - \\(\boldsymbol{x}_{k+1}=\boldsymbol{x}_k+\alpha_k\boldsymbol{p}_k\\)
- Trust Region methods: 
  - pick step \\(\boldsymbol{s}_k\\) to reduce model of \\(f(\boldsymbol{x}_k+\boldsymbol{s})\\)
  - accept \\(\boldsymbol{x}_{k+1}=\boldsymbol{x}_k+\boldsymbol{s}_k\\) if the decrease promised by the model 
  is inherited by \\(f(\boldsymbol{x]_k+\boldsymbol{s}_k)\\)
  - otherwise set \\(\boldsymbol{x}_{k+1}=\boldsymbol{x}_k\\) and improve the model

We model \\(f(\boldsymbol{x}_k+\boldsymbol{s})\\) by either of the following: 

- linear model \\(m_k^L(\boldsymbol{s}) = f_k+\boldsymbol{s}^T\boldsymbol{g}_k\\)
- quadratic model choose a symmetric matrix \\(B_k\\) \\(m_k^Q(\boldsymbol{s})=f_k+\boldsymbol{s}^T\boldsymbol{g}_k+\frac{1}{2}\boldsymbol{s}^TB_k\boldsymbol{s}\\)

Challenges: 

- Models may not resemble \\(f(\boldsymbol{x}_k+\boldsymbol{s})\\) if \\(\boldsymbol{s}\\) is large
- Models may be unbounded from below:
  - \\(m^L\\) always unless \\(\boldsymbol{g}_k=0\\)
  - \\(m^Q\\) always if \\(B_k\\) is indefinite, and possibly if \\(B_k\\) is only positive semi-definite

To prevent both problems, we impose a trust region constraint \\(\|\|\boldsymbol{s}\|\|\leq\Delta_k\\) for some 
suitable scalar radius \\(\Delta_k>0\\) and norm \\(\|\|\codt\|\|\\).

Therefore, the trust-region subproblem is the constrained optimisation problem

$$
\min_{\boldsymbol{s}\in\mathbb{R}^n} m_k(\boldsymbol{s})\\
\text{s.t. } ||\boldsymbol{s}|| \leq \Delta_k
$$

In theory the success of the method does not depend on the choice of the norm \\(\|\|\cdot\|\|\\), but 
in practice is can.

For simplicity, we concentrate on the quadratic (Newton like) model

$$
m_k(\boldsymbol{s})=m_k^Q(\boldsymbol{s})=f_k+\boldsymbol{s}^T\boldsymbol{g}_k+\frac{1}{2}\boldsymbol{s}^TB_k\boldsymbol{s}
$$

and any trust region norm \\(\|\|\cdot\|\|\\) for which \\(\kappa_s\|\|\cdot\|\|\leq\|\|\cdot\|\|_2\leq\kappa_l\|\|\cdot\|\|\\) 
for some \\(\kappa_l\geq\kappa_s>0\\)

Norms on \\(\mathbb{R}^n\\) we might want to consider: 

- \\(\|\|\cdot\|\|_2\leq\|\|\cdot\|\|_2\leq\|\|\cdot\|\|_2\\)
- \\(n^{-\frac{1}{2}}\|\|\cdot\|\|_1\leq\|\|\cdot\|\|_2\leq\|\|\codt\|\|_1\\)
- \\(\|\|\cdot\|\|_\infty\leq\|\|\cdot\|\|_2\leq n\|\|\cdot\|\|_\infty\\)

Choice of \\(B_k\\): 

\\(B_k=H_k\\) is allow but may be impractical (due ot the problem dimension) or undesirable (due to 
indefiniteness)

As an alternative, any of the Hessian approximations can be used.

#### Basic Trust Region Method

1. Initialisation: Set \\(k=0, \Delta_0>0\\) and choose starting point \\(\boldsymbol{x}_0\\) by 
educated guess. Fix \\(\eta_v \in (0,1)\\) (typically, \\(\eta_v=0.9\\)), \\(\eta_s\in(0,\eta_v)\\) 
(typically, \\(\eta_s=0.1\\)), \\(\gamma_i\geq 1\\) (typically, \\(\gamma_i=2\\)), and 
\\(\gamma_d\in(0,1)\\) (typically, \\(\gamma_d=0.5\\)).
2. Until convergence repeat
  1. Build a quadratic model \\(m(\boldsymbol{s})\\) of \\(\boldsymbol{s}\mapto f(\boldsymbol{x}_k+\boldsymboL{s})\\)
  2. Solve the trust region subproblem approximately to find \\(\boldsymbol{s}_k\\) for which 
  \\(m(\boldsymbol{s}_k) < f_k\\) and \\(\|\|\boldsymbol{s}_k\|\|\leq\Delta_k\\), and define 
  $$
  \rho_k=\frac{f_k - f(\boldsymbol{x}_k+\boldsymbol{s}_k)}{f_k - m_k(\boldsymbol{s}_k)}
  $$
  3. If \\(\rho_k \geq \eta_v\\) (very successful TR step), set \\(\boldsymbol{x}_{k+1}=\boldsymbol{x}_k+\boldsymbol{s}_k\\) 
  and \\(\Delta_{k+1}=\gamma_i\Delta_k\\)
  4. If \\(\rho_k \geq \eta_s\\) (successful TR step), set \\(\boldsymbol{x}_{k+1}=\boldsymbol{x}_k+\boldsymbol{s}_k\\) 
  and \\(\Delta_{k+1} = \Delta_k\\)
  5. If \\(\rho_k < \eta_s\\) (unsuccessful TR step), set \\(\boldsymbol{x}_{k+1}=\boldsymbol{x}_k\\) 
  and \\(\Delta_{k+1}=\gamma_d\Delta_k\\)
  6. Increase \\(k\\) by \\(1\\)

The Cauchy point is defined by \\(\boldsymbol{s}_k^c := -\alpha_k^c\boldsymbol{g}_k\\), where
$$
\alpha_k^c := \arg\min\{m_k(-\alpha\boldsymbol{g}_k): \alpha>0, \alpha||\boldsymbol{g}_k||\leq\Delta_k\}\\
= \arg\min\{m_k(-\alpha\boldsymbol{g}_k): 0<\alpha\leq\frac{\Delta_k}{||\boldlsymbol{g}_k||}\}
$$

Computing the C.P. is very easy (minimise a quadratic over a line segment)

For the approximate solution of the trust region subproblem, we require that

$$
m_k(\boldsymbol{s}_k)\leq m_k(\boldsymbol{s}_k^c) \text{ and } ||\boldsymbol{s}_k\leq\Delta_k
$$

In practice, hope to do far better than this.

- Archievable Model Decrease

Let \\(m_k(\boldsymbol{s})\\) be a quadratic model of \\(f\\) and \\(\boldsymbol{s}_k^c\\) its 
Cauchy point within the trust region \\(\{\boldsymbol{s}: \|\|\boldsymbol{s}\|\|\leq\Delta_k\}\\). 
Then the achievable model decrease is at least 
$$
f_k-m_k(\boldsymbol{s}_k^c)\geq\frac{1}{2}||\boldsymbol{g}_k||_2\cdot\min\left\{\frac{||\boldsymbol{g}_k||_2}{1+||B_k||_2}, \kappa_s\Delta_k\right\}
$$

Let \\(m_k(\boldsymbol{s})\\) be a quadratic model of \\(f\\) and \\(\boldsymbol{s}_k\\) an improvement 
on its Cauchy point within the trust region \\(\{\boldsymbol{s}: \|\|\boldsymbol{s}\|\|\leq\Delta_k\}\\), then 
$$
f_k-m_k(\boldsymbol{s}_k)\geq\frac{1}{2}||\boldsymbol{g}_k||_2\cdot\min\left\{\frac{||\boldsymbol{g}_k||_2}{1+||B_k||_2}, \kappa_s\Delta_k\right\}
$$
Further, if the trust region step \\(\boldsymbol{s}_k\\) is very successful, then
$$
f_k-f_{k+1}\geq\eta_v\frac{1}{2}||\boldsymbol{g}_k||_2\cdot\min\left\{\frac{||\boldsymbol{g}_k||_2}{1+||B_k||_2}, \kappa_s\Delta_k\right\}
$$

- Difference between model and function

Let \\(f \in C^2\\), and let there exist some constants \\(\kappa_h\geq 1\\) and \\(\kappa_b\geq 0\\) 
such that \\(\|\|H_k\|\|_2\leq\kappa_h\\) and \\(\|\|B_k\|\|_2\leq\kappa_b\\) for all \\(k\\). Then 
$$
|f(\boldsymbol{x}_k+\boldsymbol{s}_k)-m_k(\boldsymbol{s}_k)|\leq\kappa_d\cdot\Delta_k^2, k\in\mathbb{N}
$$
where \\(\kappa_d=\frac{1}{2}\kappa_l^2(\kappa_h+\kappa_b)\\)

- Ultimate Progress at Nonoptimal Points

Let \\(f\in C^2\\), and let there exist some constants \\(\kappa_h\geq 1\\) and \\(\kappa_b\geq 0\\) such 
that \\(\|\|H_k\|\|_2\leq\kappa_h\\) and \\(\|\|B_k\|\|_2\leq\kappa_b\\) for all \\(k\\). Let 
\\(\kappa_d=\frac{1}{2}\kappa_l^2(\kappa_h+\kappa_b)\\). If at iteration \\(k\\) we have \\(\boldsymbol{g}_k\neq 0\\) and 
$$
\Delta_k\leq||\boldsymbol{g}_k||_2\codt\min\left\{\frac{1}{\kappa_s(\kappa_h+\kappa_b)},\frac{\kappa_s(1-\eta_v)}{2\kappa_d}\right\}
$$
then iteration \\(k\\) is very successful and \\(\Delta_{k+1}\geq\Delta_k\\).

- TR radius won't shrink to zero at nonoptimal points

Let \\(f\in C^2\\), and let there exist some constants \\(\kappa_h\geq 1\\) and \\(\kappa_b\geq 0\\) 
such that \\(\|\|H_k\|\|_2\leq\kappa_h\\) and \\(\|\|B_k\|\|_2\leq\kappa_b\\) for all \\(k\\). Let 
\\(\kappa_d=\frac{1}{2}\kappa_l^2(\kappa_h+\kappa_b)\\). If there exists a constant \\(epsilon>0\\) 
such that \\(\|\|\boldsymbol{g}_k\|\|_2\geq\epsilon\\) for all \\(k\\), then 
$$
\Delta_k\geq\kappa_\epsilon := \epsilon\gamma_d\cdot\min\left\{\frac{1}{\kappa_s(\kappa_h+\kappa_b)}, \frac{\kappa_s(1\eta_v)}{2\kappa_d}\right\}, \forall k
$$

- Possible Finite Termination

Let \\(f\in C^2\\), and let both the true and model Hessians be bounded away from zero for all \\(k\\). 
If the basic trust region method has only finitely many successful iterations, then \\(\boldsymbol{x}_k=\boldsymbol{x}^\*\\) 
and \\(\boldsymbol{g}(\boldsymbol{x}^\*)=0\\) for all \\(k\\) large enough.

- Global Convergence

Let \\(f\in C^2\\), and let both the true and model Hessians be bounded away from zero for all \\(k\\). 
Then one of the following cases occurs

1. \\(\boldsymbol{g}_k=0\\) for some \\(k \in \mathbb{N}\\)
2. \\(\lim_{k\rightarrow\infty}f_k=-\infty\\)
3. \\(\lim_{k\rightarrow\infty}\boldsymbol{g}_k=0\\)

#### Methods for solving the TR subproblem

Let us now discuss how to solve the trust region subproblem

$$
\min_{\boldsymbol{s}\in\mathbb{R}^n}q(\boldsymbol{s})=\boldsymbol{s}^T\boldsymbol{g}+\frac{1}{2}\boldsymbol{s}^TB\boldsymbol{s}\\
\text{s.t. } ||\boldsymbol{s}||\leq\Delta
$$

such that the convergence theory above applies, that is, we aim to find \\(\boldsymbol{s}^\*\in\mathbb{R}^n\\) such that 

$$
q(\boldsymbol{s}^*)\leq q(\boldsymbol{s}^c) \text{ and } ||\boldsymbol{s}^*||\leq\Delta
$$

Might solve 

- excactly \\(\Rightarrow\\) Newton like method
- approximately \\(\Rightarrow\\) steepest descent/conjugate gradients

From now on we choose the \\(\mathcal{l}_2\\)-norm to determine trust regions, so that we have to 
approximately solve 

$$
\text{TRS} \min_{\boldsymbol{s}\in\mathbb{R}^n}\left\{q(\boldsymbol{s}): \boldsymbol{s}\in\mathbb{R}^n, ||\boldsymbol{s}||_2\leq\Delta\right\}
$$

where \\(q(\boldsymbol{s})=\boldsymbol{s}^T\boldsymbol{g}+\frac{1}{2}\boldsymbol{s}^TB\boldsymbol{s}\\).

Any global minimiser \\(\boldsymbol{s}^\*\\) of TR must satisfy 

1. \\((B+\lambda^\* I)\boldsymbol{s}^\* = - \boldsymbol{g}\\)
2. \\(B+\lambda^\* I \geq 0\\) (positive semi-definite)
3. \\(\lambda^\*\geq 0\\)
4. \\(\lambda^\*\cdot(\|\|\boldsymbol{s}^\*\|\|_2 - \Delta)=0\\)

Furthermore, if \\(B+\lambda^\* I > 0\\) (positive definite) then \\(\boldsymbol{s}^\*\\) is unique.

- Exact solutions of TRS

1. If \\(B>0\\) and solution of \\(B\boldsymbol{s}=-\boldsymbol{g}\\) satisfies \\(\|\|\boldsymbol{s}\|\|_2 \leq \Delta\\), 
then \\(\boldsymbol{s}^\* = \boldsymbol{s}\\), i.e., solve the symmetric positive definite linear 
system \\(B\boldsymbol{s}=-\boldsymbol{g}\\)
2. If \\(B\\) is indefinite or the solution to \\(B\boldsymbol{s}=-\boldysmbol{g}\\) satisfies 
\\(\|\|\boldsymbol{s}\|\|_2>\Delta\\). Then solve the nonlinear system
$$
(B+\lambda I)\boldsymbol{s} = -\boldsymbol{g}\\
\boldsymbol{s}^T\boldsymbol{s}=\Delta^2
$$

For \\(\boldsymbol{s}\\) and \\(lambda\\) using Newton's method. Complications occur
- possibly when multiple local solutions occur
- or when \\(\boldsymbol{g}\\) is close to orthogonal to the \\(\text{eigenvector}(\boldsymbol{s})\\) 
corresponding to the most negative eigenvalue of \\(B\\)

When \\(n\\) is large, factorisation to solve \\(B\boldsymbol{s}=-\boldsymbol{g}\\) may be impossible. 
However, we only need an approximate solution of TRS, so use an iterative method.

- Approximate solutions of TRS

1. Steepest descent leads to the Cauchy point \\(\boldsymbol{s}^c\\)
2. Use conjugate gradients to imporve from \\(\boldsymbol{s}^c\\)

Issues to address:

- Staying in the trust region
- Dealing with negative curvature

- Conjugate Gradients to Minimise \\(q(\boldsymbol{s})\\)

1. Initialisation: Set \\(\boldsymbol{s}^{(0)}=0, \boldsymbol{g}^{(0)}, \boldsymbol{d}^{(0)}=-\boldsymbol{g}, i=0\\)
2. Until \\(\|\|\boldsymbol{g}^{(i)}\|\|_2\\) is sufficiently small or breakdown occurs, repeat
  1. \\(\alpha^{(i)}=\frac{\|\|\boldsymbol{g}^{(i)}\|\|_2^2}{[\boldsymbol{d}^{(i)}]^TB\boldsymbol{d}^{(i)}}\\)
  2. \\(\boldsymbol{s}^{(i+1)}=\boldsymbol{s}^{(i)}+\alpha^{(i)}\boldsymbol{d}^{(i)}\\)
  3. \\(\boldsymbol{g}^{(i+1)}=\boldsymbol{g}^{(i)}+\alpha^{(i)}B\boldsymbol{d}^{(i)}\\)
  4. \\(\beta^{(i)}=\frac{\|\|\boldsymbol{g}^{(i+1)}\|\|_2^2}{\|\|\boldsymbol{g}^{(i)}\|\|_2^2}\\)
  5. \\(\boldsymbol{d}^{(i+1)}=-\boldsymbol{g}^{(i+1)}+\beta^{(i)}\boldsymbol{d}^{(i)}\\)
  6. increment \\(i\\) by \\(1\\)

Important features of conjugate gradients: 

- \\(\boldsymbol{g}^{(j)}=B\boldsymbol{s}^{(j)}+\boldsymbol{g}\\) for \\(j=0,\cdots,i\\)
- \\([\boldsymbol{d}^{(j)}]^T\boldsymbol{g}^{(i+1)}=0\\) for \\(j=0,\cdots,i\\)
- \\([\boldsymbol{g}^{(j)}]^T\boldsymbol{g}^{(i+1)}=0\\) for \\(j=0,\cdots,i\\)
- \\(\alpha^{(i)}=\arg\max_{\alpha>0} q(\boldsymbol{s}^{(i)}+\alpha\boldsymbol{d}^{(i)})\\)

- Crucial Property of CG

If \\([\boldsymbol{d}^{(i)}]^TB\boldsymbol{d}^{(i)}>0\\) for \\(0\leq i \leq k\\), then the iterates 
\\(\boldsymbol{s}^{(j)}\\) grow in \\(2\\)-norm

$$
||\boldsymbol{s}^{(j)}||_2 < ||\boldsymbol{s}^{(j+1)}||_2, (0 \leq j \leq k-1)
$$

- Truncated CG to Minimize \\(q(\boldsymbol{s})\\)

Apply CG steps in the previous algorithm, but terminate at iteration \\(i\\) if either of the following 
occurs, 

- \\([\boldsymbol{d}^{(i)}]^TB\boldsymbol{d}^{(i)}\leq 0\\) (in this case the line search \\(\min_{\alpha>0} q(\boldsymbol{s}^{(i)}+\alpha\boldsymbol{d}^{(i)})\\) is unbounded below)
- \\(\|\|\boldsymbol{s}^{(i)}+\alpha^{(i)}\boldsymbol{d}^{(i)}\|\|_2>\Delta\\) (in this case the solution lies on 
the TR boundary)

In both cases, stop with \\(\boldsymbol{s}^\*=\boldsymbol{s}^{(i)}+\alpha^B\boldsymbol{d}^{(i)}\\), where 
\\(\alpha^B\\) is chosen as the positive root of \\(\|\|\boldsymbol{s}^{(i)}+\alpha^B\boldsymbol{d}^{(i)}\|\|_2=\Delta\\)

Since the first step of the previous algorithm takes us to the Cauchy point \\(\boldsymbol{s}^{(1)}=\boldsymbol{s}^c\\), 
and all further steps are descent steps, we have

$$
q(\boldsymbol{s}^*)\leq q(\boldsymbol{s}^c) \text{ and } ||\boldsymbol{s}^*||_2 \leq \Delta
$$

Therefore, our convergence theory applies and the TR algorithm with truncated CG solves converges to a 
first-order stationary point.

When \\(q\\) is convex, the algorithm is very good.

Let \\(B\\) be positive definite and let the previous algorithm be applied to the minimisation of 
\\(q(\boldsymbol{s})\\). Let \\(\boldsymbol{s}^\*\\) be the computed solution, and let 
\\(\boldsymbol{s}^M\\) be the exact solution of the TRS, then

$$
q(\boldsymbol{s}^\*)\leq\frac{1}{2}q(\boldsymbol{s}^m)
$$

Note that \\(q(0)=0\\), so that \\(q(\boldsymbol{s}^M)\leq 0\\) and \\(\|q(\boldsymbol{s}^M)\|\\) is 
the achievable model decrease. This theorem says that at least half the achievable model decrease 
is realised.

In the non-convex case the previous algorithm may yield a poor solution with respect to the achievable 
model decrease. For example, if \\(\boldsymbol{g}=0\\) and \\(B\\) is indefinite, the \\(q(\boldsymbol{s}^\*)=0\\). 
In this case use Lanczos' method to move around trust-region boundary - effective in practice.

### Interior Point methods for Inequality constrained optimisation

#### Merit Functions

Constrained optimisation addresses two conflicting goals

- minimize the objective function \\(f(\boldsymbol{x})\\)
- satisfy the constraints

To overcome this obstacle, we minimise a composite merit function \\(\phi(\boldsymbol{x}, \boldsymbol{p})\\)

- \\(\boldsymbol{p}\\) are parameters
- (some) minimizers of \\(\phi(\boldsymbol{x}, \boldsymbol{p})\\) with respect to \\(\boldsymbol{x}\\) 
approach those of \\(f(\boldsymbol{x})\\) subject to the constraints as \\(\boldsymbol{p}\\) approaches 
a certain set \\(\mathscr{P}\\)
- we only use unconstrained minimization methods to minimise \\(\phi\\)

for example, the equality constrained problem 
\\(\min_{\boldsymbol{x}\in\mathbb{R}^n}f(\boldsymbol{x}) \text{ s.t. } c(\bodlsymbol{x})=0\\) 
can be solved using the quadratic penalty function
\\(\phi(\boldsymbol{x}, \mu)=f(\boldsymbol{x})+\frac{1}{2\mu}\|\|c(\boldsymbol{x})\|\|_2^2\\)
as a merit function.

- If \\(\boldsymbol{x}(\mu)\\) minimises \\(\phi(\boldsymbol{x}, \mu)\\), follow \\(\boldsymbol{x}(\mu)\\) as \\(\mu \rightarrow 0^+\\)
- Convergence to spurious stationary points may occur, unless safeguards are used

The log barrier function for inequality constraints

for the inequality constrained problem

$$
\min_{\boldsymbol{x}\in\mathbb{R}^n}f(\boldsymbol{x}) \text{ s.t. } c(\boldsymbol{x})\geq 0
$$

where the constraint functions \\(c\\) are such that there exist points \\(\boldsymbol{x}\\) for which 
\\(c(\boldsymbol{x})>0\\) (componentwise)

We use the logarithmic barrier function

$$
\phi(\boldsymbol{x}, \mu)=f(\boldsymbol{x})-\mu\sum_{i=1}^m\log c_i(\boldsymbol{x})
$$

as merit function

- If \\(\boldsymbol{x}(\mu)\\) minimises \\(\phi(\boldsymbol{x},\mu)\\), follow \\(\boldsymbol{x}(\mu)\\) as 
\\(\mu\rightarrow 0^+\\)
- Convergence to spurious stationary points may occur, unless safeguards are used
- All \\(\boldsymbol{x}(\mu)\\) are interior, i.e., \\(c(\boldsymbol{x}(\mu))>0\\)

- Basic Barrier Function Algorithm

1. Choose \\(\mu_0>0\\), set \\(k=0\\)
2. Until convergence, repeat
  1. find \\(\boldsymbol{x}_{\text{start}}^k\\) for which \\(c(\boldsymbol{x}_{\text{start}}^k)>0\\)
  2. starting from \\(\boldsymbol{x}_{\text{start}}^k\\) use an unconstrained minimization algorithm to find 
  an approximate minimizer \\(\boldsymbol{x}^k\\) of \\(\phi(\boldsymbol{x}, \mu_k)\\)
  3. choose \\(\mu_{k+1}\in(0, \mu_k)\\)
  4. increment \\(k\\) by \\(1\\)

Remarks

- The sequence \\((\mu_k)_{\mathbb{N}}\\) has to be chosen so that \\(\mu_k\rightarrow 0\\). often one 
chooses \\(\mu_{k+1}=0.1\mu_k\\), or even \\(\mu_{k+1}=\mu_k^2\\)
- One might choose \\(\boldsymbol{x}_{\text{start}}^k=\boldsymbol{x}^{k-1}\\), but this is often a poor choice

recall the notion of active set

$$
\mathscr{A}(\boldsymbol{x})=\{i: c_i(\boldsymbol{x})=0\}
$$

correspondingly, the inactive set is defined as 

$$
\mathscr{I}(\boldsymbol{x})=\{i: c_i(\boldsymbol{x})>0\}
$$

recall that the LICQ holds at \\(\boldsymbol{x}\\) if \\(\{\alpha_i(\boldsymbol{x}): i\in\mathscr{A}(\boldsymbol{x})\}\\) 
is linearly independent.

- Main convergence result

Let \\(f, c \in C^2\\), if the method for computing the sequences \\((\mu_k)_{\mathbb{N}}\\) and \\((\boldsymbol{x}^k)_{\mathbb{N}}\\) 
in the previous algorithm are such that \\(\Nabla_x\phi(\boldsymbol{x}^k, \mu_k)\rightarrow 0\\) and 
\\(\boldsymbol{x}^k\rightarrow\boldsymbol{x}^\*\\), and if the LICQ holds at \\(\boldsymbol{x}^\*\\), then

1. there exists a vector of Lagrange multipliers \\(\boldsymbol{y}^\*\\) such that \\((\boldsymbol{x}^\*, \boldsymbol{y}^\*)\\) 
satisfies the first order optimality conditions for problem

$$
\min_{\boldsymbol{x}\in\mathbb{R}^n}f(\boldsymbol{x}) \text{ s.t. } c(\boldsymbol{x})\geq 0
$$

2. setting \\(\boldsymbol{y}_i^k:=\frac{\mu_k}{c_i(\boldsymbol{x}^k)}\\), we have \\(\boldsymbol{y}^k \rightarrow \boldsymbol{y}^\*\\)

Algorithms to minimise \\(\phi(\boldsymbol{x},\mu)\\):

can use 

- linesearch methods
  - should use specialized linesearch to cope with singularity of log
- trust-region methods
  - need to reject points for which \\(c(\boldsymbol{x}_k+\boldsymbol{s}_k)\not\gt 0\\)
  - (ideally) need to shape trust region to cope with contours of the singularity

- Generic Barrier Newton System

The Newton correction \\(\boldsymbol{s}\\) from \\(\boldsymbol{x}\\) in the minimisation of \\(\phi\\) is 

$$
(H(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x}))+\mu A^T(\boldsymbol{x})C^{-2}(\boldsymbol{x})A(\boldsymbol{x}))\boldsymbol{s}=-g(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x}, \mu))
$$

where

- \\(C(\boldsymbol{x})=\text{Diag}(c_1(\boldsymbol{x}),\codts,c_m(\boldsymbol{x}))\\)
- \\(\boldsymbol{y}(\boldsymbol{x},\mu)=\mu C^{-1}(\boldsymbol{x})\boldsymbol{e}\\) with \\(\boldsymbol{e}=[1\cdots 1]^T\\), 
(\\(\boldsymbol{y}(\boldsymbol{x},\mu)\\) are the estimates of Lagrange multipliers)
- \\(g(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu))=g(\boldsymbol{x})-A^T(\boldsymbol{x})\boldsymbol{y}(\boldsymbol{x},\mu)\\) 
(gradient of the Lagrangian)
- \\(H(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x}))=H(\boldsymbol{x})-\sum_{i=1}^m\boldsymbol{y}_i(\boldsymbol{x},\mu)H_i(\boldsymbol{x})\\)

we also write

$$
(H(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu))+A^T(\boldsymbol{x})C^{-1}(\boldsymbol{x})Y(\boldsymbol{x},\mu)A(\boldsymbol{x}))\boldsymbol{s}=-g(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu))
$$

where \\(Y(\boldsymbol{x},\mu)=\text{Diag}(y_1(\boldsymbol{x},\mu),\cdots,y_m(\boldsymbol{x},\mu))\\), and we cal these the 
primal Newton equations.

- Perturbed Optimality conditions

Recall that the first order optimality conditions for 

$$
\min_{\boldsymbol{x}\in\mathbb{R}^n} f(\boldsymbol{x}) \text{ s.t. } c(\boldsymbol{x})\geq 0
$$

are the following

$$
g(\boldsymbol{x})-A^T(\boldsymbol{x})\boldsymbol{y}=0, \text{ dual feasibility}\\
C(\boldsymbol{x})\boldsymbol{y}=0, \text{ complementary slackness}\\
c(\boldsymbol{x}\geq 0 \text{ and } \boldsymbol{y}\geq 0
$$

For \\(\mu>0\\), let us now consider the perturbed equations

$$
g(\boldsymbol{x})-A^T(\boldsymbol{x})\boldsymbol{y}=0\\
C(\boldsymbol{x})\boldsymbol{y}=\mu\boldsymbol{e}\\
c(\boldsymbol{x})\geq 0 \text{ and } \boldsymbol{y}\geq 0
$$

- Primal Dual Path Following

Primal dual path following is based on the idea of tracking the roots of the system of equations

$$
g(\boldsymbol{x}-A^T(\boldsymbol{x})\boldsymbol{y}=0\\
C(\boldsymbol{x})\boldsymbol{y}=\mu\boldsymbol{e}
$$

whilst maintaining \\(c(\boldsymbol{x})>0\\) and \\(\boldsymbol{y}>0\\) through explicit control over the variables.

Using Newton's method to solve this nonlinear system, the correction \\((\boldsymbol{s},\boldsymbol{w})\\) to 
\\((\boldsymbol{x},\boldsymbol{y})\\) satisfies

$$
\begin{matrix}
H(\boldsymbol{x},\boldsymbol{y}) & -A^T(\boldsymbol{x})\\
YA(\boldsymbol{x}) & C(\boldsymbol{x})
\end{matrix}\begin{matrix}
\boldsymbol{s}\\
\boldsymbol{w}
\end{matrix}=-\begin{matrix}
g(\boldsymbol{x})-A^T(\boldsymbol{x})\boldsymbol{y}\\
C(\boldsymbol{x})\boldsymbol{y}-\mu\boldsymbol{e}
\end{matrix}
$$

where

$$
(H(\boldsymbol{x},\boldsymbol{y})+A^T(\boldsymbol{x})C^{-1}(\boldsymbol{x})YA(\boldsymbol{x}))\boldsymbol{s}=-(g(\boldsymbol{x})-\mu A^T(\boldsymbol{x})C(\boldsymbol{x})^{-1}\boldsymbol{e})
$$

There are called the primal-dual Newton equations.

Comparing the primal-dual Newton equations with the primal ones (obtained for the minimisation of the barrier function 
\\(\phi(\boldsymbol{x},\mu)\\), the picture is as follows: 

$$
(H(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu))+A^T(\boldsymbol{x})C^{-1}(\boldsymbol{x})Y(\boldsymbol{x},\mu)A(\boldsymbol{x}))\boldsymbol{s}_p = -g(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu)) \text{ (primal)}\\
(H(\boldsymbol{x},\boldsymbol{y})+A^T(\boldsymbol{x})C^{-1}(\boldsymbol{x})YA(\boldsymbol{x}))\boldsymbol{s}_{pd}=-g(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu)) \text{ (primal-dual)}
$$

where 

$$
\boldsymbol{y}(\boldsymbol{x},\mu) = \mu C^{-1}(\boldsymbol{x})\boldsymbol{e}
$$

The difference is that in the primal-dual equations we are free to choose the \\(\boldsymbol{y}\\) in the left-hand 
side, whereas in the primal case these are dependent variables. This difference matters.

- Primal-Dual Barrier Methods

Choose a search direction \\(\boldsymbol{s}\\) for \\(\phi(\boldsymbol{x},\mu_k)\\) by (approximately) solving the problem

$$
\min_{\boldsymbol{s}\in\mathbb{R}^n}g(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu))^T\boldsymbol{s}+\frac{1}{2}\boldsymbol{s}^T(H(\boldsymbol{x},\boldsymbol{y})+A^T(\boldsymbol{x})C^{-1}(\boldsymbol{x})YA(\boldsymbol{x}))\boldsymbol{s}
$$

possibly subject to a trust region constraint, where \\(\boldsymbol{y}(\boldsymbol{x},\mu)=\muC^{-1}(\boldsymbol{x})\boldsymbol{e}\\), 
so that \\(g(\boldsymbol{x},\boldsymbol{y}(\boldsymbol{x},\mu))=\Nabla_x\phi(\boldsymbol{x},\mu)\\)

Various possibilities for the choice of \\(\boldsymbol{y}\\)

- \\(\boldsymbol{y}=\boldsymbol{y}(\boldsymbol{x},\mu)\Rightarrow\text{ primal Newton method}\\)
- occasionally \\(\boldsymbol{y}=\frac{\mu_{k-1}}{\mu_k}\boldsymbol{y}(\boldsymbol{x},\mu_k)\Rightarrow\text{ good starting point}\\)
- \\(\boldsymbol{y}=\boldsymbol{y}_{\text{old}}+\boldsymbol{w}\\) (where \\(\boldsymbol{w}\\) is the correction to 
\\(\boldsymbol{y}_{\text{old}}\\) from the primal-dual Newton system) \\(\Rightarrow\\) primal-dual Newton method
- \\(\max\{\boldsymbol{y}_{\text{old}}+\boldsymbol{w}, \epsilon(\mu_k)\boldsymbol{e}\}\\) for small \\(\epsilon(\mu_k)>0\\) 
(e.g., \\(\epsilon(\mu_k)=\mu_k^{1.5}\\)) \\(\Rightarrow\\) practical primal-dual method

- Practical PD method

1. Choose \\(\mu_0>0\\) and a feasible \\((\boldsymbol{x}_{\text{start}}^0,\boldsymbol{y}_{\text{start}}^0)\\), and set \\(k=0\\)
2. Until convergence, repeat
  1. starting from \\((\boldsymbol{x}_{\text{start}}^k,\boldsymbol{y}_{\text{start}}^k)\\), use unconstrained minimisation to 
  find \\((\boldsymbol{x}^k,\boldsymbol{y}^k)\\) such that \\(\|\|C(\boldsymbol{x}^k)\boldsymbol{y}^k-\mu_k\boldsymbol{e}\|\|\leq\mu_k\\) and \\(\|\|g(\boldsymbol{x}^k)-A^T(\boldsymbol{x}^k)\boldsymbol{y}^k\|\|\leq\mu_k^{1.00005}\\)
  2. set \\(\mu_{k+1}=\min\{0.1\mu_k, \mu_k^{1.9999}\}\\)
  3. find \\((\boldsymbol{x}_{\text{start}}^{k+1},\boldsymbol{y}_{\text{start}}^{k+1})\\) by applying a primal-dual Newton step from 
  \\((\boldsymbol{x}^k,\boldsymbol{y}^k)\\)
  4. if \\((\boldsymbol{x}_{\text{start}}^{k+1},\boldsymbol{y}_{\text{start}}^{k+1})\\) is infeasible, reset 
  \\((\boldsymbol{x}_{\text{start}}^{k+1},\boldsymbol{y}_{\text{start}}^{k+1})\\) to \\(\boldsymbol{x}_k,\boldsymbol{y}_k)\\)
  5. increment \\(k\\) by \\(1\\)

- Fast Asymptotic Convergence of previous algorithm

Let \\(f, c \in C^2\\), if a subsequence \\(\{(\boldsymbol{x}^k,\boldsymbol{y}^k):k\in\mathbb{K}\}\\) of the iterates produced 
by the previous algorithm converges to a point \\((\boldsymbol{x}^\*,\boldsymbol{y}^\*)\\) that satisfies the second-order 
sufficient optimality conditions, where \\(A_{\mathscr{A}}(\boldsymbol{x}^\*)\\) is a full-rank matrix, and where 
\\((\boldsymbol{y}^\*)_{\mathscr{A}}>0\\), then

1. for all \\(k\in\mathbb{N}\\) large enough the point \\((\boldsymbol{x}_{\text{start}}^k,\boldsymbol{y}_{\text{start}}^k)\\) 
satisfies the termination criterion of step 2.i, so that the inner minimisation loop becomes unnecessary (the algorithm 
stays on track)
2. the entire sequence \\((\boldsymbol{x}^k,\boldsymbol{y}^k))_{\mathbb{N}}\\) converges to \\((\boldsymbol{x}^\*,\boldsymbol{y}^\*)\\)
3. convergence occurs at a superlinear rate (Q-factor \\(1.9998\\))


### Convex

- Convex Set, A convex set is defined as \\(C\subseteq\mathbb{R}^n\\) such that 
\\(\boldsymbol{x}, \boldsymbol{y} \in C \Rightarrow t\boldsymbol{x}+(1-t)\boldsymbol{y}\in C\\) for 
all \\(0 \leq t\leq 1\\). In other words, a line segment joining any two elements lies entirely in 
the set.

- Convex combination, A convex combination of \\(\boldsymbol{x}_1, \cdots, \boldsymbol{x}_k \in \mathbb{R}^n\\) 
is any linear combination: 
$$
\sum_{i=1}^k\theta_i\boldsymbol{x}_i = \theta_1\boldsymbol{x}_1 + \codts + \theta_k\boldsymbol{x}_k
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
\\(\boldsymbol{x}_0, \cdots, \boldsymbol{x}_k\\) (i.e. \\(\text{conv}\{\boldsymbol{x}_0,\cdots,\boldsymbol{x}_k\}\\)). 
Affinely independent means that \\(\boldsymbol{x}_1-\boldsymbol{x}_0, \codts, \boldsymbol{x}_k-\boldsymbol{x}_0\\) 
are linearly independent. A canonical example is the probability simplex

$$
\text{conv}\{\boldsymbol{e}_1,\cdots,\boldsymbol{e}_n\=\{\boldsymbol{w}:\boldsymbol{w}\geq 0, \boldsymbol{1}^T\boldsymbol{w}=1\}}
$$

convex cones: A cone is \\(C\in\mathbb{R}^n\\) such that \\(\boldsymbol{x}\in C\Rightarrow t\boldsymbol{x}\in C \text{ for all } t\geq 0\\)

A convex cone is a cone that is also convex \\(\boldsymbol{x}_1,\boldsymbol{x}_2\in C \Rightarrow t_1\boldsymbol{x}_1+t_2\boldsymbol{x}_2\in C \text{ for all } t_1, t_2 \geq 0\\)

A conic combination of points \\(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k\in\mathbb{R}^n\\) is, for any 
\\(\theta_i\geq 0, i=1,\cdots,k\\), any linear combination \\(\theta_1\boldsymbol{x}_1+\cdots+\theta_k\boldsymbol{x}_k\\)

A conic hull collects all conic combinations of \\(\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k\\) (or a general set \\(C\\))

$$
\text{conic}(\{\boldsymbol{x}_1,\cdots,\boldsymbol{x}_k\})=\{\theta_1\boldsymbol{x}_1+\cdots+\theta_k\boldsymbol{x}_k, \theta_i\geq 0, i=1,\cdots, k\}
$$

### convex functions

A convex function is a function \\(f:\mathbb{R}^n\rightarrow\mathbb{R}\\), such that \\(\text{dom}(f)\subseteq\mathbb{R}^n\\) 
is convex, and 

$$
f(t\boldsymbol{x}+(1-t)\boldsymbol{y})\leq tf(\boldsymbol{x})+(1-t)f(\boldsymbol{y}), \text{ for } 0\leq t\leq 1
$$

#### Operations perserving convexity

- Nonnegative linear combination

\\(f_1,\cdots,\f_m\\) convex implies \\(a_1f_1+\cdots+a_mf_m\\) convex for any \\(a_1,\cdots,a_m\geq 0\\)

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
f(\boldsymbol{x}=h(g(\boldsymbol{x}))=h(g_1(\boldsymbol{x}),\codts,\g_k(\boldsymbol{x}))
$$

where \\(g:\mathbb{R}^n\rightarrow\mathbb{R}^k,h:\mathbb{R}^k\rightarrow\mathbb{R},f:\mathbb{R}^n\rightarrow\mathbb{R}\\). Then 

- \\(f\\) in convex if \\(h\\) is convex and nondecreasing in each argument, \\(g\\) is convex
- \\(f\\) in convex if \\(h\\) is convex and nonincreasing in each argument, \\(g\\) is concave
- \\(f\\) in concave if \\(h\\) is concave and nondecreasing in each argument, \\(g\\) is concave
- \\(f\\) in concave if \\(h\\) is concave and nonincreasing in each argument, \\(g\\) is convex



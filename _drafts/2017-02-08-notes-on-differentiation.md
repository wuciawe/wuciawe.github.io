---
layout: post
category: [math]
tags: [math]
infotext: "notes on differentiations, including numerical differentiation, forward-mode differentiation, and reverse-mode differentiation"
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

When we use gradient descent methods to optimize some objective function, we need to calculate the partial derivatives of the objective 
function with respect to the parameters. There are ways to calculate those derivatives: the numerical differentiation, the forward-mode 
differentiation, and the reverse-mode differentiation (the reverse-mode automatical differentiation).

### The numerical differentiation

The formulae of the numerical differentiation is easy to get by directly applying the defination of derivative:

$$
\frac{\partial{f(x)}}{\partial{x}} = \lim_{\delta x \to 0} \frac{f(x + \delta x) - f(x)}{\delta x}
$$

As a result, we can approximate the derivative of \\(f(\vec x)\\) at \\(\vec x_0\\) with respect to \\(x_i\\) as

$$
\frac{\partial{f(\vec x)}}{\partial{x_i}} = \frac{f(\vec x_0 + \epsilon \vec e_i) - f(\vec x_0)}{\epsilon}
$$

where \\(\epsilon\\) is a small positive number, and \\(\vec e_i\\) is a unit vector in the \\(i^th\\) direction.

The ARIMA algorithm implemented in R is optimized with such method.

When there exist great amount of parameters and evaluation \\(f(x)\\) is not that cheap, this method may lead to very low efficiency, 
as it has to calculate \\(f(\vec x_0 + \epsilon \vec e_i)\\) to every parameter in every iteration, such as in the situation optimizing 
a deep neural network.

### The computational graph

Before talking about the forward-mode differentiation and the reverse-mode differentiation, I will first introduce the computational 
graph.

Let's consider the following expression:

$$
e = (a + b)(b + 1)
$$

where \\(e\\), \\(a\\), and \\(b\\) are variables. It composes the computational graph as shown below:

![the computational graph](/files/2017-02-08-notes-on-differentiation/computational_graph.png)

In the computational graph, \\(c\\) and \\(d\\) are two intermediary variables.

By assigning some values to the input variables, \\(a\\) and \\(b\\) in this example, moving with the arrows will finally give us 
the evaulated value of the expression.

#### Derivatives on the computational graph

By labelling the edges of the computational graph with the partial derivatives (with the fixed input variables), we get:

![the computational graph with derivatives](/files/2017-02-08-notes-on-differentiation/computational_graph_derivatives.png)

To understand what does this diagram mean, let's take the path \\(\frac{\partial{c}}{\partial{a}}\\) and 
\\(\frac{\partial{e}}{\partial{c}}\\) as example.

\\(\frac{\partial{c}}{\partial{a}}\\) means that a variation of \\(\delta\\) in \\(a\\) will cause a variation of 
\\(\frac{\partial{c}}{\partial{a}}\delta\\) in \\(c\\). Similar for \\(\frac{\partial{e}}{\partial{c}}\\). Chainning these together, 
we get that a variation of \\(\delta\\) in \\(a\\) will cause a variation of 
\\(\frac{\partial{e}}{\partial{c}}\frac{\partial{c}}{\partial{a}}\delta\\) in \\(e\\).

Similarly, a variation of \\(\delta\\) in \\(b\\) will cause a variation of 
\\((\frac{\partial{e}}{\partial{c}}\frac{\partial{c}}{\partial{b}} + \frac{\partial{e}}{\partial{d}}\frac{\partial{d}}{\partial{b}})\delta\\) 
in \\(c\\).

In summary, in the computational graph, the derivative of a variable \\(v_1\\) with respect to another variable \\(v_2\\) equals the 
sum of the product of all the possible paths from \\(v_2\\) to \\(v_1\\).

### The forward-mode differentiation

In the forward-mode differentiation, we calculate the relation of by changing some input variable with \\(\delta\\) will cause how much 
variation in the output variable.

![the forward-mode differentiation](/files/2017-02-08-notes-on-differentiation/forward_mode.png)

In order to compute the derivative of the output variable with respect to an input variable under current condition, we need to walk 
through all the paths from the input variable to the output variable.

In the case of gradient descent, we need to calculate the derivatives of all the parameters, which means some part of the computational 
graph will be evaluated multiple times, which is similar with the numerical differentiation. As a result, it is computational heavy.

### The reverse-mode differentiation

As its name implied, in the reverse-mode differentiation, we move backwards in the graph.

![the reverse-mode differentiation](/files/2017-02-08-notes-on-differentiation/reverse_mode.png)

Unlike the in the forward-mode applying the \\(\frac{\partial \cdot}{\partial x}\\) operator to all the nodes, it applies the 
\\(\frac{\partial x}{\partial \cdot}\\) operator to all the nodes.

As a result, we just need to pass the computational graph twice to get the gradients, one forward pass for computing the values of the 
edges in the graph, one backward pass for computing the derivatives of the output variable with respect to each nodes in the graph.

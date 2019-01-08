---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'notes on reinforcement learning, focused on approximate function solution methods, part one'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In many of the tasks, the state space of reinforcement learning is combinatorial and enormous. The 
problem with large state spaces is not just the memory needed for large tables, but the time and data 
needed to fill them accurately. In many tasks, almost every state encountered will never have been 
seen before. To make sensible decisions in such states it is necessary to generalize from previous 
encounters with different states that are in some sense similar to the current one.

### On-policy prediction with approximation

To use function approximation in estimating the state-value function from on-policy data, we 
approximate $$v_\pi$$ from value function is represented not a a table but as a parameterized 
functional form with weigth vector $$\boldsymbol{w} \in \mathbb{R}^d$$. We will write 
$$\hat{v}(s, \boldsymbol{w}) \approx v_\pi(s)$$ for the approximate value of state $$s$$ given 
weight vector $$\boldsymbol{w}$$. Typically, the number of weights (the dimensionality of 
$$\boldsymbol{w}$$) is much less than the number of states ($$d \ll |\mathcal{S}|$$), and 
changing one weight changes the estimated value of many states. Consequently, when a single 
state is updated, the change generalizes from that state to affect the values of many other 
states.

Let us refer to an individual update by the notation $$s \mapsto u$$, where $$s$$ is the state 
updated and $$u$$ is the update target that $$s$$'s estimated value is shifted toward.

In the tabular case a continuous measure of prediction quality was not necessary because the 
learned value function could come to equal the true value function exactly. Moreover, the 
learned values at each state were decoupled -- an update at one state affected no other. But 
with genuine approximation, an update at one state affects many others, and it is not possible 
to get the values of all states exactly correct.  By assumption we have far more states than 
weights, so making one state’s estimate more accurate invariably means making others’ less 
accurate. We are obligated then to say which states we care most about. We must specify a state 
weighting or distribution $$\mu(s) \geq 0$$, $$\sum_s \mu(s) = 1$$, representing how much we 
care about the error in each state $$s$$. By the error in a state $$s$$ we mean the square of 
the difference between the approximate value $$\hat{v}(s, \boldsymbol{w})$$ and the true value 
$$v_\pi(s)$$. Weighting this over the state space by $$\mu$$, we obtain a natural objective 
function, the Mean Squared Value Error, denoted $$\bar{VE}$$:

$$
\bar{VE}(\boldsymbol{w}) \doteq \sum_{s \in \mathcal{S}} \mu(s) [v_\pi(s) - \hat{v}(s, \boldsymbol{w})]^2
$$

Often $$\mu(s)$$ is chosen to be the fraction of time spent in $$s$$. Under on-policy training 
this is called the on-policy distribution.

But it is not completely clear that the $$\bar{VE}$$ is the right performance objective for 
reinforcement learning. Remember that our ultimate purpose -- the reason we are learning a value 
function -- is to find a better policy. The best value function for this purpose is not necessarily 
the best for minimizing $$\bar{VE}$$.

#### Stochastic-gradient and semi-gradient methods

SGD methods minimize error by adjusting the weight vector after each example by a small 
amount in the direction that would most reduce the error on that example:

$$
\begin{align}
\boldsymbol{w}_{t+1} &\doteq \boldsymbol{w}_t - \frac{1}{2}\alpha\nabla[v_\pi(S_t) - \hat{v}(S_t, \boldsymbol{w}_t)]^2 \\
&= \boldsymbol{w}_t + \alpha[v_\pi(S_t) - \hat{v}(S_t, \boldsymbol{w}_t)]\nabla\hat{v}(S_t, \boldsymbol{w}_t)
\end{align}
$$

where $$\alpha$$ is a positive step-size parameter, and $$\nabla f(\boldsymbol{w})$$, for any 
scalar expression $$f(\boldsymbol{w})$$, denotes the vector of partial derivatives with respect 
to the components of the weight vector.

We turn now to the case in which the target output, here denoted $$U_t \in \mathbb{R}$$, of the $$t$$th 
training example, $$S_t \mapsto U_t$$, is not the true value, $$v_\pi(S_t)$$, but some, possibly random, 
approximation to it. For example, $$U_t$$ might be a noise-corrupted version of $$v_\pi(S_t)$$, or it 
might be one of the bootstrapping targets using $$\hat{v}$$. In these cases we cannot perform the exact 
update because $$v_\pi(S_t)$$ is unknown, but we can approximate it by substituting $$U_t$$ in place of 
$$v_\pi(S_t)$$. This yields the following general SGD method for state-value prediction:

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha[U_t - \hat{v}(S_t, \boldsymbol{w}_t)]\nabla\hat{v}(S_t, \boldsymbol{w}_t)
$$

The procedure for gradient monte carlo algorithm is

$$
\begin{align}
&\text{Input: the policy } \pi \text{ to be evaluated} \\
&\text{Input: a differentiable functio: } \hat{v}: \mathcal{S} \times \mathbb{R}^d \rightarrow \mathbb{R} \\
&\text{Initialize value-function weights } \boldsymbol{w} \text{ as appropriate (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Repeat forever:} \\
&\quad\text{Generate an episode } S_0, A_0, R_1, S_1, A_1, \cdots, R_T, S_T \text{ using } \pi \\
&\quad\text{For } t = 0, 1, \cdots, T - 1: \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha[G_t - \hat{v}(S_t, \boldsymbol{w})]\nabla\hat{v}(S_t, \boldsymbol{w})
\end{align}
$$

Bootstrapping methods are not in fact instances of true gradient descent. They take into account the 
effect of changing the weight vector $$\boldsymbol{w}_t$$ on the estimate, but ignore its effect on 
the target. They include only a part of the gradient and we call them semi-gradient methods.

The procedure for semi-gradient TD(0) is

$$
\begin{align}
&\text{Input: the policy } \pi \text{ to be evaluated} \\
&\text{Input: a differentiable function: }\hat{v}: \mathcal{S}^+ \times \mathbb{R}^d \rightarrow \mathbb{R} \text{ such that } \hat{v}(terminal, \cdot) = 0 \\
&\text{Initialize value-function weights } \boldsymbol{w} \text{ arbitrarily (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Repeat (for each episode):} \\
&\quad\text{Initialize } S \\
&\quad\text{Repeat (for each step of episode):} \\
&\qquad\text{Choose } A \sim \pi(\cdot|S) \\
&\qquad\text{Take action } A \text{, observe } R, S' \\
&\qquad\boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha[R + \gamma\hat{v}(S', \boldsymbol{w}) - \hat{v}(S, \boldsymbol{w})]\nabla\hat{v}(S, \boldsymbol{w}) \\
&\qquad S \leftarrow S' \\
&\quad \text{until } S' \text{ is terminal}
\end{align}
$$

#### ANN

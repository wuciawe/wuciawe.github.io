---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'notes on reinforcement learning, focused on approximate function solution methods, part two'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Eligibility traces

Eligibility traces unify and generalize TD and Monte Carlo methods. When TD methods are augmented 
with eligibility traces, they produce a family of methods spanning a spectrum that has Monte Carlo 
methods at one end ($$\lambda = 1$$) and one-step TD methods at the other ($$\lambda = 0$$). In 
between are intermediate methods that are often better than either extreme method. Eligibility traces 
also provide a way of implementing Monte Carlo methods online and on continuing problems without episodes.

Eligibility traces achieve significant computational advantages with the mechanism that is a 
short-term memory vector, the eligibility trace $$\boldsymbol{z}_t \in \mathbb{R}^d$$, that parallels 
the long-term weight vector $$\boldsymbol{w}_t \in \mathbb{R}^d$$. The rough idea is that when a 
component of $$\boldsymbol{w}_t$$ participates in producing an estimated value, then the corresponding 
component of $$\boldsymbol{z}_t$$ is bumped up and then begins to fade away. Learning will then occur 
in that component of $$\boldsymbol{w}_t$$ if a nonzero TD error occurs before the trace falls back to 
zero. The trace-decay parameter $$\lambda \in [0, 1]$$ determines the rate at which the trace falls.

The primary computational advantage of eligibility traces over n-step methods is that only a single 
trace vector is required rather than a store of the last n feature vectors. Learning also occurs 
continually and uniformly in time rather than being delayed and then catching up at the end of the 
episode. In addition learning can occur and affect behavior immediately after a state is encountered 
rather than being delayed n steps.

#### The $$\lambda$$-return

The n-step return is defined as the sum of the first n rewards plus the estimated value of the 
state reached in n steps, each appropriately discounted

$$
G_{t:t+n} \doteq R_{t+1} + \gamma R_{t+2} + \cdots + \gamma^{n-1}R_{t+n} + \gamma^n\hat{v}(S_{t+n, \boldsymbol{w}_{t + n - 1}}), 0 \leq t \leq T - n
$$

The $$TD(\lambda)$$ algorithm can be understood as one particular way of averaging n-step updates. 
The resulting update is toward a return, called the $$\lambda$$-return, defined in its state-based 
form by

$$
G_t^\lambda \doteq (1 - \lambda)\sum_{n=1}^\infty \lambda^{n-1}G_{t:t+n}
$$

In the off-line $$\lambda$$-return algorithm, it makes no changes to the weight vector during the 
episode. At the end of the episode, a whole sequence of off-line updates are made according to 
the usual semi-gradient rule, using the $$\lambda$$-return as the target

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha[G_t^\lambda - \hat{v](S_t, \boldsymbol{w}_t)]\nabla\hat{v}(S_t, \boldsymbol{w}), t = 0, \cdots, T - 1
$$

In the forward view of a learning algorithm, for each state visited, we look forward in time to all the 
future rewards and decide how best to combine them.

#### $$TD(\lambda)$$

$$TD(\lambda)$$ improves over the off-line $$\lambda$$-return algorithm in three ways. First it updates the 
weight vector on every step of an episode rather than only at the end, and thus its estimates may be better 
sooner. Second, its computations are equally distributed in time rather that all at the end of the episode. 
And third, it can be applied to continuing problems rather than just episodic problems.

With function approximation, the eligibility trace is a vector $$\boldsymbol{z}_t \in \mathbb{R}^d$$ with the 
same number of components as the weight vector $$\boldsymbol{w}_t$$. Whereas the weight vector is a long-term 
memory, accumulating over the lifetime of the system, the eligibility trace is a short-term memory, typically 
lasting less time than the length of an episode. Eligibility traces assist in the learning process; their only 
consequence is that they affect the weight vector, and then the weight vector determines the estimated value.

In $$TD(\lambda)$$, the eligibility trace vector is initialized to zero at the beginning of the episode, is 
incremented on each time step by the value gradient, and then fades away by $$\gamma\lambda$$:

$$
\begin{align}
&\boldsymbol{z}_{-1} \doteq \boldsymbol{0} \\
&\boldsymbol{z}_t \doteq \gamma\lambda\boldsymbol{z}_{t-1} + \nabla\hat{v}(S_t, \boldsymbol{w}_t), 0 \leq t \leq T
\end{align}
$$

where $$\gamma$$ is the discount rate and $$\lambda$$ is the parameter introduced in $$\lambda$$-return. The 
eligibility trace keeps track of which components of the weight vector have contributed, positively or negatively, 
to recent state valuations, where “recent” is defined in terms $$\gamma\lambda$$. The trace is said to indicate 
the eligibility of each component of the weight vector for undergoing learning changes should a reinforcing 
event occur. The reinforcing events we are concerned with are the moment-by-moment one-step TD errors. The TD 
error for state-value prediction is

$$
\delta_t \doteq R_{t+1} + \gamma\hat{v}(S_{t+1}, \boldsymbol{w}_t) - \hat{v}(S_t, \boldsymbol{w}_t)
$$

In $$TD(\lambda)$$, the weight vector is updated on each step proportional to the scalar TD error and the vector 
eligibility trace:

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha\delta_t\boldsymbol{z}_t
$$

The procedure for Semi-gradient $$TD(\lambda)$$ is

$$
\begin{align}
&\text{Input: the policy } \pi \text{ to be evaluated} \\
&\text{Input: a differentiable function } \hat{v}: \mathcal{S}^+ \times \mathbb{R}^d \rightarrow \mathbb{R} \text{ such that } \hat{v}(terminal, \cdot) = 0 \\
&\text{Initialize value-function weights } \boldsymbol{w} \text{ arbitrarily (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize } S \\
&\quad \boldsymbol{z} \leftarrow 0 \\
&\quad \text{Repeat (for each step of episode):} \\
&\qquad \text{Choose } A \sim \pi(\cdot | S) \\
&\qquad \text{Take action } A \text{, observe } R, S' \\
&\qquad \boldsymbol{z} \leftarrow \gamma\lambda\boldsymbol{z} + \nabla\hat{v}(S, \boldsymbol{w}) \\
&\qquad \delta \leftarrow R + \gamma\hat{v}(S', \boldsymbol{w}) - \hat{v}(S, \boldsymbol{w}) \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha\delta\boldsymbol{z} \\
&\qquad S \leftarrow S' \\
&\quad \text{until } S' \text{ is terminal}
\end{align}
$$

$$TD(\lambda)$$ is oriented backward in time. At each moment we look at the current TD error and assign it 
backward to each prior state according to how much that state contributed to the current eligibility trace 
at that time.

#### True online $$TD(\lambda)$$

The n-step truncated $$\lambda$$-return is defined by

$$
G_{t:h}^\lambda \doteq (1-\lambda)\sum_{n=1}^{h-t-1}\lambda^{n-1}G_{t:t+n} + \lambda^{h-t-1}G_{t:h}
$$

The truncated $$TD(\lambda)$$ is defined by

$$
\boldsymbol{w}_{t+n} \doteq \boldsymbol{w}_{t+n-1} + \alpha[G_{t:t+n}^\lambda - \hat{v}(S_t, \boldsymbol{w}_{t+n-1})]\nabla\hat{v}(S_t, \boldsymbol{t+n-1}), 0 \leq t \lt T
$$

Choosing the truncation parameter $$n$$ in Truncated $$TD(\lambda)$$ involves a tradeoff. $$n$$ should be large 
so that the method closely approximates the off-line $$\lambda$$-return algorithm, but it should also be small 
so that the updates can be made sooner and can influence behavior sooner. To get the best of both, on each time 
step as you gather a new increment of data, you go back and redo all the updates since the beginning of the 
current episode. The new updates will be better than the ones you previously made because now they can take into 
account the time step’s new data. That is, the updates are always towards an n-step truncated $$\lambda$$-return 
target, but they always use the latest horizon.

This algorithm involves multiple passes over the episode, one at each horizon, each generating a different 
sequence of weight vectors. The general form for the update is

$$
\boldsymbol{w}_{t+1}^h \doteq \boldsymbol{w}_t^h + \alpha[G_{t:h}^\lambda - \hat{v}(S_t, \boldsymbol{w}_t^h)]\nabla\hat{v}(S_t, \boldsymbol{w}_t^h), 0 \leq t \lt h \leq T
$$

This update, together with $$\boldsymbol{w}_t \doteq \boldsymbol{w}_t^t$$ defines the online $$\lambda$$-return 
algorithm. The online $$\lambda$$-return algorithm is fully online, determining a new weight vector 
$$\boldsymbol{w}_t$$ at each step $$t$$ during an episode, using only information available at time $$t$$. It’s 
main drawback is that it is computationally complex, passing over the entire episode so far on every step.

The on-line $$\lambda$$-return algorithm just presented is currently the best performing temporal-difference 
algorithm. It is an ideal which online $$TD(\lambda)$$ only approximates. However, the on-line $$λ$$-return 
algorithm is very complex.

The true online $$TD(\lambda)$$ algorithm is 

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha\delta_t\boldsymbol{z}_t + \alpha(\boldsymbol{w}_t^T\boldsymbol{x}_t - \boldsymbol{w}_{t-1}^T\boldsymbol{x}_t)(\boldsymbol{z}_t - \boldsymbol{x}_t)
$$

where we use the shorthand $$\boldsymbol{x}_t \doteq \boldsymbol{x}(S_t)$$, $$\delta_t$$ is defined as in 
$$TD(\lambda)$$, and $$\boldsymbol{z}_t$$ is defined by

$$
\boldsymbol{z}_t \doteq \gamma\lambda\boldsymbol{z}_{t-1} + (1-\alpha\gamma\lambda\boldsymbol{z}_{t-1}^T\boldsymbol{x}_t)\boldsymbol{x}_t
$$




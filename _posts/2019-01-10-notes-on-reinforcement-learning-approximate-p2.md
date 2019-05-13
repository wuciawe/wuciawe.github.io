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
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha[G_t^\lambda - \hat{v}(S_t, \boldsymbol{w}_t)]\nabla\hat{v}(S_t, \boldsymbol{w}), t = 0, \cdots, T - 1
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
\boldsymbol{w}_{t+n} \doteq \boldsymbol{w}_{t+n-1} + \alpha[G_{t:t+n}^\lambda - \hat{v}(S_t, \boldsymbol{w}_{t+n-1})]\nabla\hat{v}(S_t, \boldsymbol{w}_{t+n-1}), 0 \leq t \lt T
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

This algorithm has been proven to produce exactly the same sequence of weight vectors, 
$$\boldsymbol{w}_t, 0 \leq t \leq T$$, as the on-line $$\lambda$$-return algorithm.

$$
\begin{align}
&\text{Input: the policy } \pi \text{ to be evaluated} \\
&\text{Initialize value-function weights } \boldsymbol{w} \text{ arbitrarily (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize state and obtain initial feature vector } \boldsymbol{x} \\
&\quad \boldsymbol{z} \leftarrow 0 \\
&\quad V_{old} \leftarrow 0 \\
&\quad \text{Repeat (for each step of episode):} \\
&\qquad \text{Choose } A \sim \pi \\
&\qquad \text{Take action } A\text{, observe } R, \boldsymbol{x}' \text{ (feature vector of the next state)} \\
&\qquad V \leftarrow \boldsymbol{w}^T\boldsymbol{x} \\
&\qquad V' \leftarrow \boldsymbol{w}^T\boldsymbol{x}' \\
&\qquad \delta \leftarrow R + \gamma V' - V \\
&\qquad \boldsymbol{z} \leftarrow \gamma\lambda\boldsymbol{z} + (1 - \alpha\gamma\lambda\boldsymbol{z}^T\boldsymbol{x})\boldsymbol{x} \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha(\delta + V - V_{old})\boldsymbol{z} - \alpha(V - V_{old})\boldsymbol{x} \\
&\qquad V_{old} \leftarrow V' \\
&\qquad \boldsymbol{x} \leftarrow \boldsymbol{x}' \\
&\quad \boldsymbol{x}' = 0 \text{ (signaling arrival at a terminal state)}
\end{align}
$$

The eligibility trace used in true online $$TD(\lambda)$$ is called a dutch trace to distinguish it from the 
trace used in $$TD(\lambda)$$, which is called an accumulating trace. Earlier work often used a third kind of 
trace called the replacing trace which is deprecated now.

#### $$SARSA(\lambda)$$

Very few changes are required in order to extend eligibility traces to action-value methods. To learn 
approximate action values, $$\hat{q}(s,a,\boldsymbol{w})$$, rather than approximate state values, 
$$\hat{v}(s,\boldsymbol{w})$$, we need to use the action-value form of the n-step return

$$
G_{t:t+n} \doteq R_{t+1} + \cdots + \gamma^{n-1}R_{t+n} + \gamma^n\hat{q}(S_{t+n}, A_{t+n}, \boldsymbol{w}_{t+n-1})
$$

for all $$n$$ and $$t$$ such that $$n \geq 1$$ and $$0 \leq t \lt T - n$$. The action-value form of the off-line 
$$\lambda$$-return algorithm simply uses $$\hat{q}$$ rather than $$\hat{v}$$:

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha[G_t^\lambda - \hat{q}(S_t, A_t\boldsymbol{w}_t)]\nabla\hat{q}(S_t, A_t, \boldsymbol{w}_t), t = 0, \cdots, T - 1
$$

where $$G_t^\lambda \doteq G_{t:\infty}^\lambda$$.

The temporal-difference method for action values, known as $$SARSA(\lambda)$$, approximates this forward view. 
It has the same update rule as given for $$TD(\lambda)$$

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha\delta_t\boldsymbol{z}_t
$$

except using the action-value form of the TD error

$$
\delta_t \doteq R_{t+1} + \gamma \hat{q}(S_{t+1}, A_{t+1}, \boldsymbol{w}_t) - \hat{q}(S_t, A_t, \boldsymbol{w}_t)
$$

and the action-value form of the eligibility trace

$$
\begin{align}
&\boldsymbol{z}_{-1} \doteq 0, \\
&\boldsymbol{z}_t \doteq \gamma\lambda\boldsymbol{z}_{t-1} + \nabla\hat{q}(S_t, A_t, \boldsymbol{w}_t), 0 \leq t \leq T
\end{align}
$$

The procedure for $$SARSA(\lambda)$$ with binary features and linear function approximation is 

$$
\begin{align}
&\text{Input: a function } \mathcal{F}(s, a) \text{ returning the set of (indicies of) active features for } s, a \\
&\text{Input: a policy } \pi \text{ to be evaluated, if any} \\
&\text{Initialize parameter vector } \boldsymbol{w} = (w_1, \cdots, w_n) \text{ arbitrarily (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Loop for each episode:} \\
&\quad \text{Initialize } S \\
&\quad \text{Choose } A \sim \pi(\cdot | S) \text{ or } \epsilon\text{-greedy according to } \hat{q}(S, \cdot, \boldsymbol{w}) \\
&\quad \boldsymbol{z} \leftarrow 0 \\
&\quad \text{Loop for each step of episode:} \\
&\qquad \text{Take action } A \text{, observe } R, S' \\
&\qquad \delta \leftarrow R \\
&\qquad \text{Loop for } i \text{ in } \mathcal{F}(S, A): \\
&\qquad\quad \delta \leftarrow \delta - w_i \\
&\qquad\quad z_i \leftarrow z_i + 1 \text{ (accumulating traces)} \\
&\qquad\quad \text{or } z_i \leftarrow 1 \text{ (replacing traces)} \\
&\qquad \text{If } S' \text{ is terminal then:} \\
&\qquad\quad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha\delta\boldsymbol{z} \\
&\qquad\quad \text{Go to next episode} \\
&\qquad \text{Choose } A' \sim \pi(\cdot| S') \text{ or near greedily } \sim \hat{q}(S', \cdot, \boldsymbol{w}) \\
&\qquad \text{Loop for } i \text{ in } \mathcal{F}(S', A'): \delta \leftarrow \delta + \gamma w_i \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha\delta\boldsymbol{z} \\
&\qquad \boldsymbol{z} \leftarrow \gamma\lambda\boldsymbol{z} \\
&\qquad S \leftarrow S'; A \leftarrow A'
\end{align}
$$

The procedure for true online $$SARSA(\lambda)$$ is

$$
\begin{align}
&\text{Input: a feature function } \boldsymbol{x}: \mathcal{S}^+ \times \mathcal{A} \rightarrow \mathbb{R}^d \text{ s.t. } \boldsymbol{x}(terminal, \cdot) = 0 \\
&\text{Input: the policy } \pi \text{ to be evaluated, if any} \\
&\text{Initialize parameter } \boldsymbol{w} \text{ arbitrarily (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Loop for each episode:} \\
&\quad \text{Initialize } S \\
&\quad \text{Choose } A \sim \pi(\cdot|S) \text{ or near greedily from } S \text{ using } \boldsymbol{w} \\
&\quad \boldsymbol{x} \leftarrow \boldsymbol{x}(S, A) \\
&\quad \boldsymbol{z} \leftarrow 0 \\
&\quad Q_{old} \leftarrow 0 \\
&\quad \text{Loop for each step of episode:} \\
&\qquad \text{Take action } A\text{, observe } R, S' \\
&\qquad \text{Choose } A' \sim \pi(\cdot|S') \text{ or near greedily from } S' \text{ using } \boldsymbol{w} \\
&\qquad \boldsymbol{x}' \leftarrow \boldsymbol{x}(S', A') \\
&\qquad Q \leftarrow \boldsymbol{w}^T\boldsymbol{x} \\
&\qquad Q' \leftarrow \boldsymbol{w}^T\boldsymbol{x}' \\
&\qquad \delta \leftarrow R + \gamma Q' - Q \\
&\qquad \boldsymbol{z} \leftarrow \gamma\lambda\boldsymbol{z} + (1 - \alpha\gamma\lambda\boldsymbol{z}^T\boldsymbol{x})\boldsymbol{x} \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha(\delta + Q - Q_{old})\boldsymbol{z} - \alpha(Q - Q_{old})\boldsymbol{x} \\
&\qquad Q_{old} \leftarrow Q' \\
&\qquad \boldsymbol{x} \leftarrow \boldsymbol{x}' \\
&\qquad A \leftarrow A' \\
&\quad \text{until } S' \text{ is terminal}
\end{align}
$$

#### Off-policy eligibility traces

Unlike in the case of n-step methods, for full non-truncated $$\lambda$$-returns one does not have a 
practical option in which the importance sampling is done outside the target return. Instead, we move 
directly to the bootstrapping generalization of per-reward importance sampling. In the state case, our 
final definition of the $$λ$$-return generalizes to

$$
G_{t}^{\lambda_s} \doteq \rho\left(R_{t+1} + \gamma_{t+1}((1-\lambda_{t+1})\hat{v}S(S_{t+1},\boldsymbol{w}_t) + \lambda_{t+1}G_{t+1}^{\lambda_s})\right) + (1 - \rho_t)\hat{v}(S_t, \boldsymbol{w}_t)
$$

where $$\rho = \frac{\pi(A_t|S_t)}{b(A_t|S_t)}$$ is the usual single-step importance sampling ratio. The 
truncated version of this return can be approximated simply in terms of sums of the state-based TD error, 

$$
\delta_t^s = R_{t+1} + \gamma_{t+1}\hat{v}(S_{t+1}, \boldsymbol{w}_t) - \hat{v}(S_t, \boldsymbol{w}_t)
$$

as

$$
G_t^{\lambda_s} \approx \hat{v}(S_t, \boldsymbol{w}_t) + \rho_t \sum_{k=t}^\infty\delta_k^s\sum_{i=t+1}^k\gamma_i\lambda_i\rho_i
$$

with the approximation becoming exact if the approximate value function does not change.

The above form of the $$\lambda$$-return is convenient to use in a forward-view update

$$
\begin{align}
\boldsymbol{w}_{t+1} &= \boldsymbol{w}_t + \alpha(G_t^{\lambda_s} - \hat{v}(S_t, \boldsymbol{w}_t))\nabla\hat{v}(S_t, \boldsymbol{w}_t) \\
&\approx \boldsymbol{w}_t + \alpha\rho_t\left(\sum_{k=t}^\infty\delta_k^s\prod_{i=t+1}^k\gamma_i\lambda_i\rho_i\right)\nabla\hat{v}(S_t, \boldsymbol{w}_t)
\end{align}
$$

which looks like an eligibility-based TD update -- the product is like an eligibility trace and it is multiplied 
by TD errors. But this is just one time step of a forward view. The relationship that we are looking for is that 
the forward-view update, summed over time, is approximately equal to a backward-view update, summed over time. 
The sum of he forward-view update over time is

$$
\begin{align}
\sum_{t=1}^\infty(\boldsymbol{w}_{t+1} - \boldsymbol{w}_t) &\approx \sum_{t=1}^\infty\sum_{k=t}^\infty\alpha\rho_t\delta_k^s\nabla\hat{v}(S_t, \boldsymbol{w}_t)\prod_{i=t+1}^k\gamma_i\lambda_i\rho_i \\
&= \sum_{k=1}^\infty\sum_{t=1}^k\alpha\rho_t\nabla\hat{v}(S_t, \boldsymbol{w}_t)\delta_k^s\prod_{i=t+1}^k\gamma_i\lambda_i\rho_i \\
&= \sum_{k=1}^\infty\alpha\delta_k^s\sum_{t=1}^k\rho_t\nabla\hat{v}(S_t, \boldsymbol{w}_t)\prod_{i=t+1}^k\gamma_i\lambda_i\rho_i
\end{align}
$$

which would be in the form of the sum of a backward-view TD update if the entire expression from the second sum left 
could be written and updated incrementally as an eligibility trace, which we now show can be done. That is, we show 
that if this expression was the trace at time $$k$$, then we could update it from its value at time $$k − 1$$ by:

$$
\begin{align}
\boldsymbol{z}_k &= \sum_{t=1}^k\rho_t\nabla\hat{v}(S_t, \boldsymbol{w}_t)\prod_{i=t+1}^k\gamma_i\lambda_i\rho_i \\
&= \sum_{t=1}^{k-1}\rho_t\nabla\hat{v}(S_t, \boldsymbol{w}_t)\prod_{i=t+1}^k\gamma_i\lambda_i\rho_i + \rho_k\nabla\hat{v}(S_k, \boldsymbol{w}_k) \\
&= \gamma_k\lambda_k\rho_k\sum_{t=1}^{k-1}\rho_t\nabla\hat{v}(S_t, \boldsymbol{w}_t)\prod_{i=t+1}^{k-1}\gamma_i\lambda_i\rho_i + \rho_k\nabla\hat{v}(S_k, \boldsymbol{w}_k) \\
&= \rho_k(\gamma_k\lambda_k\boldsymbol{z}_{k-1} + \nabla\hat{v}(S_k, \boldsymbol{w}_k))
\end{align}
$$

which, changing the index from $$k$$ to $$t$$, is the general accumulating trace update for state values

$$
\boldsymbol{z}_t \doteq \rho_t(\gamma_t\lambda_t\boldsymbol{z}_{t-1} + \nabla\hat{v}(S_t, \boldsymbol{w}_t))
$$

A very similar series of steps can be followed to derive the off-policy eligibility traces for action-value methods 
and corresponding general $$SARSA(\lambda)$$ algorithms.

#### When to use eligibility traces

Methods using eligibility traces require more computation than one-step methods, but in return they offer significantly 
faster learning, particularly when rewards are delayed by many steps. Thus it often makes sense to use eligibility 
traces when data are scare and cannot be repeatedly processed, as is often the case in on-line applications. On the 
other hand, in off-line applications in which data can be generated cheaply, perhaps from an inexpensive simulation, 
then it often does not pay to use eligibility traces. In these cases the objective is not to get more out of a limited 
amount of data, but simply to process as much data as possible as quickly as possible. In these cases the speedup 
per datum due to traces is typically not worth their computational cost, and one-step methods are favoured.

### Policy gradient methods

We consider methods that learn a parameterized policy that can select actions 
without consulting a value function. A value function may still be used to learn 
the policy parameter, but is not required for action selection. We use the 
notation $$\boldsymbol{\theta} \in \mathbb{R}^{d'}$$ for the policy's parameter 
vector. Thus we write $$\pi(a|s,\boldsymbol{\theta}) = \text{Pr}\{A_t=a|S_t=s,\boldsymbol{\theta}_t=\boldsymbol{\theta}\}$$ 
for the probability that action $$a$$ is taken given that the environment is in 
state $$s$$ at time $$t$$ with parameter $$\boldsymbol{\theta}$$. If a method 
uses a learned value function as well, then the value function's weight vector 
is denoted $$\boldsymbol{w} \in \mathbb{R}^d$$ as usual, as in $$\hat{v}(s, \boldsymbol{w})$$.

Consider methods for learning the policy parameter based on the gradient of some 
performance measure $$\mathcal{J}(\boldsymbol{\theta})$$ with respect to the 
policy parameter. These methods seek to maximize performance, so their udpates 
approximate gradient ascent in $$\mathcal{J}$$

$$
\boldsymbol{\theta}_{t+1} = \boldsymbol{\theta}_t + \alpha\hat{\nabla\mathcal{J}(\boldsymbol{\theta})}
$$

where $$\hat{\nabla\mathcal{J}(\boldsymbol{\theta})}$$ is a stochastic estimate 
whose expectation approximates the gradient of the performance measure with respect 
to its argument $$\boldsymbol{\theta}_t$$ . All methods that follow this general 
schema we call policy gradient methods, whether or not they also learn an approximate 
value function. Methods that learn approximations to both policy and value functions 
are often called actor–critic methods, where 'actor' is a reference to the learned 
policy, and 'critic' refers to the learned value function, usually a state-value 
function.

#### Policy approximation

In policy gradient methods, the policy can be parameterized in any way, as long 
as $$\pi(a|s,\boldsymbol{\theta})$$ is differentiable with respect to its 
parameters, that is, as long as $$\nabla_{\boldsymbol{\theta}}\pi(a|s,\boldsymbol{\theta})$$ 
exists and is always finite. In practice, to ensure exploration we generally 
require that the policy never becomes deterministic (i.e., that $$\pi(a|s,\boldsymbol{\theta}) \in (0, 1)$$) 
for all $$s, a, \boldsymbol{\theta}$$.

If the action space is discrete and not too large, then a natural kind of parameterization 
is to form parameterized numerical preferences $$h(s,a,\boldsymbol{\theta}) \in \mathbb{R}$$ 
for each state–action pair. The actions with the highest preferences in each state are given 
the highest probabilities of being selected, for example, according to an exponential softmax distribution:

$$
\pi(a|s,\boldsymbol{\theta}) = \frac{\exp(h(s,a,\boldsymbol{\theta}))}{\sum_b\exp(h(s,b,\boldsymbol{\theta}))}
$$

The preferences themselves can be parameterized arbitrarily. For example, they might be computed 
by a deep neural network, where $$\boldsymbol{\theta}$$ is the vector of all the connection 
weights of the network.

An immediate advantage of selecting actions according to the softmax in action preferences is 
that the approximate policy can approach a deterministic policy, whereas with $$\epsilon$$-greedy action 
selection over action values there is always an $$\epsilon$$ probability of selecting a random 
action. Of course, one could select according to a softmax over action values, but this alone 
would not allow the policy to approach a deterministic policy. Instead, the action-value estimates 
would converge to their corresponding true values, which would differ by a finite amount, 
translating to specific probabilities other than 0 and 1. If the softmax included a temperature 
parameter, then the temperature could be reduced over time to approach determinism, but in 
practice it would be difficult to choose the reduction schedule, or even the initial temperature, 
without more prior knowledge of the true action values than we would like to assume. Action 
preferences are different because they do not approach specific values; instead they are driven 
to produce the optimal stochastic policy. If the optimal policy is deterministic, then the 
preferences of the optimal actions will be driven infinitely higher than all suboptimal actions 
(if permited by the parameterization).

In problems with significant function approximation, the best approximate policy may be stochastic. 
Action-value methods have no natural way of finding stochastic optimal policies, whereas policy 
approximating methods can. This is a second significant advantage of policy-based methods.

Perhaps the simplest advantage that policy parameterization may have over action-value 
parameterization is that the policy may be a simpler function to approximate. Problems vary in the 
complexity of their policies and action-value functions. For some, the action-value function is 
simpler and thus easier to approximate. For others, the policy is simpler.

Finally, we note that the choice of policy parameterization is sometimes a good way of injecting prior 
knowledge about the desired form of the policy into the reinforcement learning system. This is often 
the most important reason for using a policy-based learning method.

#### The policy gradient theorem

In addition to the practical advantages of policy parameterization over $$\epsilon$$-greedy action selection, 
there is also an important theoretical advantage. With continuous policy parameterization the 
action probabilities change smoothly as a function of the learned parameter, whereas in 
$$\epsilon$$-greedy selection the action probabilities may change dramatically for an arbitrarily 
small change in the estimated action values, if that change results in a different action having 
the maximal value. Largely because of this stronger convergence guarantees are available for 
policy-gradient methods than for action-value methods. In particular, it is the continuity of 
the policy dependence on the parameters that enables policy-gradient methods to approximate 
gradient ascent.

The episodic and continuing cases define the performance measure, 
$$\mathcal{J}(\boldsymbol{\theta})$$, differently and thus have to be treated separately to some 
extent. In the episodic case we define performance as

$$
\mathcal{J}(\boldsymbol{\theta}) \doteq v_{\pi_{\boldsymbol{\theta}}}(s_0)
$$

where $$v_{\pi_{\boldsymbol{\theta}}}$$ is the true value function for 
$$\pi_{\boldsymbol{\theta}}$$, the policy determined by $$\boldsymbol{\theta}$$.

With function approximation, it may seem challenging to change the policy parameter in a way that 
ensures improvement. The problem is that performance depends on both the action selections and the 
distribution of states in which those selections are made, and that both of these are affected by 
the policy parameter. Given a state, the effect of the policy parameter on the actions, and thus 
on reward, can be computed in a relatively straightforward way from knowledge of the 
parameterization. But the effect of the policy on the state distribution is a function of the 
environment and is typically unknown.

The policy gradient theorem provides us an analytic expression for the gradient of performance 
with respect to the policy parameter that does not involve the derivative of the state 
distribution. The policy gradient theorem establishes that

$$
\nabla\mathcal{J}(\boldsymbol{\theta}) \propto \sum_s \mu(s) \sum_a q_\pi(s, a) \nabla_{\boldsymbol{\theta}} \pi(a|s, \boldsymbol{\theta})
$$

where the gradients are column vectors of partial derivatives with respect to the components of 
$$\boldsymbol{\theta}$$, and $$\pi$$ denotes the policy corresponding to parameter vector 
$$\boldsymbol{\theta}$$.  In the episodic case, the constant of proportionality is the average 
length of an episode, and in the continuing case it is 1, so that the relationship is actually 
an equality. The distribution $$\mu$$ here is the on-policy distribution under $$\pi$$.

#### REINFORCE: Monte Carlo policy gradient

$$
\begin{align}
&\text{Input: a differentiable policy parameterization } \pi(a|s, \boldsymbol{\theta}) \\
&\text{Initialize policy parameter } \boldsymbol{\theta} \in \mathbb{R}^{d'} \\
&\text{Repeat forever:} \\
&\quad \text{Generate an episode } S_0, A_0, R_1, \cdots, S_{T-1}, A_{T-1}, R_T, \text{ following } \pi(\cdot | \cdot, \boldsymbol{\theta}) \\
&\quad \text{For each step of the episode } t = 0, \cdots, T-1: \\
&\qquad G \leftarrow \text{ return from step } t \\
&\qquad \boldsymbol{\theta} \leftarrow \boldsymbol{\theta} + \alpha\gamma^t G\nabla_{\boldsymbol{\theta}} \ln \pi(A_t|S_t, \boldsymbol{\theta})
\end{align}
$$

Its update has an intuitive appeal. Each increment is proportional to the product of a 
return $$G_t$$ and a vector, the gradient of the probability of taking the action actually 
taken divided by the probability of taking that action. The vector is the direction in 
parameter space that most increases the probability of repeating the action $$A_t$$ on future 
visits to state $$S_t$$. The update increases the parameter vector in this direction 
proportional to the return, and inversely proportional to the action probability. The former 
makes sense because it causes the parameter to move most in the directions that favor actions 
that yield the highest return. The latter makes sense because otherwise actions that are 
selected frequently are at an advantage (the updates will be more often in their direction) 
and might win out even if they do not yield the highest return.

The vector $$\ln \pi(A_t|S_t, \boldsymbol{\theta}) = \frac{\nabla_{\boldsymbol{\theta}}\pi(A_t|S_t, \boldsymbol{\theta}_t)}{\pi(A_t|S_t, \boldsymbol{\theta}_t)}$$ in the REINFORCE update is 
the only place the policy parameterization appears in the algorithm. This vector has been 
given several names and notations in the literature; we will refer to it simply as the 
eligibility vector.

#### REINFORCE with baseline

The policy gradient theorem can be generalized to include a comparison of the action value 
to an arbitrary baseline $$b(s)$$:

$$
\nabla\mathcal{J}(\boldsymbol{\theta}) \propto \sum_s \mu(s) \sum_a \left(q_\pi(s,a) - b(s)\right)\nabla_{\boldsymbol{\theta}}\pi(a|s, \boldsymbol{\theta})
$$

The baseline can be any function, even a random variable, as long as it does not vary with 
$$a$$. The policy gradient theorem with baseline can be used to derive an update rule using 
similar steps. The update rule that we end up with is a new version of REINFORCE that 
includes a general baseline:

$$
\boldsymbol{\theta}_{t+1} \doteq \boldsymbol{\theta}_t + \alpha\left(G_t - b(S_t)\right)\frac{\nabla_{\boldsymbol{\theta}}\pi(A_t|S_t,\boldsymbol{\theta}_t)}{\pi(A_t|S_t,\boldsymbol{\theta}_t)}
$$

For MDPs the baseline should vary with state. In some states all actions have high values 
and we need a high baseline to differentiate the higher valued actions from the less highly 
valued ones; in other states all actions will have low values and a low baseline is appropriate.

One natural choice for the baseline is an estimate of the state value, 
$$\hat{v}(S_t, \boldsymbol{w})$$, where $$\boldsymbol{w} \in \mathbb{R}^m$$ is a weight 
vector learned by one of the methods presented in previous chapters. Because REINFORCE is 
a Monte Carlo method for learning the policy parameter, $$\boldsymbol{\theta}$$, it seems 
natural to also use a Monte Carlo method to learn the state-value weights, $$\boldsymbol{w}$$. 

$$
\begin{align}
&\text{Input: a differentiable policy parameterization } \pi(a|s, \boldsymbol{\theta}) \\
&\text{Input: a differentiable state-value parameterization } \hat{v}(s, \boldsymbol{w}) \\
&\text{Parameters: step size } \alpha^{\boldsymbol{\theta}} \gt 0, \alpha^{\boldsymbol{w}} \gt 0 \\
&\text{Initialize policy parameter } \boldsymbol{\theta} \in \mathbb{R}^{d'} \text{ and state-value weights } \boldsymbol{w} \in \mathbb{R}^d \\
&\text{Repeat forever:} \\
&\quad \text{Generate an episode } S_0, A_0, R_1, \cdots, S_{T-1}, A_{T-1}, R_T, \text{ following } \pi(\cdot|\cdot, \boldsymbol{\theta}) \\
&\quad \text{For each step of the episode } t = 0, \cdots, T-1: \\
&\qquad G_t \leftarrow \text{ return from step } t \\
&\qquad \delta \leftarrow G_t - \hat{v}(S_t, \boldsymbol{w}) \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha^{\boldsymbol{w}}\gamma^t\delta\nabla_{\boldsymbol{w}}\hat{v}(S_t, \boldsymbol{w}) \\
&\qquad \boldsymbol{\theta} \leftarrow \boldsymbol{\theta} + \alpha^{\boldsymbol{\theta}}\gamma^t\delta\nabla_{\boldsymbol{\theta}}\ln\pi(A_t|S_t, \boldsymbol{\theta})
\end{align}
$$

#### Actor-Critic method

Although the REINFORCE-with-baseline method learns both a policy and a state-value function, 
we do not consider it to be an actor–critic method because its state-value function is used 
only as a baseline, not as a critic. That is, it is not used for bootstrapping (updating the 
value estimate for a state from the estimated values of subsequent states), but only as a 
baseline for the state whose estimate is being updated. This is a useful distinction, for only 
through bootstrapping do we introduce bias and an asymptotic dependence on the quality of the 
function approximation. The bias introduced through bootstrapping and reliance on the state 
representation is often beneficial because it reduces variance and accelerates learning. REINFORCE 
with baseline is unbiased and will converge asymptotically to a local minimum, but like all Monte 
Carlo methods it tends to learn slowly (produce estimates of high variance) and to be inconvenient 
to implement online or for continuing problems. With temporal-difference methods we can eliminate 
these inconveniences, and through multi-step methods we can flexibly choose the degree of 
bootstrapping. In order to gain these advantages in the case of policy gradient methods we use 
actor–critic methods with a bootstrapping critic.

The procedure of one-step actor-critic is

$$
\begin{align}
&\text{Input: a differentiable policy parameterization } \pi(a|s, \boldsymbol{\theta}) \\
&\text{Input: a differentiable state-value parameterization } \hat{v}(s, \boldsymbol{w}) \\
&\text{Parameters: step sizes } \alpha^{\boldsymbol{\theta}} \gt 0, \alpha^{\boldsymbol{w}} \gt 0 \\
&\text{Initialize policy parameter } \boldsymbol{\theta} \in \mathbb{R}^{d'} \text{ and state-value weights } \boldsymbol{w} \in \mathbb{R}^d \\
&\text{Repeat forever:} \\
&\quad \text{Initialize } S \text{ (first state of episode)} \\
&\quad I \leftarrow 1 \\
&\quad \text{While } S \text{ is not terminal:} \\
&\qquad A \sim \pi(\cdot|S, \boldsymbol{\theta}) \\
&\qquad \text{Take action} A\text{, observe } S', R \\
&\qquad \delta \leftarrow R + \gamma\hat{v}(S', \boldsymbol{w}) - \hat{v}(S, \boldsymbol{w}) \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha^{\boldsymbol{w}}I\delta\nabla_{\boldsymbol{w}}\hat{v}(S,\boldsymbol{w}) \\
&\qquad \boldsymbol{\theta} \leftarrow \boldsymbol{\theta} + \alpha^{\boldsymbol{\theta}}I\delta\nabla_{\boldsymbol{\theta}}\ln\pi(A|S,\boldsymbol{\theta}) \\
&\qquad I \leftarrow \gamma I \\
&\qquad S \leftarrow S'
\end{align}
$$

The generalizations to the forward view of multi-step methods and then to a $$\lambda$$-return 
algorithm are straightforward. The one-step return is merely replaced by $$G_{t:t+k}^\lambda$$ 
and $$G_t^\lambda$$ respectively. The backward views are also straightforward, using separate 
eligibility traces for the actor and critic.

$$
\begin{align}
&\text{Input: a differentiable policy parameterization } \pi(a|s, \boldsymbol{\theta}) \\
&\text{Input: a differentiable state-value parameterization } \hat{v}(s, \boldsymbol{w}) \\
&\text{Parameters: trace-decay rates } \lambda^{\boldsymbol{\theta}} \in [0, 1], \lambda^{\boldsymbol{w}} \in [0, 1] \text{; step sizes } \alpha^{\boldsymbol{\theta}} \gt 0, \alpha^{\boldsymbol{w}} \gt 0 \\
&\text{Initialize policy parameter } \boldsymbol{\theta} \in \mathbb{R}^{d'} \text{ and state-value weights } \boldsymbol{w} \in \mathbb{R}^d \\
&\text{Repeat forever:} \\
&\quad \text{Initialize } S \text{ (first state of episode)} \\
&\quad \boldsymbol{z}^{\boldsymbol{\theta}} \leftarrow 0 \text{ (} d'\text{-component eligibility trace vector)} \\
&\quad \boldsymbol{z}^{\boldsymbol{w}} \leftarrow 0 \text{ (} d\text{-component eligibility trace vector)} \\
&\quad I \leftarrow 1 \\
&\quad \text{While } S \text{ is not terminal (for each time step):} \\
&\qquad A \sim \pi(\cdot|S, \boldsymbol{\theta}) \\
&\qquad \text{Take action} A\text{, observe } S', R \\
&\qquad \delta \leftarrow R + \gamma\hat{v}(S', \boldsymbol{w}) - \hat{v}(S, \boldsymbol{w}) \\
&\qquad \boldsymbol{z}^{\boldsymbol{w}} \leftarrow \gamma\lambda^{\boldsymbol{w}}\boldsymbol{z}^{\boldsymbol{w}} + I\nabla_{\boldsymbol{w}}\hat{v}(S, \boldsymbol{w}) \\
&\qquad \boldsymbol{z}^{\boldsymbol{\theta}} \leftarrow \gamma\lambda^{\boldsymbol{\theta}}\boldsymbol{z}^{\boldsymbol{\theta}} + I\nabla_{\boldsymbol{\theta}}\ln\pi(A|S,\boldsymbol{\theta}) \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha^{\boldsymbol{w}}\delta\boldsymbol{z}^{\boldsymbol{w}} \\
&\qquad \boldsymbol{\theta} \leftarrow \boldsymbol{\theta} + \alpha^{\boldsymbol{\theta}}\delta\boldsymbol{z}^{\boldsymbol{\theta}} \\
&\qquad I \leftarrow \gamma I \\
&\qquad S \leftarrow S'
\end{align}
$$

#### Policy gradient for continuing problems

For continuing problems without episode boundaries we need to define performance in terms of 
the average rate of reward per time step:

$$
\begin{align}
\mathcal{J}(\boldsymbol{\theta}) \doteq r(\pi) &\doteq \lim_{h \rightarrow \infty} \frac{1}{h}\sum_{t=1}^h\mathbb{E}[R_t|A_{0:t-1} \sim \pi] \\
&= \lim_{t \rightarrow \infty} \mathbb{E}[R_t|A_{0:t-1} \sim \pi] \\
&= \sum_s\mu(s)\sum_a\pi(a|s)\sum_{s',r}p(s',r|s,a)r
\end{align}
$$

where $$\mu$$ is the steady-state distribution under $$\pi$$, 
$$\mu(s)\doteq\lim_{t\rightarrow\infty}\text{Pr}\{S_t=s|A_{0:t}\sim\pi\}$$, which is assumed 
to exist and to be independent of $$S_0$$ (an ergodicity assumption). This is the special 
distribution under which, if you select actions according to $$\pi$$, you remain in the same 
distribution:

$$
\sum_s\mu(s)\sum_a\pi(a|s, \boldsymbol{\theta})p(s'|s,a) = \mu(s')
$$

We also define values, $$v_\pi(s) \doteq \mathbb{E}_\pi[G_t|S_t = s]$$ and 
$$q_\pi(s, a) \doteq \mathbb{E}_\pi[G_t|S_t=s,A_t=a]$$, with respect to the differential 
return:

$$
G_t \doteq R_{t+1} - \eta(\pi) + R_{t+2} - \eta(\pi) + R_{t+3} - \eta(\pi) + \cdots
$$

With these alternate definitions, the policy gradient theorem as given for the episodic case 
remains true for the continuing case. The forward and backward view equations also remain the 
same.

$$
\begin{align}
&\text{Input: a differentiable policy parameterization } \pi(a|s, \boldsymbol{\theta}) \\
&\text{Input: a differentiable state-value parameterization } \hat{v}(s, \boldsymbol{w}) \\
&\text{Parameters: trace-decay rates } \lambda^{\boldsymbol{\theta}} \in [0, 1], \lambda^{\boldsymbol{w}} \in [0, 1] \text{; step sizes } \alpha^{\boldsymbol{\theta}} \gt 0, \alpha^{\boldsymbol{w}} \gt 0, \eta \gt 0 \\
&\boldsymbol{z}^{\boldsymbol{\theta}} \leftarrow 0 \text{ (} d'\text{-component eligibility trace vector)} \\
&\boldsymbol{z}^{\boldsymbol{w}} \leftarrow 0 \text{ (} d\text{-component eligibility trace vector)} \\
&\text{Initialize } \bar{R} \in \mathbb{R} \text{ (e.g., to } 0 \text{)} \\
&\text{Initialize policy parameter } \boldsymbol{\theta} \in \mathbb{R}^{d'} \text{ and state-value weights } \boldsymbol{w} \in \mathbb{R}^d \text{ (e.g., to } 0 \text{)} \\
&\text{Initialize } S \in \mathcal{S} \text{ (e.g., to } s_0 \text{)} \\
&\text{Repeat forever:} \\
&\quad A \sim \pi(\cdot|S, \boldsymbol{\theta}) \\
&\quad \text{Take action} A\text{, observe } S', R \\
&\quad \delta \leftarrow R - \bar{R} + \hat{v}(S', \boldsymbol{w}) - \hat{v}(S, \boldsymbol{w}) \qquad \text{(if } S' \text{ is terminal, then } \hat{v}(S',\boldsymbol{w}) \doteq 0 \text{)} \\
&\quad \bar{R} \leftarrow \bar{R} + \eta\delta \\
&\quad \boldsymbol{z}^{\boldsymbol{w}} \leftarrow \lambda^{\boldsymbol{w}}\boldsymbol{z}^{\boldsymbol{w}} + \nabla_{\boldsymbol{w}}\hat{v}(S, \boldsymbol{w}) \\
&\quad \boldsymbol{z}^{\boldsymbol{\theta}} \leftarrow \lambda^{\boldsymbol{\theta}}\boldsymbol{z}^{\boldsymbol{\theta}} + \nabla_{\boldsymbol{\theta}}\ln\pi(A|S,\boldsymbol{\theta}) \\
&\quad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha^{\boldsymbol{w}}\delta\boldsymbol{z}^{\boldsymbol{w}} \\
&\quad \boldsymbol{\theta} \leftarrow \boldsymbol{\theta} + \alpha^{\boldsymbol{\theta}}\delta\boldsymbol{z}^{\boldsymbol{\theta}} \\
&\quad S \leftarrow S'
\end{align}
$$

#### Policy parameterization for continuous actions

Policy-based methods offer practical ways of dealing with large actions spaces, even continuous 
spaces with an infinite number of actions. Instead of computing learned probabilities for each 
of the many actions, we instead learn statistics of the probability distribution. For example, 
the action set might be the real numbers, with actions chosen from a normal distribution.

The probability density function for the normal distribution is conventionally written

$$
p(x) \doteq \frac{1}{\sigma\sqrt{2\pi}}\exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)
$$

where $$\mu$$ and $$\sigma$$ are the mean and standard deviation of the normal distribution. 
The value $$p(x)$$ is the density of the probability at $$x$$, not the probability.

To produce a policy parameterization, the policy can be defined as the normal probability 
density over a real-valued scalar action, with mean and standard deviation given by parametric 
function approximators that depend on the state. That is,

$$
\pi(a|s,\boldsymbol{\theta}) \doteq \frac{1}{\sigma(s,\boldsymbol{\theta})\sqrt{2\pi}}\exp\left(-\frac{(a - \mu(s,\boldsymbol{\theta}))^2}{2\sigma(s,\boldsymbol{\theta})^2}\right)
$$

where $$\mu: \mathcal{S} \times \mathbb{R}^{d'} \rightarrow \mathbb{R}$$ and 
$$\sigma: \mathcal{S} \times \mathbb{R}^{d'} \rightarrow \mathbb{R}^+$$ are two parameterized 
function approximators.

To complete the example we need only give a form for these approximators. For this we divide 
the policy's parameter vector into two parts, $$\boldsymbol{\theta}=[\boldsymbol{\theta}_\mu, 
\boldsymbol{\theta}_\sigma]^T$$, one part to be used for the approximation of the mean 
and one part for the approximation of the standard deviation. The mean can be approximated as 
a linear function. The standard deviation must always be positive and is better approximated 
as the exponential of a linear function. Thus

$$
\mu(s,\boldsymbol{\theta})\doteq\boldsymbol{\theta}_\mu^T\boldsymbol{x}(s) \\
\sigma(s,\boldsymbol{\theta}) \doteq \exp(\boldsymbol{\theta}_\sigma^T\boldsymbol{x}(s))
$$

where $$\boldsymbol{x}(s)$$  is a state feature vector.

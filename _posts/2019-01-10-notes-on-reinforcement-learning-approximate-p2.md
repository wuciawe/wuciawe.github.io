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



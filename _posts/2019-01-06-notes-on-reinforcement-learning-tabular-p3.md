---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'notes on reinforcement learning, focused on tabular solution methods, part three'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Eligibility traces

n-step TD methods generalize both MC methods and one-step TD methods so 
that one can shift from one to the other smoothly as needed to meet the 
demands of a particular task. The idea of n-step methods is usually used 
as an introduction to the algorithmic idea of eligibility traces.

#### n-step TD prediction

Methods in which the temporal difference extends over n steps are called 
n-step TD methods. n-step TD for estimating $$V \approx v_\pi$$ is 

$$
\begin{align}
&\text{Initialize } V(s) \text{ arbitrarily, } s \in \mathcal{S} \\
&\text{Parameters: step size } \alpha \in (0, 1] \text{, a positive integer } n \\
&\text{All store and access operations (for } S_t \text{ and } R_t \text{ ) can take their index mod } n \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize and store } S_0 \neq terminal \\
&\quad T \leftarrow \infty \\
&\quad \text{For } t = 0, 1, 2, \cdots : \\
&\qquad \text{If } t \lt T \text{, then: } \\
&\qquad\quad \text{Take an action according to } \pi(\cdot|S_t) \\
&\qquad\quad \text{Observe and store the next reward as } R_{t+1} \text{ and the next state as } S_{t+1} \\
&\qquad\quad \text{If } S_{t+1} \text{ is terminal, then } T \leftarrow t + 1\\
&\qquad \tau \leftarrow t - n + 1 \text{ (} \tau \text{ is the time whose state's estimate is being updated)} \\
&\qquad \text{If } \tau \geq 0 : \\
&\qquad\quad G \leftarrow \sum_{i=\tau+1}^{\min (\tau + n, T)} \gamma^{i - \tau - 1}R_i \\
&\qquad\quad \text{If } \tau + n \lt T \text{, then: } G \leftarrow G + \gamma^n V(S_{\tau + n}) \\
&\qquad\quad V(S_\tau) \leftarrow V(S_\tau) + \alpha [G - V(S_\tau)] \\
&\quad \text{until } \tau = T - 1
\end{align}
$$

The error reduction property of n-step returns ensures the convergence 
to the correct prediction of n-step TD methods under appropriate 
technical conditions.

#### n-step SARSA

$$
\begin{align}
&\text{Initialize } Q(s, a) \text{arbitrarily, for all } s \in \mathcal{S}, a \in \mathcal{A} \\
&\text{Initialize } \pi \text{ to be } \epsilon\text{-greedy with respect to } Q \text{, or to a fixed given policy} \\
&\text{Parameters: step size } \alpha \in (0, 1] \text{, small } \epsilon \gt 0 \text{, a positive integer } n \\
&\text{All store and access operations (for } S_t, A_t, \text{ and } R_t \text{) can take their index mod } n \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize and store } S_0 \neq terminal \\
&\quad \text{Select and store an action } A_0 \sim \pi(\cdot | S_0) \\
&\quad T \leftarrow \infty \\
&\quad \text{For } t = 0, 1, 2, \cdots : \\
&\qquad \text{If } t \lt T \text{, then: } \\
&\qquad\quad \text{Take action } A_t \\
&\qquad\quad \text{Observe and store the next reward as } R_{t+1} \text{ and the next state as } S_{t+1} \\
&\qquad\quad \text{If } S_{t+1} \text{ is terminal, then:} \\
&\qquad\qquad T \leftarrow t + 1 \\
&\qquad\quad \text{else:} \\
&\qquad\qquad \text{Select and store an action } A_{t+1} \sim \pi(\cdot | S_{t+1}) \\
&\qquad \tau \leftarrow t - n + 1 \text{ (} \tau \text{ is the time whose estimate is being updated)} \\
&\qquad \text{If } \tau \geq 0 : \\
&\qquad\quad G \leftarrow \sum_{i = \tau + 1}^{\min (\tau + n, T)} \gamma^{i - \tau -1} R_i \\
&\qquad\quad \text{If } \tau + n \lt T \text{, then } G \leftarrow G + \gamma^n Q(S_{\tau + n}, A_{\tau + n}) \\
&\qquad\quad Q(S_\tau, A_\tau) \leftarrow Q(S_\tau, A_\tau) + \alpha [G - Q(S_\tau, A_\tau)] \\
&\qquad\quad \text{if } \pi \text{ is being learned, then ensure that } \pi(\cdot | S_\tau) \text{ is } \epsilon \text{-greedy w.r.t. } Q \\
&\quad \text{until } \tau = T - 1
\end{align}
$$

#### n-step off-policy learning via importance sampling

$$
\begin{align}
&\text{Input: an arbitrary behaviour policy } b \text{ such that } b(a|s) \gt 0 \text{, for all } s \in \mathcal{S}, a \in \mathcal{A} \\
&\text{Initialize } Q(s, a) \text{ arbitrarily, for all } s \in \mathcal{S}, a \in \mathcal{A} \\
&\text{Initialize } \pi \text{ to be } \epsilon\text{-greedy with respect to } Q \text{, or as a fixed given policy} \\
&\text{Parameters: step size } \alpha \in (0, 1] \text{, small } \epsilon \gt 0 \text{, a positive integer } n \\
&\text{All store and access operations (for } S_t, A_t, \text{ and } R_t \text{) can take their index mod } n \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize and store } S_0 \neq terminal \\
&\quad \text{Select and store an action } A_0 \sim b(\cdot | S_0) \\
&\quad T \leftarrow \infty \\
&\quad \text{For } t = 0, 1, 2, \cdots : \\
&\qquad \text{If } t \lt T \text{, then:} \\
&\qquad\quad \text{Take action } A_t \\
&\qquad\quad \text{Observe and store the next reward as } R_{t+1} \text{ and the next state as } S_{t+1} \\
&\qquad\quad \text{If } S_{t+1} \text{ is terminal, then:} \\
&\qquad\qquad T \leftarrow t + 1\\
&\qquad\quad \text{else:} \\
&\qquad\qquad \text{Select and store an action } A_{t+1} \sim b(\cdot | S_{t+1}) \\
&\qquad \tau \leftarrow t - n + 1 \text{ (} \tau \text{ is the time whose estimate is being updated)} \\
&\qquad \text{If } \tau \geq 0 : \\
&\qquad\quad \rho \leftarrow \prod_{i = \tau + 1}^{\min (\tau + n - 1, T - 1)} \frac{\pi(A_i|S_i)}{b(A_i|S_i)} \\
&\qquad\quad G \leftarrow \sum_{i = \tau + 1}^{\min (\tau + n, T)} \gamma^{i - \tau - 1} R_i \\
&\qquad\quad \text{If } \tau + n \lt T \text{, then: } G \leftarrow G + \gamma^n Q(S_{\tau + n}, A_{\tau + n}) \\
&\qquad\quad Q(S_\tau, A_\tau) \leftarrow Q(S_\tau, A_\tau) + \alpha \rho [G - Q(S_\tau, A_\tau)] \\
&\qquad\quad \text{If } \pi \text{ is being learned, then ensure that } \pi(\cdot | S_\tau) \text{ is } \epsilon\text{-greedy w.r.t. } Q \\
&\quad \text{until } \tau = T - 1 
\end{align}
$$

#### Off-policy learning without importance sampling: the n-step tree backup algorithm

$$
\begin{align}
&\text{Initialize } Q(s, a) \text{ arbitrarily, for all } s \in \mathcal{S}, a \in \mathcal{A} \\
&\text{Initialize } \pi \text{ to be } \epsilon\text{-greedy with respect to } Q \text{, or as a fixed given policy} \\
&\text{Parameters: step size } \alpha \in (0, 1] \text{, small } \epsilon \gt 0 \text{, a positive integer } n \\
&\text{All store and access operations can take their index mod } n \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize and store } S_0 \neq terminal \\
&\quad \text{Select and store an action } A_0 \sim \pi(\cdot | S_0) \\
&\quad \text{Store } Q(S_0, A_0) \text{ as } Q_0 \\
&\quad T \leftarrow \infty \\
&\quad \text{For } t = 0, 1, 2, \cdots : \\
&\qquad \text{If } t \lt T : \\
&\qquad\quad \text{Take action } A_t \\
&\qquad\quad \text{Observe the next reward } R \text{; observe and store the next state as } S_{t+1} \\
&\qquad\quad \text{If } S_{t+1} \text{ is terminal:} \\
&\qquad\qquad T \leftarrow t + 1 \\
&\qquad\qquad \text{Store } R - Q_t \text{ as } \delta_t \\
&\qquad\quad \text{else:} \\
&\qquad\qquad \text{Store } R + \gamma\sum_a\pi(a|S_{t+1})Q(S_{t+1}, a) - Q_t \text{ as } \delta_t \\
&\qquad\qquad \text{Select arbitrarily and store an action as } A_{t+1} \\
&\qquad\qquad \text{Store } Q(S_{t+1}, A_{t+1}) \text{ as } Q_{t+1} \\
&\qquad\qquad \text{Store } \pi(A_{t+1}|S_{t+1}) \text{ as } \pi_{t+1} \\
&\qquad \tau \leftarrow t - n + 1 \text{ (} \tau \text{ is the time whose estimate is being updated)} \\
&\qquad \text{If } \tau \geq 0 : \\
&\qquad\quad Z \leftarrow 1 \\
&\qquad\quad G \leftarrow Q_\tau \\
&\qquad\quad \text{For } k = \tau, \cdots, \min (\tau + n - 1, T - 1) : \\
&\qquad\qquad G \leftarrow G + Z\delta_k \\
&\qquad\qquad Z \leftarrow \gamma Z_{\pi_{k+1}} \\
&\qquad\quad Q(S_\tau, A_\tau) \leftarrow Q(S_\tau, A_\tau) + \alpha [G - Q(S_\tau, A_\tau)] \\
&\qquad\quad \text{If } \pi \text{ is being learned, then ensure that } \pi(a|S_\tau) \text{ is } \epsilon\text{-greedy w.r.t. } Q(S_\tau, \cdot) \\
&\quad \text{until } \tau = T - 1
\end{align}
$$

#### A unifying algorithm: n-step $$Q(\delta)$$

Consider three kinds of action-value algorithms: n-step SARSA has all sample 
transitions, the tree-backup algorithm has all state-to-action transitions 
fully branched without sampling, and n-step Expected SARSA has all sample 
transitions except for the last state-to-action one, which is fully branched 
with an expected value.

The n-step $$Q(\delta)$$ unifies them:

$$
\begin{align}
&\text{Input: an arbitrary behaviour policy } b \text{ such that } b(a|s) \gt 0 \text{, for all } s \in \mathcal{S}, a \in \mathcal{A} \\
&\text{Initialize } Q(s, a) \text{ arbitrarily, for all } s \in \mathcal{S}, a \in \mathcal{A} \\
&\text{Initialize } \pi \text{ to be } \epsilon\text{-greedy with respect to } Q \text{, or as a fixed given policy} \\
&\text{Parameters: step size } \alpha \in (0, 1] \text{, small } \epsilon \gt 0 \text{, a positive integer } n \\
&\text{All store and access operations can take their index mod } n \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize and store } S_0 \neq terminal \\
&\quad \text{Select and store an action } A_0 \sim b(\cdot | S_0) \\
&\quad \text{Store } Q(S_0, A_0) \text{ as } Q_0 \\
&\quad T \leftarrow \infty \\
&\quad \text{For } t = 0, 1, 2, \cdots : \\
&\qquad \text{If } t \lt T : \\
&\qquad\quad \text{Take action } A_t \\
&\qquad\quad \text{Observe the next reward } R \text{; observe and store the next state as } S_{t+1} \\
&\qquad\quad \text{If } S_{t+1} \text{ is terminal:} \\
&\qquad\qquad T \leftarrow t + 1 \\
&\qquad\qquad \text{Store } \delta_t \leftarrow R - Q_t \\
&\qquad\quad \text{else:} \\
&\qquad\qquad \text{Select and store an action } A_{t+1} \sim b(\cdot | S_{t+1}) \\
&\qquad\qquad \text{Select and store } \sigma_{t + 1} \\
&\qquad\qquad \text{Store } Q(S_{t+1}, A_{t+1}) \text{ as } Q_{t+1} \\
&\qquad\qquad \text{Store } R + \gamma\sigma_{t+1}Q_{t+1} + \gamma(1 - \sigma_{t+1})\sum_a\pi(a|S_{t+1})Q(S_{t+1}, a) - Q_t \text{ as } \delta_t \\
&\qquad\qquad \text{Store } \pi(A_{t+1}|S_{t+1}) \text{ as } \pi_{t+1} \\
&\qquad\qquad \text{Store } \frac{\pi(A_{t+1}|S_{t+1})}{b(A_{t+1}|S_{t+1})} \text{ as } \rho_{t+1} \\
&\qquad \tau \leftarrow t - n + 1 \text{ (} \tau \text{ is the time whose estimate is being updated)} \\
&\qquad \text{If } \tau \geq 0 : \\
&\qquad\quad \rho \leftarrow 1 \\
&\qquad\quad Z \leftarrow 1 \\
&\qquad\quad G \leftarrow Q_\tau \\
&\qquad\quad \text{For } k = \tau, \cdots, \min (\tau + n - 1, T - 1) : \\
&\qquad\qquad G \leftarrow G + Z\delta_k \\
&\qquad\qquad Z \leftarrow \gamma Z[(1 - \sigma_{k+1})\pi_{k+1} + \sigma_{k+1}] \\
&\qquad\qquad \rho \leftarrow \rho(1 - \sigma_k + \sigma_k \rho_k) \\
&\qquad\quad Q(S_\tau, A_\tau) \leftarrow Q(S_\tau, A_\tau) + \alpha \rho [G - Q(S_\tau, A_\tau)] \\
&\qquad\quad \text{If } \pi \text{ is being learned, then ensure that } \pi(a|S_\tau) \text{ is } \epsilon\text{-greedy w.r.t. } Q(S_\tau, \cdot) \\
&\quad \text{until } \tau = T - 1
\end{align}
$$

### Planning and Learning

The model-based reinforcement learning methods, such as dynamic programming and 
heuristic search, require a model of the environment. The model-free reinforcement 
learning methods, such as Monte Carlo and temporal-difference methods, can be 
used without a model. Model-based methods rely on planning as their primary 
component, while model-free methods primarily rely on learning.

#### Models and planning

By a model of the environment we mean anything an agent can use to predict how 
the environment will respond to its actions. If the model is stochastic, then 
there are several possible next states and next rewards, each with some 
probability of occurring. Some models produce a description of all possibilities 
and their probabilities; these we call distribution models. Other models produce 
just one of the possibilities, sampled according to the probabilities; these we 
call sample models.

In artificial intelligence, there are two distinct approaches to planning. 
State-space planning is viewed primarily as a search through the state space 
for an optimal policy or an optimal path to a goal. Actions cause transitions 
from state to state, and value functions are computed over states. In 
plan-space planning, planning is instead a search through the space of plans. 
Operators transform one plan into another, and value functions, if any, are 
defined over the space of plans. Plan-space planning includes evolutionary 
methods and partial-order planning, a common kind of planning in artificial 
intelligence in which the ordering of steps is not completely determined at 
all stages of planning.

All state-space planning methods share a common structure: 1) all state-space 
planning methods involve computing value functions as a key intermediate 
step toward improving the policy, and 2) they compute value functions by updates 
or backup operations applied to simulated experience.

The heart of both learning and planning methods is the estimation of value 
functions by backing-up update operations. The difference is that whereas 
planning uses simulated experience generated by a model, learning methods 
use real experience generated by the environment.

#### DYNA 

https://datascience.stackexchange.com/questions/26938/what-exactly-is-bootstrapping-in-reinforcement-learning
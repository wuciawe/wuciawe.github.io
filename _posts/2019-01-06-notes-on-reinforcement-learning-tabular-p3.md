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

#### DYNA: Integrating planning, acting and learning

When planning is done on-line, while interacting with the environment, new 
information gained from the interaction may change the model and thereby interact 
with planning. DYNA-Q is a simple architecture integrating the major functions 
needed in an on-line planning agent.

Dyna-Q includes all of the processes, acting, model-learning, and direct RL—all 
occurring continuously. The planning method is the random-sample one-step tabular 
Q-planning method. The direct RL method is one-step tabular Q-learning. The model-learning 
method is also table-based and assumes the environment is deterministic. After each 
transition $$\{S_t, A_t \rightarrow R_{t+1}, S_{t+1}\}$$, the model records in its 
table entry for $$S_t, A_t$$ the prediction that $$R_{t+1}, S_{t+1}$$ will deterministically 
follow. Thus, if the model is queried with a state–action pair that has been experienced 
before, it simply returns the last-observed next state and next reward as its prediction. 
During planning, the Q-planning algorithm randomly samples only from state–action pairs 
that have previously been experienced (in Step 1), so the model is never queried with a 
pair about which it has no information.

$$
\begin{align}
&\text{Initialize } Q(s, a) \text{ and } Model(s, a) \text{ for all } s \in \mathcal{S}, a \in \mathcal{A}(s) \\
&\text{Do forever:} \\
&\quad \text{(a) } S \leftarrow \text{ current (nonterminal) state} \\
&\quad \text{(b) } A \leftarrow \epsilon\text{-greedy}(S, Q) \\
&\quad \text{(c) Execute action } A \text{; observe resultant reward, } R \text{, and state, } S' \\
&\quad \text{(d) } Q(S, A) \leftarrow Q(S, A) + \alpha [R + \gamma\max_a Q(S', a) - Q(S, A)] \\
&\quad \text{(e) } Model(S, A) \leftarrow R, S' \text{ (assuming deterministic environment)} \\
&\quad \text{(f) Repeat } n \text{ times:} \\
&\qquad S \leftarrow \text{ random previously observed state} \\
&\qquad A \leftarrow \text{ random action previously taken in } S \\
&\qquad R, S' \leftarrow Model(S, A) \\
&\qquad Q(S, A) \leftarrow Q(S, A) + \alpha [R + \gamma\max_a Q(S', a) - Q(S, A)]
\end{align}
$$

In DYNA-Q, learning and planning are accomplished by exactly the same algorithm, operating 
on real experience for learning and on simulated experience for planning. Because planning 
proceeds incrementally, it is trivial to intermix planning and acting. Both proceed as fast 
as they can. The agent is always reactive and always deliberative, responding instantly to 
the latest sensory information and yet always planning in the background. Also ongoing in 
the background is the model-learning process. As new information is gained, the model is 
updated to better match reality. As the model changes, the ongoing planning process will 
gradually compute a different way of behaving to match the new model.

#### Expected vs sample updates

For one-step value-function updates, they vary primarily along three binary dimensions. The 
first two dimensions are whether they update state values or action values and whether 
they estimate the value for the optimal policy or for an arbitrary given policy. These two 
dimensions give rise to four classes fo updates for approximating the four value functions, 
$$q_*$$, $$v_*$$, $$q_\pi$$, and $$v_\pi$$. The other binary dimension is whether the 
updates are expected updates, considering all possible events that might happen, or sample 
updates, considering a single sample of what might happen. These three binary dimensioins given 
rise to eight cases, seven of which correspond to specific algorithms.

$$
\begin{align}
&\text{Value estimated}& &\text{Expected updates (DP)}& &\text{Sample updates (one-step TD)} \\
&v_\pi(s)& &\text{policy evaluation}& &TD(0) \\
&v_*(s)& &\text{value iteration}& &\text{-} \\
&q_\pi(s, a)& &\text{q-policy evaluation}& &\text{SARSA} \\
&q_*(s, a)& &\text{q-value iteration}& &\text{q-learning}
\end{align}
$$

The DYNA-Q agents use $$q_*$$ sample udpates, but they could just as well use $$q_*$$ 
expected updates, or either expected or sample $$q_\pi$$ updates. The DYNA-AC system uses 
$$v_\pi$$ sample updates together with a learning policy structure. For stochastic problems, 
prioritized sweeping is always done using one of the expected udpates.

In the absence of a distribution model, expected updates are not possible, but sample updates 
can be done using sample transitions from the environment or a sample model. Expected updates 
certainly yield a better estimate because they are uncorrupted by sampling error, but they also 
require more computation, and computation is often the limiting resource in planning.

#### Heuristic search

The classical state-space planning methods in artificial intelligence are decision-time planning 
methods collectively known as heuristic search. In heuristic search, for each state encountered, 
a large tree of possible continuations is considered. The approximate value function is applied to 
the leaf nodes and then backed up toward the current state at the root. The backing up within the 
search tree is just the same as in the expected updates with maxes (those for $$v_∗$$ and $$q_∗$$). 
The backing up stops at the state–action nodes for the current state. Once the backed-up values of 
these nodes are computed, the best of them is chosen as the current action, and then all backed-up 
values are discarded.

We may save the backed-up values to change the approximate value function. In fact, the value function 
is generally designed by people and never changed as a result of search. However, it is natural to 
consider allowing the value function to be improved over time, using either the backed-up values computed 
during heuristic search or greedy, $$\epsilon\text{-greedy}$$, and UCB action-selection methods.

The point of searching deeper than one step is to obtain better action selections. If one has a 
perfect model and an imperfect action-value function, then in fact deeper search will usually yield 
better policies. On the other hand, the deeper the search, the more computation is required, usually 
resulting in a slower response time. A good example is provided by Tesauro’s grandmaster-level backgammon
player, TD-Gammon.

We should not overlook the most obvious way in which heuristic search focuses updates: on the current 
state. Much of the effectiveness of heuristic search is due to its search tree being tightly focused 
on the states and actions that might immediately follow the current state.

The distribution of updates can be altered in similar ways to focus on the current state and its 
likely successors. As a limiting case we might use exactly the methods of heuristic search to construct 
a search tree, and then perform the individual, one-step updates from bottom up. The performance 
improvement observed with deeper searches is not due to the use of multistep updates as such. Instead, 
it is due to the focus and concentration of updates on states and actions immediately downstream from 
the current state.

#### Monte Carlo tree search

Monte Carlo Tree Search (MCTS) is a recent and strikingly successful example of decision-time planning. 
At is base, MCTS is a rollout algorithm, but enhanced by the addition of a means for accumulating value 
estimates obtained from the Monte Carlo simulations in order to successively direct simulations toward 
more highly-rewarding trajectories.

MCTS is executed after encountering each new state to select the agent’s action for that state; it is 
executed again to select the action for the next state, and so on. As in a rollout algorithm, each 
execution is an iterative process that simulates many trajectories starting from the current state and 
running to a terminal state (or until discounting makes any further reward negligible as a contribution 
to the return). The core idea of MCTS is to successively focus multiple simulations starting at the 
current state by extending the initial portions of trajectories that have received high evaluations from 
earlier simulations. MCTS does not have to retain approximate value functions or policies from one 
action selection to the next, though in many implementations it retains selected action values likely to 
be useful for its next execution.

For the most part, the actions in the simulated trajectories are generated using a simple policy, usually 
called a rollout policy as it is for simpler rollout algorithms. As in any tabular Monte Carlo method, the 
value of a state–action pair is estimated as the average of the (simulated) returns from that pair. Monte 
Carlo value estimates are maintained only for the subset of state–action pairs that are most likely to be 
reached in a few steps, which form a tree rooted at the current state. MCTS incrementally extends the tree 
by adding nodes representing states that look promising based on the results of the simulated trajectories. 
Any simulated trajectory will pass through the tree and then exit it at some leaf node. Outside the tree 
and at the leaf nodes the rollout policy is used for action selections, but at the states inside the tree 
something better is possible. For these states we have value estimates for of at least some of the actions, 
so we can pick among them using an informed policy, called the tree policy, that balances exploration
and exploitation.

In each iteration of a basic version of MCTS

1. Selection. Starting at the root node, a tree policy based on the action values attached to the edges of 
the tree traverses the tree to select a leaf node.

2. Expansion. On some iterations (depending on details of the application), the tree is expanded from the 
selected leaf node by adding one or more child nodes reached from the selected node via unexplored actions.

3. Simulation. From the selected node, or from one of its newly-added child nodes (if any), simulation of 
a complete episode is run with actions selected by the rollout policy. The result is a Monte Carlo trial 
with actions selected first by the tree policy and beyond the tree by the rollout policy.

4. Backup. The return generated by the simulated episode is backed up to update, or to initialize, the 
action values attached to the edges of the tree traversed by the tree policy in this iteration of MCTS. 
No values are saved for the states and actions visited by the rollout policy beyond the tree.

MCTS continues executing these four steps, starting each time at the tree’s root node, until no more time 
is left, or some other computational resource is exhausted. Then, finally, an action from the root node 
(which still represents the current state of the environment) is selected according to some mechanism that 
depends on the accumulated statistics in the tree; for example, it may be an action having the largest 
action value of all the actions available from the root state, or perhaps the action with the largest visit 
count to avoid selecting outliers. After the environment transitions to a new state, MCTS is run again, 
sometimes starting with a tree of a single root node representing the new state, but often starting with 
a tree containing any descendants of this node left over from the tree constructed by the previous execution 
of MCTS; all the remaining nodes are discarded, along with the action values associated with them.

### Reference

[Bootstrapping in RL](https://datascience.stackexchange.com/questions/26938/what-exactly-is-bootstrapping-in-reinforcement-learning){:target='_blank'}

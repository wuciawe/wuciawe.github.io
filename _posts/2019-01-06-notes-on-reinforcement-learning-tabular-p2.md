---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'notes on reinforcement learning, focused on tabular solution methods, part two'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Dynamic programming

Dynamic programming methods are well developed mathematically, but require a 
complete and accurate model of the environment.

#### Policy evaluation (prediction)

Policy evaluation is to compute the state-value function $$v_\pi$$ 
for an arbitrary policy $$\pi$$.

$$
\begin{align}
v_{k+1}(s) &\doteq \mathbb{E}_\pi [R_{t+1} + \gamma v_k (S_{t+1}) | S_t = s] \\
&= \sum_a \pi(a|s) \sum_{s', r}p(s', r | s, a)[r + \gamma v_k (s')]
\end{align}
$$

for all $$s \in \mathcal{S}$$. $$v_k = v_\pi$$ is a fixed point for 
this update rule because the Bellman equation for $$v_\pi$$ assures 
us of equality in this case. This algorithm is called iterative policy 
evaluation.

This kind of update is called expected update because it is based on 
an expectation over all possible next states rather than on a sample 
next state.

A complete in-place version of iterative policy evaluation is 

$$
\begin{align}
&\text{Input } \pi \text{, the policy to be evaluated} \\
&\text{Initialize an array } V(s) = 0 \text{, for all } s \in \mathcal{S}^+ \\
&\text{Repeat} \\
&\quad \Delta \leftarrow 0 \\
&\quad \text{For each } s \in \mathcal{S}: \\
&\qquad v \leftarrow V(s) \\
&\qquad V(s) \leftarrow \sum_a \pi(a|s)\sum_{s', r} p(s', r | s, a)[r + \gamma V(s')] \\
&\qquad \Delta \leftarrow \max (\Delta, |v - V(s)|) \\
&\text{until } \Delta \lt \theta \text{ (a small positive number)} \\
&\text{Output } V \approx v_\pi
\end{align}
$$

#### Policy improvement

The reason for computing the value function for a policy is to help find 
better policies. Suppose we have determined the value function $$v_\pi$$ 
for an arbitrary deterministic policy $$\pi$$. For some state $$s$$ we 
would like to know whether or not we should change the policy to 
deterministically choose an action $$a \neq \pi(s)$$. We know how good it 
is to follow the current policy from $$s$$, that is $$v_\pi(s)$$, but 
would it be better or worse to change to the new policy? One way to answer 
this question is to consider selecting $$a$$ in $$s$$ and thereafter 
following the existing policy $$\pi$$. The value of this way of 
behaving is 

$$
\begin{align}
q_\pi(s, a) &\doteq \mathbb{E}[R_{t+1} + \gamma v_\pi (S_{t+1}) | S_t = s, A_t = a] \\
&= \sum_{s', r} p(s', r | s, a)[r + \gamma v_\pi(s')]
\end{align}
$$

If it is greater than $$v_\pi(s)$$, that is, if it is better to select 
$$a$$ once in $$s$$ and thereafter follow $$\pi$$ than it would be 
to follow $$\pi$$ all the time, then one would expect it to be better 
still to select $$a$$ every time $$s$$ is encountered, and that the 
new policy would in fact be a better one overall.

That this is true is a special case of a general result called the 
policy improvement theorem. Let $$\pi$$ and $$\pi '$$ be any pair of 
deterministic policies such that, for all $$s \in \mathcal{S}$$,

$$
q_\pi(s, \pi ' (s)) \geq v_\pi (s)
$$

Then the policy $$\pi '$$ must be as good as, or better than, $$\pi$$. 
That is, it must obtain greater or equal expected return from all 
states $$s \in \mathcal{S}$$

$$
v_{\pi '}(s) \geq v_\pi (s)
$$

So far we have seen how, given a policy and its value function, we can 
easily evaluate a change in the policy at a single state to a particular 
action. It is a natural extension to consider changes at all states and to 
all possible actions, selecting at each state the action that appears 
best according to $$q_\pi(s, a)$$. In other words, to consider the new 
greedy policy $$\pi '$$, given by

$$
\begin{align}
\pi ' (s) &\doteq \arg\max_a q_\pi(s, a) \\
&= \arg\max_a \mathbb{E}[R_{t+1} + \gamma v_\pi(S_{t+1}) | S_t = s, A_t = a] \\
&= \arg\max_a \sum_{s', r} p(s', r | s, a)[r + \gamma v_\pi(s')]
\end{align}
$$

The process of making a new policy that improves on an original policy, 
by making it greedy with respect to the value function of the original 
policy, is called policy improvement.

In the general case, a stochastic policy $$\pi$$ specifies probabilities, 
$$\pi(a|s)$$, for taking each action, $$a$$, in each state, $$s$$. 
The idea of improvement of deterministic policies extend to stochastic 
policies.

#### Policy iteration

Once a policy $$\pi$$ has been improved using $$v_\pi$$ to yield a 
better policy $$\pi '$$, we can then compute $$v_{\pi '}$$ and 
improve it again to yield an even better $$\pi ''$$. This way of 
finding an optimal policy is called policy iteration.

$$
\begin{align}
&\text{1. Initialization} \\
&\quad V(s) \in \mathbb{R} \text{ and } \pi(s) \in \mathcal{A}(s) \text{ arbitrarily for all } s \in \mathcal{S} \\
&\text{2. Policy Evaluation} \\
&\quad\text{Repeat}\\
&\qquad \Delta \leftarrow 0 \\
&\qquad \text{For each } s \in \mathcal{S}: \\
&\qquad\quad v \leftarrow V(s) \\
&\qquad\quad V(s) \leftarrow \sum_{s', r} p(s', r | s, \pi(s))[r + \gamma V(v')] \\
&\qquad\quad \Delta \leftarrow \max (\Delta, |v - V(s)|) \\
&\quad \text{until } \Delta \lt \theta \text{ (a small positive number)} \\
&\text{3. Policy Improvement} \\
&\quad policy\_stable \leftarrow true \\
&\quad\text{For each } s \in \mathcal{S}: \\
&\qquad old\_action \leftarrow \pi(s) \\
&\qquad \pi(s) \leftarrow \arg\max_a \sum_{s', r} p(s', r | s, a)[r + \gamma V(s')] \\
&\qquad\text{If } old\_action \neq \pi(s) \text{, then } policy\_stable \leftarrow false \\
&\text{If } policy\_stable \text{, then stop and return } V \approx v_* \text{ and } \pi \approx \pi_* \text{; else go to 2}
\end{align}
$$

Policy iteration often converges in surprisingly few iterations.

#### Value iteration

One drawback to policy iteration is that each of its iterations involves 
policy evaluation, which may itself be a protracted iterative computation 
requiring multiple sweeps through the state set. If policy evaluation is 
done iteratively, then convergence exactly to $$v_\pi$$ occurs only in 
the limit.

In fact, the policy evaluation step of policy iteration can be truncated 
in serveral ways without losing the convergence guarantees of policy 
iteration. One important special case is when policy evaluation is stopped 
after just one sweep (one update of each state). This algorithm is called 
value iteration. It can be written as a particularly simple udpate 
operation that combines the policy improvement and truncated policy 
evaluation steps:

$$
\begin{align}
v_{k+1}(s) &\doteq \max_a \mathbb{E}[R_{t+1} + \gamma v_k(S_{t+1}) | S_t = s, A_t = a] \\
&= \max_a \sum_{s', r} p(s', r | s, a)[r + \gamma v_k(s')]
\end{align}
$$

for all $$s \in \mathcal{S}$$.

Another way of understanding value iteration is by reference to the 
Bellman optimality equation. Note that value iteration is obtained 
simply by turning the Bellman optimality equation into an update 
rule. Also note how the value iteration update is identical to the 
policy evaluation update except that it requires the maximum to be 
taken over all actions.

$$
\begin{align}
&\text{Initialize array } V \text{ arbitrarily (e.e., } V(s) = 0 \text{ for all } s \in \mathcal{S}^+ \text{)} \\
&\text{Repeat} \\
&\quad \Delta \leftarrow 0 \\
&\quad \text{For each } s \in \mathcal{S}: \\
&\qquad v \leftarrow V(s) \\
&\qquad V(s) \leftarrow \max_a \sum_{s', r} p(s', r | s, a)[r + \gamma V(s')] \\
&\qquad \Delta \leftarrow \max(\Delta, |v - V(s)|) \\
&\text{until } \Delta \lt \theta \text{ (a small positive number)} \\
&\text{Output a deterministic policy, } \pi \approx \pi_* \text{, such that} \\
&\quad \pi(s) = \arg\max_a \sum_{s', r} p(s', r | s, a)[r + \gamma V(s')]
\end{align}
$$

Value iteration effectively combines, in each of its sweeps, one sweep 
of policy evaluation and one sweep of policy improvement.

#### Generalized policy iteration

We use the term generalized policy iteration (GPI) to refer to the general 
idea of letting policy evaluation and policy improvement processes interact, 
independent of the granularity and other details of the two processes. 
Almost all reinforcement learning methods are well described as GPI. That 
is, all have identifiable policies and value functions, with the policy always 
being improved with respect to the value function and the value function 
always being driven toward the value function for the policy, as suggested 
by the diagram to the right. It is easy to see that if both the evaluation 
process and the improvement process stabilize, that is, no longer produce 
changes, then the value function and policy must be optimal. The value 
function stabilizes only when it is consistent with the current policy, and 
the policy stabilizes only when it is greedy with respect to the current value 
function. Thus, both processes stabilize only when a policy has been found 
that is greedy with respect to its own evaluation function. This implies 
that the Bellman optimality equation holds, and thus that the policy 
and the value function are optimal.

### Monte Carlo methods

Monte Carlo methods don't require a model and are conceptually simple, but 
are not well suited for step-by-step incremental computation.

Monte Carlo methods are ways of solving the reinforcement learning problem 
based on averaging sample returns. To ensure that well-defined returns are 
available, here we define Monte Carlo methods only for episodic tasks.

Monte Carlo methods sample and average returns for each state–action pair much 
like the bandit methods sample and average rewards for each action. The main 
difference is that now there are multiple states, each acting like a different 
bandit problem (like an associative-search or contextual bandit) and the different 
bandit problems are interrelated. That is, the return after taking an action 
in one state depends on the actions taken in later states in the same episode. 
Because all the action selections are undergoing learning, the problem becomes 
nonstationary from the point of view of the earlier state.

To handle the nonstationarity, we adapt the idea of general policy iteration (GPI) 
developed for DP. Whereas there we computed value functions from knowledge of the 
MDP, here we learn value functions from sample returns with the MDP. The value 
functions and corresponding policies still interact to attain optimality in 
essentially the same way (GPI).

#### Monte Carlo prediction

Suppose we wish to estimate $$v_\pi(s)$$, the value of a state $$s$$ under 
policy $$\pi$$, given a set of episodes obtained by following $$\pi$$ and 
passing through $$s$$. Each occurrence of state $$s$$ in an episode is 
called a visit to $$s$$. Of course, $$s$$ may be visited multiple times in 
the same episode; let us call the first time it is visited in an episode the 
first visit to $$s$$. The first-visit MC method estimates $$v_\pi(s)$$ 
as the average of the returns following first visits to $$s$$, whereas the 
every-visit MC method averages the returns following all visits to $$s$$.

First-visit MC prediction is

$$
\begin{align}
&\text{Initialize:} \\
&\quad \pi \leftarrow \text{ policy to be evaluted} \\
&\quad V \leftarrow \text{ an arbitrary state-value function} \\
&\quad Returns(s) \leftarrow \text{ an empty list, for all } s \in \mathcal{S} \\
&\text{Repeat forever:} \\
&\quad \text{Generate an episode using } \pi \\
&\quad \text{For each state } s \text{ appearing in the episode:} \\
&\qquad G \leftarrow \text{ the return that follows the first occurrence of } s \\
&\qquad \text{Append } G \text{ to } Returns(s) \\
&\qquad V(s) \leftarrow \text{average}(Returns(s))
\end{align}
$$

If a model is not available, then it is particularly useful to estimate 
action values rather than state values. With a model, state values alone 
are sufficient to determine a policy; one simply looks ahead one step 
and chooses whichever action leads to the best combination of reward and 
next state. Without a model, however, state values alone are not sufficient. 
One must explicitly estimate the value of each action in order for the 
values to be useful in suggesting a policy. Thus, one of our primary goals 
for Monte Carlo methods is to estimate $$q_∗$$. It is essentially the 
same as for state values, except now we use visits to a state-action 
pair rather than to a state.

The only complication is that many state–action pairs may never be visited. 
To compare alternatives we need to estimate the value of all the actions 
from each state. This is the general problem of maintaining exploration. 
One way to assure continual exploration is by specifying that the episodes 
start in a state–action pair, and that every pair has a nonzero probability 
of being selected as the start. This guarantees that all state–action 
pairs will be visited an infinite number of times in the limit of an infinite 
number of episodes. We call this the assumption of exploring starts.

#### Monte Carlo control

Let's consider how Monte Carlo estimation can be used in control, that is, 
to aproximate optimal policies. In Monte Carlo version of classical 
policy iteration, we perform alternating complete steps of policy 
evaluation and policy improvement. Policy evaluation is done by Monte 
Carlo estimation. Many episodes are experienced, with the approximate 
action-value function approaching the true function asymptotically. 
Policy improvement is done by making the policy greedy with respect 
to the current value functioin.

In order to easily obtain the guarantee of convergence for the Monte 
Carlo method, we make two unlikely assumptions. One is that the 
episodes have exploring starts, and the other is that policy 
evaluation is done with an infinite number of episodes.

Complete Monte Carlo with Exploring Starts is

$$
\begin{align}
&\text{Initialize, for all } s \in \mathcal{S}, a \in \mathcal{A}(s): \\
&\quad Q(s, a) \leftarrow \text{ arbitrary} \\
&\quad \pi(s) \leftarrow \text{ arbitrary} \\
&\quad Return(s, a) \leftarrow \text{ empty list} \\
&\text{Repeat forever:} \\
&\quad \text{Choose } S_0 \in \mathcal{S} \text{ and } A_0 \in \mathcal{A}(S_0) \text{ s.t. all pairs have probability } \gt 0 \\
&\quad \text{Generate an episode starting from } S_0, A_0, \text{ following } \pi \\
&\quad \text{For each pair } s, a \text{ appearing in the episode:} \\
&\qquad G \leftarrow \text{ the return that follows the first occurrence of } s, a \\
&\qquad \text{Append } G \text{ to } Returns(s, a) \\
&\qquad Q(s, a) \leftarrow \text{average}(Returns(s, a)) \\
&\quad \text{For each } s \text{ in the episode:} \\
&\qquad \pi(s) \leftarrow \arg\max_a Q(s, a)
\end{align}
$$

#### On-policy Monte Carlo control without exploring

To avoid the unlikely assumption of exploring starts, the only general way 
to ensure that all actions are selected infinitely often is for the agent 
to continue to select them. There are two approaches to ensuring this, 
resulting in on-policy methods and off-policy methods. On-policy methods 
attempt to evaluate or improve the policy that is used to make decisions, 
whereas off-policy methods evaluate or improve a policy different from 
that used to generate the data. The Monte Carlo ES method shown above is 
an example of an on-policy method.

In on-policy control methods the policy is generally soft, meaning that 
$$\pi(a|s) \gt 0$$ for all $$s \in \mathcal{S}$$ and all 
$$a \in \mathcal{A}(s)$$, but gradually shifted closer to a 
deterministic optimal policy.

The overall idea of on-policy Monte Carlo control ($$\epsilon\text{-soft}$$ policies) 
is still that of GPI. As in Monte Carlo ES, we use first-visit MC methods 
to estimate the action-value function for the current policy. Without the 
assumption of exploring starts, however, we cannot simply improve the policy 
by making it greedy with respect to the current value function, because 
that would prevent further exploration of nongreedy actions. Fortunately, 
GPI does not require that the policy be taken all the way to a greedy 
policy, only that it be moved toward a greedy policy.

$$
\begin{align}
&\text{Initialize, for all } s \in \mathcal{S}, a \in \mathcal{A}(s): \\
&\quad Q(s, a) \leftarrow \text{ arbitrary} \\
&\quad Returns(s, a) \leftarrow \text{ empty list} \\
&\quad \pi(a|s) \leftarrow \text{ an arbitrary } \epsilon\text{-soft policy} \\
&\text{Repeat forever:} \\
&\quad \text{(a) Generate an episode using } \pi \\
&\quad \text{(b) For each pair } s, a \text{ appearing in the episode:} \\
&\qquad G \leftarrow \text{ the return that follows the first occurrence of } s, a \\
&\qquad \text{Append } G \text{ to } Returns(s, a) \\
&\qquad Q(s, a) \leftarrow \text{average}(Returns(s, a)) \\
&\quad \text{(c) For each } s \text{ in the episode: } \\
&\qquad A^* \leftarrow \arg\max_a Q(s, a) \text{ (with ties broken arbitrarily)}\\
&\qquad \text{For all } a \in \mathcal{A}(s): \\
&\qquad\quad \pi(a|s) \leftarrow 
\begin{cases}
1 - \epsilon + \frac{\epsilon}{|\mathcal{A}(s)|} &\text{ if } a = A^* \\
\frac{\epsilon}{|\mathcal{A}(s)|} &\text{ if } a \neq A^*
\end{cases}
\end{align}
$$

#### Off-policy prediction via importance sampling

All learning control methods face a dilemma: They seek to learn action 
values conditional on subsequent optimal behaviour, but they need to 
behave non-optimally in order to explore all actions. The on-policy 
approach learns action values not for the optimal policy, but for a 
near-optimal policy that still explores. The off-policy learning 
uses two policies, one that is learned about and that becomes the 
optimal policy, and one that is more exploratory and is used to 
generate behaviour. The policy being learned about is called the 
target policy, and the policy used to generate behaviour is called 
the behaviour policy.

In the prediction problem for off-policy methods, both target and 
behaviour policies are fixed. Suppose we want to estimate $$v_\pi$$ 
or $$q_\pi$$, but all we have are episodes following another policy 
$$b$$, where $$b \neq \pi$$. In order to use episodes from $$b$$ to 
estimate values for $$\pi$$, we require that every action taken 
under $$\pi$$ is also taken, at least occasionally, under $$b$$. 
That is, we require that $$\pi(a|s) \gt 0$$ implies $$b(a|s) \gt 0$$. 
This is called the assumption of coverage. It follows from coverage 
that $$b$$ must be stochastic in states where it is not identical to 
$$\pi$$. The target policy $$\pi$$ may be deterministic, and in fact 
this is a case of particular interest in control problems. In control, 
the target policy is typically the deterministic greedy policy with 
respect to the current action-value function estimate. This policy 
becomes a deterministic optimal policy while the behaviour policy 
remains stochastic and more exploratory, for example, $$\epsilon\text{-greedy}$$ 
policy.

Almost all off-policy methods utilize importance sampling, a 
general technique for estimating expected values under one 
distribution given samples from another. We apply importance sampling 
to off-policy learning by weighting returns according to the 
relative probability of their trajectories occurring under the 
target and behaviour policies, called the importance-sampling ratio.

Given a starting state $$S_t$$, the probability of the subsequent 
state-action trajectory, $$A_t, S_{t+1}, A_{t+1}, \cdots, S_T$$, 
occurring under any policy $$\pi$$ is

$$
\begin{align}
&\text{Pr}\{A_t, S_{t+1}, A_{t+1}, \cdots, S_T | S_t, A_{t:T-1} \sim \pi\} \\
= &\pi(A_t | S_t)p(S_{t+1} | S_t, A_t)\pi(A_{t+1}|S_{t+1})\cdots p(S_T | S_{T-1}, A_{T-1}) \\
= &\prod_{k=t}^{T-1} \pi(A_k|S_k)p(S_{k+1}|S_k, A_k)
\end{align}
$$

where $$p$$ here is the state-transition probability function. Thus 
the relative probability of the trajectory under the target and 
behaviour policies (the importance-sampling ratio) is 

$$
\rho_{t:T-1} \doteq \frac{\prod_{k=t}^{T-1} \pi(A_k|S_k)p(S_{k+1}|S_k,A_k)}{\prod_{k=t}^{T-1}b(A_k|S_k)p(S_{k+1}|S_k,A_k)} = \prod_{k=t}^{T-1}\frac{\pi(A_k|S_k)}{b(A_k|S_k)}
$$

Although the trajectory probabilities depend on the MDP's transition 
probabilities, which are generally unknown, they appear identically 
in both the numerator and denominator, and thus cancel.

We define $$\mathcal{T}(s)$$ a set of all time steps in which 
state $$s$$ is visited for every-visited method, $$\mathcal{T}(s)$$ 
time steps that were first visits to $$s$$ within their episodes. 
We define $$T(t)$$ the first time of termination following 
time $$t$$, and $$G_t$$ the return after $$t$$ up through 
$$T(t)$$. Then $$\{G_t\}_{t \in \mathcal{T}(s)}$$ are the returns 
that pertain to state $$s$$, and $$\{\rho_{t:T(t)-1}\}_{t \in \mathcal{T}(s)}$$ 
are corresponding importance-sampling ratios. To estimate 
$$v_\pi(s)$$, we scale the returns by the ratios and average 
the results:

$$
V(s) \doteq \frac{\sum_{t \in \mathcal{T}(s)} \rho_{t:T(t) - 1} G_t}{|\mathcal{T}(s)|}
$$

When importance sampling is done as a simple average in this 
way it is called ordinary importance sampling.

An important alternative is weighted importance sampling, which 
uses a weighted average, defined as

$$
V(s) \doteq \frac{\sum_{t \in \mathcal{T}(s)} \rho_{t:T(t) - 1} G_t}{\sum_{t \in \mathcal{T}(s)} \rho_{t:T(t) - 1}}
$$

or zero if the denominator is zero.

In weighted-average estimate, the ratio $$\rho_{t:T(t)-1}$$ for 
the single return cancels in the numerator and denominator, so 
that the estimate is equal to the observed return independent 
of the ratio. As a result, the expectation is $$v_b(s)$$ rather 
than $$v_\pi(s)$$, and in statistical sense it is biased. In 
contrast, the simple average is always $$v_\pi(s)$$ in 
expectation, but it can be extreme.

The ordinary importance-sampling estimator is unbiased 
whereas the weighted importance-sampling estimator is biased. 
On the other hand, the variance of the ordinary 
importance-sampling estimator is in general unbounded 
because the variance of the ratios can be unbounded, whereas 
in the weighted estimator the largest weight on any 
single return is one. In fact, assuming bounded returns, 
the variance of the weighted importance-sampling estimator 
converges to zero even if the variance of the ratios 
themselves is infinite.

In practice, the weighted estimator usually has dramatically 
lower variance and is strongly preferred. The ordinary 
importance sampling is easier to extend to the approximate 
methods using function estimation.

Monte Carlo prediction methods can be implemented 
incrementally, on an episode-by-episode basis. For ordinary 
importance sampling, it has similar incremental methods 
as shown in previous section. For weighted importance 
sampling, the incremental algorithm is

$$
\begin{align}
&\text{Input: an arbitrary target policy } \pi \\
&\text{Initialize, for all } s \in \mathcal{S}, a \in \mathcal{A}(s): \\
&\quad Q(s, a) \leftarrow \text{arbitrary} \\
&\quad C(s, a) \leftarrow 0 \\
&\text{Repeat forever:} \\
&\quad b \leftarrow \text{ any policy with coverage of } \pi \\
&\quad \text{Generate an episode using } b: \\
&\qquad S_0, A_0, R_1, \cdots, S_{T-1}, A_{T-1}, R_T, S_T \\
&\quad G \leftarrow 0 \\
&\quad W \leftarrow 1 \\
&\quad \text{For } t = T - 1, T - 2, \cdots \text{ down to } 0: \\
&\qquad G \leftarrow \gamma G + R_{t+1} \\
&\qquad C(S_t, A_t) \leftarrow C(S_t, A_t) + W \\
&\qquad Q(S_t, A_t) \leftarrow Q(S_t, A_t) + \frac{W}{C(S_t, A_t)}[G - Q(S_t, A_t)] \\
&\qquad W \leftarrow W\frac{\pi(A_t|S_t)}{b(A_t|S_t)} \\
&\qquad \text{if } W = 0 \text{ then exit For loop}
\end{align}
$$

#### Off-policy Monte Carlo control

Based on GPI and weighted importance sampling, for 
estimating $$\pi_*$$ and $$q_*$$, the procedure for off-policy 
Monte Carlo control method is

$$
\begin{align}
&\text{Initialize, for all } s \in \mathcal{S}, a \in \mathcal{A}(s): \\
&\quad Q(s, a) \leftarrow \text{ arbitrary} \\
&\quad C(s, a) \leftarrow 0 \\
&\quad \pi(s) \leftarrow \arg\max_a Q(S_t, a) \text{ (with ties between consistently)} \\
&\text{Repeat forever:} \\
&\quad b \leftarrow \text{ any soft policy} \\
&\quad \text{Generate an episode using } b: \\
&\qquad S_0, A_0, R_1, \cdots, S_{T-1}, A_{T-1}, R_T, S_T \\
&\quad G \leftarrow 0 \\
&\quad W \leftarrow 1 \\
&\quad \text{For } t = T-1, T-2, \cdots \text{ down to } 0: \\
&\qquad G \leftarrow \gamma G + R_{t+1} \\
&\qquad C(S_t, A_t) \leftarrow C(S_t, A_t) + W \\
&\qquad Q(S_t, A_t) \leftarrow Q(S_t, A_t) + \frac{W}{C(S_t, A_t)}[G - Q(S_t, A_t)] \\
&\qquad \pi(S_t) \leftarrow \arg\max_a Q(S_t, a) \text{ (with ties broken consistently)} \\
&\qquad \text{If } A_t \neq \pi(S_t) \text{ then exit For loop} \\
&\qquad W \leftarrow W\frac{1}{b(A_t|S_t)}
\end{align}
$$

The behaviour policy $$b$$ can be anything, but in order 
to assure convergence of $$\pi$$ to the optimal policy, 
an infinite number of returns must be obtained for each 
pair of state and action. This can be assured by choosing 
$$b$$ to be $$\epsilon\text{-soft}$$. A potential problem 
is that this method learns only from the tails of episodes, 
when all of the remaining actions in the episode are 
greedy. If nongreedy actions are common, then learning 
will be slow, particularly for states appearing in the 
early portions of long episodes. There has been insufficient 
experience with off-policy Monte Carlo methods to assess 
how serious this problem is. If it is serious, the most 
important way to address it is probably by incorporating 
temporal-difference learning.

### Temporal-difference learning

Temporal-difference methods require no model and are fully incremental, but 
are more complex to analyze. Like Monte Carlo methods, TD methods can learn 
directly from raw experience without a model of the environment's dynamics. 
Like DP, TD methods update estimates based in part on other learned estimates, 
without waiting for a final outcome.

#### TD prediction

Roughly speaking, Monte Carlo methods wait until the return following the 
visit is known, then use that return as a target for $$V(S_t)$$. A simple 
every-visit Monte Carlo method suitable for nonstationary environment is

$$
V(S_t) \leftarrow V(S_t) + \alpha[G_t - V(S_t)]
$$

where $$G_t$$ is the actual return following time $$t$$, and $$\alpha$$ is 
a constant step-size parameter. This method is called $$\text{constant-}\alpha$$. 
Whereas Monte Carlo methods must wait until the end of the episode to 
determine the increment to $$V(S_t)$$, TD methods need to wait only until 
the next time step. At time $$t+1$$ they immediately form a target and make 
a useful update using the observed reward $$R_{t+1}$$ and estimate $$V(S_{t+1})$$. 
The simplest TD method makes the update 

$$
V(S_t) \leftarrow V(S_t) + \alpha[R_{t+1} + \gamma V(S_{t+1}) - V(S_t)]
$$

immediately on transition to $$S_{t+1}$$ and receiving $$R_{t+1}$$. In effect, 
the target for the Monte Carlo update is $$G_t$$, whereas the target for the 
TD update is $$R_{t+1} + \gamma V(S_{t+1})$$. This TD method is called $$TD(0)$$, 
or one-step TD, because it is a special case of the $$TD(\lambda)$$.

The procedure for $$TD(0)$$ is

$$
\begin{align}
&\text{Input: the policy } \pi \text{ to be evaluated} \\
&\text{Initialize } V(s) \text{ arbitrarily (e.g., } V(s) = 0 \text{, for all } s \in \mathcal{S}^+ \text{)} \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize } S\\
&\quad \text{Repeat (for each step of episode):} \\
&\qquad A \leftarrow \text{ action given by } \pi \text{ for } S \\
&\qquad \text{Take action } A \text{, observe } R, S' \\
&\qquad V(S) \leftarrow V(S) + \alpha [R + \gamma V(S') - V(S)] \\
&\qquad S \leftarrow S' \\
&\quad \text{until } S \text{ is terminal}
\end{align}
$$

Because $$TD(0)$$ bases its update in part on an existing estimate, we say that 
it is a bootstrapping method, like DP.

$$
\begin{align}
v_\pi(s) &\doteq \mathbb{E}_\pi [G_t | S_t = s] & \text{(eq 1)} \\
&= \mathbb{E}_\pi [R_{t+1} + \gamma G_{t+1} | S_t = s] & \text{(eq 2)} \\
&= \mathbb{E}_\pi [R_{t+1} + \gamma v_\pi(S_{t+1}) | S_t = s] & \text{(eq 3)}
\end{align}
$$

Roughly speaking, Monte Carlo methods use an estimate of $$text{(eq 1)}$$ 
as a target, whereas DP methods use an estimate of $$\text{(eq 3)}$$ as a 
target. The Monte Carlo target is an estimate because the expected value 
in $$text{(eq 1)}$$ is not known; a sample return is used in place of the 
real expected return. The DP target is an estimate not because of the 
expected values, which are assumed to be completely provided by a model 
of the environment, but because $$v_\pi(S_{t+1})$$ is not known and the 
current estimate, $$V(S_{t+1})$$, is used instead. The TD target is an 
estimate for both reasons: it samples the expected values in $$\text{(eq 3)}$$ 
and it uses the current estimate $$V$$ instead of the true $$v_\pi$$. 
Thus, TD methods combine the sampling of Monte Carlo with the bootstrapping 
of DP.

Note that the quantity in brackets in the $$TD(0)$$ update is a sort of 
error, measuring the difference between the estimated value of $$S_t$$ 
and the better estimte $$R_{t+1} + \gamma V(S_{t+1})$$. This quantity is 
called the TD error

$$
\delta \doteq R_{t+1} + \gamma V(S_{t+1}) - V(S_t)
$$

Notice that the TD error at each time is the error in the estimate made at 
that time. Because the TD error depends on the next state and next reward, 
it is not actually available until one time step later. Also note that if 
the array $$V$$ does not change during the episode (as it does not in Monte 
Carlo methods), then the Monte Carlo error can be written as a sum of TD 
errors. This identity is not exact if $$V$$ is updated during the episode 
(as it is in $$TD(0)$$), but if the step size is small then it may still 
hold approximately.

#### SARSA: on-policy TD control

Action value update rule is 

$$
Q(S_t, A_t) \leftarrow Q(S_t, A_t) + \alpha [R_{t+1} + \gamma Q(S_{t+1}, A_{t+1}) - Q(S_t, A_t)]
$$

The general form of the SARSA control algorithm is

$$
\begin{align}
&\text{Initialize } Q(s, a) \text{, for all } s \in \mathcal{S}, a \in \mathcal{A}(s) \text{, arbitrarily, and } Q(terminal\_state, \cdot) = 0 \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize } S \\
&\quad \text{Choose } A \text{ from } S \text{ using policy derived from } Q \text{ (e.g., } \epsilon\text{-greedy}\text{)} \\
&\quad \text{Repeat (for each step of episode):} \\
&\qquad \text{Take action } A \text{, observe } R, S' \\
&\qquad \text{Choose } A' \text{ from } S' \text{ using policy derived from } Q \text{ (e.g., } \epsilon\text{-greedy}\text{)} \\
&\qquad Q(S, A) \leftarrow Q(S, A) + \alpha [R + \gamma Q(S', A') - Q(S, A)] \\
&\qquad S \leftarrow S' \\
&\qquad A \leftarrow A' \\
&\quad \text{until } S \text{ is terminal}
\end{align}
$$

#### Q-learning: off-policy TD control

Q-learning is defined by

$$
Q(S_t, A_t) \leftarrow Q(S_t, A_t) + \alpha [R_{t+1} + \gamma \max_a Q(S_{t+1}, a) - Q(S_t, A_t)]
$$

In this case, the learned action-value function $$Q$$ directly approximates 
the optimal action-value function $$q_*$$, independent of the policy being 
followed.

The procedure for Q-learning is

$$
\begin{align}
&\text{Initialize } Q(s, a) \text{, for all } s \in \mathcal{S}, a \in \mathcal{A}(s) \text{, arbitrarily, and } Q(terminal\_state, \cdot) = 0 \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize } S \\
&\quad \text{Repeat (for each step of episode): } \\
&\qquad \text{Choose } A \text{ from } S \text{ using policy derived from } Q \text{ (e.g., } \epsilon\text{-greedy}\text{)} \\
&\qquad \text{Take action } A \text{, observe } R, S' \\
&\qquad Q(S, A) \leftarrow Q(S, A) + \alpha [R + \gamma \max_a Q(S', a) - Q(S, A)] \\
&\qquad S \leftarrow S' \\
&\quad \text{until } S \text{ is terminal}
\end{align}
$$

#### Expected SARSA

The expected SARSA follows the schema of Q-learning and moves deterministically 
in the same direction as SARSA moves in expectation

$$
\begin{align}
Q(S_t, A_t) &\leftarrow Q(S_t, A_t) + \alpha \left[R_{t+1} + \gamma \mathbb{E}[Q(S_{t+1}, A_{t+1}) | S_{t+1}] - Q(S_t, A_t)\right] \\
&\leftarrow Q(S_t, A_t) + \alpha \left[R_{t+1} + \gamma \sum_a \pi(a|S_{t+1})Q(S_{t+1}, a) - Q(S_t, A_t)\right]
\end{align}
$$

Expected SARSA is more complex computationally than SARSA but it eliminates 
the variance due to the random selection of $$A_{t+1}$$.

#### Maximization bias and double learning

In Q-learning the target policy is the greedy policy given the current 
action values, which is defined with a max, and in SARSA the policy is the 
$$\epsilon\text{-greedy}$$, which also involves a maximization operation. 
In these algorithms, a maximization over estimated values is used implicitly 
as an estimate of the maximum value, which can lead to a significant positive 
bias. Consider a single state $$s$$ where there are many actions $$a$$$ whose 
true values, $$q(s, a)$$, are all zero. The maximum of the true values is 
zero, but the maximum of the estimates is positive, a positive bias. This 
is called the maximization bias.

The maximization bias is due to using the same samples (plays) both to determine 
the maximizing action and to estimate its value. Suppose we divide the plays 
in two sets and use them to learn two independent estimates, call them 
$$Q_1(a)$$ and $$Q_2(a)$$, each an estimate of the true value $$q(a)$$, for 
all $$a \in \mathcal{A}$$. We could then use one estimate, say $$Q_1(a)$$, to 
determine the maximizing action $$A^* = \arg\max_a Q_1(a)$$, and the other, 
$$Q_2$$, to provide the estimate of its value, $$Q_2(A^*) = Q_2(\arg\max_a Q_2(a))$$. 
This estimate will then be unbiased in the sense that $$\mathbb{E}[Q_2(A^*)] = q(Q^*)$$. 
We can also repeat the process with the role of the two estimates reversed to 
yield a second unbiased estimate $$Q_1(\arg\max_a Q_2(a))$$. This is the idea 
of double learning. Note that although we learn two estimates, only one estimate 
is updated on each play; double learning doubles the memory requirements, but 
does not increase the amount of computation per step.

Double Q-learning divides the time steps in two, perhaps by flipping a coin 
on each step. If the coin comes up heads, the update is

$$
Q_1(S_t, A_t) \leftarrow Q_1(S_t, A_t) + \alpha [R_{t+1} + \gamma Q_2(S_{t+1}, \arg\max_a Q_1(S_{t+1}, a)) - Q_1(S_t, A_t)]
$$

If the coins comes up tails, then the same update is done with $$Q_1$$ and 
$$Q_2$$ switched, so that $$Q_2$$ is updated.

$$
\begin{align}
&\text{Initialize } Q_1(s, a) \text{ and } Q_2(s, a) \text{, for all } s \in \mathcal{S}, a \in \mathcal{A} \text{, arbitrarily} \\
&\text{Initialize } Q_1(terminal\_state, \cdot) = Q_2(terminal\_state, \cdot) = 0 \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize } S \\
&\quad \text{Repeat (for each step of episode):} \\
&\qquad \text{Choose } A \text{ from } S \text{ using policy derived from } Q_1 \text{ and } Q_2 \text{ (e.g., } \epsilon\text{-greedy in } Q_1 + Q_2\text{)} \\
&\qquad \text{Take action } A \text{, observe } R, S' \\
&\qquad \text{With } 0.5 \text{ probability:} \\
&\qquad\quad Q_1(S, A) \leftarrow Q_1(S, A) + \alpha \left(R + \gamma Q_2(S', \arg\max_a Q_1(S', a)) - Q_1(S, A)\right) \\
&\qquad \text{else:} \\
&\qquad\quad Q_2(S, A) \leftarrow Q_2(S, Q) + \alpha \left(R + \gamma Q_1(S', \arg\max_a Q_2(S', a)) - Q_2(S, A)\right) \\
&\qquad S \leftarrow S' \\
&\quad \text{until } S \text{ is terminal}
\end{align}
$$
 
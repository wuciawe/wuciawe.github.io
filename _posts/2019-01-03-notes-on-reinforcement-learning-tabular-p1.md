---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'notes on reinforcement learning, focused on tabular solution methods, part one'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Bandit problems

#### $$\epsilon\text{-greedy}$$ action selection

For a simple non-associative bandit algorithm, the $$\epsilon\text{-greedy}$$ 
averaging method is as

$$
\begin{align}
&\text{Initialize, for } a = 1 \text{ to } k\text{:} \\
&\quad Q(a) \leftarrow 0 \\
&\quad N(a) \leftarrow 0 \\
&\text{Repeat forever:} \\
&\quad A \leftarrow \begin{cases}
\arg\max_a Q(a) &\text{ with probability } 1 - \epsilon \\
\text{a random action} &\text{ with probability } \epsilon
\end{cases} \\
&\quad R \leftarrow \text{bandit}(A) \\
&\quad N(A) \leftarrow N(A) + 1 \\
&\quad Q(A) \leftarrow Q(A) + \frac{1}{N(A)}[R - Q(A)]
\end{align}
$$

where we denote the estimated value of action $$a$$ as $$Q(a)$$,  
which approaches to $$q_*(a)$$ (expected or mean reward given 
$$a$$). We denote the number of action $$a$$ has been selected 
as $$N(a)$$. And $$\frac{1}{N(a)}$$ is the step size.

#### upper-confidence-bound action selection

$$\epsilon\text{-greedy}$$ action selection forces the non-greedy 
actions to be tried, but indiscriminately, with no preference for those 
that are nearly greedy or particularly uncertain. It would be better 
to select among the non-greedy actions according to their potential 
for actually being optimal, taking into account both how close their 
estimates are to being maximal and the uncertainties in those 
estimates. The upper-confidence-bound action selection selects 
action according to

$$
A_t \doteq \arg\max_a \left[ Q_t(a) + c\sqrt{\frac{\ln t}{N_t(a)}}\right]
$$

where $$\ln t$$ denotes the natural logarithm of $$t$$, $$N_t(a)$$ 
denotes the number of times that action $$a$$ has been selected prior 
to time $$t$$, and the number $$c \gt 0$$ controls the degree of 
exploration. If $$N_t(a) = 0$$, then $$a$$ is considered to be a 
maximizing action.

The idea of UCB action selection is that the square-root term is a 
measure of the uncertainty or variance in the estimate of $$a$$’s 
value. The quantity being max’ed over is thus a sort of upper bound 
on the possible true value of action $$a$$, with $$c$$ determining 
the confidence level. Each time $$a$$ is selected the uncertainty is 
presumably reduced: $$N_t(a)$$ increments, and, as it appears in 
the denominator, the uncertainty term decreases. On the other hand, 
each time an action other than $$a$$ is selected, $$t$$ increases 
but $$N_t(a)$$ does not; because $$t$$ appears in the numerator, 
the uncertainty estimate increases. The use of the natural logarithm 
means that the increases get smaller over time, but are unbounded; all 
actions will eventually be selected, but actions with lower value 
estimates, or that have already been selected frequently, will be 
selected with decreasing frequency over time.

#### Gradient bandit algorithm

Both the $$\epsilon\text{-greedy}$$ and UCB estimate action values and 
use those estimates to select actions. We can also learn a numerical 
preference for each action $$a$$, which we denote $$H_t(a)$$. The larger 
the preference, the more often that action is taken, but the preference 
has no interpretation in terms of reward. Only the relative preference of 
one action over anohter is important, the action probabilities are determined 
according to a soft-max distribution:

$$
\text{Pr}\{A_t = a\} \doteq \frac{e^{H_t(a)}}{\sum_{b=1}^k e^{H_t(b)}} \doteq \pi_t(a)
$$

where $$\pi_t(a)$$ denotes the probability of taking action $$a$$ at 
time $$t$$. Initially all preferences are the same (e.g., $$H_1(a) = 0$$ 
for all $$a$$) so that all actions have an equal probability of being selected.

On each step, after selecting action $$A_t$$ and receiving the reward $$R_t$$, 
preferences are updated by

$$
\begin{align}
H_{t+1}(A_t) &\doteq H_t(A_t) + \alpha (R_t - \bar{R}_t)(1 - \pi_t(A_t)) \\
H_{t+1}(a) &\doteq H_t(a) - \alpha (R_t - \bar{R}_t) \pi_t(a) \quad \text{ for all } a \neq A_t
\end{align}
$$

where $$\alpha \gt 0$$ is a step-size parameter, and 
$$\bar{R}_t \in \mathbb{R}$$ is the average of all the rewards up through 
and including time $$t$$, which can be computed incrementally. The $$\bar{R}_t$$ 
term serves as a baseline with which the reward is compared. If the reward is 
higher than the baseline, then the probability of taking $$A_t$$ in the 
future is increased, and if the reward is below baseline, then probability is 
decreased. The non-selected actions move in the opposite direction.

#### Associative search (contextual bandits)

In non-associative tasks, the learner either tries to find a single best 
action when the task is stationary, or tries to track the best action as 
it changes over time when the task is non-stationary. However, in a general 
reinforcement learning task there is more than one situation, and the goal 
is to learn a policy: a mapping from situations to the actions that are best 
in those situations.

Associative search tasks are often now called contextual bandits in the 
literature. Associative search tasks are intermediate between the k-armed 
bandit problem and the full reinforcement learning problem. They are like 
the full reinforcement learning problem in that they involve learning a 
policy, but like k-armed bandit problem in that each action affects only 
the immediate reward. If actions are allowed to affect the next situation 
as well as the reward, then we have the full reinforcement learning 
problem.

#### Bayesian methods

Bayesian methods assume a known initial distribution over the action values 
and then update the distribution exactly after each step (assuming that the 
true action values are stationary). In general, the update computations can 
be very complex, but for certain special distributions (called conjugate 
priors) they are easy. One possibility is to then select actions at each 
step according to their posterior probability of being the best action. This 
method, sometimes called posterior sampling or Thompson sampling, often performs 
similarly to the best of the distribution-free methods described above.

In the Bayesian setting it is even conceivable to compute the optimal balance 
between exploration and exploitation. One can compute for any possible action 
the probability of each possible immediate reward and the resultant posterior 
distributions over action values. This evolving distribution becomes the 
information state of the problem. Given a horizon, say of 1000 steps, one can 
consider all possible actions, all possible resulting rewards, all possible 
next actions, all next rewards, and so on for all 1000 steps. Given the 
assumptions, the rewards and probabilities of each possible chain of events 
can be determined, and one need only pick the best. But the tree of possibilities 
grows extremely rapidly; even if there were only two actions and two rewards, 
the tree would have $$2^2000$$ leaves. It is generally not feasible to perform 
this immense computation exactly, but perhaps it could be approximated efficiently. 
This approach would effectively turn the bandit problem into an instance of the 
full reinforcement learning problem. In the end, we may be able to use 
approximate reinforcement learning methods to approach this optimal solution.

### Finite Markov decision process

MDPs are a mathematically idealized form of the reinforcement learning problem 
for which precise theoretical statements can be made.

Finite MDP involves evaluative feedback, as in bandits, but also an associative 
aspect—choosing different actions in different situations. MDPs are a classical 
formalization of sequential decision making, where actions influence not just 
immediate rewards, but also subsequent situations, or states, and through those 
future rewards. Thus MDPs involve delayed reward and the need to tradeoff 
immediate and delayed reward. Whereas in bandit problems we estimated the value 
$$q_∗(a)$$ of each action $$a$$, in MDPs we estimate the value $$q_∗(s,a)$$ 
of each action $$a$$ in each state $$s$$, or we estimate the value 
$$v_∗(s)$$ of each state given optimal action selections. These state-dependent 
quantities are essential to accurately assigning credit for long-term consequences 
to individual action selections.

In a finite MDP, the sets of states, actions, and rewards 
$$(\mathcal{S}, \mathcal{A}, \text{ and } \mathcal{R})$$ all have a finite 
number of elements. In this case, the random variables $$R_t$$ and $$S_t$$ 
have well defined discrete probability distributions dependent only on the 
preceding state and action. That is, for particular values of these random variables, 
$$s' \in \mathcal{S}$$ and $$r \in \mathcal{R}$$, there is a probability of 
those values occurring at time $$t$$, given particular values of the preceding 
state and action:

$$
p(s', r | s, a) \doteq \text{Pr}\{S_t = s', R_t = r | S_{t-1} = s, A_{t-1} = a\}
$$

for all $$s', s \in \mathcal{S}$$, and $$a \in \mathcal{A}(s)$$. The function 
$$p: \mathcal{S} \times \mathcal{R} \times \mathcal{S} \times \mathcal{A} \rightarrow [0, 1]$$ 
is an ordinary deterministic function of four arguments, and it specifies a 
probability distribution for each choice of $$s$$ and $$a$$,

$$
\sum_{s' \in \mathcal{S}}\sum_{r \in \mathcal{R}} p(s', r | s, a) = 1 \text{, for all } s \in \mathcal{S}, a \in \mathcal{A}(s)
$$

The probabilities given by the four-argument function $$p$$ completely 
characterize the dynamics of a finite MDP. The state-transition probabilities 
is 

$$
p(s' | s, a) \doteq \text{Pr}\{S_t = s' | S_{t-1} = s, A_{t-1} = a\} = \sum_{r \in \mathcal{R}} p(s', r | s, a)
$$

and the expected rewards for state-action pairs is 

$$
r(s, a) \doteq \mathbb{E}[R_t | S_{t-1} = s, A_{t-1} = a] = \sum_{r \in \mathcal{R}}r\sum_{s' \in \mathcal{S}}p(s', r | s, a)
$$

and the expectd rewards for state-action-next-state is

$$
r(s, a, s') \doteq \mathbb{E}[R_t | S_{t-1} = s, A_{t-1} = a, S_t = s'] = \sum_{r \in \mathcal{R}}r\frac{p(s', r | s, a)}{p(s' | s, a)}
$$

#### Return

For MDP, we seek to maximize the expected return, where the return, denoted 
$$G_t$$, is defined as some specific function of the reward sequence.

In the simplest case the return is the sum of the rewards:

$$
G_t \doteq R_{t+1} + R_{t+2} + R_{t+3} + \cdots + R_{T}
$$

where $$T$$ is a final time step. This approach makes sense in applications 
in which there is a natural notion of final time step, that is, when the 
agent-environment interaction breaks naturally into subsequences, which we 
call episodes. Each episode ends in a special state called the terminal state, 
followed by a reset to a standard starting state or to a sample from a 
standard distribution of starting states.

On the other hand, in many cases the agent-environment interaction does not 
break naturally into identifiable episodes, but goes on continually without 
limit. We call these continuing tasks. In this case, using the sum of the 
rewards as the return is problematic.

The discounted return is defined as

$$
G_t \doteq R_{t+1} + \gamma R_{t+2} + \gamma^2 R_{t+3} + \cdots = \sum_{k=0}^\infty \gamma^k R_{t+k+1} = \sum_{k = t+1}^\infty \gamma^{k-t-1}R_k
$$

where $$\gamma$$ is a parameter, $$0 \leq \gamma \leq 1$$, called the 
discount rate.

#### Policies and value functions

Almost all reinforcement learning algorithms involve estimating value 
functions -- functions of states (or of state-action pairs) that 
estimate how good it is for the agent to be in a given state (or how 
good it is to perform a given action in a given state). The value functions 
are defined with respect to particular ways of acting, called polices.

A policy is a mapping from states to probabilities of selecting each 
possible action. If the agent is following policy $$\pi$$ at time 
$$t$$, then $$\pi(a\|s)$$ is the probability that $$A_t = a$$ if 
$$S_t = s$$.

The value of a state $$s$$ under a policy $$\pi$$, denoted 
$$v_\pi(s)$$, is the expected return when starting in $$s$$ and 
following $$\pi$$ thereafter. 

$$
v_\pi(s) \doteq \mathbb{E}[G_t | S_t = s] = \mathbb{E}_\pi \left[\sum_{k=0}^\infty \gamma^k R_{t+k+1} | S_t = s\right] \text{, for all } s \in \mathcal{S}
$$

We call function $$v_\pi$$ the state-value function for policy 
$$\pi$$.

Similarly, we define the value of taking action $$a$$ in state $$s$$ 
under a policy $$\pi$$, denoted $$q_\pi(s, a)$$, as the expected 
return starting from $$s$$, taking the action $$a$$, and thereafter 
following policy $$\pi$$

$$
q_\pi(s, a) \doteq \mathbb{E}_\pi[G_t | S_t = s, A_t = a] = \mathbb{E}_\pi \left[\sum_{k=0}^\infty \gamma^k R_{t+k+1} | S_t = s, A_t = a\right]
$$

We call $$q_\pi$$ the action-value function for policy $$\pi$$.

For any policy $$\pi$$ and any state $$s$$, the following consistency 
condition holds between the value of $$s$$ and the value of its 
possible successor states

$$
\begin{align}
v_\pi(s) &\doteq \mathbb{E}_\pi [G_t | S_t = s] \\
&= \mathbb{E}_\pi [R_{t+1} + \gamma G_{t+1} | S_t = s] \\
&= \sum_a \pi(a|s) \sum_{s'}\sum_r p(s', r | s, a)\left[r + \gamma \mathbb{E}_\pi [G_{t+1} | S_{t+1} = s']\right] \\
&= \sum_a \pi(a|s) \sum_{s', r} p(s', r | s, a)[r + \gamma v_\pi(s')] \text{, for all } s \in \mathcal{S}
\end{align}
$$

The above equation is the Bellman equation for $$v_\pi$$. It expresses 
a relationship between the value of a state and the values of its 
successor states. The value function $$v_\pi$$ is the unique solution 
to its Bellman equation.

#### Optimal policies and optimal value functions

A policy $$\pi$$ is defined to be better than or equal to a policy 
$$\pi '$$ if its expected return is greater than or equal to that of 
$$\pi '$$ for all states, $$\pi \geq \pi '$$ if and only if 
$$v_\pi(s) \geq v_{\pi '}(s)$$ for all $$s \in \mathcal{S}$$. 
There is always at least one policy that is better than or equal to all 
other policies. This is an optimal policy. Although there may be 
more than one, we denote all the optimal policies by $$\pi_*$$. 
They share the same state-value function, called the optimal state-value 
function, denoted $$v_*$$, and defined as

$$
v_*(s) \doteq \max_\pi v_\pi (s)
$$

for all $$s \in \mathcal{S}$$.

Optimal policies also share the same optimal action-value function, 
denoted $$q_*$$, and defined as 

$$
q_*(s, a) \doteq \max_\pi q_\pi (s, a)
$$

for all $$s \in \mathcal{S}$$ and $$a \in \mathcal{A}(s)$$. For the 
state-action pair $$(s, a)$$, this function gives the expected return 
for taking action $$a$$ in state $$s$$ and thereafter following an 
optimal policy. Thus, we can write $$q_*$$ in terms of $$v_*$$ 
as follows

$$
q_*(s, a) = \mathbb{E}[R_{t+1} + \gamma v_*(S_{t+1}) | S_t = s, A_t = a]
$$

Because $$v_*$$ is the value function for a policy, it must satisfy 
the self-consistency condition given by the Bellman equation for state 
values. Because it is the optimal value function, however, $$v_*$$'s 
consistency condition can be written in a special form without reference 
to any specific policy. This is the Bellman equation for $$v_*$$, or 
the Bellman optimality equation. Intuitively, the Bellman optimality 
equation expresses the fact that the value of a state under an optimal 
policy must equal the expected return for the best action from that 
state:

$$
\begin{align}
v_*(s) &= \max_{a \in \mathcal{A}(s)} q_{\pi_*}(s, a) \\
&= \max_a \mathbb{E}_{\pi_*}[G_t | S_t = s, A_t = a] \\
&= \max_a \mathbb{E}_{\pi_*}[R_{t+1} + \gamma G_{t+1} | S_t = s, A_t = a] \\
&= \max_a \mathbb{E}[R_{t+1} + \gamma v_*(S_{t+1}) | S_t = s, A_t = a] \\
&= \max_a \sum_{s', r} p(s', r | s, a)[r + \gamma v_* (s')]
\end{align}
$$

The last two equations are two forms of the Bellman optimality equation 
for $$v_*$$. The Bellman optimality equation for $$q_*$$ is

$$
\begin{align}
q_*(s, a) &= \mathbb{E}[R_{t+1} + \gamma \max_{a'} q_* (S_{t+1}, a') | S_t = s, A_t = a] \\
&= \sum_{s', r} p(s', r | s, a) [r + \gamma \max_{a'} q_*(s', a')]
\end{align}
$$

For finite MDPs, the Bellman optimality equation for $$v_\pi$$ has a 
unique solution independent of the policy. The Bellman optimality equation 
is actually a system of equations, one for each state, so if there are 
$$n$$ states, then there are $$n$$ equations in $$n$$ unknowns. If 
the dynamics $$p$$ of the environment are known, then in principle one 
can solve this system of equations for $$v_∗$$ using any one of a 
variety of methods for solving systems of nonlinear equations. One can 
solve a related set of equations for $$q_∗$$.

Once one has $$v_∗$$, it is relatively easy to determine an optimal 
policy. For each state $$s$$, there will be one or more actions at which 
the maximum is obtained in the Bellman optimality equation. Any policy 
that assigns nonzero probability only to these actions is an optimal policy. 
You can think of this as a one-step search.

Having $$q_∗$$ makes choosing optimal actions even easier. With 
$$q_∗$$, the agent does not even have to do a one-step-ahead search: 
for any state $$s$$, it can simply find any action that maximizes 
$$q_∗(s,a)$$. The action-value function effectively caches the results 
of all one-step-ahead searches. It provides the optimal expected long-term 
return as a value that is locally and immediately available for each 
state–action pair. Hence, at the cost of representing a function of 
state–action pairs, instead of just of states, the optimal action-value 
function allows optimal actions to be selected without having to know 
anything about possible successor states and their values, that is, 
without having to know anything about the environment’s dynamics.

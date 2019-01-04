---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'notes on reinforcement learning, focused on tabular solution methods'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Bandit problems

#### \\(\epsilon\text{-greedy}\\) action selection

For a simple non-associative bandit algorithm, the \\(\epsilon\text{-greedy}\\) 
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

where we denote the estimated value of action \\(a\\) as \\(Q(a)\\),  
which approaches to \\(q_\*(a)\\) (expected or mean reward given 
\\(a\\)). We denote the number of action \\(a\\) has been selected 
as \\(N(a)\\). And \\(\frac{1}{N(a)}\\) is the step size.

#### upper-confidence-bound action selection

\\(\epsilon\text{-greedy}\\) action selection forces the non-greedy 
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

where \\(\ln t\\) denotes the natural logarithm of \\(t\\), \\(N_t(a)\\) 
denotes the number of times that action \\(a\\) has been selected prior 
to time \\(t\\), and the number \\(c \gt 0\\) controls the degree of 
exploration. If \\(N_t(a) = 0\\), then \\(a\\) is considered to be a 
maximizing action.

The idea of UCB action selection is that the square-root term is a 
measure of the uncertainty or variance in the estimate of \\(a\\)’s 
value. The quantity being max’ed over is thus a sort of upper bound 
on the possible true value of action \\(a\\), with \\(c\\) determining 
the confidence level. Each time \\(a\\) is selected the uncertainty is 
presumably reduced: \\(N_t(a)\\) increments, and, as it appears in 
the denominator, the uncertainty term decreases. On the other hand, 
each time an action other than \\(a\\) is selected, \\(t\\) increases 
but \\(N_t(a)\\) does not; because \\(t\\) appears in the numerator, 
the uncertainty estimate increases. The use of the natural logarithm 
means that the increases get smaller over time, but are unbounded; all 
actions will eventually be selected, but actions with lower value 
estimates, or that have already been selected frequently, will be 
selected with decreasing frequency over time.

#### Gradient bandit algorithm

Both the \\(\epsilon\text{-greedy}\\) and UCB estimate action values and 
use those estimates to select actions. We can also learn a numerical 
preference for each action \\(a\\), which we denote \\(H_t(a)\\). The larger 
the preference, the more often that action is taken, but the preference 
has no interpretation in terms of reward. Only the relative preference of 
one action over anohter is important, the action probabilities are determined 
according to a soft-max distribution:

$$
\text{Pr}\{A_t = a\} \doteq \frac{e^{H_t(a)}}{\sum_{b=1}^k e^{H_t(b)}} \doteq \pi_t(a)
$$

where \\(\pi_t(a)\\) denotes the probability of taking action \\(a\\) at 
time \\(t\\). Initially all preferences are the same (e.g., \\(H_1(a) = 0\\) 
for all \\(a\\)) so that all actions have an equal probability of being selected.

On each step, after selecting action \\(A_t\\) and receiving the reward \\(R_t\\), 
preferences are updated by

$$
\begin{align}
H_{t+1}(A_t) &\doteq H_t(A_t) + \alpha (R_t - \bar{R}_t)(1 - \pi_t(A_t)) \\
H_{t+1}(a) &\doteq H_t(a) - \alpha (R_t - \bar{R}_t) \pi_t(a) \quad \text{ for all } a \neq A_t
\end{align}
$$

where \\(\alpha \gt 0\\) is a step-size parameter, and 
\\(\bar{R}_t \in \mathbb{R}\\) is the average of all the rewards up through 
and including time \\(t\\), which can be computed incrementally. The \\(\bar{R}_t\\) 
term serves as a baseline with which the reward is compared. If the reward is 
higher than the baseline, then the probability of taking \\(A_t\\) in the 
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
the tree would have \\(2^2000\\) leaves. It is generally not feasible to perform 
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
\\(q_\∗(a)\\) of each action \\(a\\), in MDPs we estimate the value \\(q_\∗(s,a)\\) 
of each action \\(a\\) in each state \\(s\\), or we estimate the value 
\\(v_\∗(s)\\) of each state given optimal action selections. These state-dependent 
quantities are essential to accurately assigning credit for long-term consequences 
to individual action selections.

In a finite MDP, the sets of states, actions, and rewards 
\\((\mathcal{S}, \mathcal{A}, \text{ and } \mathcal{R})\\) all have a finite 
number of elements. In this case, the random variables \\(R_t\\) and \\(S_t\\) 
have well defined discrete probability distributions dependent only on the 
preceding state and action. That is, for particular values of these random variables, 
\\(s' \in \mathcal{S}\\) and \\(r \in \mathcal{R}\\), there is a probability of 
those values occurring at time \\(t\\), given particular values of the preceding 
state and action:

$$
p(s', r | s, a) \doteq \text{Pr}\{S_t = s', R_t = r | S_{t-1} = s, A_{t-1} = a\}
$$

for all \\(s', s \in \mathcal{S}\\), and \\(a \in \mathcal{A}(s)\\). The function 
\\(p: \mathcal{S} \times \mathcal{R} \times \mathcal{S} \times \mathcal{A} \rightarrow [0, 1]\\) 
is an ordinary deterministic function of four arguments, and it specifies a 
probability distribution for each choice of \\(s\\) and \\(a\\),

$$
\sum_{s' \in \mathcal{S}}\sum_{r \in \mathcal{R}} p(s', r | s, a) = 1 \text{, for all } s \in \mathcal{S}, a \in \mathcal{A}(s)
$$

The probabilities given by the four-argument function \\(p\\) completely 
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
\\(G_t\\), is defined as some specific function of the reward sequence.

In the simplest case the return is the sum of the rewards:

$$
G_t \doteq R_{t+1} + R_{t+2} + R_{t+3} + \cdots + R_{T}
$$

where \\(T\\) is a final time step. This approach makes sense in applications 
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

where \\(\gamma\\) is a parameter, \\(0 \leq \gamma \leq 1\\), called the 
discount rate.

#### Policies and value functions

Almost all reinforcement learning algorithms involve estimating value 
functions -- functions of states (or of state-action pairs) that 
estimate how good it is for the agent to be in a given state (or how 
good it is to perform a given action in a given state). The value functions 
are defined with respect to particular ways of acting, called polices.

A policy is a mapping from states to probabilities of selecting each 
possible action. If the agent is following policy \\(\pi\\) at time 
\\(t\\), then \\(\pi(a\|s)\\) is the probability that \\(A_t = a\\) if 
\\(S_t = s\\).

The value of a state \\(s\\) under a policy \\(\pi\\), denoted 
\\(v_\pi(s)\\), is the expected return when starting in \\(s\\) and 
following \\(\pi\\) thereafter. 

$$
v_\pi(s) \doteq \mathbb{E}[G_t | S_t = s] = \mathbb{E}_\pi \left[\sum_{k=0}^\infty \gamma^k R_{t+k+1} | S_t = s\right] \text{, for all } s \in \mathcal{S}
$$

We call function \\(v_\pi\\) the state-value function for policy 
\\(\pi\\).

Similarly, we define the value of taking action \\(a\\) in state \\(s\\) 
under a policy \\(\pi\\), denoted \\(q_\pi(s, a)\\), as the expected 
return starting from \\(s\\), taking the action \\(a\\), and thereafter 
following policy \\(\pi\\)

$$
q_\pi(s, a) \doteq \mathbb{E}_\pi[G_t | S_t = s, A_t = a] = \mathbb{E}_\pi \left[\sum_{k=0}^\infty \gamma^k R_{t+k+1} | S_t = s, A_t = a\right]
$$

We call \\(q_\pi\\) the action-value function for policy \\(\pi\\).

For any policy \\(\pi\\) and any state \\(s\\), the following consistency 
condition holds between the value of \\(s\\) and the value of its 
possible successor states

$$
\begin{align}
v_\pi(s) &\doteq \mathbb{E}_\pi [G_t | S_t = s] \\
&= \mathbb{E}_\pi [R_{t+1} + \gamma G_{t+1} | S_t = s] \\
&= \sum_a \pi(a|s) \sum_{s'}\sum_r p(s', r | s, a)\left[r + \gamma \mathbb{E}_\pi [G_{t+1} | S_{t+1} = s']\right] \\
&= \sum_a \pi(a|s) \sum_{s', r} p(s', r | s, a)[r + \gamma v_\pi(s')] \text{, for all } s \in \mathcal{S}
\end{align}
$$

The above equation is the Bellman equation for \\(v_\pi\\). It expresses 
a relationship between the value of a state and the values of its 
successor states. The value function \\(v_\pi\\) is the unique solution 
to its Bellman equation.

#### Optimal policies and optimal value functions

A policy \\(\pi\\) is defined to be better than or equal to a policy 
\\(\pi '\\) if its expected return is greater than or equal to that of 
\\(\pi '\\) for all states, \\(\pi \geq \pi '\\) if and only if 
\\(v_\pi(s) \geq v_{\pi '}(s)\\) for all \\(s \in \mathcal{S}\\). 
There is always at least one policy that is better than or equal to all 
other policies. This is an optimal policy. Although there may be 
more than one, we denote all the optimal policies by \\(\pi_\*\\). 
They share the same state-value function, called the optimal state-value 
function, denoted \\(v_\*\\), and defined as

$$
v_*(s) \doteq \max_\pi v_\pi (s) \text{
$$

for all \\(s \in \mathcal{S}\\).

Optimal policies also share the same optimal action-value function, 
denoted \\(q_\*\\), and defined as 

$$
q_*(s, a) \doteq \max_\pi q_\pi (s, a)
$$

for all \\(s \in \mathcal{S}\\) and \\(a \in \mathcal{A}(s)\\). For the 
state-action pair \\((s, a)\\), this function gives the expected return 
for taking action \\(a\\) in state \\(s\\) and thereafter following an 
optimal policy. Thus, we can write \\(q_\*\\) in terms of \\(v_\*\\) 
as follows

$$
q_*(s, a) = \mathbb{E}[R_{t+1} + \gamma v_*(S_{t+1}) | S_t = s, A_t = a]
$$

Because \\(v_\*\\) is the value function for a policy, it must satisfy 
the self-consistency condition given by the Bellman equation for state 
values. Because it is the optimal value function, however, \\(v_\*\\)'s 
consistency condition can be written in a special form without reference 
to any specific policy. This is the Bellman equation for \\(v_\*\\), or 
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
for \\(v_\*\\). The Bellman optimality equation for \\(q_\*\\) is

$$
\begin{align}
q_*(s, a) &= \mathbb{E}[R_{t+1} + \gamma \max_{a'} q_* (S_{t+1}, a') | S_t = s, A_t = a] \\
&= \sum_{s', r} p(s', r | s, a) [r + \gamma \max_{a'} q_*(s', a')]
\end{align}
$$

For finite MDPs, the Bellman optimality equation for \\(v_\pi\\) has a 
unique solution independent of the policy. The Bellman optimality equation 
is actually a system of equations, one for each state, so if there are 
\\(n\\) states, then there are \\(n\\) equations in \\(n\\) unknowns. If 
the dynamics \\(p\\) of the environment are known, then in principle one 
can solve this system of equations for \\(v_\∗\\) using any one of a 
variety of methods for solving systems of nonlinear equations. One can 
solve a related set of equations for \\(q_\∗\\).

Once one has \\(v_\∗\\) , it is relatively easy to determine an optimal 
policy. For each state \\(s\\), there will be one or more actions at which 
the maximum is obtained in the Bellman optimality equation. Any policy 
that assigns nonzero probability only to these actions is an optimal policy. 
You can think of this as a one-step search.

Having \\(q_\∗\\) makes choosing optimal actions even easier. With 
\\(q_\∗\\) , the agent does not even have to do a one-step-ahead search: 
for any state \\(s\\), it can simply find any action that maximizes 
\\(q_\∗(s,a)\\). The action-value function effectively caches the results 
of all one-step-ahead searches. It provides the optimal expected long-term 
return as a value that is locally and immediately available for each 
state–action pair. Hence, at the cost of representing a function of 
state–action pairs, instead of just of states, the optimal action-value 
function allows optimal actions to be selected without having to know 
anything about possible successor states and their values, that is, 
without having to know anything about the environment’s dynamics.

### Dynamic programming

Dynamic programming methods are well developed mathematically, but require a 
complete and accurate model of the environment.

#### Policy evaluation (prediction)

Policy evaluation is to compute the state-value function \\(v_\pi\\) 
for an arbitrary policy \\(\pi\\).

$$
\begin{align}
v_{k+1}(s) &\doteq \mathbb{E}_\pi [R_{t+1} + \gamma v_k (S_{t+1}) | S_t = s] \\
&= \sum_a \pi(a|s) \sum_{s', r}p(s', r | s, a)[r + \gamma v_k (s')]
\end{align}
$$

for all \\(s \in \mathcal{S}\\). \\(v_k = v_\pi\\) is a fixed point for 
this update rule because the Bellman equation for \\(v_\pi\\) assures 
us of euquality in this case. This algorithm is called iterative policy 
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
better policies. Suppose we have determined the value function \\(v_\pi\\) 
for an arbitrary deterministic policy \\(\pi\\). For some state \\(s\\) we 
would like to know whether or not we should change the policy to 
deterministically choose an action \\(a \neq \pi(s)\\). We know how good it 
is to follow the current policy from \\(s\\), that is \\(v_\pi(s)\\), but 
would it be better or worse to change to the new policy? One way to answer 
this question is to consider selecting \\(a\\) in \\(s\\) and thereafter 
following the existing policy \\(\pi\\). The value of this way of 
behaving is 

$$
\begin{align}
q_\pi(s, a) &\doteq \mathbb{E}[R_{t+1} + \gamma v_\pi (S_{t+1}) | S_t = s, A_t = a] \\
&= \sum_{s', r} p(s', r | s, a)[r + \gamma v_\pi(s')]
\end{align}
$$

If it is greater than \\(v_\pi(s)\\), that is, if it is better to select 
\\(a\\) once in \\(s\\) and thereafter follow \\(\pi\\) than it would be 
to follow \\(\pi\\) all the time, then one would expect it to be better 
still to select \\(a\\) every time \\(s\\) is encountered, and that the 
new policy would in fact be a better one overall.

That this is true is a special case of a general result called the 
policy improvement theorem. Let \\(\pi\\) and \\(\pi '\\) be any pair of 
deterministic policies such that, for all \\(s \in \mathcal{S}\\),

$$
q_\pi(s, \pi ' (s)) \geq v_\pi (s)
$$

Then the policy \\(\pi '\\) must be as good as, or better than, \\(\pi\\). 
That is, it must obtain greater or equal expected return from all 
states \\(s \in \mathcal{S}\\)

$$
v_{\pi '}(s) \geq v_\pi (s)
$$

So far we have seen how, given a policy and its value function, we can 
easily evaluate a change in the policy at a single state to a particular 
action. It is a natural extension to consider changes at all states and to 
all possible actions, selecting at each state the action that appears 
best according to \\(q_\pi(s, a)\\). In other words, to consider the new 
greedy policy \\(\pi '\\), given by

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

In the general case, a stochastic policy \\(\pi\\) specifies probabilities, 
\\(\pi(a\|s)\\), for taking each actioin, \\(a\\), in each state, \\(s\\). 
The idea of improvement of deterministic policies extend to stochastic 
policies.

#### Policy iteration

Once a policy \\(\pi\\) has been improved using \\(v_\pi\\) to yield a 
better policy \\(\pi '\\), we can then compute \\(v_{\pi '}\\) and 
improve it again to yield an even better \\(\pi ''\\). This way of 
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
done iteratively, then convergence exactly to \\(v_\pi\\) occurs only in 
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

for all \\(s \in \mathcal{S}\\).

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

Suppose we wish to estimate \\(v_\pi(s)\\), the value of a state \\(s\\) under 
policy \\(\pi\\), given a set of episodes obtained by following \\(\pi\\) and 
passing through \\(s\\). Each occurrence of state \\(s\\) in an episode is 
called a visit to \\(s\\). Of course, \\(s\\) may be visited multiple times in 
the same episode; let us call the first time it is visited in an episode the 
first visit to \\(s\\). The first-visit MC method estimates \\(v_\pi(s)\\) 
as the average of the returns following first visits to \\(s\\), whereas the 
every-visit MC method averages the returns following all visits to \\(s\\).

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
for Monte Carlo methods is to estimate \\(q_\∗\\). It is essentially the 
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
\\(\pi(a\|s) \gt 0\\) for all \\(s \in \mathcal{S}\\) and all 
\\(a \in \mathcal{A}(s)\\), but gradually shifted closer to a 
deterministic optimal policy.

The overall idea of on-policy Monte Carlo control (\\(\epsilon\text{-soft}\\) policies) 
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



### Temporal-difference learning

Temporal-difference methods require no model and are fully incremental, but 
are more complex to analyze.

### Eligibility traces

### 

https://datascience.stackexchange.com/questions/26938/what-exactly-is-bootstrapping-in-reinforcement-learning

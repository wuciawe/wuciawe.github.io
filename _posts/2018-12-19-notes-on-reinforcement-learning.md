---
layout: post
category: [machine learning, math]
tags: [machine learning, math, reinforcement learning]
infotext: 'notes on reinforcement learning'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Introduction of reinforcement learning

Reinforcement learning sits at the intersection of many different fields of science.

[!] faces of reinforcement learning

Reinforcement learning differentiates from other machine learning paradigms in 
following ways: there is no supervior, only a reward signal; feedback is delayed, 
not instantaneous; time matters (sequential, non-i.i.d data); agent's actions 
affect the subsequent data it receives.

#### Rewards

A reward \\(R_t\\) is a scalar feedback signal, which indicates how well agent is 
doing at step \\(t\\). The agent's job is to maximise cumulative reward.

Reinforcement learning is based on the reward hypothesis: all goals can be 
described by the maximisation of expected cumulative reward.

#### Agent and environment

At each step \\(t\\) the agent executes action \\(A_t\\), receives observation 
\\(O_t\\), and receives scalar reward \\(R_t\\). The environment receives action 
\\(A_t\\), emits observation \\(O_{t+1}\\), and emits scalar reward \\(R_{t+1}\\).

#### History and state

The history is the sequence of observations, actions, rewards

$$
H_t = O_1, R_1, A_1, \cdots, A_{t-1}, O_t, R_t
$$

According to the history, the agent selects actions and the environment selects 
observations/rewards. State is the information used to determine what happens 
next. Formally, state is a function of the history:

$$
S_t = f(H_t)
$$

The environment state \\(S_t^e\\) is the environment's private representation. 
Whatever data the environment uses to pick the next observation/reward. The 
environment state is not usually visible to the agent. Even if \\(S_t^e\\) is 
visible, it may contain irrelevant information.

The agent state \\(S_t^a\\) is the agent's internal representation. Whatever 
information the agent uses to pick the next action. It is the information 
used by reinforcement learning algorithms. It can be any function of history 
\\(S_t^a = f(H_t)\\).

##### Information state

An information state (a.k.a Markov state) contains all useful information 
from the history.

A state \\(S_t\\) is Markov if and only if \\(P[S_{t+1}\|S_t] = P[S_{t+1}\|S_1,\cdots,S_t]\\).

It means the future is independent of the past given the present, once 
the state is known, the history may be thrown away.

#### Fully observable environments

Agent directly observes environment state, \\(O_t = S_t^a = S_t^e\\). 
Formally, this is a Markov decision process.

#### Partially observable environments

Agent indirectly observes environment, the agent state is not 
the same as environment state. Formally this is a partially 
observable Markov decision process.

Agent must construct its own state representation \\(S_t^a\\), e.g. 

- complete history: \\(S_t^a = H_t\\)
- beliefs of environment state: \\(S_t^a = (P[S_t^e = s^1], \cdots, P[S_t^e = s^n])\\)
- recurrent neural network: \\(S_t^a = \delta(S_{t-1}^aW_s + O_tW_o)\\)

#### Major components of an RL agent

An RL agent may include one or more of these compoents:

- policy: agent's behaviour function; it is a map from state to action

  - deterministic policy: \\(a = \pi(s)\\)
  - stochastic policy: \\(\pi(a \| s) = P[A_t = a \| S_t = s]\\)

- value function: how good is each state and/or action; it is a 
prediction of future reward

  $$
  v_\pi(s) = E_\pi[R_{t+1} + \gamma R_{t+2} + \gamma^2 R_{t+3} + \cdots | S_t = s]
  $$

- model: agent's representation of the environment; it predicts what 
the environment will do next

  - \\(P\\) predicts the next state: \\(P_{ss'}^a = P[S_{t+1} = s' \| S_t = s, A_t = a]\\)
  - \\(R\\) predicts the next (immediate) reward: \\(R_s^a = E[R_{t+1} \| S_t = s, A_t = a]\\)

#### Categories of RL agents

- v1

  - value based
    
    - no policy (implicit)
    - value function
  
  - policy based
  
    - policy
    - no value function
    
  - actor critic
  
    - policy
    - value function

- v2

  - model free
  
    - policy and/or value function
    - no model
    
  - model based
  
    - policy and/or value function
    - model

#### Learning and planning

There are two fundamental problems in sequential decision making

- reinforcement learning:

  - the environment is initially unknown
  - the agent interacts with the environment
  - the agent improves its policy

- planning

  - a model of the environment is known
  - the agent performs computations with its model (without any external interaction)
  - the agent imporves its policy
  - a.k.a deliberation, reasoning, introspection, pondering, thought, search

#### Exploration and exploitation

Reinforcement learning is like trial-and-error learning, the agent should 
discover a good policy from its experiences of the environment without 
losing too much reward along the way.

Exploration finds more information about the environment. Exploitation 
exploits known information to maximise reward. It is usually important 
to explore as well as exploit.

### Introduction to MDPs

Markov decision processes formally describe an environment for 
reinforcement learning where the environment is fully observable. 
Almost all RL problems can be formalised as MDPs, e.g., Optimal 
control primirily deals with continuous MDPs; Partially observable 
problems can be converted into MDPs; Bandits are MDPs with one 
state.

#### Markov process

A Markov process is a memoryless random process, i.e. a sequence of 
random states \\(S_1\\), \\(S_2\\), ... with the Markov property.

A Markov process (or Markov chain) is a tuple \\(<S, P>\\)

- \\(S\\) is a (finite) set of states
- \\(P\\) is a state transition probability matrix, \\(P_{ss'} = P[S_{t+1} = s' \| S_t = s]\\)

#### Markov reward process

A Markov reward process is a Markov chain with values.

A Markov reward process is a tuple \\(<S, P, R, \gamma>\\)

- \\(S\\) is a finite set of states
- \\(P\\) is a state transition probability matrix, \\(P_{ss'} = P[S_{t+1} = s' \| S_t = s]\\)
- \\(R\\) is a reward function, \\(R_s = E[R_{t+1} \| S_t=s]\\)
- \\(\gamma\\) is a discount factor, \\(\gamma \in [0, 1]\\)

##### Return

The return \\(G_t\\) is the total discounted reward from time-step \\(t\\)

$$
G_t = R_{t+1} + \gamma R_{t+2} + \cdots = \sum_{k=0}^\inf \gamma^k R_{t+k+1}
$$

The discount \\(\gamma \in [0, 1]\\) is the present value of future rewards. 
The value of receiving reward \\(R\\) after \\(k + 1\\) time-steps is 
\\(\gamma^k R\\).

##### Value function

The value function \\(v(s)\\) gives the long-term value of state \\(s\\). 
The state value function \\(v(s)\\) of an MDP is the expected return 
starting from state \\(s\\)

$$
v(s) = E[G_t | S_t = s]
$$

The value function can be decomposed into two parts: immediate 
reward \\(R_{t+1}\\) and discounted value of successor state 
\\(\gamma v(S_{t+1})\\):

$$
v(s) = E[G_t | S_t = s] = E[R_{t+1} + \gamma v(S_{t+1}) | S_t = s] = R_s + \gamma \sum_{s' \in S} P_{ss'}v(s')
$$

The Bellman equation can be expressed concisely using matrices, 

$$
v = R + \gamma Pv
$$

where \\(v\\) is a column vector with one entry per state 

$$
\begin{matrix}v(1) \\ \vdots \\ v(n) \end{matrix}
=
\begin{matrix}R_1 \\ \vdots \\ R_n \end{matrix}
+
\gamma \begin{matrix}P_{11} & \cdots & P_{1_n} \\ \vdots & {} & {} \\ P_{n1} & \cdots & P_{nn} \end{matrix} \begin{matrix}v(1) \\ \vdots \\ v(n) \end{matrix}
$$

The Bellman equation is a linear equation, it can be solved directly, 
\\(v = (I - \gamma P)^{-1}R\\). For \\(n\\) states, the computational 
complexity is \\(O(n^3)\\).

Direct solution only possible for small MRPs, for large MRPs, there are 
many iterative methods, e.g.

- dynamic programming
- monte-carlo evaluation
- temporal-difference learning

#### Markov decision process

A Markov decision process is a Markov reward process with decision. It 
is an environment in which all states are Markov.

A Markov decision process is a tuple \\(<S, A, P, R, \gamma>\\)

- \\(S\\) is a finite set of states
- \\(A\\) is a finite set of actions
- \\(P\\) is a state transition probability matrix, \\(P_{ss'}^a = P[S_{t+1} = s' | S_t = s, A_t = a]\\)
- \\(R\\) is a reward function, \\(R_s^a = E[R_{t+1} \| S_t = s, A_t = a]\\)
- \\(\gamma\\) is a discount factor \\(\gamma \in [0, 1]\\)

##### Policies

A policy \\(\pi\\) is a distribution over actions given states, 
\\(\pi(a \| s) = P[A_t = a \| S_t = s]\\). A policy fully defines 
the behaviour of an agent. MDP policies depend on the current state 
(not the history), i.e., policies are stationary (time-independent), 
\\(A_t \sim \pi(\cdot \| S_t), \forall t > 0\\).

Given an MDP \\(M = <S, A, P, R, \gamma>\) and a policy \\(\pi\\), 
the state sequence \\(S_1, S_2, \cdots\\) is a Markov process 
\\(<S, P^\pi>\\) and the state and reward sequence 
\\(S_1, R_2, S_2, \cdots\\) is a Markov reward process 
\\(<S, P^\pi, R^\pi, \gamma>\\) where 

$$
P_{ss'}^\pi = \sum_{a \in A} \pi (a | s) P_{ss'}^a \\
R_{s}^\pi = \sum_{a \in A} \pi (a | s) R_s^a
$$

#### Value function

The state-value function \\(v_\pi(s)\\) of an MDP is the expected 
return starting from state \\(s\\), and then following policy 
\\(\pi\\), \\(v_\pi(s) = E_\pi [G_t \| S_t = s]\\).

The state-value function can again be decomposed into immediate 
reward plus discounted value of successor state, 

$$
\begin{array}
v_\pi(s) &=& E_\pi [R_{t+1} + \gamma v_\pi(S_{t+1}) | S_t = s] \\
&=& \sum_{a \in A} \pi(a | s) q_\pi(s, a) \\
&=& \sum_{a \in A} \pi(a | s) \left(R_s^a + \gamma\sum_{s' in S} P_{ss'}^a v_\pi(s')\right)
\end{array}
$$

The action-value function \\(q_\pi(s, a)\\) is the expected 
return starting from state \\(s\\), taking action \\(a\\), and 
then following policy \\(\pi\\), 
\\(q_\pi(s, a) = E_\pi [G_t \| S_t = s, A_t = a]\\).

The action-value function can be decomposed,

$$
\begin{array}
q_\pi(s, a) &=& E_\pi [R_{t+1} + \gamma q_\pi(S_{t+1}, A_{t+1}) | S_t = s, A_t = a] \\
&=& R_s^a + \gamma \sum_{s' in S} P_{ss'}^a v_\pi(s') \\
&=& R_s^a + \gamma \sum_{s' in S}P_{ss'}^a\sum_{a' in A}\pi(a'|s')q_\pi(s', a')
\end{array}
$$

#### Optimal value function

The optimal state-value function \\(v_*(s)\\) is the maximum value function 
over all policies \\(v_*(s) = \max_\pi v_\pi(s)\\).

The optimal action-value function \\(q_*(s, a)\\) is the maximum action-value 
function over all policies \\(q_*(s, a) = \max_\pi q_\pi(s, a)\\).

The optimal value function specifies the best possible performance 
in the MDP.

#### Optimal policy

Define a partial ordering over policies \\(\pi \geq \pi ' \text{ if } v_\pi(s) \geq v_{\pi '}(s), \forall s\\)

For any Markov decision process, there exists an optimal policy 
\\(\pi_*\\) that is better than or equal to all otehr policies, 
\\(\pi_* \geq \pi, \forall \pi\\). All optimal policies achieve 
the optimal value function, \\(v_{\pi_*}(s) = v_*(s)\\). All 
optimal policies achieve the optimal action-value function, 
\\(q_{\pi_*}(s, a) = q_*(s, a)\\).

An optimal policy can be found by maximising over \\(q_*(s, a)\\), 

$$
\pi_*(a | s) = 
\begin{cases}
1 \text{ if } a = \arg\max_{a \in A} q_*(s, a)\\
0 \text{ otherwise}
\end{cases}
$$

The optimal value functions are recursively related by the 
Bellman optimality equations:

$$
v_*(s) = \max_a q_*(s, a) \\
q_*(s, a) = R_s^a + \gamma\sum_{s' \in S}P_{ss'}^a v_*(s') \\
v_*(s) = \max_a R_s^a + \gamma \sum_{s' \in S} P_{ss'}^a v_*(s') \\
q_*(s, a) = R_s^a + \gamma \sum_{s' \in S} P_{ss'}^a \max_{a'} q_*(s', a')
$$

The Bellman optimality equation is non-linear, there is no closed 
form solution in general. There are many iterative solution methods, 
such as value iteration, policy iteration, q-learning, SARSA.

#### Extensions to MDPs

The following extensions are all possible:

- coutably infinite state and/or action spaces; straightforward
- continuous state and/or action spaces; closed form for linear quadratic model (LQR)
- continuous time
  
  - requires partial differential equations
  - Hamilton-Jacobi-Bellman (HJB) equation
  - limiting case of Bellman equation as time-step -> 0

##### Partially observable MDPs

A partially observable Markov decision process is an MDP with hidden 
states. It is a hidden Markov model with actions. A POMDP is a tuple 
\\(<S, A, O, P, R, Z, \gamma>\\)

- \\(S\\) is a finite set of states
- \\(A\\) is a finite set of actions
- \\(O\\) is a finite set of observations
- \\(P\\) is a state transition probability matrix, \\(P_{ss'}^a = P[S_{t+1} = s' \| S_t = s, A_t = a]\\)
- \\(R\\) is a reward function, \\(R_s^a = E[R_{t+1} \| S_t = s, A_t = a]\\)
- \\(Z\\) is an observation function, \\(Z_{s'o}^a = P[O_{t+1} = o \| S_{t+1} = s', A_t = a]\\)
- \\(\gamma\\) is a distount factor \\(\gamma \in [0, 1]\\)

A history \\(H_t\\) is a sequence of actions, observations and rewards, 
\\(H_t = A_0, O_1, R_1, \cdots, A_{t-1}, O_t, R_t\\).

A belief state \\(b(h)\\) is a probability distribution over states, 
conditioned on the history \\(h\\), \\(b(h) = (P[S_t = s^1 \| H_t = h], \cdots, P[S_t = s^n \| H_t = h])\\).

The history \\(H_t\\) satisfies the Markov property. The belief 
state \\(b(H_t)\\) satisfies the Markov property. A POMDP can 
be reduced to an (infinite) history tree. A POMDP can be 
reduced to an (infinite) belief state tree.

##### Average reward MDPs

An ergodic Markov process is 

- recurrent: each state is visited an infinite number of times
- aperiodic: each state is visited without any systematic period

An ergodic Markov process has a limiting stationary distribution 
\\(d^\pi(s)\\) with the property \\(d^\pi(s) = \sum_{s' \in S}d^\pi(s')Ps's\\).

An MDP is ergodic if the Markov chain induced by any policy 
is ergodic. For any policy \\(\pi\\), an ergodic MDP has an 
average reward per time-step \\(\rho^\pi\\) that is 
independent of start state.

$$
\rho^\pi = \limit_{T \rightarrow \inf} \frac{1}{T} E[\sum_{t=1}^T R_t]
$$

The value function of an undiscounted, ergodic MDP can be 
expressed in terms of average reward. \\(\tilde{v}_\pi(s)\\) 
is the extra reward due to starting from state \\(s\\), 
\\(\tilde{v}_\pi(s) = E_\pi [\sum_{k=1}^\inf (R_{t+k} - \rho^\pi) \| S_t = s]\\).

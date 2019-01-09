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

#### Tips on artificial neural networks

The backpropagation algorithm can produce good results for shallow networks having $$1$$ or $$2$$ 
hidden layers, but it may not work well for deeper ANNs.  Explaining results like these is not 
easy, but several factors are important. First, the large number of weights in a typical deep 
ANN makes it difficult to avoid the problem of overfitting, that is, the problem of failing to 
generalize correctly to cases on which the network has not been trained. Second, backpropagation 
does not work well for deep ANNs because the partial derivatives computed by its backward passes 
either decay rapidly toward the input side of the network, making learning by deep layers extremely 
slow, or the partial derivatives grow rapidly toward the input side of the network, making learning 
unstable.

A particularly effective method for reducing overfitting by deep ANNs is the dropout method. During 
training, units are randomly removed from the network (dropped out) along with their connections. 
This can be thought of as training a large number of "thinned" networks. Combining the results of 
these thinned networks at test time is a way to improve generalization performance. The dropout method 
efficiently approximates this combination by multiplying each outgoing weight of a unit by the 
probability that that unit was retained during training. The dropout method significantly improves 
generalization performance. It encourages individual hidden units to learn features that work well with 
random collections of other features. This increases the versatility of the features formed by the 
hidden units so that the network does not overly specialize to rarely-occurring cases.

Another method is to train the deepest layers one at a time using an unsupervised learning 
algorithm. Without relying on the overall objective function, unsupervised learning can extract 
features that capture statistical regularities of the input stream. The deepest layer is trained 
first, then with input provided by this trained layer, the next deepest layer is trained, and so on, 
until the weights in all, or many, of the network’s layers are set to values that now act as initial values 
for supervised learning. The network is then fine-tuned by backpropagation with respect to the overall 
objective function. Studies show that this approach generally works much better than backpropagation 
with weights initialized with random values. The better performance of networks trained with weights 
initialized this way could be due to many factors, but one idea is that this method places the network 
in a region of weight space from which a gradient-based algorithm can make good progress.

Batch normalization is another technique that makes it easier to train deep ANNs. It has long been known 
that ANN learning is easier if the network input is normalized, for example, by adjusting each input 
variable to have zero mean and unit variance. Batch normalization for training deep ANNs normalizes the 
output of deep layers before they feed into the following layer. This method used statistics from subsets, 
or "mini-batches" of training examples to normalize these between-layer signals to improve the learning rate 
of deep ANNs.

Another technique useful for training deep ANNs is deep residual learning. Sometimes it is easier to learn 
how a function differs from the identity function than to learn the function itself. Then adding this 
difference, or residual function, to the input produces the desired function. In deep ANNs, a block of layers 
can be made to learn a residual function simply by adding shortcut, or skip, connections around the block. 
These connections add the input to the block to its output, and no additional weights are needed.

### On-policy control with approximation

#### Episodic semi-gradient control

The approximate action-value function $$\hat{q} \approx q_\pi$$ is represented as a parameterized functional 
form with weight vector $$\boldsymbol{w}$$. Consider the random training examples of the form $$S_t, A_t \mapsto U_t$$, 
the update target $$U_t$$ can be any approximation of $$q_\pi(S_t,  A_t)$$, including the usual backed-up 
values such as the full Monte Carlo return, $$G_t$$, or any of the n-step SARSA returns. The general 
gradient-descent update for action-value prediction is

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha [U_t - \hat{q}(S_t, A_t, \boldsymbol{w}_t)]\nabla\hat{q}(S_t, A_t, \boldsymbol{w}_t)
$$

For example, the update for the one-step SARSA method is 

$$
\boldsymbol{w}_{t+1} \doteq \boldsymbol{w}_t + \alpha [R_{t+1} + \gamma\hat{q}(S_{t+1}, A_{t+1}, \boldsymbol{w}_t) - \hat{q}(S_t, A_t, \boldsymbol{w}_t)]\nabla\hat{q}(S_t, A_t, \boldsymbol{w}_t)
$$

We call this method episodic semi-gradient one-step SARSA.

To form control methods, we need to couple such actioin-value prediction methods with techniques for 
policy improvement and action selection.

$$
\begin{align}
&\text{Input: a differentiable functioin } \hat{q}: \mathcal{S} \times \mathcal{A} \times \mathbb{R}^d \rightarrow \mathbb{R} \\
&\text{Initialize value-function weights } \boldsymbol{w} \in \mathbb{R}^d \text{ arbitrarily (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Repeat (for each episode):} \\
&\quad S, A \leftarrow \text{ initial state and action of episode (e.g., } \epsilon\text{-greedy)} \\
&\quad \text{Repeat (for each step of episode):} \\
&\qquad \text{Take action } A\text{, observe } R, S' \\
&\qquad \text{If } S' \text{ is terminal:} \\
&\qquad\quad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha [R - \hat{q}(S, A, \boldsymbol{w})]\nabla\hat{q}(S, A, \boldsymbol{w}) \\
&\qquad\quad \text{Go to next episode} \\
&\qquad \text{Choose } A' \text{ as a function of } \hat{q}(S', \cdot, \boldsymbol{w}) \text{(e.g., }\epsilon\text{-greedy)} \\
&\qquad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha [R + \gamma\hat{q}(S', A', \boldsymbol{w}) - \hat{q}(S, A, \boldsymbol{w})]\nabla\hat{q}(S, A, \boldsymbol{w}) \\
&\qquad S \leftarrow S' \\
&\qquad A \leftarrow A'
\end{align}
$$

#### n-step semi-gradient SARSA

We can obtain an n-step version of episodic semi-gradient SARSA by using an n-step return as the update 
target in the semi-gradient SARSA update equation. The n-step return immediately generalizes from its 
tabular form to a function approximation form:

$$
G_{t:t+n} \doteq R_{t+1}+\gamma R_{t+2} + \cdots + \gamma^{n-1}R_{t+n} + \gamma^n\hat{q}(S_{t+n}, A_{t+n}, \boldsymbol{w}_{t+n-1}), n \geq 1, 0 \leq t \lt T - n
$$

with $$G_{t:t+n} \doteq G_t$$ if $$t + n \geq T$$, as usual. The n-step update equation is

$$
\boldsymbol{w}_{t+n} \doteq \boldsymbol{w}_{t+n-1} + \alpha [G_{t:t+n} - \hat{q}(S_t, A_t, \boldsymbol{w}_{t + n - 1})]\nabla\hat{q}(S_t, A_t, \boldsymbol{w}_{t+n-1}), 0 \leq t \lt T
$$

$$
\begin{align}
&\text{Input: a differentiable functioin } \hat{q}: \mathcal{S} \times \mathcal{A} \times \mathbb{R}^d \rightarrow \mathbb{R} \text{, possibly } \pi \\
&\text{Initialize value-function weight vector } \boldsymbol{w} \text{ arbitrarily (e.g., } \boldsymbol{w} = 0 \text{)} \\
&\text{Parameters: step size } \alpha \gt 0 \text{, small } \epsilon \gt 0 \text{, a positive integer } n \\
&\text{All store and access operations (} S_t, A_t \text{, and } R_t \text{) can take their index mod } n \\
&\text{Repeat (for each episode):} \\
&\quad \text{Initialize and store } S_0 \neq terminal \\
&\quad \text{Select and store an action } A_0 \sim \pi(\cdot|S_0) \text{ or } \epsilon\text{-greedy w.r.t. } \hat{q}(S_0, \cdot, \boldsymbol{w}) \\
&\quad T \leftarrow \infty \\
&\quad \text{For } t = 0, 1, 2, \cdots : \\
&\qquad \text{If } t \lt T \text{, then:} \\
&\qquad\quad \text{Take action } A_t \\
&\qquad\quad \text{Observe and store the next reward as } R_{t+1} \text{ and the next state as } S_{t+1} \\
&\qquad\quad \text{If } S_{t+1} \text{ is terminal, then:} \\
&\qquad\qquad T \leftarrow t + 1 \\
&\qquad\quad \text{else:} \\
&\qquad\qquad \text{Select and store } A_{t+1} \sim \pi(\cdot | S_{t+1}) \text{ or } \epsilon\text{-greedy w.r.t. } \hat{q}(S_{t+1}, \cdot, \boldsymbol{w}) \\
&\qquad \tau \leftarrow t - n + 1 \text{(} \tau \text{ is the time whose estimate is being updated)} \\
&\qquad \text{If } \tau \geq 0 : \\
&\qquad\quad G \leftarrow \sum_{i = \tau + 1}^{\min (\tau + n, T)} \gamma^{i - \tau - 1}R_i \\
&\qquad\quad \text{If } \tau + n \lt T \text{, then } G \leftarrow G + \gamma^n\hat{q}(S_{\tau+n}, A_{\tau+n}, \boldsymbol{w}) \\
&\qquad\quad \boldsymbol{w} \leftarrow \boldsymbol{w} + \alpha [G - \hat{q}(S_\tau, A_\tau, \boldsymbol{w})]\nabla\hat{q}(S_\tau, S_\tau, \boldsymbol{w}) \\
&\quad \text{until } \tau = T - 1
\end{align}
$$




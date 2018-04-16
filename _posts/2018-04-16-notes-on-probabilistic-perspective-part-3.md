---
layout: post
category: [math]
tags: [math]
infotext: "reading note/report of Machine learning a probabilistic perspective & The elements of statistical learning Data mining, inference, and prediction"
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Support Vector Machine

Consider the \\(\mathcal{l}_2\\) regularized empirical risk function 

$$
\mathcal{J}(w, \lambda)=\sum_{i=1}^N\text{L}(y_i, \hat{y}_i) + \lambda||w||^2
$$

where \\(\hat{y}_i=w^Tx_i + w_0\\). If \\(\text{L}\\) is quadratic loss, 
this is equivalent to ridge regression, and if \\(\text{L}\\) is the log-loss, 
this is equivalent to logistic regression.

In the ridge regression case, we know that the solusion to this has the form 
\\(\hat{w}=(X^TX+\lambda I)^{-1}X^Ty\\), and plug-in predictions take the 
form \\(\hat{w}_0+\hat{w}^Tx\\). We can rewrite these equations in a way that 
only involves inner products of the form \\(x^Tx'\\), which we can replace 
by calls to a kernel function, \\(\kappa(x,x')\\). This is kernelized, but 
not sparse. However, if we replace the quadratic / log-loss with some other 
loss function, we can ensure that the solution is sparse, so that predictions 
only depend on a subset of the training data, known as support vectors. 
This combination of the kernel trick plus a modified loss function is known 
as a support vector machine or SVM. This technique was originally designed 
for binay classification, but can be extended to regression and multi-class 
classification.

Note that SVMs are very unnatural from a probabilistic point of view. First, 
they encode sparsity in the loss function rather than the prior. Second, 
they encode kernels by using an algorithmic trick, rather than being an 
explicit part of the model. Finally, SVMs do not result in probabilistic 
outputs, which causes various difficulties, especially in the multi-class 
classification setting.

The ridge estimate \\(w=X^T(XX^T + \lambda I_N)^{-1}y\\) takes 
\\(O(N^3+N^2D)\\) time to compute. This can be advantageous if \\(D\\) is large. 
We can partially kernelize this by replacing \\(XX^T\\) with the Gram matrix 
\\(K\\). For the leading \\(X^T\\) term, we define the following dual variables: 

$$
\alpha \triangleq (K+\lambda I_N)^{-1}y
$$

Then we can rewrite theprimal variables as follows

$$
w=X^T\alpha=\sum_{i=1}^N\alpha_ix_i
$$

This shows that the solution vector is just a linear sum of the \\(N\\) 
training vectors. When we plug this in at test time to compute the 
predictive mean, we get

$$
\hat{f}(x)=w^Tx=\sum_{i=1}^N\alpha_ix_i^Tx=\sum_{i=1}^N\alpha_i\kappa(x,x_i)
$$

### Boosting

The goal of boosting is to solve the following optimization problem:

$$
\min_f \sum_{i=1}^N\text{L}(y_i, f(x_i))
$$

and \\(\text{L}(y,\hat{y})\\) is some loss function, and \\(f\\) is assumed 
to be an ARM model.

If we use squared error loss, the optimal estimate is given by 

$$
f^*(x)=\arg\min_{f(x)}=\mathbb{E}_{y|x}[(Y-f(x))^2]=\mathbb{E}[Y|x]
$$

Of course, this cannot be computed in practice since it 
requires knowing the true conditional distribution \\(p(y|x)\\). Hence 
this is sometimes called the population minimizer, where the expectation 
is interpreted in a frequentist sense.

Finding the optimal \\(f\\) is hard, we can tackle it sequenctially. 
We initialise by defining

$$
f_0(x)=\arg\min_{\gamma}\sum_{i=1}^N \text{L}(y_i, f(x_i; \gamma))
$$

For example, if we use squared error, we can set \\(f_0(x)=\bar{y}\\), 
and if we use log-loss or exponential loss, we can set 
\\(f_0(x)=\frac{1}{2}\log\frac{\tilde\pi}{1-\tilde\pi}\\), where 
\\(\tilde\pi=\frac{1}{N}\sum_{i=1}^N\mathbb{I}(y_i=1)\\). We could use 
a more powerful model model for the baseline, such as a GLM.

Then at iteration \\(m\\), we compute

$$
(\beta_m, \gamma_m)=\arg\min_{\beta,\gamma}\sum_{i=1}^N\text{L}(y_i, f_{m-1}(x_i)+\beta\phi(x_i;\gamma))
$$

and then we set

$$
f_m(x)=f_{m-1}(x)+\beta_m\phi(x;\gamma_m)
$$

The key point is that we do not go back and adjust earlier parameters. 
This is why the method is called forward stagewise additive modeling.

We continue this for a fixed number of iterations \\(M\\). In fact 
\\(M\\) is the main tuning parameter of the method. Often we pick it 
by monitoring the performance on a separate validation set, and then 
stopping once performance starts to decrease; this is called early 
stopping. Alternatively, we can use model selection criteria such 
as AIC or BIC.

In practice, better performance can be obtained by performing 
"partial updates" of the form

$$
f_m(x)=f_{m-1}(x)+\nu\beta_m\phi(x;\gamma_m)
$$

Here \\(0 < \nu < 1\\) is a step-size parameter. In practice it is 
common to use a small value such as \\(\nu=0.1\\). This is called 
shrinkage.

Suppose we use squared error loss. Then at step \\(m\\) the loss has 
the form

$$
\text{L}(y_i, f_{m-1}(x_i)+\beta\phi(x_i; \gamma))=(r_{im}-\phi(x_i; \gamma))^2
$$

where \\(r_{im}\triangleq y_i - f_{m-1}(x_i)\\) is the current residual, 
and we have set \\(\beta=1\\) without loss of generality. Hence we can 
find the new basis function by using the weak learner to predict 
\\(r_m\\). This is called L2boosting, or least squared boosting.

Consider a binary classification problem with exponential loss. At step 
\\(m\\) we have to minimize

$$
\text{L}_m(\phi) = \sum_{i-1}^N \exp[-\tilde{y}_i(f_{m-1}(x_i)+\beta\phi(x_i))]=\sum_{i=1}^N w_{i,m}\exp(-\beta\tilde{y}_i\phi(x_i))
$$

where \\(w_{i,m}\triangleq\exp(-\tilde{y}\_if\_{m-1}(x_i))\\) is a weight 
applied to datacase \\(i\\), and \\(\tilde{y}_i \in \\{-1,+1\\}\\). We 
can rewrite this objective as follows:

$$
\begin{array}
\text{L}_m &=e^{-\beta}\sum_{\tilde{y}_i=\phi(x_i)}w_{i,m} + e^{\beta}\sum_{\tilde{y}_i \neq \phi(x_i)w_{i,m}}\\
&= (e^\beta - e^{-\beta})\sum_{i=1}^N w_{i,m}\mathbb{I}(\tilde{y}_i \neq \phi(x_i)) + e^{-\beta}\sum_{i=1}^N w_{i,m}
\end{array}
$$

Consequently the optimal function to add is 

$$
\phi_m = \arg\min_{\phi} w_{i,m}\mathbb{I}(\tilde{y}_i \neq \phi(x_i))
$$

This can be found by applying the weak learner to a weighted version 
of the dataset, with weight \\(w_{i,m}\\). Substituting \\(\phi_m\\) 
into \\(\text{L}_m\\) and solving for \\(\beta\\) we find

$$
\beta_m = \frac{1}{2}\log\frac{1-\text{err}_m}{\text{err}_m}
$$

where

$$
\text{err}_m = \frac{\sum_{i=1}^N w_i \mathbb{I}(\tilde{y}_i \neq \phi(x_i))}{\sum_{i=1}^N w_{i,m}}
$$

The overall update becomes

$$
f_m(x)=f_{m-1}(x) + \beta_m\phi_m(x)
$$

With this, the weights at the next iteration become

$$
\begin{array}
{}w_{i, m+1} &= w_{i,m}e^{-\beta_m\tilde{y}_i\phi_m(x_i)}\\
&= w_{i,m}e^{\beta_m(2\mathbb{I}(\tilde{y}_i\neq\phi_m(x_i))-1)}\\
&= w_{i,m}e^{2\beta_m\mathbb{I}(\tilde{y}_i\neq\phi_m(x_i))}e^{-\beta_m}
\end{array}
$$

where we exploit the fact that \\(-\tilde{y}_i\phi_m(x_i)=-1\\) if 
\\(\tilde{y}_i = \phi_m(x_i)\\) and \\(-\tilde{y}_i\phi_m(x_i)=+1\\) 
otherwise. Since \\(e^{-\beta_m}\\) will cancel out in the 
normalization step, we can drop it. The result is the algorithm 
known AdaboostML.

The trouble with exponential loss is that it puts a lot of weight on 
misclassified examples. In addition, \\(e^{-\tilde{y}f}\\) is not the 
logarithm of any pmf for binary variables \\(\tilde{y} \in \\{-1,+1\\}\\); 
consequently we cannot recover probability estimates from \\(f(x)\\).

A natural alternative is to use logloss instead. This only punishes 
mistakes linearly. Furthermore, it means that we will be able to 
extract probabilities from the final learned function, using

$$
p(y=1|x)=\frac{e^{f(x)}}{e^{-f(x)+e^{f(x)}}}=\frac{1}{1+e^{-2f(x)}}
$$

The goal is to minimize the expected log-loss, given by

$$
\text{L}_m(\phi)=\sum_{i=1}^N\log[1+\exp(-2\tilde{y}_i(f_{m-1}(x)+\phi(x_i)))]
$$

This is known as logitBoost.

Rather than deriving new versions of boosting for every different 
loss function, it is possible to derive a generic version, known as 
gradient boosting. To explain this, imagine minimizing

$$
\hat{f} = \arg\min_f \text{L}(f)
$$

where \\(f=\(f(x_1), \cdots, f(x_N)\)\\) are the parameters. We will 
solve this stagewise, using gradient descent. At step \\(m\\), let 
\\(g_m\\) be the gradient of \\(\text{L}(f)\\) evaluated at 
\\(f=f_{m-1}\\):

$$
g_{im}=\left[\frac{\partial\text{L}(y_i, f(x_i))}{\partial f(x_i)}\right]_{f=f_{m-1}}
$$

We then make the update 

$$
f_m = f_{m-1}-\rho_mg_m
$$

where \\(\rho_m\\) is the step length, chosen by

$$
\rho_m = \arg\min_\rho \text{L}(f_{m-1} - \rho g_m)
$$

This is called functional gradient descent.

In its current form, this is not much use, since it only optimizes 
\\(f\\) at a fixed set of \\(N\\) points, so we do not learn a function 
that can generalize. However, we can modify the algorithm by fitting 
a weak learner to approximate the negative gradient signal. That is, 
we use this update

$$
\gamma_m=\arg\min_\gamma\sum_{i=1}^N(-g_{im}-\phi(x_i;\gamma))^2
$$

If we apply this algorithm using squared loss, we recover L2Boosting. 
If we apply this algorithm to log-loss, we get an algorithm known as 
BinomialBoost. The advantage of this over LogitBoost is that it does 
not need to be able to do weighted fitting: it just applies any 
black-box regression model to the gradient vector.

Suppose we use as our weak learner the following algorithm: search 
over all possible variables \\(j=1:D\\), and pick the one \\(j(m)\\) 
that best predicts the residual vector:

$$
j(m)=\arg\min_j\sum_{i=1}^N(r_{im}-\hat{\beta}_{jm}x_{ij})^2\\
\hat{\beta}_{jm}=\frac{\sum_{i=1}^N x_{ij}r_{im}}{\sum_{i=1}^Nx_{ij}^2}\\
\phi_m(x)=\hat{\beta}_{j(m),m}x_{j(m)}
$$

This method, which is known as sparse boosting, is identical to the 
matching pursuit algorithm.

It is clear that this will result in a sparse estimate, at least if 
\\(M\\) is small. To see this, let us rewrite the update as follows:

$$
\beta_m := \beta_{m-1}+\nu(0,\cdots,0,\hat{\beta}_{j(m),m},0,\cdots,0)
$$

where the non-zero entry occurs in location \\(j(m)\\). This is known 
as forward stagewise linear regression, which becomes equivalent to 
the LAR algorithm as \\(\nu \rightarrow 0\\). Increasing the number 
of steps \\(m\\) in boosting is analogous to decreasing the 
regularization penalty \\(\lambda\\).

The boostings works well especially for classifiers. There are two 
main reasons for this. First, it can be seen as a form of 
\\(\mathcal{l}_1\\) regularization, which is known to help prevent 
overfitting by eliminating "irrelevant" features. To see this, 
imagine pre-computing all possible weak-learners, and defining a 
feature vector of the form \\(\phi(x)=[\phi_1(x),\cdots,\phi_K(x)]\\). 
We could use \\(\mathcal{l}_1\\) regularization to select a subset 
of these. Alternatively we can use boosting, where at each step, the 
weak learner creates a new \\(\phi_k\\) on the fly. It is possible 
to combine boosting and \\(\mathcal{l}_1\\) regularization, to get 
an algorithm known as L1-Adaboost.

So far, our presentation of boosting has been very frequentist, since 
it has focussed on greedily minimizing loss functions. Consider a 
mixture of experts model of the form

$$
p(y|x,\theta)=\sum_{m=1}^M\pi_mp(y|x,\gamma_m)
$$

where each expert \\(p(y|x,\gamma_m)\\) is like a weak learner. We 
usually fit all \\(M\\) experts at once using EM, but we can imagine 
a sequential scheme, whereby we only update the parameters for one 
expert at a time. In the E step, the posterior responsibilities will 
reflect how well the existing experts explain a given data point; if 
this is a poor fit, these data points will have more influence on the 
next expert that is fitted. (This view natually suggest a way to use 
a boosting-like algorithm for unsupervised learning: we simply 
sequentially fit mixture models, instead of mixtures of experts.)

Notice that this is a rather "broken" MLE procedure, since it never 
goes back to update the parameters of an old expert.

### Stochastic process

The basic idea behind a Markov chain is to assume that \\(X_t\\) 
captures all the relevant information for predicting the future. If 
we assume discrete time steps, we can write the joint distribution 
as follows:

$$
p(X_{1:T})=p(X_1)p(X_2|X_1)p(X_3|X_2)\cdots=p(X_1)\prod_{t=2}^Tp(X_t|X_{t-1})
$$

This is called a Markov chain or Markov model.

If we assume the transition function \\(p(X_t|X_{t-1})\\) is 
independent of time, then the chain is called homogeneous, stationary, 
or time-invariant. This is an example of parameter tying, since the 
same parameter is shared by multiple variables. This assumption allows 
us to model an arbitrary number of variables using a fixed number of 
parameters; such models are called stochastic processes.

If we assume that the observed variables are discrete, so 
\\(X_t\in\\{1,\cdots,K\\}\\), this is called a discrete-state or 
finite-state Markov chain.

### State space model

A state space model or SSM is just like an HMM, except the hidden 
states are continuous. The model can be written in the following 
generic form:

$$
z_i=g(u_t,z_{t-1},\epsilon_t)\\
y_t=h(z_t,u_t,\delta_t)
$$

where \\(z_t\\) is the hidden state, \\(u_t\\) is an optional input 
or control signal, \\(y_t\\) is the observation, \\(g\\) is the 
transition model, \\(h\\) is the observation model, \\(\epsilon_t\\) 
is the system noise at time \\(t\\), and \\(\sigma_t\\) is the 
observation noise at time \\(t\\).

One of the primary goals in using SSMs is to recursively estimate the 
belief state \\(p(z_t|y_{1:t},u_{1:t},\theta)\\).

An import special case of an SSM is where all the CPDs are 
linear-Gaussian. In other words, we assume

- The transition model is a linear function

$$
z_t=A_tz_{t-1}+B_tu_t+\epsilon_t
$$

- The observation model is a linear function

$$
y_t=C_tz_t+D_tu_t+\sigma_t
$$

- The system noise is Gaussian

$$
\epsilon_t \sim \mathcal{N}(0, Q_t)
$$

- The observation noise is Gaussian

$$
\delta_t \sim \mathcal{N}(0, R_t)
$$

This model is called a linear-Gaussian SSM (LG-SSM) or a linear 
dynamical system (LDS). If the parameters 
\\(\theta_t=\(A_t,B_t,C_t,D_t,Q_t,R_t\)\\) are independent of time, 
the model is called stationary.

### Belief propagation

The belief propagation (BP) or the sum-product algorithm is the 
generalization of the forwards-backwards algorithm from chains to 
trees.


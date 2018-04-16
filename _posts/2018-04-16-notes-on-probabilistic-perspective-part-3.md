### Support Vector Machine

Consider the \\(\mathcal{l}_2\\) regularized empirical risk function 

$$
\mathcal{J}(w, \lambda)=\sum_{i=1}^N\text{L}(y_i, \hat{y}_i) + \lambda||w||^2
$$

where \\(\hat{y}_i=w^Tx_i + w_0\\). If \\(\text{L}\\) is quadratic loss, 
this is equivalent to ridge regression, and if \\(\text{L}\\) is the log-loss, 
this is equivalent to logistic regression.

In the ridge regression case, we know that the solusion to this has the form 
\\(\hat{w}=(X^TX+\lambdaI)^{-1}X^Ty\\), and plug-in predictions take the 
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

The ridge estimate \\(w=X^T(XX^T + \lambdaI_N)^{-1}y\\) takes 
\\(O(N^3+N^2D)\\) time to compute. This can be advantageous if \\(D\\) is large. 
We can partially kernelize this by replacing \\(XX^T\\) with the Gram matrix 
\\(K\\). For the leading \\(X^T\\) term, we define the following dual variables: 

$$
\alpha \triangleq (K+\lambdaI_N)^{-1}y
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
\\(\tilde\pi=frac{1}{N}\sum_{i=1}^N\mathbb{I}(y_i=1)\\). We could use 
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





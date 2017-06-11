---
layout: post
category: [machine learning, math]
tags: [machine learning, math, neural network]
infotext: 'A generative stochastic artificial neural network that can learn a probability distribution over its set of inputs.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

### Energy based model

Energy based probabilistic models define a probability distribution through an energy function:

$$
p(\boldsymbol x) = \frac{e^{-E(\boldsymbol x)}}{Z}
$$

where \\(Z\\) is the normalization factor, which is also called the partition function by 
analogy with physical systems:

$$
Z = \sum_{\boldsymbol x} e^{-E(\boldsymbol x)}
$$

The formulae looks pretty much like the one of softmax.

An energy based model can be learnt by performing sgd on the empirical negative log-likelihood 
of the training data. As for the logistic regression we will first define the log-likelihood 
and then the loss function as being the negative log-likelihood:

$$
L(\boldsymbol\theta, D) = \frac{1}{N} \sum_{\boldsymbol{x}^{(i)} \in D} \log p(\boldsymbol{x}^{(i)})
$$

$$
l(\boldsymbol\theta, D) = -L(\boldsymbol\theta, D)
$$

And use stochastic gradient \\(-\frac{\partial \log p(\boldsymbol{x}^{(i)})}{\partial \boldsymbol\theta}\\) 
to optimize the model, where \\(\boldsymbol\theta\\) are the parameters of the model.

### EBM with hidden units

In some situation, we may not observe \\(\boldsymbol{x}\\) fully, or we  want to introduce some 
unobserved variables to increase thee expressive power of the model. By adding the hidden 
variables \\(\boldsymbol{h}\\), we have:

$$
P(\boldsymbol{x}) = \sum_{\boldsymbol{h}} P(\boldsymbol{x}, \boldsymbol{h}) = \sum_{\boldsymbol{h}} \frac{e^{-E(\boldsymbol{x}, \boldsymbol{h})}}{Z}
$$

Now let's introduce the notation of __free energy__, term from physics, defined as

$$
F(\boldsymbol{x}) = -\log \sum_{\boldsymbol{h}} e^{-E(\boldsymbol{x}, \boldsymbol{h})}
$$

Then we have:

$$
P(\boldsymbol{x}) = \frac{e^{-F(\boldsymbol{x})}}{Z}
$$

where \\(Z = \sum_{\boldsymbol{x}} e^{-F(\boldsymbol{x})}\\) is again the partition function.

For any energy-based (bolzmann) distribution, the gradient of the loss has the form: 

$$
\begin{align}
-\frac{\partial \log p(\boldsymbol{x})}{\partial \theta} & = -\frac{\partial \log \frac{e^{-F(\boldsymbol{x})}}{Z}}{\partial \boldsymbol\theta}\\
& = \frac{\partial (F(\boldsymbol{x}) + \log Z)}{\partial \boldsymbol\theta}\\
& = \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta} + \frac{\partial \log Z}{\partial \boldsymbol\theta}\\
& = \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta} + \frac{1}{Z}\frac{\partial \sum_{\boldsymbol{x}} e^{-F(\boldsymbol{x})}}{\partial \boldsymbol\theta}\\
& = \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta} - \frac{1}{Z} \sum_{\boldsymbol{x}} e^{-F(\boldsymbol{x})} \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta}\\
& = \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta} - \sum_{\boldsymbol{x}} p(\boldsymbol{x}) \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta} \tag{1}\\
& = \frac{\partial -\log \sum_{\boldsymbol{h}} e^{-E(\boldsymbol{x}, \boldsymbol{h})}}{\partial \boldsymbol\theta} - \sum_{\boldsymbol{x}} p(\boldsymbol{x}) \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta}\\
& = \frac{\sum_{\boldsymbol{h}} e^{-E(\boldsymbol{x}, \boldsymbol{h})} \frac{\partial E(\boldsymbol{x}, \boldsymbol{h})}{\partial \boldsymbol\theta}}{\sum_{\boldsymbol{h}} e^{-E(\boldsymbol{x}, \boldsymbol{h})}} - \sum_{\boldsymbol{x}} p(\boldsymbol{x}) \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta}\\
& = \sum_{\boldsymbol{h}} \frac{e^{-E(\boldsymbol{x}, \boldsymbol{h})}}{\sum_{\boldsymbol{h}'} e^{-E(\boldsymbol{x}, \boldsymbol{h}')}} \frac{\partial E(\boldsymbol{x}, \boldsymbol{h})}{\partial \boldsymbol\theta} - \sum_{\boldsymbol{x}} p(\boldsymbol{x}) \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta}\\
& = \sum_{\boldsymbol{h}} p(\boldsymbol{h}|\boldsymbol{x}) \frac{\partial E(\boldsymbol{x}, \boldsymbol{h})}{\partial \boldsymbol\theta} - \sum_{\boldsymbol{x},\boldsymbol{h}} p(\boldsymbol{x},\boldsymbol{h}) \frac{\partial E(\boldsymbol{x},\boldsymbol{h})}{\partial \boldsymbol\theta}\\
& = \mathbb{E}_{\boldsymbol{h}|\boldsymbol{x}} [\frac{\partial E(\boldsymbol{x}, \boldsymbol{h})}{\partial \boldsymbol\theta}] - \mathbb{E}_{\boldsymbol{x},\boldsymbol{h}} [\frac{\partial E(\boldsymbol{x},\boldsymbol{h})}{\partial \boldsymbol\theta}] \tag{2}\\
& = \text{positive phase contribution} - \text{negative phase contribution}
\end{align}
$$

As shown in above, eq (2) is the final form of the stochastic gradient of all 
energy-based distribution. In this post, we will use eq (1) for notation 
simplicity.

The above gradient contains two parts, which are referred to as the positive phase and the 
negative phase. The positive phase increases the probability of training data (by reducing 
the corresponding free energy), while the negative phase decreases the probability of 
samples generated by the model (by increasing the energy of all \\(\boldsymbol{x} \sim P\\)).

It's difficult to determine the gradient analytically, as it involves the computation of 
\\(\sum_{\boldsymbol{x}} p(\boldsymbol{x}) \frac{\partial F(\boldsymbol{x})}{\partial \boldsymbol\theta}\\). 

The first step in making this computation tractable is to estimate the expectation using a 
fixed number of model samples. Samples used to estimate the negative phase gradient are 
referred to as __negative particles__, which are denoted as \\(N\\). The gradient becomes:

$$
-\frac{\partial \log p(\boldsymbol{x})}{\partial \theta} \approx \frac{\partial F(\boldsymbol{x})}{\partial \theta} - \frac{1}{||N||} \sum_{\tilde{\boldsymbol{x}} \in N} \frac{\partial F(\tilde{\boldsymbol{x}})}{\partial \boldsymbol\theta}
$$

The elements \\(\tilde{\boldsymbol{x}}\\) of \\(N\\) are sampled according to \\(P\\) (Monte-Carlo).

### Restricted Boltzmann Machines

Boltzmann machines are a particular form of log-linear Markov Random Field, for which the energy 
function is linear in its free parameters. To make them powerful enough to represent complicated 
distributions (go from the limited parametric setting to a non-parameteric one), let's consider 
that some of the variables are never observed. Restricted Boltzmann machines restrict BMs to those 
without visible-visible and hidden-hidden connections.

The energy funciton \\(E(\boldsymbol{v}, \boldsymbol{h})\\) of an RBM is defined as:

1. for binomial energy term

   $$
   E(\boldsymbol{v}, \boldsymbol{h}) = -\boldsymbol{b}^T \boldsymbol{v} - \boldsymbol{c}^T \boldsymbol{h} - \boldsymbol{h}^T \Omega \boldsymbol{v}
   $$

   where \\(\Omega\\) represents the weights connecting hidden and visible units and 
   \\(\boldsymbol{b}\\) and \\(\boldsymbol{c}\\) are the offsets of the visible and hidden 
   variables respectively.
   
   Thus the energy function:
   
   $$
   F(\boldsymbol{v}) = -\boldsymbol{b}^T \boldsymbol{v} - \sum_i \log \sum_{h_i} e ^ {h_i (c_i + \Omega_i \boldsymbol{v})}
   $$
   
   The visible and hidden units are conditionally independent given one-another. So we have:
   
   $$
   p(\boldsymbol{h} | \boldsymbol{v}) = \prod_i p(h_i | \boldsymbol{v})
   $$
   
   $$
   p(\boldsymbol{v} | \boldsymbol{h}) = \prod_i p(v_i | \boldsymbol{h})
   $$

2. for fixed variance Gaussian energy term

   $$
   a_i^2 v_i^2 - b_i v_i - \sum_j w_{ij}v_i h_j
   $$

   The energy function is 
   
   $$
   \begin{align}
   p(v_i | \boldsymbol{h}) & = \frac{1}{Z} e^{- a_i^2 v_i^2 + b_i v_i + \sum_j w_{ij}v_i h_j} = \frac{1}{Z} e^{-\frac{(v_i - \mu)^2}{2\delta^2}}\\
   & = N(v_i; \mu, \delta^2) \text{ with } \delta^2 = \frac{1}{2a_i^2} \text{ , } \mu = \frac{b_i + \sum_j w_{ij}h_j}{2a_i^2}
   \end{align}
   $$

3. for softmax energy term

   $$
   - b_i v_i - \sum_j w_{ij} v_i h_j
   $$
   
   The energy function is 
      
   $$
   \begin{align}
   p(v_i = 1| \boldsymbol{h}) = \frac{e^{b_i + \sum_j w_{ij}h_j}}{\sum_{i'} e^{b_{i'} + \sum_j w_{i'j}h_j}} = \text{softmax}(b_i + \sum_j w_{ij}h_j)
   \end{align}
   $$

#### RBM with binary units

Suppose that \\(\boldsymbol{v}\\) and \\(\boldsymbol{h}\\) are binary vectors, a probabilistic 
version of the usual neuron activation function turns out to be:

$$
P(h_i = 1 | \boldsymbol{v}) = \text{sigm} (c_i + \Omega_i \boldsymbol{v})
$$

$$
P(v_i = 1 | \boldsymbol{h}) = \text{sigm} (b_i + \Omega_i \boldsymbol{h})
$$

The free energy of an RBM with binary units further simplifies to:

$$
F(\boldsymbol{v}) = -\boldsymbol{b}^T \boldsymbol{v} - \sum_i \log (1 + e^{c_i + \Omega_i\boldsymbol{v}})
$$

And the gradients for an RBM with binary units:

$$
-\frac{\partial \log p(\boldsymbol{v})}{\partial \Omega_{ij}} = \mathbb{E}_{\boldsymbol{v}} [p(h_i | \boldsymbol{v}) v_j] - v_j^{(i)} \text{sigm}(\Omega_i \boldsymbol{v}^{(i)} + c_i)
$$

$$
-\frac{\partial \log p(\boldsymbol{v})}{\partial c_i} = \mathbb{E}_{\boldsymbol{v}} [p(h_i | \boldsymbol{v})] - \text{sigm}(\Omega_i \boldsymbol{v}^{(i)})
$$

$$
-\frac{\partial \log p(\boldsymbol{v})}{\partial b_j} = \mathbb{E}_{\boldsymbol{v}} [p(v_j | \boldsymbol{h})] - v_j^{(i)}
$$

### Sampling

Samples of \\(P(\boldsymbol{x})\\) can be obtained by running a Markov chain to convergence, 
using Gibbs sampling as the transition operator.

Gibbs sampling of the joint of \\(N\\) random variables \\(S=(S_1, ... , S_N)\\) is done 
through a sequence of \\(N\\) sampling sub-steps of the form \\(S_i \sim p(S_i | S_{-i})\\) 
where \\(S_{-i}\\) contains the \\(N-1\\) other random variables in \\(S\\) excluding 
\\(S_i\\).

For RBMs, \\(S\\) consists of the set of visible and hidden units. However, since they are 
conditionally independent, one can perform block Gibbs sampling. In this setting, visible 
units are sampled simultaneously given fixed values of the hidden units. Similarly, hidden 
units are sampled simultaneously given the visible units.

In theory, each parameter update in the learning process would require running one sampling 
chain to convergence. It is needless to say that doing so would be prohibitively expensive. 
As such, several algorithms have been devised for RBMs, in order to efficiently sample 
from \\(p(v,h)\\) during the learning process.

#### Contrastive Divergence (CD-k)

Contrastive Divergence uses two tricks to speed up the sampling process:

1. Since we eventually want \\(p(\boldsymbol{v}) \approx p_{\text{train}}(\boldsymbol{v})\\) 
(the true, underlying distribution of the data), we initialize the Markov chain with a training 
example (i.e., from a distribution that is expected to be close to \\(p\\), so that the chain 
will be already close to having converged to its final distribution \\(p\\)).
2. CD does not wait for the chain to converge. Samples are obtained after only k-steps of Gibbs 
sampling. In practice, \\(k=1\\) has been shown to work surprisingly well.

In a CD-1, we have

$$
\mbox{ observed } \boldsymbol{x} = \boldsymbol{x}^0  \stackrel{P(\boldsymbol{y}|\boldsymbol{x}^0)}{\longrightarrow} \boldsymbol{y}^0 \stackrel{P(\boldsymbol{x}|\boldsymbol{y}^0)}{\longrightarrow} \boldsymbol{x}^1 \stackrel{P(\boldsymbol{y}|\boldsymbol{x}^1)}{\longrightarrow} \boldsymbol{y}^1
$$

The updating rules are like:

- output binomial unit \\(i\\) <-> input binomial unit \\(j\\)
  - weight \\(w_{ij}\\):
  
    positive phase contribution: 
    
    $$
    P(y^0_i=1|\boldsymbol{x}^0) 1 \times x^0_j + (1 - P(y^0_i=1|\boldsymbol{x}^0)) 0 \times x^0_j = P(y^0_i=1|\boldsymbol{x}^0) x^0_j
    $$
    
    negative phase contribution: 
    
    $$
    P(y^1_i=1|\boldsymbol{x}^1) 1 \times x^1_j + (1 - P(y^1_i=1|\boldsymbol{x}^1)) 0 \times x^1_j = P(y^1_i=1|\boldsymbol{x}^1) x^1_j
    $$
    
  - bias \\(b_i\\):
  
    positive phase contribution: 
    
    $$
    P(y^0_i=1|\boldsymbol{x}^0)
    $$
    
    negative phase contribution: 
    
    $$
    P(y^1_i=1|\boldsymbol{x}^1)
    $$
    
- output binomial unit \\(i\\) <-> input Gaussian unit \\(j\\)
  - bias \\(b_i\\) and weight \\(w_{ij}\\) as above
  - parameter \\(a_j\\):
  
    positive phase contribution: \\(2 a_j (x^0_j)^2\\)
    
    negative phase contribution: \\(2 a_j (x^1_j)^2\\)
    
- output softmax unit \\(i\\) <-> input binomial unit \\(j\\)

  same formulas as for binomial units, except that \\(P(y_i=1|\boldsymbol{x})\\) is computed 
  differently (with softmax instead of sigmoid)

### Reference

[link1](http://deeplearning.net/tutorial/rbm.html){:target='_blank'} and [link2](http://www.iro.umontreal.ca/~lisa/twiki/bin/view.cgi/Public/DBNEquations){:target='_blank'}

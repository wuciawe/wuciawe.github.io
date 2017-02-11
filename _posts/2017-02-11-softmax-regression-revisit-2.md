---
layout: post
category: [machine learning, math]
tags: [machine learning, regression, math]
infotext: "sampling based approaches to reduce the computational complexity in the gradient calculation of the softmax regression."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In [the previous post]({%post_url 2017-02-09-softmax-regression-revisit%}), I introduced the model 
inference of the softmax regression and the hierarchical softmax regression which aims at higher 
efficiency during model training when the total class number is large. In this revisit post, I will 
introduce the sampling based approaches to reduce the computational complexity during training.

### The loss function of the softmax regression

Let's first recall the loss function of the softmax regression with \\(m\\) classes:

$$
\mathbb{L} = - \sum_{i=1}^m y_i \log \frac{e^{\vec \omega_i \vec x}}{\sum_{j=1}^m e^{\vec \omega_j \vec x}} = - \log \frac{e^{\vec \omega_* \vec x}}{\sum_{i=1}^m e^{\vec \omega_i \vec x}}
$$

Note that we derive the above equations with the fact that the \\(\vec y\\) in the softmax regression 
is a one-hot vector. The \\(\*\\) in \\(\vec \omega\_\*\\) denotes the value in \\(\vec y\\) with index 
\\(\*\\) is one. 

If we view \\(\vec \omega_i \vec x\\) as a function of \\(\omega_i\\) with \\(\vec x\\) fixed, such 
as \\(\mathcal{E}(\vec \omega_i) = \vec \omega_i \vec x\\), then the above equations can be further 
derived as:

$$
\mathbb{L} = -\vec \omega_* \vec x + \log \sum_{i = 1}^m e^{\vec \omega_i \vec x} = -\mathcal{E}(\vec \omega_*) + \log \sum_{i = 1}^m e^{\mathcal{E}(\vec \omega_i)}
$$

The the gradient of loss with respect to parameters \\(\Omega\\) is:

$$
\nabla_\Omega\mathbb{L} = -\nabla_\Omega\mathcal{E}(\vec \omega_*) + \nabla_\Omega \log \sum_{i = 1}^m e^{\mathcal{E}(\vec \omega_i)} = -\nabla_\Omega\mathcal{E}(\vec \omega_*) + \frac{1}{\sum_{i = 1}^m \mathcal{E}(\vec \omega_i)} \sum_{i = 1}^m e^{\mathcal{E}(\vec \omega_i)}\nabla_\Omega\mathcal{E}(\vec \omega_i)
$$

Recall that the probability \\(P(y_i = 1\| \vec x, \Omega) = \frac{e^{\mathcal{E}(\omega_i)}}{\sum_{i=1}^m e^{\mathcal{E}(\omega_i)}} = P_i\\), we have:

$$
\nabla_\Omega\mathbb{L} = -\nabla_\Omega\mathcal{E}(\vec \omega_*) + \sum_{i = 1}^m \frac{e^{\mathcal{E}(\vec \omega_i)}}{\sum_{j = 1}^m \mathcal{E}(\vec \omega_j)} \nabla_\Omega\mathcal{E}(\vec \omega_i) = -\nabla_\Omega\mathcal{E}(\vec \omega_*) + \sum_{i = 1}^m P_i \nabla_\Omega\mathcal{E}(\vec \omega_i)
$$

We can see that the gradient is composed with two parts, the first term is the positive reinforcement 
of the target output, the second term is the negative reinforcement of all possible outputs with 
their probability, which is an expectation of the gradient of \\(\mathcal{E}\\).

It is obvious that the second term is hard to calculate when there are a lot of possible outputs. More 
specifically, it is the calculation of \\(P_i\\) in the formulae requiring most computation, as it 
requires to traverse all the possible output to achieve the normalisation.

### The importance sampling

We can approximate the expected value \\(\mathbb{E}\\) of any probability distribution using the 
Monte Carlo method, by taking the mean of random samples of the probability distribution. We just 
sample \\(N\\) outputs \\(o_i\\) with the probability \\(P_i\\), then we get the expectation:

$$
\mathbb{E}_{i \sim P}[\nabla_\Omega \mathcal{E}(\omega_i)] \approx \frac{1}{N} \sum_{i=1}^N \nabla_\Omega \mathcal{E}(\vec\omega_{o_i})
$$

However, in order to sample from the probability distribution \\(P\\), we need to compute \\(P\\), 
which is what we want to avoid in the first place. The importance sampling is to approximate the 
target distribution \\(P\\) by using a proposal distribution \\(Q\\) in the Monte Carlo process.

In the language modelling, the unigram distribution is usually used as the proposal distribution 
\\(Q\\).

In order to avoid the expense to compute the weight \\(P_i\\) of the sampled output's gradient 
\\(\nabla_\Omega \mathcal{E}(\omega_i)\\), a biased estimator is proposed, which can be used when 
the distribution \\(P\\) is computed as a product. The biased estimator calculates the weight 
\\(\frac{1}{R} r(\vec\omega_i)\\) with the proposal distribution \\(Q\\), where 
\\(r(\vec\omega_i) = \frac{e^{\mathcal{E}(\vec\omega_i)}}{Q_i}\\) and \\(R=\sum_{i=1}^mr(\vec\omega_i)\\).

The expectation is approximated as:

$$
\mathbb{E}_{i \sim P}[\nabla_\Omega \mathcal{E}(\omega_i)] \approx \frac{1}{R}\sum_{i=1}^N r(\vec\omega_{o_i})\nabla_\Omega \mathcal{E}(\omega_{o_i})
$$

The fewer the samples are used, the worse the approximation is. And the importance sampling suffers 
the risk of the divergence of the model caused by the divergence between \\(P\\) and \\(Q\\) with 
small \\(N\\).

### The noise contrastive estimation

The NCE is proposed as a more stable sampling method than the IS. The NCE does not estimate the output 
probability, it instead optimises an auxiliary loss.

The loss function in NCE is proposed as:

$$
\mathbb{J} = - \sum_{i=1}^m [ \log P(y=1|\vec\omega_i) + k \mathbb{E}_{i \sim Q}[\log P(y=0|\vec{\tilde{\omega}}_i)] ]
$$

It means for every output, we generate \\(k\\) noise samples from the noise distribution \\(Q\\), 
and \\(y\\) is the label for the binary classification task, with \\(y=1\\) for target outputs and 
\\(y=0\\) for noise samples. In language modelling, we can use the unigram distribution as \\(Q\\).

To avoid summing over all possible outputs to calculate the normalized probability of a negative 
label in computing the \\(\mathbb{E}_{i\sim Q}\\), we use the Monte Carlo approximation:

$$
\mathbb{J} = - \sum_{i=1}^m [ \log P(y=1|\vec\omega_i) + k \sum_{i=1}^k \frac{1}{k} \log P(y=0|\vec{\tilde{\omega}}_i) ] = - \sum_{i=1}^m [ \log P(y=1|\vec\omega_i) + \sum_{i=1}^k \log P(y=0|\vec{\tilde{\omega}}_i) ]
$$

So, in the NCE, we sample labels from two distributions: sampling positive labels from the empirical 
distribution of the training set \\(P_{\text{train}}\\), and sampling negative labels from the 
noise distribution \\(Q\\).

We can thus represent the probability of sampling either a positive or a noise sample as a mixture 
of those two distributions, which are weighted based on the number of samples that come from each:

$$
P(y, \vec\omega_i) = \frac{1}{k+1}P_{\text{train}}(\vec\omega_i) + \frac{k}{k+1}Q(\vec\omega_i)
$$

So that, we have:

$$
P(y=1|\vec\omega_i) = \frac{\frac{1}{k+1}P_{\text{train}}(\vec\omega_i)}{\frac{1}{k+1}P_{\text{train}}(\vec\omega_i) + \frac{k}{k+1}Q(\vec\omega_i)} = \frac{P_{\text{train}}(\vec\omega_i)}{P_{\text{train}}(\vec\omega_i) + kQ(\vec\omega_i)}
$$

Since \\(P_{\text{train}}\\) is target of the modelling, we use the current probability of the model 
\\(P(y = 1 | \Omega, \vec x) = \frac{e^{\vec\omega_i \vec x}}{\sum_{i=j}^m e^{\vec\omega_j \vec x}}\\) 
in the above formulae during the training.

Computing \\(P(y = 1 | \Omega, \vec x)\\) means that we need to sum over all possible outputs. In 
NCE, we treat \\(Z(\vec x) = \sum_{i=1}^m e^{\vec\omega_i \vec x}\\) as a parameter to learn for the 
model. In some research, it shows that \\(Z(\vec x)\\) is close to \\(1\\) and has low variance.

By setting \\(Z(\vec x) = 1\\), we have:

$$
P(y=1|\vec\omega_i) = \frac{e^{\vec\omega_i \vec x}}{e^{\vec\omega_i \vec x} + kQ(\vec\omega_i)}
$$

Finally, we get the loss of NCE as:

$$
\mathbb{J} = - \sum_{i=1}^m [ \log \frac{e^{\vec\omega_i \vec x}}{e^{\vec\omega_i \vec x} + kQ(\vec\omega_i)} + \sum_{i=1}^k \log (1 - \frac{e^{\vec\omega_i \vec x}}{e^{\vec\omega_i \vec x} + kQ(\vec\omega_i)}) ]
$$

The NCE can be shown to approximate the loss of the softmax as the number of samples \\(k\\) 
increases.

### The negative sampling

In NEG, the objective function is an approximation to NCE.

Recall that, in NCE we have:

$$
P(y = 1|\vec\omega_i) = \frac{e^{\vec\omega_i \vec x}}{e^{\vec\omega_i \vec x} + kQ(\vec\omega_i)}
$$

In NEG, it sets \\(kQ(\vec\omega_i) = 1\\) to simplify the computation:

$$
P(y = 1|\vec\omega_i) = \frac{e^{\vec\omega_i \vec x}}{e^{\vec\omega_i \vec x} + 1}
$$

\\(kQ(\vec\omega_i) = 1\\) is true, when \\(k=m\\) and \\(Q\\) is a uniform distribution. In this 
case NEG is equivalent to NCE.

Setting \\(kQ(\vec\omega_i) = 1\\) instead of other constants makes \\(P(y = 1|\vec\omega_i)\\) a 
sigmoid function:

$$
P(y = 1|\vec\omega_i) = \frac{e^{\vec\omega_i \vec x}}{e^{\vec\omega_i \vec x} + 1} = \frac{1}{1+e^{-\vec\omega_i \vec x}} = \delta(\vec\omega_i \vec x)
$$

In the end, we have:

$$
\mathbb{J} = - \sum_{i=1}^m [ \log \delta(\vec\omega_i \vec x) + \sum_{i=1}^k \log \delta(-\vec\omega_i \vec x) ]
$$

As NEG is an approximation to NCE, it does not ensure optimize the likelihood of the model, so it's 
not suitable for language modelling. But for learning distributed representation of the input, such 
as in word2vec, it is good to use.

### The infrequent normalisation

Back to the binary classification formed loss:

$$
\mathbb{L} = \sum_i [-\mathcal{E}(\vec \omega_i) + \log \sum_{i = 1}^m e^{\mathcal{E}(\vec \omega_i)}]
$$

Let's deonte \\(Z(\vec x) = \sum_{i = 1}^m e^{\mathcal{E}(\vec \omega_i)}\\) as in the noise 
contrastive estimation. We further introduce a penalty term in the loss:

$$
\mathbb{L} = \sum_i [-\mathcal{E}(\vec \omega_i) + \log Z(\vec x) + \alpha(\log Z(\vec x) - 0)^2]
$$

where the penalty term encourages the model to learn \\(\log Z(\vec x)\\) close to \\(0\\), so that 
\\(Z(\vec x)\\) close to \\(1\\).

And the loss can be further reduced as:

$$
\mathbb{L} = \sum_i [-\mathcal{E}(\vec \omega_i) + \alpha \log^2 Z(\vec x)]
$$

This is called the self-normalisation.

In infrequent normalisation, it further down-samples the penalty term:

$$
\mathbb{L} = - \sum_{i=1}^m \mathcal{E}(\vec \omega_i) + \frac{\alpha}{\gamma} \sum_{c \in C}\log^2 Z(\vec x)
$$

It computes the penalty based on a subset of \\(C\\), where \\(C\\) denotes the whole set of all 
possible outputs. And \\(\gamma\\) controls the size of the subset.

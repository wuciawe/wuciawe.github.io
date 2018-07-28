---
layout: post
category: [machine learning, math]
tags: [machine learning, math, stat]
infotext: "Efficient weighted sampling based on stratified sampling and stochastic universal sampling."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

In many cases, we need to sample with replacement a number of samples 
according to some probabilities/weights.

A straight forward way is to align the candidates on a stroke, and sample 
a point uniformly on the stroke at each sampling step, the candidates containing 
the sampled points are the sample result. Suppose we want to sample \\(M\\) samples 
out of \\(N\\) candidates, this method requres \\(O(MN)\\) complexity.

Following I will introduce two efficient sampling methods based on 
stratified sampling and stochastic universal sampling.

### Stratified Sampling

In statistics, stratified sampling is a method of sampling from a population.

In statistical surveys, when subpopulations within an overall population vary, 
it is advantageous to sample each subpopulation (stratum) independently. 
Stratification is the process of dividing members of the population into 
homogeneous subgroups before sampling. The strata should be mutually exclusive: 
every element in the population must be assigned to only one stratum. 
The strata should also be collectively exhaustive: no population element can be excluded. 
Then simple random sampling or systematic sampling is applied within each stratum. 
The objective is to improve the precision of the sample by reducing sampling error. 
It can produce a weighted mean that has less variability than the arithmetic mean 
of a simple random sample of the population.

Let \\(N\\) be the population size and \\(n\\) the sample size, let \\(N_h\\) and 
\\(n_h\\) be the population and sample sizes for stratum \\(h\\).

$$
W_h = \frac{N_h / N}{n_h / n} = \frac{N_h}{n_h} \frac{n}{N} = \frac{f}{f_h} \rightarrow 
\begin{cases}
W_h < 1, & f_h > f\\
W_h = 1, & f_h = f\\
W_h > 1, & f_h < f
\end{cases}
$$

where \\(\frac{n}{N}\\) is the sampling fraction \\(f\\) for the 
whole sample and \\(\frac{N_h}{n_h}\\) is the inverse of the 
sampling fraction, of the probability of selection, in the 
\\(h\\)-th stratum, \\(f_h\\). (\\(w_h=\frac{N_h}{n_h}\\) is the 
inverse probability sampling weight of a unit \\(i\\) in stratum \\(h\\).)

We can see that the \\(W_h\\) is the relative weight showing by how much 
a given stratum is under/oversampled.

Based on the above background knowledge, suppose we want to sample 
with replacement \\(M\\) samples from \\(N\\) candidates. In the 
sampling process, we align the candidates on a stroke and put another 
stroke, split to \\(M\\) parts evenly, parallel to the first stroke. To 
get the \\(m\\)-th sample, we sample a point from the \\(m\\)-th part 
of the second stroke uniformly, and pick the candidate aligned with 
the point as the sample result.

Here, each part of the second stroke is a stratum and we pick one sample 
from each stratum. The first stroke corresponds to the total population 
size and each portion in the first stroke aligned with the part of the 
second stroke corresponds to the population size of each stratum. So we 
have the population size is \\(\sum w_i\\) and the sample size is \\(M\\). 
And for each stratum, the population size is \\(\frac{\sum w_i}{M}\\) and 
the sample size is \\(1\\). And each stratum is composed by the corresponding 
\\(w_i\\) aligned with the evenly split part of the second stroke.

With everything at hand, we have 
\\(W_h = \frac{N_h}{n_h}\frac{n}{N} = \frac{\frac{\sum w_i}{M}}{1}\frac{M}{\sum w_i} = 1\\).

Following is the implementation in scala:

{% highlight scala linenos=table %}
def stratifiedSampling[T](candidates: Array[T], weights: Array[Double], m: Int): Array[T] = {
  val ml = scala.collection.mutable.MutableList.empty[T]
  val sampleWidth = weights.sum / m
  var currentWeights = 0D
  var currentIndex = -1
  (0 until m).foreach { i =>
    val sampleDist = (i + scala.util.Random.nextDouble()) * sampleWidth
    while (sampleDist >= currentWeights && currentIndex + 1 < candidates.length) {
      currentIndex += 1
      currentWeights += weights(currentIndex)
    }
    ml += candidates(currentIndex)
  }
  scala.util.Random.shuffle(ml).toArray
}
{% endhighlight %}

### Stochastic Universal Sampling

Stochastic universal sampling (SUS) is a technique used in 
genetic algorithms for selecting potentially useful solutions 
for recombination. It was introduced by James Baker.

SUS is a development of fitness proportionate selection (FPS) 
which exhibits no bias and minimal spread. Where FPS chooses several 
solutions from the population by repeated random sampling, SUS uses 
a single random value to sample all of the solutions by choosing them at 
evenly spaced intervals. This gives weaker members of the population 
(according to their fitness) a chance to be chosen and thus reduces 
the unfair nature of fitness-proportional selection methods.

FPS can have bad performance when a member of the population has a really 
large fitness in comparison with other members. Using a comb-like ruler, 
SUS starts from a small random number, and chooses the next candidates 
from the rest of population remaining, not allowing the fittest members 
to saturate the candidate space.

In the stratified sampling, we generate one random number for each sample, 
while in the stochastic universal sampling, we only need generate one 
random number for the whole process.

Following is the implementation in scala:

{% highlight scala linenos=table %}
def stochasticUniversalSampling[T](candidates: Array[T], weights: Array[Double], m: Int): Array[T] = {
  val ml = scala.collection.mutable.MutableList.empty[T]
  val sampleWidth = weights.sum / m
  var currentWeights = - scala.util.Random.nextDouble() * sampleWidth
  var currentIndex = -1
  (0 until m).foreach { i =>
    val sampleDist = i * sampleWidth
    while (sampleDist >= currentWeights && currentIndex + 1 < candidates.length) {
      currentIndex += 1
      currentWeights += weights(currentIndex)
    }
    ml += candidates(currentIndex)
  }
  scala.util.Random.shuffle(ml).toArray
}
{% endhighlight %}

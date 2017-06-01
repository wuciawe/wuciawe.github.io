---
layout: post
category: [machine learning, math, recommendation, optimization]
tags: [machine learning, math, recommendation, collaborative filtering, alternating least squares]
infotext: "A simple review on collaborative filtering. This topic was a nightmare in all previous interviews, as those collaborative filter methods messed up in my mind, and I didn't have time to sort them out."
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

The collaborative filtering is a commonly used model in recommendation systems. Suppose we have a bunch 
of goods and a group of users who have rated some of the goods, we want to infer the ratings a user will 
rate on the goods that have not yet been rated on.

Following is the notation, suppose we have \\(n\\) users \\(\mathcal{U} = \\{u\\}^n\\), 
\\(m\\) items \\(\mathcal{I} = \\{i\\}^m\\), and \\(\\{r_{ui}\\}\\) are non-negative numbers 
which denotes the observations of the ratings user \\(u\\) give item \\(i\\), we want to infer the 
value of \\(\\{\hat{r}_{ui}\\}\\) that have not been observed yet.

### Neighborhood models

Here I will introduce two kinds of neighborhood models: user to user / item to item models, and 
content based models.

#### user to user / item to item

This sort of algorithms are based on the assumption that users with similar rating behaviour are more 
likely to rate the same score on a certain item, or similar items will have similar ratings on the 
other side, where the former one is called the user-oriented approach and the latter one is called 
the item-oriented approach.

For the user-oriented approach, based on the previously observed ratings behaviour of the users, the 
similarity \\(s\_{uv}\\) between user \\(u\\) and user \\(v\\) can be calculated. To infer the 
unobserved rating \\(\hat{r}\_{ui}\\), we first find the \\(k\\) closest users 
\\(\mathcal{S}^k(u; i)\\) to the user \\(u\\) who had previously rated on item \\(i\\), then the 
rating \\(\hat{r}\_{ui}\\) is calculated as:

$$
\hat{r}_{ui} = \frac{1}{\Phi}\sum_{v \in \mathcal{S}^k(u; i)}s_{uv}r_{vi}
$$

where \\(\Phi = \sum\_{v \in \mathcal{S}^k(u; i)}s\_{uv}\\) is the normalization factor.

Similarly for item-oriented approach, with the similarity \\(s\_{ij}\\) between item \\(i\\) and 
item \\(j\\) calculated based on the ratings of the commond set of users all of whom have rated them, 
in order to infer the rating \\(\hat{r}\_{ui}\\), we have the neighbor set 
\\(\mathcal{S}^k(u; i)\\) with \\(k\\) nearest items to item \\(i\\) rated by user \\(u\\), where the 
similarity is most commonly obtained by __the Pearson coefficient__. (For more details on similarity 
matrices, view [notes on similarity matrices]({% post_url 2016-06-09-notes-on-similarity-measurements %}).) The rating is

$$
\hat{r}_{ui} = \frac{1}{\Phi}\sum_{j \in \mathcal{S}^k(u; i)}s_{ij}r_{uj}
$$

where \\(\Phi = \sum\_{j \in \mathcal{S}^k(u; i)}s\_{ij}\\) is the normalization factor.

I remember that in the early version of the implementation of mahout, it uses this kind of models for 
collaborative filtering.

#### content based models

The content based models are similar to the item-oriented approaches, the difference is that in the 
content models the similarities between items are calculated by the profiles or the attributions of 
the items.

It might also make sense to build a content based model based the user-profiles.

After obtaining the similarities between items/users, we apply similar formulae to estimate 
the ratings from a set of nearest items/users' ratings.

### Latent factor model

There are many kinds of latent factor models: pLSA, Latent Dirichlet Allocation, SVD and so on.

In this post, the matrix factorization approach will be discussed, specifically the SVD.

In this approach, each user \\(u\\) is associated with a user vector \\(\boldsymbol{x\_{u}}\\) and 
each item \\(i\\) is associated with an item vector \\(\boldsymbol{y\_{i}}\\), then the rating made by 
user \\(u\\) on item \\(i\\) is as \\(r\_{ui} = \boldsymbol{x}\_u^T\boldsymbol{y}\_i\\). (`NOTE`: 
It seems that in this approach only positive numbers are valid observed ratings.)

Then we can build up the following objective function:

$$
\min_{x_*, y_*}\sum_{\text{observed} r_{ui}} (r_{ui} - \boldsymbol{x}_u^T\boldsymbol{y}_i)^2 + \lambda(||\boldsymbol{x}_u||^2 + ||\boldsymbol{y}_i||^2)
$$

where \\(\lambda\\) is the regularization factor.

### Implicit feedback latent factor model

In the above approach, it only utilizes the explicit feedback made by the users, while in this 
approach, the implicit feedback information is used as well.

In the following, two kinds of implicit feedback latent factor models will be discussed.

#### Unknown name model

I forget the name of the model. Let's just simply step on.

First introduce the indicator \\(p\_{ui}\\) indicating the preference of user \\(u\\) to item \\(i\\)

$$
p_{ui} = \begin{cases}1\quad&r_{ui} \gt 0\\0\quad&r_{ui} = 0\end{cases}
$$

And introduce the variable \\(c\_{ui}\\) indicating the conference in observing \\(p\_{ui}\\)

$$
c_{ui} = 1 + \alpha r_{ui}
$$

where \\(\alpha\\) is the constant rate of the increase with rating. As we observe more evidence for 
preference, our conference in \\(p\_{ui}\\) increases accordingly. Now the objective function is built 
up as

$$
\min_{x_*, y_*}\sum_{u, i}c_{ui}(p_{ui} - \boldsymbol{x}_u^T\boldsymbol{y}_i)^2 + \lambda(||\boldsymbol{x}_u||^2 + ||\boldsymbol{y}_i||^2)
$$

where \\(\lambda\\) is the normalization factor. Here the objective function involves all pairs of 
\\(u\\) and \\(i\\) instead of only the observed ratings. That is because this algorithm aims to model 
both the implicit feedback and explicit feedback, which implies that a lack of feedback does not mean 
the user have no preference in the item for example the item is just too expansive to afford and an 
appearance of positive feedback does not mean the user really have a positive preference in the item as 
the user may choose the item as a gift for someone else or choose the item by coincidence.

#### SVD++

This is an variation of SVD based models, in which it includes the effect of the implicit information 
as opposed to \\(\boldsymbol{x}\_u\\) that only includes the effect of the explicit one. It assumes 
that a user rates an item is in itself an indication of preference. In other words, chances that the 
user likes an item he/she has rated are higher than for a random not-rated item.

The objective function is similar to that of SVD apporach:

$$
\min_{x_*, y_*}\sum_{\text{observed} r_{ui}} (r_{ui} - (\boldsymbol{x}_u + |N(u)|^{-\frac{1}{2}}\sum_{j \in N(u)} yay_j)^T\boldsymbol{y}_i)^2 + \lambda(||\boldsymbol{x}_u||^2 + ||\boldsymbol{y}_i||^2 + \sum_{j \in N(u)} ||yay_j||^2)
$$

http://www.recsyswiki.com/wiki/SVD%2B%2B

`NOTE`: In all the above three models, no negative feedback is allowed. (Maybe negative feedback makes 
sense in the neighborhood models.)

### Alternating least squares

For the objective function of the implicit feedback latent factor model, we can see that when we fix 
either the user factors or the item factors, the objective function becomes quadratic. Alternating 
between the re-computing of user factors and item factors, each step is guaranteed to lower the value 
of the cost function. This process is call the __alternating least squares__, it is also used for 
explicit feedback latent factor model.

First fix \\(\boldsymbol{y}\_i\\), solving for \\(\boldsymbol{x}\_u\\):

$$
\begin{array}
\quad&\mathcal{F}(\boldsymbol{x}_u) &= \sum_{u, i}c_{ui}(p_{ui} - \boldsymbol{x}_u^T\boldsymbol{y}_i)^2 + \lambda(\boldsymbol{x}_u^T \boldsymbol{x}_u + \boldsymbol{y}_i^T\boldsymbol{y}_i)\\
\Rightarrow&\frac{\mathcal{F}(\boldsymbol{x}_u)}{\boldsymbol{x}_u} &= -2\sum_ic_{ui}(p_{ui} - \boldsymbol{x}_u^T\boldsymbol{y}_i)\boldsymbol{y}_i + 2\lambda\boldsymbol{x}_u\\
\quad&\quad&= -2\sum_ic_{ui}(p_{ui} - \boldsymbol{y}_i^T\boldsymbol{x}_u)\boldsymbol{y}_i + 2\lambda\boldsymbol{x}_u\\
\quad&\quad&= -2Y^TC^u\boldsymbol{p}_u + 2Y^TC^uY\boldsymbol{x}_u + 2\lambda\boldsymbol{x}_u\\
\Rightarrow&\quad 0 &= -2Y^TC^u\boldsymbol{p}_u + 2Y^TC^uY\boldsymbol{x}_u + 2\lambda\boldsymbol{x}_u\\
\Rightarrow&\quad \boldsymbol{x}_u &= (Y^TC^uY + \lambda I)^{-1}Y^TC^u\boldsymbol{p}_u
\end{array}
$$

Similar for \\(\boldsymbol{y}_i\\), we have:

$$
\boldsymbol{y}_i = (X^TC^iX + \lambda I)^{-1}X^TC^i\boldsymbol{p}_i
$$

where \\(C^\*\\)'s are diagonal matrices with \\(C^u_{ii} = c_{ui}\\) and \\(C^i_{uu} = c_{ui}\\), 
and \\(\boldsymbol{p}\_\*\\) are vectors. Using the above two equations repeatedly alternatively 
until convergence, we will come to the solution.

### Make prediction

After solving the implicit feedback latent factor model, we can make prediction as

$$
\hat{p}_{ui} = \sum_{j: r_{uj} \gt 0} s_{ij}^u c_{uj}
$$

where \\(s\_{ij}^u = \boldsymbol{y}\_i^TW^u\boldsymbol{y}\_u\\) is the weighted similarity between 
item \\(i\\) and item \\(j\\) from the user \\(u\\)'s viewpoint, and 
\\(W^u = (Y^TC^uY + \lambda I)^{-1}\\) is the weighted matrix associated with user \\(u\\).

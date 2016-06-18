---
layout: post
category: [algorithm]
tags: [path search]
infotext: 'general idea of A* algorithm, also compared with dijkstra and greedy algorithms in shortest path searching application.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

Suppose there is a map composed with weighted edges and vertices, and we 
want to find the shortest path from a start point to an end point. All weights 
of the edges are non-negative. 
[Here](http://theory.stanford.edu/~amitp/GameProgramming/AStarComparison.html){:target='_blank'} 
is a great article about the A* algorithm and path searching.

### The Dijkstra's algorithm

The idea of the Dijkstra's algorithm for this task is to find the lowest cost 
of visiting each vertex from the start point outwards until reaching the end 
point.

That is to say, from the start point, visit all the lowest cost vertices from 
all the approachable vertices. And then repeatedly processing visiting all the 
current approachable lowest cost vertices and update approachable vertices set 
until meeting the end point. It will guarantee the global optimal path.

Also as the procedure implies, it will visit a lot of vertices not on the optimal 
path until find the optimal solution, which means it's not fast.

### The Greedy search algorithm

In the greedy search algorithm, we visit the local optimal vertices in each step. 
The rule of determining the local optimal vertex is based on the heuristic on 
the expectation of the cost from the vertex to the end point.

So in each step, the greedy search algorithm visits the estimated lowest cost 
vertices to the end point from all the approachable vertices. Since the real 
cost rarely matches the estimated cost, the final path are probably not the 
global optimal.

In summary, the greedy algorithm gives an optimal result with fast speed. Sometimes 
the estimated cost may vary from the real cost dramatically, which will result in 
disaster both in the goodness of the found path and the speed.

### The A* algorithm

A* is like Dijkstra’s algorithm in that it can be used to find a shortest path. A* is 
like Greedy Best-First-Search in that it can use a heuristic to guide itself. It can 
be as fast as Greedy Best-First-Search. It can also be as good as Dijkstra's algorithm.

In each step, the A* algorithm visits the approachable vertices based on the cost:

$$
c(n) = g(n) + h(n)
$$

where \\(g(n)\\) is the exact cost from the start point to this vertex \\(n\\), and 
\\(h(n)\\) is the heuristic that tells an estimate of the minimum cost from vertex 
\\(n\\) to the end point. 

The heuristic can be used to control A*’s behavior.

- At one extreme, if \\(h(n)\\) is 0, then only \\(g(n)\\) plays a role, and A* turns 
into Dijkstra’s algorithm, which is guaranteed to find a shortest path.
- If \\(h(n)\\) is always lower than (or equal to) the cost of moving from \\(n\\) to 
the end point, then A* is guaranteed to find a shortest path. The lower \\(h(n)\\) is, 
the more node A* expands, making it slower.
- If \\(h(n)\\) is exactly equal to the cost of moving from \\(n\\) to the end point, 
then A* will only follow the best path and never expand anything else, making it very 
fast. Although you can’t make this happen in all cases, you can make it exact in some 
special cases. It’s nice to know that given perfect information, A* will behave 
perfectly.
- If \\(h(n)\\) is sometimes greater than the cost of moving from \\(n\\) to the end 
point, then A* is not guaranteed to find a shortest path, but it can run faster.
- At the other extreme, if \\(h(n)\\) is very high relative to \\(g(n)\\), then only 
\\(h(n)\\) plays a role, and A* turns into Greedy Best-First-Search.

To get the exact heuristic, one can pre-compute the costs from a vertex to the end 
point.
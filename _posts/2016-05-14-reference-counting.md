---
layout: post
category: [java]
tags: [java, garbage collection]
infotext: 'read an article about another way to detect cycle in reference counting, but there is no prove, doubt the correctness'
---
{% include JB/setup %}

### Reference Counting

Reference counting is a way to collect garbage based on the counting of the references referred to an object. It is simple 
and seems efficient. But if there are a group of objects that mutually reference to each other but none of them 
referred by other live object outside of that group, then each object in that group has a positive reference counting, 
but all of them should be collected as they are not really live at all.

In order to overcome that problem, a full gc may be required to be performed periodically. Or in a tree structure, the 
weak reference can be used to break cycle as the parent refers to the child with strong reference and the child 
refer to the parent with a weak reference and weak references don't contribute to the reference counting.

Days before, I read [an article](http://c2.com/cgi/wiki?ReferenceCountingCanHandleCycles){:target='_blank'} about another way to perform cycle detection in reference counting.

### Another Potential Approach

**Definitions:**

- **Transitive closure of _x_** - the set of objects which can be reached from **x** (including itself) by following references.
- **Damaged** - the state of an object from the time that it loses some reference, to the time it is proven that it oughtn't be freed.
- **Referend** - the object referred to by the reference in question.

**Axiom:** Objects referred to by a live object are live.

**Lemma:** Objects in the transitive closure of a live object are live.

**Axiom:** If every object is live before an object becomes damaged, objects not in the transitive closure of the damaged object are live, despite the damage.

For each object, assign two fields for the GC's use: a current reference count, and a temporary reference count. The temporary count is normally zero.

When an object **x** is damaged, do:

1.  Decrement the current reference count of **x**.
2.  Perform a search starting from **x**, following all paths, so as to find the transitive closure 
of **x**. Each time a reference is followed, increment the referend's temporary count. The referend 
can be visited multiple times, but the out arrow can be followed only once. (`NOTE`)
3.  For each object **y** in the transitive closure of **x**: if **y**'s current reference count 
exceeds its temporary reference count, then it must have a link from "outside", so it is live by 
the previous axiom. Thus its transitive closure is live, by the previous lemma.
4.  All objects in the transitive closure of **x** which were not demonstrated to be live by the 
previous step, are dead. (`PROVE`) For each **z** in this set:
    1.  Decrement the reference count of each object referred to by **z**. Since the transitive 
    closure of these objects is contained within the transitive closure of **x**, no need for recursion.
    2.  Free the memory of **z**. Any object which referred to **z** before the deletion, will eventually 
    be removed in this step; otherwise **z** could not have been determined to be dead.
5.  Reset the temporary counts (to zero) of all the objects which were found to be live.

`NOTE:` I think the temporary reference count of the transitive closure should be equivalent to the 
out-degree of the transitive closure.

`PROVE:` _(I assume that statement is right, or the following is bullshit.)_ 

The current reference count of an object denotes the in-degree of that object in current object graph. 
The temporary reference count of an object denotes the in-degree of that object that are contributed 
from the transitive closure. From this, we get a conclusion that the temporary reference count should 
either be equivalent to the current reference count or be less than the current reference count. 

For each object, it has its transitive closure, which at least contains itself. Every out-degree of that 
object reaches another object, that reached object is included in the transitive closure. And the child's 
transitive closure is a sub-set of its parent's transitive closure.

Since the temporary reference count of an object denotes all the in-degree of that object that are contributed 
from the out-degree of the closure, if the current reference count exceeds the temporary reference count, 
it means that the object is referenced by some other object outside of the closure. It's a live object and 
all the objects in its transitive closure are live.

For all those remaining objects that are not referenced by outside object nor in the transitive closure 
of any live objects, its temporary reference count must be equivalent to its current reference count. And 
the remaining closure's out-degrees become the in-degrees in the remaining closure, which means there 
is no outside reference to any object in the remaining closure. Suppose some object in the remaining 
closure is live, then there exist at least one object in the remaining closure which finally references 
to the object and has a greater current reference count than the temporary reference count which draws 
a contradiction with the fact that every object in the remaining closure has an equivalent count of the 
temporary reference count and the current reference count.

Done.

Even the above approach works, it is slow as it may require to traverse most object in the memory in the 
case where the closure is large. And it requires to be performed with each decrement of reference count 
of any object.

Though you can save operations as building a damaged object list, it still performs poor easily.
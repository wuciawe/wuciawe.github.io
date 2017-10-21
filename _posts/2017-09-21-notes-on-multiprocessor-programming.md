---
layout: post
category: [multicore]
tags: [multicore]
infotext: 'brief introduction to multicore programming in the shared-memory architecture.'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

A shared-memory multiprocessor, a.k.a multicore, is a system that multiprocessors communicating 
via a shared memory. Multiprocessor programming is challenging because modern computer systems 
are inherently asynchronous: activities can be halted or delayed without warning by interrupts, 
preemption, cache misses, failures, and other events. These delays are inherently unpredictable, 
and can vary enormously in scale: a cache miss might delay a processor for fewer than ten 
instructions, a page fault for a few million instructions, and operating system preemption for 
hundreds of millions of instructions.

### Amdahl's Heartbreaking Law

Amdahl's Law captures the notion that the extent to which we can speed up any 
complex job is limited by how much of the job must be executed sequentially.
Define the speedup $$S$$ of a job to be the ratio between the time it takes one 
processor to complete the job versus the time it takes $$n$$ concurrent processors 
to complete the same job. Amdahl's Law characterizes the maximum speedup $$S$$ that 
can be achieved by $$n$$ processors collaborating on an application, where $$p$$ is the 
fraction of the job that can be executed in parallel. Assume that it takes time 
$$1$$ for a single processor to complete the job. With $$n$$ concurrent processors, the 
parallel part takes time $$\frac{p}{n}$$ and the sequential part takes time $$1 - p$$. 
Overall, the parallelized computation takes time: $$1 - p + \frac{p}{n}$$.

Amdahl's Law says that the speedup, that is, the ratio between the sequential 
time and the parallel time, is $$S = \frac{1}{1 - p + \frac{p}{n}}$$.

In practice, there is some job which has little fraction can be executed in parallel, 
you can hardly speedup the execution no matter how many resources you have under such 
a heartbreaking condition.

### Reasoning about the concurrent computation

Reasoning about the concurrent computation is mostly reasoning about time. Sometimes 
we want things to happen simultaneously, and sometimes we want them to happen at 
different times. We need to reason about complicated conditions involving how 
multiple time intervals can overlap, or, sometimes, how they cannot.

__A thread is a state machine__, and its state transitions are called events. Events are 
instantaneous: they occur at a single instant of time. It is convenient to require 
that events are never simultaneous: distinct events occur at distinct times.

__A critical section__ is a block of code that can be executed by only one thread at a 
time. And this is the property __mutual exclusion__.

#### Properties

__Mutual Exclusion__: Critical sections of different threads do not overlap. The mutual 
exclusion is a safety property.

Two kinds of communication occur naturally in concurrent systems:

- __Transient communication__ requires both parties to participate at the same time.
- __Persistent communication__ allows the sender and receiver to participate at different times.

Mutual exclusion requires persistent communication.

__Freedom from Deadlock__: If some thread attempts to acquire the lock, then some thread will 
succeed in acquiring the lock. The deadlock-freedom property implies that the system never 
freezes. Individual threads may be stuck forever (called starvation), but some thread makes 
progress. The deadlock-freedom is a __liveness property__.

A program composed with locks all satisfying deadlock-free property is __`not`__ guaranteed to 
be deadlock-free. For example, consider threads $$A$$ and $$B$$ that share locks $$l0$$ and 
$$l1$$. First, $$A$$ acquires $$l0$$ and $$B$$ acquires $$l1$$. Next, $$A$$ tries to acquire 
$$l1$$ and $$B$$ tries to acquire $$l0$$. The threads deadlock because each one waits for 
the other to release its lock. *A program can still deadlock even if each of the locks it 
uses satisfies the deadlock-freedom property.*

__Freedom from Starvation__ (lockout-freedom property): Every thread that attempts to acquire 
the lock eventually succeeds. The starvation freedom implies deadlock freedom. The 
starvation-freedom property is the least compelling of the three. It is also weak in the sense 
that there is no guarantee for how long a thread waits before it enters the critical section.

__Fairness__: the starvation-freedom property guarantees that every thread that calls `lock()` 
eventually enters that critical section, but it makes no guarantees about how long this 
may take. Ideally if $$A$$ calls `lock()` before $$B$$, then $$A$$ should enter the critical 
section before $$B$$.

Any algorithm that is both deadlock-free and first-come-first-served is also starvation-free.

Any deadlock-free Lock algorithm based on reading and writing memory requires allocating and 
then reading or writing at least $$n$$ distinct locations in the worst case where $$n$$ is the 
maximum number of concurrent threads.

#### Blocking and nonblocking

Along a different dimension, different method implementations provide different progress 
guarantees. Some are blocking, where the delay of any one thread can delay others, and some 
are nonblocking, where the delay of a thread cannot delay the others.

#### Consistency

The behavior of concurrent objects is best described through their safety and liveness properties, 
often referred to as correctness and progress.

Three correctness conditions: 

- __Quiescent consistency__ is appropriate for applications that require high performance at 
the cost of placing relatively weak constraints on object behavior.
- __Sequential consistency__ is a stronger condition, often useful for describing low-level 
systems such as hardware memory interfaces.
- __Linearizability__, even stronger, is useful for describing higher-level systems composed from 
linearizable components.

Method calls take time. A method call is the interval that starts with an invocation event and 
ends with a response event. Method calls by concurrent threads may overlap, while method calls 
by a single thread are always sequential. We say a method call is pending if its call event has 
occurred, but not its response event.

A correctness property $$\mathcal{P}$$ is __compositional__ if, whenever each object in the system 
satisfies $$\mathcal{P}$$, the system as a whole satisfies $$\mathcal{P}$$.

The order in which a single thread issues method calls is called its __program order__.

__Quiescent consistency__ is defined by two principles:

- Method calls should appear to happen in a one-at-a-time, sequential order.
- Method calls separated by a perioid of quiescence should appear to take effect in their 
real-time order.

Informally, it says that any time an object becomes quiescent, then the execution so far is 
equivalent to some sequential execution of the completed calls.

A method is total if it is defined for every object state; otherwise it is partial. In any 
concurrent execution, for any pending invocation of a total method, there exists a quiescently 
consistent response. The quiescent consistency is a nonblocking correctness condition.

__Sequential consistency__ is defined by two principles:

- Method calls should appear to happen in a one-at-a-time, sequential order.
- Method calls should appear to take effect in program order.

Sequential consistency requires that method calls act as if they occurred in a sequential 
order consistent with program order.

Sequential consistency and quiescent consistency are incomparable: there exist sequentially 
consistent executions that are not quiescently consistent, and vice versa. Quiescent 
consistency does not necessarily preserve program order, and sequential consistency is 
unaffected by quiescent periods.

In most modern multiprocessor architectures, memory reads and writes are not sequentially 
consistent: they can be typically reordered in complex ways. Most of the time no one can tell, 
because the vast majority of reads-writes are not used for synchronization. In those specific 
cases where programmers need sequential consistency, they must ask for it explicitly. The 
architectures provide special instructions (usually called __memory barriers__ or __fences__) that 
instruct the processor to propagate updates to and from memory as needed, to ensure that 
reads and writes interact correctly. In the end, the architectures do implement sequential 
consistency, but only on demand.

Sequential consistency, like quiescent consistency, is nonblocking: any pending call to 
a total method can always be completed. Sequential consistency is not compositional.

__Linearizability__: Each method call should appear to take effect instantaneously at some 
moment between its invocation and response. This principle states that the real-time 
behaviour of method calls must be preserved. Every linearizable execution is sequentially 
consistent, but not vice versa. The usual way to show that a concurrent object implementation 
is linearizable is to identify for each method a linearization point where the method takes 
effect. Linearizability, like sequential consistency, is nonblocking. Like quiescent 
consistency, but unlike sequential consistency, linearizability is compositional.

Compositionality is important because it allows concurrent systems to be designed and 
constructed in a modular fashion; linearizable objects can be implemented, verified, and 
executed independently. A concurrent system based on a noncompositional correctness 
property must either relay on a centralized scheduler for all objects, or else satisfy 
additional constraints placed on objects to ensure that they follow compatible 
scheduling protocols.

#### Wait-free and Lock-free

A method is __wait-free__ if it guarantees that every call finishes its execution in a finite 
number of steps. It is __bounded wait-free__ if there is a bound on the number of steps a 
method call can take. A wait-free method whose performance does not depend on the number 
of active threads is called __population-oblivious__.

The wait-free property is attractive because it guarantees that every thread that takes 
steps makes progress. However, wait-free algorithms can be inefficient, and sometimes 
we are willing to settle for a weaker nonblocking property.

A method is __lock-free__ if it guarantees that infinitely often some method call finishes in 
a finite number of steps. Any wait-free method implementation is also lock-free, but not 
vice versa. Lock-free algorithms admit the possibility that some threads could starve. 
As a practical matter, there are many situations in which starvation, while possible, is 
extremely unlikely, so a fast lock-free algorithm may be more attractive than a slower 
wait-free algorithm.

A method call executes in isolation if no other threads take steps. A method is 
__obstruction-free__ if, from any point after which it executes in isolation, it finishes in 
a finite number of steps.

Like the other nonblocking progress conditions, the obstruction-free condition ensures that not 
all threads can be blocked by a sudden delay of one or more other threads. A lock-free algorithm 
is obstruction-free, but not vice versa.

The obstruction-free algorithm rules out the use of locks but does not guarantee progress 
when multiple threads execute concurrently. It seems to defy the fair approach of most 
operating system schedulers by guaranteeing progress only when one thread is unfairly 
scheduled ahead of the others.

### Consensus

The foundations of sequential computing were established in the 1930s by Alan Turing 
and Alonzo Church, who independently formulated what has come to be known as the 
Church-Turing Thesis: anything that can be computed, can be computed by a Turing 
Machine (or, equivalently, by Church's Lambda Calculus). Any problem that cannot be 
solved by a Turing Machine (such as deciding whether a program halts on any input) is 
universally considered to be unsolvable by any kind of practical computing device. 
The Turing Thesis is a thesis, not a theorem, because the notion of "what is computable" 
can never be defined in a precise, mathematically rigorous way. Nevertheless, just about 
everyone believes it.

If one thinks of primitive synchronization instructions as objects whose exported methods 
are the instructions themselves (in the literature these objects are often referred to 
as synchronization primitives), one can show that there is an infinite hierarchy of 
synchronization primitives, such that no primitive at one level can be used for a wait-free 
or lock-free implementation of any primitives at higher levels. The basic idea is simple: 
each class in the hierarchy has an associated consensus number, which is the maximum 
number of threads for which objects of the class can solve an elementary synchronization 
problem called consensus. In a system of $$n$$ or more concurrent threads, it is impossible 
to construct a wait-free or lock-free implementation of an object with consensus number 
$$n$$ from an object with a lower consensus number.

Atomic registers have consensus number $$1$$. It is impossible to construct a wait-free 
implementation of any object with consensus number greater than $$1$$ using atomic registers.

Many, if not all, of the classical synchronization operations provided by multiprocessors 
in hardware can be expressed as read-modify-write (RMW) operations, or, as they are called 
in their object form, read-modify-write registers. A method is an RMW for the function set 
$$\mathcal{F}$$ if it atomically replaces the current register value $$v$$ with $$f(v)$$, 
for some $$f \in \mathcal{F}$$, and returns the original value $$v$$. An RMW method is 
nontrivial if its set of functions includes at least one function that is not the identity 
function.

Any nontrivial RMW register has consensus number at least $$2$$.

A set of functions $$\mathcal{F}$$ belongs to __Common2__ if for all values $$v$$ and all 
$$f_i$$ and $$f_j$$ in $$\mathcal{F}$$, either:

- $$f_i$$ and $$f_j$$ commute: $$f_i(f_j(v)) = f_j(f_i(v))$$, or
- one function overwrites the other: $$f_i(f_j(v)) = f_i(v) or f_j(f_i(v)) = f_j(v)$$

A RMW register belongs to __Common2__ if its set of functions $$\mathcal{F}$$ belongs to 
__Common2__. Any RMW register in __Common2__ has consensus number (exactly) $$2$$.

A register providing `compareAndSet()` and `get()` methods has an infinite consensus number.

A class is universal in a system of $$n$$ threads if, and only if it has a consensus number 
greater than or equal to $$n$$.

A class $$C$$ is universal if one can construct a wait-free implementation of any object from 
some number of objects of $$C$$ and some number of read-write registers.

Any mutual exclusion protocol poses the question: what do you do if you cannot acquire the 
lock? There are two alternatives. If you keep trying, the lock is called a __spin lock__, and 
repeatedly testing the lock is called __spinning__, or __busywaiting__. The alternative is to 
__suspend__ yourself and ask the operating system's scheduler to schedule another thread on your 
processor, which is sometimes called __blocking__.

### Practicing

We consider a typical multiprocessor architecture in which processors communicate by a shared 
broadcast medium called a bus (like a tiny Ethernet). Both the processors and the memory 
controller can broadcast on the bus, but only one processor (or memory) can broadcast on the 
bus at a time. All processors (and memory) can listen. Today, bus-based architectures are 
common because they are easy to build, although they scale poorly to large numbers of processors.

Each processor has a cache, a small high-speed memory where the processor keeps data likely 
to be of interest. A memory access typically requires orders of magnitude more machine 
cycles than a cache access.

When a processor reads from an address in memory, it first checks whether that address and 
its contents are present in its cache. If so, then the processor has a cache hit, and can 
load the value immediately. If not, then the processor has a cache miss, and must find the 
data either in the memory, or in another processor's cache. The processor then broadcasts the 
address on the bus. The other processors snoop on the bus. If one processor has that address 
in its cache, then it responds by broadcasting the address and value. If no processor has 
that address, then the memory itself responds with the value at that address.

Following are two different implementations of spin lock:

{% highlight java linenos=table %}
public class TASLock implements Lock {
  AtomicBoolean state = new AtomicBoolean(false);
  public void lock() {
    while(state.getAndSet(true)) {}
  }
  public void unlock() {
    state.set(false);
  }
}
{% endhighlight %}

In `TASLock`, each `getAndSet()` call is broadcast on the bus. Because all threads 
must use the bus to communicate with memory, these `getAndSet()` calls delay all 
threads, even those not waiting for the lock. Even worse, the `getAndSet()` call 
forces other processors to discard their own cached copies of the lock, so every 
spinning thread encounters a cache miss almost every time, and must use the bus to 
fetch the new, but unchanged value. Adding insult to injury, when the thread holding 
the lock tries to release it, it may be delayed because the bus is monopolized 
by the spinners.

{% highlight java linenos=table %}
public class TTASLock implements Lock {
  AtomicBoolean state = new AtomicBoolean(false);
  public void lock() {
    while(true) {
      while(state.get()) {};
      if(!state.getAndSet(true))
        return;
    }
  }
  public void unlock() {
    state.set(false);
  }
}
{% endhighlight %}

Now consider the behaviour of the `TTASLock` algorithm while the lock is held by a 
thread $$A$$. The first time thread $$B$$ reads the lock it takes a cache miss, forcing 
$$B$$ to block while the value is loaded into $$B$$'s cache. As long as $$A$$ holds the lock, 
$$B$$ repeatedly rereads the value, but hits in the cache every time. $$B$$ thus produces 
no bus traffic, and does not slow down other threads' memory accesses. Moreover, 
a thread that releases a lock is not delayed by threads spinning on that lock.

The situation deteriorates, however, when the lock is released. The lock holder releases 
the lock by writing false to the lock variable, which immediately invalidates the 
spinners' cached copies. Each one takes a cache miss, rereads the new value, and 
they all (more-or-less simultaneously) call `getAndSet()` to acquire the lock. The first 
to succeed invalidates the others, who must then reread the value, causing a storm 
of bus traffic. Eventually, the threads settle down once again to local spinning.

This notion of local spinning, where threads repeatedly reread cached values instead 
of repeatedly using the bus, is an important principle critical to the design of 
efficient spin locks.

### Transaction

With conventional synchronization primitives, we have problems as follows

- Locks are hard to manage effectively, especially in large systems.
- Atomic primitives such as `compareAndSet()` operate on only one word at a time, 
resulting in complex algorithms.
- It is difficult to compose multiple calls to multiple objects into atomic units.

__A transaction__ is a sequence of steps executed by a single thread. Transactions must 
be __serializable__, meaning that they appear to execute sequentially, in a one-at-a-time 
order.

Serializability is a kind of coarse-grained version of linearizability. Linearizability 
defined atomicity of individual objects by requiring that each method call of a given 
object appear to take effect instantaneously between its invocation and response, 
Serializability, on the other hand, defines atomicity for entire transactions, that is, 
blocks of code that may include calls to multiple objects. It ensures that a transaction 
appears to take effect between the invocation of its first call and the response to its 
last call.

Some definitions of serializability in the literature do not require transactions to be 
serialized in an order compatible with their real-time precedence order.

Properly implemented, transactions do not deadlock or livelock.

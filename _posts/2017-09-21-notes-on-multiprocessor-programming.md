A shared-memory multiprocessor, a.k.a multicore, is a system that multiprocessors communicating via a shared memory. 
Multiprocessor programming is challenging because modern computer systems are inherently asynchronous: 
activities can be halted or delayed without warning by interrupts, preemption, cache misses, failures, 
and other events. These delays are inherently unpredictable, and can vary enormously in scale: 
a cache miss might delay a processor for vewer than ten instructions, a page fault for a few million 
instructions, and operating system preemption for hundreds of millions of instructions.

mutual exclusion property
deadlock-freedom property
starvation-freedom property (lockout-freedom property)

Two kinds of communication occur naturally in concurrent systems:

Transient communication requires both parties to participate at the same time.
Persistent communication allows the sender and receiver to participate at different times.

Mutual exclusion requires persistent communication.

Amdahl's Law captures the notion that the extent to which we can speed up any 
complex job is limited by how much of the job must be executed sequentially.
Define the speedup S of a job to be the ratio between the time it takes one 
processor to complete the job versus the time it takes n concurrent processors 
to complete the same job. Amdahl's Law characterizes the maximum speedup S that 
can be achieved by n processors collaborating on an application, where p is the 
fraction of the job that can be executed in parallel. Assume that it takes time 
1 for a single processor to complete the job. With n concurrent processors, the 
parallel part takes time p/n and the sequential part takes time 1 - p. Overall, 
the parallelized computation takes time: 

1-p+p/n

Amdahl's Law says that the speedup, that is, the ratio between the sequential 
time and the parallel time, is 

S=1/(1-p+p/n)

Reasoning about the concurrent computation is mostly reasoning about time. Sometimes 
we want things to happen simultaneously, and sometimes we want them to happen at 
different times. We need to reason about complicated conditions involving how 
multiple time intervals can overlap, or, sometimes, how they cannot.

A thread is a state machine, and its state transitions are called events. Events are 
instantaneous: they occur at a single instant of time. It is convenient to require 
that events are never simultaneous: distinct events occur at distinct times.

A critical section is a block of code that can be executed by only one thread at a 
time. And this is the property mutual exclusion.

Mutual Exclusion: Critical sections of different threads do not overlap.

Freedom from Deadlock: If some thread attempts to acquire the lock, then some thread will 
succeed in acquiring the lock.

Freedom from Starvation: Every thread that attempts to acquire the lock eventually succeeds.

The starvation freedom implies deadlock freedom.

The mutual exclusion is a safety property. The deadlock-freedom property implies that the 
system never freezes. Individual threads may be stuck forever (called starvation), but some 
thread makes progress. The deadlock-freedom is a liveness property. A program can still 
deadlock even if each of the locks it uses satisfies the deadlock-freedom property. For 
example, consider threads A and B that share locks l0 and l1. First, A acquires l0 and B 
acquires l1. Next, A tries to acquire l1 and B tries to acquire l0. The threads deadlock 
because each one waits for the other to release its lock. The starvation-freedom property 
is the least compelling of the three. It is also weak in the sense that there is no 
guarantee for how long a thread waits before it enters the critical section.



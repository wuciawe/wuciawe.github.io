---
layout: post
category: [jvm]
tags: [jvm, concurrency]
infotext: 'introduction to concurrency in jvm'
---
{% include JB/setup %}

Days ago, when I wanted to set up some schudled task in each executor in a Spark Streaming job, 
I did not find an appropriate tool at first try. Many years ago, I have learnt Java very 
roughly. Then years later, I learnt Scala in more depth, but still remained very limited knowledge 
about Java. So in the following years, when I needed parallelism, I utilized 
Akka in Scala. Until days before I faced that task, I found that it was overcomplicated to 
use Akka in Spark executors. And not until then, I found the concurrent tools in the standard Java.

### Concurrency v.s. Parallelism

Concurrency and parallelism are very similar concepts, and there are different definitions to them. 
Take an example. The concurrency is that when you have more than one task in a single processor with 
a single core and the operating system's scheduler quickly switches from one task to another, so it 
seems that all the tasks run simultaneously. The parallelism is that when you have more than one task 
run simultaneously in a different computer, processor, or core inside a processor.

According to Oracle’s “Multithreading Guide”, parallelism is “a condition that arises when at least 
two threads are executing simultaneously.” In contrast, concurrency is “a condition that exists when 
at least two threads are making progress. [It is a] more generalized form of parallelism that can 
include time-slicing as a form of virtual parallelism.

### Synchronization

In concurrency, we define synchronization as the coordination of two or more tasks to get the 
desired results.

- Control synchronization: a task wait until another task finishes.
- Data access synchronization: more than one tasks access to a shared data with only one of them 
access the data at any time.

A `critical section` is a piece of code that can only be executed by one task at any time. `Mutual 
exclusion` is the mechanism used to guarantee that concurrent threads don't simultaneously execute 
a critical section, the critical section is accessed in a serial manner, and can be implemented by 
different ways.

The most popular mechanisms to achieve synchronization in a concurrent system is:

- Semaphore: It has a variable that stores the number of resources that can be used and two atomic 
operations to manage the value of the variable. A `mutex` (mutual exclusion) is a special kind of 
semaphore that can take only two values (free or busy).
- Monitor: It has a mutex, a condition variable, and two operations to wait for the condition and 
to signal the condition. Once you signal the condition, one of the tasks that are waiting for the 
resource continues with its execution.

Thread-safe can be achieved by protecting the shared data with synchronization mechanisms, non-blocking 
compare-and-swap primitive, or immutable data.

#### CAS

Compare-and-swap (CAS) is the generic term for an uninterruptible microprocessor-specific instruction 
that reads a memory location, compares the read value with an expected value, and stores a new value 
in the memory location when the read value matches the expected value. Otherwise, nothing is done.

#### Reentrant Synchronization

Recall that a thread cannot acquire a lock owned by another thread. But a thread can acquire a lock that 
it already owns. Allowing a thread to acquire the same lock more than once enables reentrant synchronization. 
This describes a situation where synchronized code, directly or indirectly, invokes a method that also 
contains synchronized code, and both sets of code use the same lock. Without reentrant synchronization, 
synchronized code would have to take many additional precautions to avoid having a thread cause itself to 
block.

#### Synchronization mechanisms in Java

Some most important mechanisms for defining a critical section or synchronize tasks in a common point:

- `synchronized` keyword: define a critical section in a block of code or in an entire method. The 
synchronized keyword exhibits two properties: mutual exclusion and visibility. The JVM supports synchronized 
keyword via monitors and the `monitorenter` and `monitorexit` JVM instructions.
  - synchronized method acquires the intrinsic lock for the instance the method belongs to
  - static synchronized method acquires the intrinsic lock for the Class object associated with the class
  - synchronized block acquires the intrinsic lock for the specified object

Every Java object is associated with a monitor. When a thread locks a monitor, the values of 
shared variables that are stored in main memory are read into the copies of these variables 
that are stored in a thread's working memory (cache memory). This ensures that the thread will 
work with the most recent values of these variables and not stale values, and is known as 
visibility. When the thread unlocks the monitor, the values in its copies of shared variables 
are written back to main memory.

- Lock, ReentrantLock, Condition, ReadWriteLock, ReentrantReadWriteLock, and StampedLock: 
offer more extensive locking operations than can be obtained via the locks associated with 
monitors. All Lock implementations are required to enforce the same memory synchronization 
semantics as provided by the built-in monitor lock.
  - Lock
    - `lock`: acquire the lock, wait until the lock becomes available.
    - `lockInterruptibly`: acquire the lock unless the calling thread is interrupted.
    - `newCondition`: return a new Condition instance that's bound to this Lock instance.
    - `tryLock`: acquire the lock when it's available at the time this method is invoked.
    - `unlock`: release the lock.
    
    Lock implementations must provide the same memory-visibility semantics as intrinsic locks, 
    but can differ in their locking semantics, scheduling algorithms, ordering guarantees, and 
    performance characteristics.
    
  - ReentrantLock: it is associated with a hold count. When a thread acquire the lock, the 
  hold count is increased by one. When the thread unlock it, the hold count is decremented 
  by one. The lock is released when the hould count reaches zero.
  
    ReentrantLock offers the same concurrency and memory semantics as the implicit monitor 
    lock that's accessed via synchronized keyword. Acquiring a ReentrantLock has the same 
    memory semantics as entering a synchronized block, and releasing a ReentrantLock has 
    the same memory semantics as exiting a synchronized block. It has extended capabilities 
    and offers better performance under high thread contention.
  
  - Condition: it factors out Object's wait and notification methods into distinct 
  condition objects to give the effect of having multiple wait-sets per object, by combining 
  them with the use of arbitrary Lock implementations. A Condition instance is intrinsically 
  bound to a lock.
  - ReadWriteLock: it maintains a pair of locks: one lock for read-only operations and one lock 
  for write operations. The read lock may be held simultaneously be multiple reader threads 
  as long as there are no writers. The write lock is exclusive: only a single thread can modify 
  shared data.
    - `readLock`: return the lock that's used for reading
    - `writeLock`: return the lock that's used for writing
  - ReentrantReadWriteLock.
  
    A thread that tries to acquire a fair read lock (non-reentrantly) will block when the write 
    lock is held or when there's a waiting writer thread. The thread will not acquire the read lock 
    until after the oldest currently waiting writer thread has acquired and released the write lock. 
    If a waiting writer abandons its wait, leaving one or more reader threads as the longest waiters 
    in the queue with the write lock free, those readers will be assigned the read lock.
  
    A thread that tries to acquire a fair write lock (non-reentrantly) will block unless both the 
    read lock and write lock are free (which implies no waiting threads).
  
  - StampedLock: is a capability-based lock with three modes for controlling read/write access. It 
  allows for optimistic reads.
- Semaphore: it maintains a set of permits for restricting the number of threads that can access a limited 
resource. The fairness policy can be configured during construction. If it is configured as fair, then FIFO 
is ensured.
  - `acquire`/`acquire(n)`: acquire a/n permit(s) from the semaphore, blocking until enough permit(s) are 
  available.
  - `acquireUninterruptibly`/`acquireUninterruptibly(n)`: similar to `acquire`/`acquire(n)`, but not 
  interruptible.
  - `tryAcquire`/`tryAcquire(n)`: similar to `acquire`/`acquire(n)`, but return immediately with a boolean 
  indicating whether enough permit(s) are available at the time of invocation.
  - `drainPermits`: acquire and return a count of all permits that are available.
  - `availablePermits`: return the number of current available permits.
  - `getQueueLength`: return an estimate of the number of threads waiting to acquire permits.
  - `isFair`: fairness
  - `release`/`release(n)`: release a/n permit(s)
- CountDownLatch: it consists of a count and causes threads to wait until the count decremented to zero.
  - `await`: force the calling thread to wait until the latch has counted down to zero
  - `countDown`: decrement the count, releasing all waiting threads when the count reaches zero. Nothing 
  happens when the count is already zero when this method is called.
  -  `getCount`: return the current count
  
  A binary semaphore can be used as a `mutex` with nonreentrant locking semantics.
  
- CyclicBarrier: it lets a set of threads wait for each other to reach a common barrier point. The barrier 
is cyclic because it can be reused after the waiting threads are released. Latches are for waiting for 
events; barriers are for waiting for other threads.

  The constructor of the CyclicBarrier can accept a Runnable which is executed when the barrier is tripped. 
  It can be used to update shared state before any of the threads continue.

  - `await`: force the calling thread to wait until all parties have invoked `await`.
  - `getNumberWaiting`: return the number of parties that are currently waiting at the barrier.
  - `getParties`: return the number of parties that are required to trip the barrier.
  - `isBroken`: check whether there exist parties breaking out of this barrier because of interruption or 
  timeout.
  - `reset`: reset the barrier to its initial state. If any parties are currently waiting at the barrier, 
  they will return with BrokenBarrierException.

- Phaser: a more flexible cyclic barrier. It lets a group of threads wait on a barrier until the last thread 
arrives. Different from a cyclic barrier which coordinates a fixed number of threads, a phaser can coordinate 
a variable number of threads, which can register at any time.
  - `register`: add a new unarrived thread to this phaser.
  - `arriveAndAwaitAdvance`: record arrival and wait for the phaser to advance.
  - `arriveAndDeregister`: arrive at this phaser and deregister from it without waiting for others to arrive, 
  reducing the number of threads required to advance in future phases.
- Exchanger: provides a synchronization point where threads can swap objects.
  - `exchange`: wait for another thread to arrive at this exchange point, and then transfer the given object 
  to it, receiving the other thread's object in return. If another thread is already waiting at the exchange 
  point, the current thread returns immediately.

### The Java Memory Model

`volatile` is a weaker form of `synchronized` keyword which ensures the visibility only.

CPU have different levels of cache, and each core has its own cache, which stores the minimal set of main 
memory (RAM) for performance. Each thread mutates the variable and the result of the mutation may not be 
visible to other threads. There is no guarantee that operations in one thread will be performed in the order 
given by the program, as long as the reordering is not detectable from within that thread -- even if the 
reordering is apparent to other threads. In the absence of synchronization, the Jave Memory Model permits the 
compiler to reorder operations and cache values in registers, and permits CPUs to reorder operations and cache 
values in processor-specific caches. `volatile` keyword ensures the visibility of the mutation.

The Java Memory Model is defined in happens before rules, e.g. there is a happens before rule between a volatile 
write of field x and a volatile read of field x. So when a write is done, a subsequent read will see the value 
written.

`volatile` also prevents compiler over-optimising the order of execution of the code, which is achieved by 
the Java Memory Model.

A volatile filed can not also be declared `final`.

`final` is a more limited version of the `const` mechanism from C++, supports the construction of 
immutable objects. Final fields can not be modified, and have special sematics under the Java Memory Model. 
It is the use of final fields that makes possible the guarantee of `initialization safety` that lets 
immutable objects be freely accessed and shared without synchronization. Properly constructed final 
fields can be safely accessed without additional synchronization. However, if final fields refer to 
mutable objects, synchronization is still required to access the state of the objects they refer to.

`static` initializer is often the easiest and safest way to publish objects that can be statically 
constructed. Static initializers are executed by the JVM at class initialization time, because of internal 
synchronization in the JVM, this mechanism is guaranteed to safely publish any objects initialized in this 
way.

The safe publication mechanisms all guarantee that the as-published state of an object is visible to all 
accessing threads as soon as the reference to it is visible, and if that state is not going to be changed 
again, this is sufficient to ensure that any access is safe. If an object may be modified after 
construction, safe publication ensures only the visibility of the as-published state.

#### what is it

The Java Language Specification requires the JVM to maintain `within-thread as-if-serial` semantics: 
as long as the program has the same result as if it were executed in program order in a strictly 
sequential environment, all these games are permissible. Compilers may generate instructions in a 
different order than the one suggested by the source code, or store variables in registers instead 
of in memory; processors may execute instructions in parallel or out of order; caches may vary the 
order in which writes to variables are committed to main memory; and values stored in 
processor-local caches may not be visible to other processors.

In a multithreaded environment, the illusion of sequentiality can not be maintained without 
significant performance cost. The JMM specifies the minimal guarantees the JVM must make about when 
writes to variables become visible to other threads. It was designed to balance the need for 
predictability and ease of program development with the realities of implementing high-performance 
JVMs on a wide range of popular processor architectures.

In a shared-memory multiprocessor architecture, each processor has its own cache that is periodically 
reconciled withmain memory. Processor architectures provide varing degrees of cache coherence. An 
architecture's memory model tells programs what guarantees they can expect from the memory system, 
and specifies the special instructions required (called memory barriers or fences) to get 
additional memory coordination guarantees required when sharing data. Java provides its own memory 
model, and the JVM deals with the differences between the JMM and the underlying platform's memory 
model by inserting memory barriers at the appropriate places.

The Java Memory Model is specified in terms of `action`s, which include reads and writes to 
variables, locks and unlocks of monitors, and starting and joining with threads. The JMM defines 
a partial ordering called `happens-before` on all actions within the program. To guarantee that 
the thread executing action B can see the results of action A, there must be a `happens-before` 
relationship between A and B. In the absence of a `happens-before` ordering between two operations, 
the JVM is free to reorder them as it pleases.


### Race

#### Race condition

When more than one tasks mutate a shared data outside the critical section, it will cause race condition. 
A race condition occurs when the correctness of a computation depends on the relative timing or 
interleaving of multiple threads by the scheduler.

Common types of race condition are: `check-then-act`, `read-modify-write`.

#### Data race

A data race is often confused with a race condition, where more than one threads access the same memory 
concurrently, at least one of them is for writing, and the threads don't coordinate their accesses to 
that memory.

### Liveness

#### Deadlock

When the four Coffman's conditions happen simultaneously in the system, the deadlock happens:

1.  Mutual exclusion: the resources involved in the deadlock is not shareable.
2.  Hold and wait condition: A task holds the mutual excluson for a resource and it requires the 
mutual exclusion for another resource.
3.  No pre-emption: The resources can only be released by the tasks that hold them.
4.  Circular wait: There is a circular waiting.

It is a good practice to get locks in the same order.

The above is the most deadlock, called lock ordering deadlock. Besides, there is thread starvation 
deadlock which means threads waiting for results from each other.

#### Livelock

A livelock occurs when two tasks in the system chaing their states due to the actions of the other. 
Consequently, they are in a loop of state changing and unable to continue. That says, the thread keeps 
retrying an operation that is always fail, and it makes no progress.

#### Starvation

Starvation occurs when a task in the system never gets the resource that it needs to continue with its 
execution. `Fairness` is the solution to this problem. All the tasks that are waiting for the resource 
must have the resource in a given period of time.

Starvation is also referred to as indefinite postponement.

### Thread

Each Java application has a default main thread that executes the `main()` method, the entry 
point of the application. Threads can create threads to run simultaneously. Each thread has its 
own JVM stack to prevent threads from interfering with each other.

The main thread is a non `daemon` thread, which means it will prevent JVM exits until it 
finishes its execution. A daemon thread is a service provider thread, when all the non daemon 
threads finish execution, the JVM terminates daemon threads automatically and exits.

Thread is usually used with Runnable object, following is an example.

{% highlight java linenos=table %}
Runnable r = () -> System.out.println("Hi");
Thread t = new Thread(r);
t.setDaemon(true);
t.start();
{% endhighlight %}

Calling start() results in the runtime creating the underlying thread and scheduling it for subsequent 
execution in which the runnable’s run() method is invoked. When execution leaves run(), the thread is 
destroyed and the Thread object on which start() was called is no longer viable, and 
IllegalThreadStateException will arise.

Some interesting methods:

- `interrupt`: interrupt the thread

  A good way to think about interruption is that it does not actually interrupt a running thread; it just 
  requests that the thread interrupt itself at the next convenient opportunity, which is called 
  `cancellation point`.

- `join`: wait the thread to die
- `sleep`: temporarily cease execution, no waste of processor cycles
- `holdsLock`: check whether the thread holds the lock on an object

`wait`, `notify`, and `notifyAll` methods of Object used with Thread.

- `wait`: cause the current thread to wait until another thread invokes `notify` or `notifyAll` for 
this object, or for some other thread to interrupt the current thread while waiting.
- `notify`: wake up a single thread that's waiting on this object's monitor.
- `notifyAll`: wake up all threads that are waiting on this object's monitor.

{% highlight java linenos=table %}
synchronized(obj) {
  while (<condition does not hold>)
    obj.wait();
  // Perform an action that's appropriate to condition.
}

synchronized(obj) {
  // Set the condition.
  obj.notify();
}
{% endhighlight %}

Calling `wait` inside a loop takes the benifit of testing the condition before calling `wait`'s 
ensuring liveness and retesting the condition after calling `wait`'s ensuring safety. Testing before 
calling `wait` prevents that the condition holds and `notify` has been called prior to `wait`. 
Retesting the condition after calling `wait` prevents that another thread calls `notify` accidentally 
when the condition doesn't hold.

Notice that `notify` is called from a critical section guarded by the same object as the critical 
section for the `wait` method.

#### ThreadLocal variable

If data is only accessed from a single thread, no synchronization is needed, which is called `thread 
confinement`, one of the simplest ways to achieve thread safety. Swing and pooled JDBC use this 
technique. For example in pooled JDBC, the JDBC specification does not require that `Connection` be 
thread-safe. The pool will not dispense the same connection to another thread until it ihas been 
returned, this pattern of connection management implicitly confines the `Connection` to that thread 
for the duration of the request.

- `ad-hoc thread confinement` describes when the responsibility for maintaining thread confinement 
falls entirely on the implementation.
- `stack confinement` is a special case of thread confinement in which an object can only be reached 
through local variables. Local variables are intrinsically confined to the executing thread. They 
exist on the executing thread's stack, which is not accessible to other threads.
- `ThreadLocal` is a more formal means of maintaining thread confinement, which allows you to associate 
a per-thread value with a value-holding object.

  Each `ThreadLocal` instance describes a thread-local variable, which is a variable that provides a 
  separate storage slot to each thread that accesses the variable. Each thread sees only its value and 
  is unaware of other threads having their own values in this variable.

  `InheritableThreadLocal` is a subclass of `ThreadLocal`, which provides the capability of controlling 
  the initialization of the ThreadLocal variable in child thread from parent thread.

### Timer

The Timer framework can be used to schedule a task to execute once or repeatedly. It is recommanded to 
use the ScheduledThreadExecutor instead, which will be introduced soon in the following paragraphs, for 
reasons:

- Timer can be sensitive to changes in the system clock, ScheduledThreadPoolExecutor isn't.
- Timer has only one execution thread, so long-running task can delay other tasks. 
ScheduledThreadPoolExecutor can be configured with any number of threads. Furthermore, you have full 
control over created threads, if you want (by providing ThreadFactory).
- Runtime exceptions thrown in TimerTask kill that one thread, thus making Timer dead (scheduled tasks 
will not run anymore). ScheduledThreadExecutor not only catches runtime exceptions, but it lets you handle 
them if you want (by overriding afterExecute method from ThreadPoolExecutor). Task which threw exception 
will be canceled, but other tasks will continue to run.

### Executors

The Executor framework is a mechanism that allows you to separate thread creation and management for 
the implementation of concurrent tasks. The Executor framework also resuses the threads so as to 
avoid overhead of the creation of threads.

- ThreadPoolExecutor: a class that provides an executor with a pool of threads and optionally define a 
maximum number of parallel tasks.
- ScheduledThreadPoolExecutor: a speical kind of executor that allows to execute tasks after a delay or 
periodically, which is similar to Timer, but more powerful.
- ForkJoinPool: a special kind of executor specialized in the resolution of problems with the divide and 
conquer technique.
  - `async mode`: it concerns the order in which each worker takes forked tasks that are never joined 
  from its work queue.
  
    In ForkJoinPool, workers in async mode process tasks in FIFO order. By default, it processes tasks in 
    LIFO order.
  
  Work stealing is implemented in `ForkJoinTask.join()`, 
  [here for more information](http://stackoverflow.com/questions/26576260/can-i-use-the-work-stealing-behaviour-of-forkjoinpool-to-avoid-a-thread-starvati){:target='_blank'}. In a work stealing design, every consumer has its own deque. If 
  a consumer exhausts the work in its own deque, it can steal work from the tail of someone else's deque.
  
- Executors: a facility for the creation of executors.
- Callable: an alternative to the Runnable interface, with the ability to return a result.
- Future: an interface that includes the methods to obtain the value returned by a Callable interface 
and to control its status.
  - `FutureTask` acts like a latch. It implements `Future`. A computation represented by a `FutureTask` is 
  implemented with a `Callable`, and can be in one of three states: waiting to run, running, or completed.
  
    The behaviour of `Future.get` depends on the state of the task. If it is completed, it returns the 
    result immediately, and otherwise blocks until the task transitions to the completed state and then 
    returns the result or throws an exception. The specification of `FutureTask` guarantees that this 
    transfer constitutes a safe publication of the result.

### Concurrency design patterns

- Signaling, a task notifies an event to another task

{% highlight java linenos=table %}
public void task1(){
  // codes 1
  obj.notify();
}

public void task2(){
  obj.wait();
  // codes 2
}
{% endhighlight %}

So that codes 2 will always be executed after codes 1 has finished.

- Rendezvous, a generalization of the Signaling pattern, where two tasks wait events from each other.

{% highlight java linenos=table %}
public void task1(){
  // codes 1
  obj1.notify();
  obj2.wait();
  // codes 2
}

public void task2(){
  // codes 3
  obj2.notify();
  obj1.wait();
  // codes 4
}
{% endhighlight %}

In this case, codes 4 will always be executed after codes 1 has finished and codes 2 will always be 
executed after codes 3 has finished. If you switch the wait and notify, there will be a deadlock.

- Mutex, mutual exclusion

{% highlight java linenos=table %}
public void task(){
  // before critical section
  lock.lock();
  // critical section
  lock.unlock();
  // after critical section
}
{% endhighlight %}

- Multiplex, a generalization of the mutex, where a determined number of tasks can execute a block of 
code simultaneously.

{% highlight java linenos=table %}
public void task(){
  // before critical section
  semaphore.acquire();
  // critical section
  semaphore.release();
  // after critical section
}
{% endhighlight %}

- Barrier, a mechanism to synchronize tasks at a common point.

{% highlight java linenos=table %}
public void task(){
  // before sync point
  barrier.await();
  // after sync point
}
{% endhighlight %}

- Double-checked locking, a pattern for condition testing under concurrent execution

{% highlight java linenos=table %}
if(<condition testing>) {
  lock.lock();
  try{
    if(<condition testing>) {
      // codes
      // mutating condition
    }
  } finally {
    lock.unlock();
  }
}
{% endhighlight %}

### Costs

- `context switching`: if there are more runnable threads than CPUs, eventually the OS will preempt one 
thread so that another can use the CPU, which requires saving the execution context of the currently 
running thread and restoring the execution context of the newly scheduled thread.

  Thread scheduling requires manipulating shared data structures in the OS and JVM. When a new thread is 
  switched in, the data it needs is unlikely to be in the local processor cache, so a context switch 
  causes a flurry of cache misses.

- `memory synchronization`: the visibility guarantees provided by `synchronized` and `volatile` may entail 
using special instructions called `memory barriers` that can flush or invalidate caches, flush hardware 
write buffers, and stall execution pipelines. Memory barriers may also have indirect performance 
conseuences because they inhibit other compiler optimizations; most operations can not be reordered with 
memory barriers.

  The uncontended synchronization is rarely significant in overall application performance. Modern JVMs 
  can even reduce the cost of incidental synchronization by optimizing away locking that can be proven 
  never to contend. More sophisticated JVMs can use `escape analysis` to identify when a local object 
  reference is never published to the heap and is therefore thread-local. Compilers can also perform 
  `lock coarsening`, the merging of adjacent synchronized blocks using the same lock. It will give the 
  optimizer a much larger block to work with, likely enabling other optimizations.

- `block`: contended synchronization may require OS activity, which adds to cost. When locking is 
contended, the losing threads must block. The JVM can implement blocking either via `spin-waiting` 
(repeatedly trying to acquire the lock until it succeeds) or by `suspending` the blocked thread through 
the operating system.

  Suspending a thread because it could not get a lock, or because it blocked on a condition wait or 
  blocking I/O operation, entails two additional context switches and all the attendant OS and cache 
  activity: the blocked thread is switched out before its quantum has expired, and is then switched back 
  in later after the lock or other resource becomes available. (Blocking due to lock contention also has 
  a cost for the thread holding the lock: when it releases the lock, it must then ask the OS to resume the 
  blocked thread.)

### Other

There are some interesting things on ForkJoinPool in JVM, see 
[link1](https://stackoverflow.com/questions/29966535/confused-by-docs-and-source-of-countedcompleter){:target='_blank'}
and [link2](http://www.coopsoft.com/ar/CalamityArticle.html#faulty){:target='_blank'} for reference.

---
layout: post
category: [jvm]
tags: [jvm, concurrency]
infotext: 'introduction to concurrency in jvm'
---
{% include JB/setup %}

Days ago, when I want to set up some schudled task in each executor in a Spark Streaming job, 
I did not find an appropriate tool at first try. Many years ago, I have learnt Java very 
roughly. Then years later, I learnt Scala in more depth, but still remained very limited knowledge 
about Java. So in the following years, when I need to do something in parallelism, I utilize 
Akka in Scala. Until days before I faced that task, I found that it is over complicated to 
use Akka in Spark executors. And not until then, I found the concurrent tools in standard Java.

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

- synchronized keyword: define a critical section in a block of code or in an entire method. The 
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
  - ReentrantLock: it is associated with a hold count. When a thread acquire the lock, the 
  hold count is increased by one. When the thread unlock it, the hold count is decremented 
  by one. The lock is released when the hould count reaches zero.
  
  ReentrantLock offers the same concurrency and memory semantics as the implicit monitor 
  lock that's accessed via synchronized keyword. It has extended capabilities and offers 
  better performance under high thread contention.
  - Condition: it factors out Object's wait and notification methods into distinct 
  condition objects to give the effect of having multiple wait-sets per object, by combining 
  them with the use of arbitrary Lock implementations. A Condition instance is intrinsically 
  bound to a lock.
  - ReadWriteLock: it maintains a pair of locks: one lock for read-only operations and one lock 
  for write operations. The read lock may be held simultaneously be multiple reader threads 
  as long as there are no writers. The write lock is exclusive: only a single thread can modify 
  shared data.
    - `readLocd`: return the lock that's used for reading
    - `writeLock`: return the lock that's used for writing
  - ReentrantReadWriteLock.
  
  A thread that tries to acquire a fair read lock (non-reentrantly) will block when the write 
  lock is held or when there's a waiting writer thread. The thread will not acquire the read lock 
  until after the oldest currently waiting writer thread has acquired and released the write lock. 
  If a waiting writer abandons its wait, leaving one or more reader threads as the longest waiters 
  in the queue with the write lock free, those readers will be assigned the read lock.
  
  A thread that tries to acquire a fair write lock (non-reentrantly) will block unless both the read 
  lock and write lock are free (which implies no waiting threads).
  
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
- CyclicBarrier: it lets a set of threads wait for each other to reach a common barrier point. The barrier 
is cyclic because it can be reused after the waiting threads are released.

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

`volatile` is a weaker form of synchronized keyword which ensures the visibility only.

CPU have different levels of cache, and each core has its own cache, which stores the minimal set of main 
memory (RAM) for performance. Each thread mutates the variable and the result of the mutation may not be 
visible to other threads. `volatile` keyword ensures the visibility of the mutation.

The Java Memory Model is defined in happens before rules, e.g. there is a happens before rule between a volatile 
write of field x and a volatile read of field x. So when a write is done, a subsequent read will see the value 
written.

`volatile` also prevents compiler over optimising the order of execution of the code, which is achieved by 
the Java Memory Model.

A volatile filed can not also be declared `final`. final fields are thread safe as they are immutable.

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

1 Mutual exclusion: the resources involved in the deadlock is not shareable.
2 Hold and wait condition: A task holds the mutual excluson for a resource and it requires the 
mutual exclusion for another resource.
3 No pre-emption: The resources can only be released by the tasks that hold them.
4 Circular wait: There is a circular waiting.

It is a good practice to get locks in the same order.

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

- ThreadPoolExecutor
- ScheduledThreadPoolExecutor
- Executors
- Runnable
- Callable
- Future
- ForkJoinPool, async mode

### Concurrency design patterns

- Signaling
- Rendezvous
- Mutex
- Multiplex
- Barrier
- Double-checked locking




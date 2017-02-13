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
exclusion` is the mechanism used to guarantee this requirement, and can be implemented by different 
ways.

The most popular mechanisms to achieve synchronization in a concurrent system is:

- Semaphore: It has a variable that stores the number of resources that can be used and two atomic 
operations to manage the value of the variable. A `mutex` (mutual exclusion) is a special kind of 
semaphore that can take only two values (free or busy).
- Monitor: It has a mutex, a condition variable, and two operations to wait for the condition and 
to signal the condition. Once you signal the condition, one of the tasks that are waiting for the 
resource continues with its execution.

Thread-safe can be achieved by protecting the shared data with synchronization mechanisms, non-blocking 
compare-and-swap primitive, or immutable data.

### Race condition

When more than one tasks mutate a shared data outside the critical section, it will cause race condition.

### Deadlock

When the four Coffman's conditions happen simultaneously in the system, the deadlock happens:

1 Mutual exclusion: the resources involved in the deadlock is not shareable.
2 Hold and wait condition: A task holds the mutual excluson for a resource and it requires the 
mutual exclusion for another resource.
3 No pre-emption: The resources can only be released by the tasks that hold them.
4 Circular wait: There is a circular waiting.

Getting locks in the same order.

### Livelock

A livelock occurs when two tasks in the system chaing their states due to the actions of the other. 
Consequently, they are in a loop of state changing and unable to continue.

### Starvation

Starvation occurs when a task in the system never gets the resource that it needs to continue with its 
execution. `Fairness` is the solution to this problem. All the tasks that are waiting for the resource 
must have the resource in a given period of time.

### Synchronization mechanisms in Java

Some most important mechanisms for defining a critical section or synchronize tasks in a common point:

- synchronized keyword: define a critical section in a block of code or in an entire method.
- Lock, ReentrantLock, ReentrantReadWriteLock, and StampedLock
- Semaphore
- CountDownLatch
- CyclicBarrier
- Phaser

### Thread

Each Java application has a default main thread that executes the `main()` method, the entry 
point of the application. Threads can create threads to run simultaneously. Each thread has its 
own JVM stack to prevent threads from interfering with each other.

The main thread is a non `daemon` thread, which means it will prevent JVM exits until it 
finishes its execution. A daemon thread is a service provider thread, when all the non daemon 
threads finish execution, the JVM terminates daemon threads automatically and exits.

Thread local storage

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

### Executors

The Executor framework is a mechanism that allows you to separate thread creation and management for 
the implementation of concurrent tasks. The Executor framework also resuse the threads so as to 
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

### The Java memory model

volatile cache main memory


---
layout: post
category: [java]
tags: [java, jvm, garbage collecion]
infotext: ''
---
{% include JB/setup %}

## Foundation of garbage collection

Instead of collecting and discarding dead objects, Java garbage collection tracks live objects and designates everything 
else. The operating system allocates the heap in advance to be managed by the JVM while the program is running, 
which results in following ramifications:

-   Object creation is fast for needlessness of global synchronization with the operation system. An allocation simply claims 
some portion of a memory array and moves the offset pointer forward.
-   When an object is no longer used(referenced), no explicit deletion is performed, the garbage collector reclaims the underlying 
memory and reuses it.

## Garbage Collection Roots

When an object is no longer used, it is not referenced and becomes unreachable. The GC roots are the roots of references and 
always reachable. There are four kinds of GC roots in Java:

-   **Class** - class loaded by system class loader. (The classes loaded by custom class loaders are not roots.)
-   **Thread** - live thread
-   **Stack Local** - local variable or parameter of Java method
-   **JNI Local** - local variable or parameter of JNI method
-   **JNI Global** - global JNI reference
-   **Monitor Used** - objects used as a monitor for synchronization
-   **Held by JVM** - objects held from garbage collection by JVM, for example: the system class loader, a few important exception 
classes that the JVM knows about, a few pre-allocated objects for exception handling, and custom class loaders when they 
are in the process of loading classes.
-   **Static variables** are referenced by their classes. This fact makes them _de facto_ GC roots. Classes themselves can be 
garbage-collected, which would remove all referenced static variables. This is of special importance when we use application 
servers, OSGi containers or class loaders in general.

A simple Java application has the following GC roots:

-   Local variables in the main method
-   The main thread
-   Static variables of the main class

## Mark-Sweep-Compact algorithm

The JVM intermittently runs the mark-and-sweep algorithm to free unused memory, and performs compacting to avoiding memory 
fragmentation which may impact allocation speed or cause allocation errors:

-   Traverse all object references, starting with the GC roots, and mark every object found as alive.
-   All other heap memory is reclaimed.
-   Move all live objects to one end of the heap.

`When the developer forgot to dereference the unused objects, those are still reachable and thus will still cause memory 
leaks.`

## Reducing garbage collection pause time

In MSC, the more live objects are found, the longer the suspension the JVM takes to mark-and-sweep. And the compaction 
will cause even longer GC cycle, since most JVMs suspend the application execution during compaction.
Executing in parallel or concurrently are two general ways to reduce garbage collection pause time.

**The serial collector** suspends the application and executes the mark-and-sweep algorithm in a single thread. It is the 
simplest and oldest form of garbage collection in Java and is still the default in the Oracle HotSpot JVM.

**The parallel collector** uses multiple threads to do its work. It is often the best choice for throughput applications.

**The concurrent collector** does the majority of its work concurrent with the application execution. It has to suspend 
the application for only very short amounts of time. This has a big benefit for response-time-sensitive applications.

### Concurrent marking and sweeping(mostly)

CMS complicates the relatively simple mark-and-sweep algorithm a bit. The mark phase is usually sub-divided into three 
phases. First suspend all threads, and mark all GC roots as alive. Then traverse all reachable objects concurrently with 
all threads. All threads can create new objects in this phase. Finally, suspend all threads and mark all newly created 
objects as alive. The Oracle JRockit JVM improves this algorithm by keeping new objects in a keep area for their first GC.

In the sweep phase of the CMS, all unused memory areas are added to the free list. JRockit divides the heap into several 
areas, and perform sweep one after another, partially concurrently with application threads. New objects can be allocated in the area not actively being swept.

The downsides of the CMS are:

-   As the marking phase is concurrent to the application's execution, the space allocated for objects can surpass the 
capacity of the CMS, leading to an allocation error.
-   The free lists lead to memory fragmentation and all this entails.

## Reducing the impact of compacting

Nearly all GC execute compaction in parallel and suspend the application during compaction. The JVMs may compact memory in 
smaller, incremental steps instead of a single big block:

-   Execute compaction when a certain level of fragmentation is reached.
-   Execute compaction when a designated percentage of free memory is available as a continuous block.

## Generational garbage collection

As most objects are with short-live-time and only some objects last for a long time, 
the generational garbage collection divides the heap area into two areas: the young generation and the old generation, 
with separate strategies.

Usually objects are created in the young area. A small portion of objects will survive in every GC. An object is tenured 
to old generation after surviving certain GC cycles. As long as the memory is not needed, the unreachable objects in 
the old generation will not be reclaimed.

## Copy collection

In the young generation, copy collection divides the heap into two or more areas to avoid compacting. Only one is used for allocations, when 
it's full, all live objects are copied to another area and mark current area as empty. This is effective with the assumption 
of young generation that only small portion of objects alive after each GC cycle. But it may cause problem when the JVM 
is executing a high number of concurrent transactions.

If the young generation is too small, objects are tenured prematurely to the old generation. If the young generation is 
too large, too many objects are alive and GC cycle will take long time.

If the number of temporary objects is relatively small, a non-generational GC has advantages.

## Problem with concurrency

All threads in the JVM share memory resources, and all memory allocations must be synchronized.

To work around with it, each thread gets its own TLA(Thread Local Area), a portion of the heap. TLA separates the heap 
only for object creation, threads allocate objects in its area, but can access any object in the heap. TLA is usually a 
part of the young generation.

A generational heap with TLA requires a larger young generation. A non-generational heap with TLA is likely 
to be more fragmented and will need more frequent compaction.
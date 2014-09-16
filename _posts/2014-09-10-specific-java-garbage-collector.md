---
layout: post
category: [java]
tags: [java, jvm, garbage collecion]
infotext: 'Brief summation of garbage collectors for different JVMs'
---
{% include JB/setup %}

In last [post]({% post_url 2014-09-09-memory-management-in-java %}), I have illustrated the basic concepts of garbage 
collector. While in different JVMs, the algorithms and strategies of garbage collector are different from each other
 for different use cases. In this post, I will briefly talk about the garbage collector in three major JVMs.
 
<!-- more -->

## Oracle Hotspot JVM

![Oracle Hotspotd JVM](/files/2014-09-10-specific-java-garbage-collector/OracleHotspotJVM.png)

This is a very famous and widely used JVM. It is also a representative of generational garbage collector. As shown in 
in the picture, the young generation is divided into an eden space and two survivor spaces. Before the major garbage 
collection moving objects into the tenured space, the garbage collector will perform minor garbage collection by using 
copy collection to move objects into survivor 1 space then survivor 2 space from the eden space. As the procedure of 
 copy costs much, so the eden space should be large enough to ensure that most objects will be unreferenced in their 
 first GC cycle.

The collection in the young generation could be either serial or parallel, while the collection in the tenured generation 
can be one of the three forms: serial, parallel and concurrent. As the concurrent one will make memory fragmentations 
and thus lead to allocation errors, the CMS will trigger a full GC which performs like that in young generation with 
compacting.

In order to make the GC more efficient, the HotSpot JVM has a permanent generation in addition. The application codes and 
the classes are actually instances of objects in heap of Java. And those class objects and constants are placed in the 
permanent generation to reduce the cost in regular GC cycles. As the proliferation of application servers, OSGi containers and 
dynamically-generated code may load or generate a large number of classes, and those class objects are not so permanent as 
well, the permanent generation will be garbage collected during a major GC cycle to reclaim more free memory and thus 
reduce the risk of going out of memory.

#### Garbage First (G1)

The Oracle's Java 7 includes an implementation of G1 garbage collection algorithm to improve the performance of GC.

The heap is divided into a number of fixed subareas. And the JVM maintains a remember set for every area, which is a 
list of references to objects in that area. The changes of references will be informed to remember set. When GC performs, 
it will first collect the area with most amount of garbage. In an optimal case, there will be no alive in that area, and 
no need for mark-sweep-compact, only a single operation of reclamation is needed.

The G1 can avoid sizing problem as that of young generation in generational collection. In addition, it is possible 
to define targets with G1 collector for example, collect as many areas as it can in a required pause time.

## IBM WebSphere JVM

![IBM WebSphere JVM](/files/2014-09-10-specific-java-garbage-collector/IBMWebSphereJVM.png)

This JVM recommends a single big heap with either a parallel or a concurrent GC strategy in simple applications 
with a heap less than 100MB.

The generational one is as in the picture that a nursery generation is divided into two parts of equal size. 
Objects will allocated in the allocate space. And in GC cycle, the copy collection is used to copy survived objects 
into the survivor space. And these two spaces sweep their roles and waits for another GC cycle.

The IBM WebSphere JVM will treat large objects specifically by allocating them in non-generational heap or directly in 
the tenured generation space, so as to avoid copying tho large objects in minor GC cycles. While the IBM WebSphere JVM also 
treats classes like other normal objects, under some circumstances where classes are repeatedly reloaded, it will lead 
to performance problems.

## Oracle JRockIt JVM

![Oracle JRockIt JVM](/files/2014-09-10-specific-java-garbage-collector/OracleJRockItJVM.png)

The Oracle JRockIt JVM can use a single continuous heap as well as generational GC. The generational GC in the Oracle 
JRockIt JVM declares a block within the nursery generation called keep area. Objects will be first allocated outside 
the keep area. When the nursery fills up, the GC is triggered and new objects will be allocated into the keep area. During 
the GC cycle, alive objects outside the keep area will be copied into the tenured space and all the objects in the keep area 
will be considered alive and left untouched. After the GC cycle, another block of area in the nursery space will be 
declared as the keep area, and everything runs again.

As a result, every object will be copied only once. The nursery space of the Oracle JRockIt JVM should be larger so as to avoid 
unnecessary promotions. And the thread local allocation(TLA) is active in default. The Oracle JRockIt JVM treats large objects 
specifically and class objects normally as that in the IBM WebSphere JVM.

## Other Garbage Collection Strategies

There exist other two garbage collection strategies: remote garbage collection and real time garbage collection. These two may be 
covered in the posts some day.



---
layout: post
category: [jvm]
tags: [jvm]
infotext: 'very rough, or even worse, something incorrect, description on the internal memory in jvm.'
---
{% include JB/setup %}

I'm about to write something related with the bytecode of JVM, and I find that I should first 
write something about how memory looks like in JVM in order to understand the meaning of bytecode.

The memory stores the data and instructions when a JVM program executes as any other programs do under 
Von Neumann architecture. Besides main memory, which is most common and massive, there are register, 
CPU cache level 1, and even CPU cache level 2, and CPU cache level 3 for faster data fetching and thus 
higher performance.

In this post, memory is a rough concept, and may refer to any of the memories mentioned above under 
specific situation.

### Process and Thread

I think it is necessary to introduce process and thread so as to understand how memory is used in JVM.

#### The JVM Process

We run JVM programs on JVM, which is a virtual machine and is responsible for converting compiled 
bytecode into native code. When we run a JVM program, it starts a process, which starts at least one 
user thread called main thread with several background system threads. The main thread is the entry point 
of the user defined program.

The background system threads contain:

- __VM thread__: it watis for operations to appear that require the JVM to reach a safe-point where no 
modification to the head occur, such as the stop-the-world garbage collection, thread stack dump, thread 
suspension and biased lock revocation.
- __Periodic task thread__: it is used to schedule execution of periodic operations.
- __GC threads__: they perform the garbage collection activities.
- __Compiler threads__: they compile bytecode to native code.
- __Signal dispatcher thread__: it receives signals sent to the JVM process.

For each process in the common os, it has its own address space which is not visible to other processes. It 
manages its resources and is isolated with other processes.

The JVM process contains:

- __heap__: the classes and objects are stored in the heap. To support garbage collection, (check previous 
posts for more information on garbage collection: 
[memory management in java]({%post_url 2014-09-09-memory-management-in-java%}) and 
[specific java garbage collector]({%post_url 2014-09-10-specific-java-garbage-collector%})), the heap is 
divided into three sections in general:

  - young generation: further split between eden and survivor.
  - old generation
  - permanent generation: in Java8, there is no permanent generation any more, instead there comes the 
  metaspace.

The class definition and code cache are not stored with the ordinary objects in the heap. The code cache is 
used for compilation and storage of methods that have been compiled to native code by JIT. The Class Objects 
contain following information:

- Classloader reference
- Run Time Constant Pool, it contains the numeric constans, field references, method references and attributes.
- Field data, each contains the name, type, modifiers, and attributes.
- Method data, each contains the name, return type, parameter types, modifiers, and attributes.
- Method code, each contains the bytecode, operand stack size, local variable size, local variable table, 
and exception table; each exception handler contains the start point, end point, PC offset for handler code, 
and constant pool index for exception class being caught.

All threads share the same method area, so access to the method area data and the process of dynamic linking 
must be thread safe. In fact, due to the limitation of the reflection provided by JVM, loaded class can not 
be modified. See more information about reflection, check []({%post_url 2017-02-20-notes-on-reflection%}).

#### The JVM Thread

Every process may have multiple threads. The threads in a process share the memory area of the process. It 
remains true in JVM. The JVM threads share the heap of the JVM process. In early days, there exists green 
thread in some JVM implementation. Now the JVM threads are directly mapped to native threads.

The JVM threads contain:

- __Program Counter__: The PC, the address of the current instruction, which keeps track of the execution.
- __stack__: each thread has its own stack that holds a frame for each method executing on that thread.
- __native stack__: mainly for native methods invocation.
- __stack restrictions__: a stack can be of dynamic or fixed size. When the stack is too deep, a 
`StackOverflowError` is thrown.
- __frame__: a new frame is created and added to the top of stack for every method invocation. The frame is 
removed when the method returns normally or if an uncaught exception is thrown during the method invocation.

  Each frame contains:
  
  - local variable array: it contains all method parameters and other locally defined variables. For 
  instance method (non-static method), it has an implicit parameter `this` refers to the current instance.
  - return value
  - operand stack: it is used during the execution of bytecode instructions in a similar way that general 
  purpose registers are used in a native CPU. Most JVM bytecode executes instructions manipulating the 
  operand stack.
  - reference to runtime constant pool of the class the current method belongs to: it helps to support 
  dynamic linking. In the classfile, all references to variables and methods are stored in the class's 
  constant pool as a symbolic reference. After resolution, the symbolic references are binded to direct 
  references, which store the offsets against the storage structure associated with the runtime location 
  of the variable or method.

### Related to bytecode

In the above section, I talk about the usage of memory in the JVM: how threads share the heap, and how 
memory is organized in each thread. Following I will point out specific parts of memory related to the 
bytecode.

- `permanent generation` / `meta space` in heap: classfile is loaded and turns out to be `Class` Object 
staying in this place where there are field definition, method definition, constant pool, inheritance 
hierarchy.
- `frame`: every method invocation creates a frame in the stack inside the thread.
- `operand stack`: most `mnemonic`s are for pushing, popping, duplicating, swapping, or executing 
operations that produce or consume values on the operand stack.
- `local variable array`: many `mnemonic`s are used to store values to local variable array from the 
operand stack, or load values to the operand stack from the local variable array.

### References

[link1](http://blog.jamesdbloom.com/JVMInternals.html){:target='_blank'}.

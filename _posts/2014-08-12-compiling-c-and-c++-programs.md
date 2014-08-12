---
layout: post
category : [C++]
tags : [c++, compile]
---
{% include JB/setup %}

`gcc` is the "GNU" C compiler, and `g++` is the "GNU C++ compiler, while `cc` and `CC` are the Sun C and C++ compilers
also available on Sun workstations. Below are several examples that show how to use g++ to compile C++ programs.

# Compiling a single file

{% highlight console %}
g++ source.cc -o executable
{% endhighlight %}

This command compiles source.c into an executable program named executable which you can run with **./ executable**.

Alternatively, you can also compile it with following two commands:

{% highlight console %}
g++ -c source.cc
g++ source.o -o executable
{% endhighlight %}

This time the two-step method first `compiles` source.cc into a machine code file named "source.o" and then `links`
source.o with some system libraries to produce the file program "executable".In fact the first method also does this
two-stage process of compiling and linking, but the stages are done transparently, and the intermediate file "source.o"
is deleted in the process.
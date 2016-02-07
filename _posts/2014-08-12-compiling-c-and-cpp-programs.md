---
layout: post
category : [C++]
tags : [c++, compile]
infotext: 'The simple way to compile cc files with g++ command.'
---
{% include JB/setup %}

`gcc` is the "GNU" C compiler, and `g++` is the "GNU C++ compiler, while `cc` and `CC` are the Sun C and C++ compilers
also available on Sun workstations. Below are several examples that show how to use g++ to compile C++ programs.

## Compiling a single source file

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

<!-- more -->

## Compiling a program with multiple source files

{% highlight console %}
g++ source1.cc source2.cc -o executable
{% endhighlight %}

When a program's source code is in seperate files, the above command compiles related source files into an executable
program named executable.

You can also compile it with the two-step method as follows:

{% highlight console %}
g++ -c source1.cc
g++ -c source2.cc
g++ source1.o source2.o -o executable
{% endhighlight %}

In this way, when part of the sources are modified, you don't need to `compile` all the source files to update the
executable. That is, for example, when source2.cc is modified, in order to update the executable, you can do as follows:

{% highlight console %}
g++ -c source2.cc
g++ source1.o source2.o -o executable
{% endhighlight %}

The source1.cc does not need to be recompiled. When there are numerous source files, and a change is only made to one
of them, the time savings can be significant. This process, though somewhat complicated, is generally handled
automatically by a [makefile]({%post_url 2014-08-12-the-use-of-makefile%}).

## Frequently used compilation options

C and C++ compilers allow for many options for how to compile a program, and the examples below demonstrate how to use
many of the more commonly used options. In most cases options can be combined, although it is generally not useful to
use "debugging" and "optimization" options together.

Compile source.cc so that executable contains symbolic information that enables it to be debugged with the gdb debugger.

{% highlight console %}
g++ -g source.cc -o executable
{% endhighlight %}

Have the compiler generate many warnings about syntactically correct but questionable looking code. It is good practice
to always use this option with gcc and g++.

{% highlight console %}
g++ -Wall source.cc -o executable
{% endhighlight %}

Generate symbolic information for gdb and many warning messages.

{% highlight console %}
g++ -g -Wall source.cc -o executable
{% endhighlight %}

Generate optimized code on a Linux machine with warnings. The -O is `a capital o` and not the number 0.

{% highlight console %}
g++ -Wall -O source.cc -o executable
{% endhighlight %}

Compile source.cc when it contains Xlib graphics routines.

{% highlight console %}
g++ source.cc -o executable -lX11
{% endhighlight %}

If "source.c" is a C program, then the above commands will all work by replacing g++ with gcc and "source.cc" with
"source.c". Below are a few examples that apply only to C programs.

Compile a C program that uses math functions such as "sqrt".

{% highlight console %}
gcc source.c -o executable -lm
{% endhighlight %}

Compile a C program with the "electric fence" library. This library, available on all the Linux machines, causes many
incorrectly written programs to crash as soon as an error occurs. It is useful for debugging as the error location can
be quickly determined using gdb. However, it should only be used for debugging as the executable will be much slower
and use much more memory than usual.

{% highlight console %}
gcc -g source.c -o executable -lefence
{% endhighlight %}
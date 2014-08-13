---
layout: post
category : [C++]
tags : [c++, compile, makefile]
---
{% include JB/setup %}

In the post [Compiling C and C++ Programs]({%post_url 2014-08-12-compiling-c-and-c++-programs%}), I've described how to
compiling C and C++ programs with commands **gcc** and **g++** respectively. It's enough with simple programs. But in
the situation where the program contains lots of source files and the dependence between the source files are
complicated, using compile commands directly to maintain the program becomes quite impractical and `MakeFile` is on
need.

# The Basic MakeFile

The basic makefile is composed of:

{% highlight make %}
target: dependencies
    command
{% endhighlight %}

When you finish writing the MakeFile, you can use following basic command to compile the program:

{% highlight console %}
make
{% endhighlight %}

This will look for a file named makefile/Makefile/MakeFile in current directory, and then make the MakeFile. If there
are several MakeFiles, use following command to specify the desired MakeFile:

{% highlight console %}
make -f theMakeFile
{% endhighlight %}

<!-- more -->

## Organizing the project on dependencies

When a program contains numerous source files, if you still recompile the whole program every time you modify some
source file, it will cost much time. To avoid that, you can make the use of different targets to organize the program
correctly according to the dependency relationship between source files. Now the MakeFile will take care of the process
of compiling and update the program by recompiling things modified or to be modified.

For example:

{% highlight make %}
all: executable

executable: main.o source1.o source2.o
    g++ main.o source1.o source2.o -o executable

main.o: main.cc
    g++ -c main.cc

source1.o: source1.cc
    g++ -c source1.cc

source2.o: source2.cc
    g++ -c source2.cc
{% endhighlight %}

In the example, the target `all` has only dependencies, but no commands. In order for **make** to execute correctly, it
has to meet all the dependencies of the called target (in this case `all`). Each of the dependencies are searched
through all the targets available and executed if found.
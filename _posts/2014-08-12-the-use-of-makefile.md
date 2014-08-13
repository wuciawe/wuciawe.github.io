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


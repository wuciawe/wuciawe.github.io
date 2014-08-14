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

## Using variables and comments

You can also use variables when writing Makefiles. It comes in handy in situations where you want to change the
compiler, or the compiler options.

{% highlight make %}
#Now we define some constants CC and CFLAGS.
#CC specifies which compiler to use
#CFLAGS is the list of flags to pass to the compilation command.

CC = g++
CFLAGS = -c -Wall

all: executable

executable: main.o source1.o source2.o
    $(CC) main.o source1.o source2.o -o executable

main.o: main.cc
    $(CC) $(CFLAGS) main.cc

source1.o: source1.cc
    $(CC) $(CFLAGS) source1.cc

source2.o: source2.cc
{% endhighlight %}

## Simple macros

{% highlight make %}
CC = g++
CFLAGS = -c
DEPS = header.h
OBJ = main.o source1.o source2.o

all: executable

executable: $(OBJ)
    $(CC) $^ -o $@

%.o: %.cc $(DEPS)
    $(CC) $(CFLAGS) $< -o $@
{% endhighlight %}

In this example, we create macro `DEPS` and `OBJ`. `DEPS` is the set of .h files on which the .c files depend. `OBJ` is
the list of object files. `%.o` means file ending in the .o suffix, `%.cc` is in similar case. `$@` says to put the
output of the compilcation in the file named on the left side of the `:`, while `$^` represents the right side of `:`.
`$<` is the first item in the dependencies list.

## Last example

{% highlight make %}
IDIR = ../include
CC = g++
CFLAGS = -c -Wall -I$(IDIR)

ODIR = obj

LDIR = ../lib
LIBS = -lm
LDFLAGS =

_DEPS = header.h
DEPS = $(patsubst %, $(IDIR)/%, $(_DEPS))

SOURCES = main.cc source1.cc source2.cc
_OBJECTS = $(SOURCES:.cc=.o)
OBJECTS = $(patsubst %, $(ODIR)/%, $(_OBJ))

EXECUTABLE = executable

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
    $(CC) $(LDFLAGS) $^ -o $@ $(LIBS)

$(ODIR)/%.o: %.cc $(DEPS)
    $(CC) $(CFLAGS) $< -o $@

.PHONY: clean

clean:
    rm -rf $(ODIR)/*.o *~ $(IDIR)/*~ $(EXECUTABLE)
{% endhighlight %}

In this example, the MakeFile should be located in the src directory. Note that it also includes a rule for cleaning up
your source, object directories and the executable if you type **make clean**. The `.PHONY` rule keeps make from doing
something with a file named clean.

Until now, you know basic usage of MakeFile. For advanced usage, check this post:
[More On Makefile And Autodependencies]({%post_url 2014-08-13-more-on-makefile-and-autodependencies%}).
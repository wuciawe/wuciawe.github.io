---
layout: post
category : [C++]
tags : [c++, compile, makefile]
---
{% include JB/setup %}

In the post [The Use Of Makefile]({%post_url 2014-08-12-the-use-of-makefile%}), I've described the basic usage of
MakeFile. You will be happy with it in most cases, but sometimes you still feel uncomfortable with dealing with
complicated dependencies relationship of source files. In this post, I will introduce a way to generate dependencies
automatically with MakeFile. Before that, let's see more about MakeFile.

# More On MakeFile

## VPATH and vpath

The `VPATH` is a list of directories to be searched for missing source files (actually for missing prerequisites: they
don't have to be source files, but VPATH and vpath are best only used for source files). The list can be separated by
spaces.

When GNU Make cannot find a prerequisite it will search the directories in `the VPATH list` (from first to last) and
stop at the first directory in which it finds the missing prerequisite. It then substitutes the location where the
missing prerequisite is found for the name specified in the Makefile.

{% highlight make %}
# Specifying this anywhere in MakeFile will add /usr/include into search path
VPATH = /usr/include

# This will clear the VPATH
VPATH =
{% endhighlight %}

But this approach may cause maintenance problem, every time GNU Make can't find a prerequisite, it will go searching
down the `VPATH`. It would be better to tell GNU Make just where to find specified file.

<!-- more -->

The `vpath` directive both a search path and a pattern. Only missing prerequisites matching the pattern are searched
using the associated path. So `vpath` makes it possible to specify just a path to search for header ( .h) files:

{% highlight make %}
vpath %.h /usr/include
{% endhighlight %}

The `vpath` syntax is a little more complicated than `VPATH` and has three forms:

{% highlight make %}
# This sets the search path for the pattern.
vpath pattern path

# This clears the path for the specified pattern.
vpath pattern

# Clears all vpath settings
vpath
{% endhighlight %}

## Multiple targets

{% highlight make %}
boutput loutput: text
    generate $< -$(subst output,,$@) > $@
{% endhighlight %}

This is equivalent to the following one:

{% highlight make %}
boutput: text
    generate text -b > boutput
loutput: text
    generate text -l > loutput
{% endhighlight %}

## Static pattern rules

Following is the syntax of a static pattern rule:

{% highlight make %}
targets: target-pattern: prereq-patterns
    command
{% endhighlight %}

The targets list specifies the targets that the rule applies to. The targets can contain wildcard characters. The
target-pattern and prereq-patterns say how to compute the prerequisites of each target. Each target is matched against
the target-pattern to extract a part of the target name, called the stem. This stem is substituted into each of the
prereq-patterns to make the prerequisite names (one from each prereq-pattern).

Each pattern normally contains the character `%` just once. When the target-pattern matches a target, the `%` can match
any part of the target name; this part is called the stem. The rest of the pattern must match exactly.

{% highlight make %}
files = foo.elc source1.o source2.o

$(filter %.o, $(files)): %.o: %.cc
    g++ -c $< -o $@
{% endhighlight %}

In this example, we first use `the filter function` to remove non-matching file names, then compile the source files of
c++ program.

Another example shows how to use `$*` in static pattern rules:

{% highlight make %}
boutput loutput: %output: text
    generate text -$* > $@
{% endhighlight %}

When the **generate** command is run, `$*` will expand to the stem.

## Functions

{% highlight make %}
# Performs a textual replacement on the text text: each occurrence of from is replaced by to. The result is substituted for the function call.
$(subst from,to,text)

# Finds whitespace-separated words in text that match pattern and replaces them with replacement. Here pattern may contain a `%` which acts as a wildcard, matching any number of any characters within a word. If replacement also contains a `%`, the `%` is replaced by the text that matched the `%` in pattern. Only the first `%` in the pattern and replacement is treated this way; any subsequent `%` is unchanged.
$(patsubst pattern,replacement,text)
# for example
$(patsubst %.c,%.o,x.c.c bar.c)
# results in x.c.o bar.o

# Removes leading and trailing whitespace from string and replaces each internal sequence of one or more whitespace characters with a single space.
$(strip string)

# Searches in for an occurrence of find. If it occurs, the value is find; otherwise, the value is empty.
$(findstring find,in)

# Returns all whitespace-separated words in text that do match any of the pattern words, removing any words that do not match. The patterns are written using `%`, just like the patterns used in the patsubst function above.
$(filter pattern...,text)

# Returns all whitespace-separated words in text that do not match any of the pattern words, removing the words that do match one or more. This is the exact opposite of the filter function.
$(filter-out pattern...,text)

# Sorts the words of list in lexical order, removing duplicate words. The output is a list of words separated by single spaces.
$(sort list)
{% endhighlight %}

## Automatic variables

- `$@` The file name of the target of the rule. If the target is an archive member, then `$@` is the name of the archive
file. In [a pattern rule](http://www.gnu.org/software/make/manual/make.html#Pattern-Intro){:target="_blank"} that has
multiple targets, `$@` is the name of whichever target caused the rule's recipe to be run.

- `$%` The target member name, when the target is an archive member. `$%` is empty when the target is not an archive
member.

- `$<` The name of the first prerequisite. If the target got its recipe from
[an implicit rule](http://www.gnu.org/software/make/manual/make.html#Implicit-Rules){:target="_blank"}, this will be
the first prerequisite added by the implicit rule.

- `$?` The names of all the prerequisites that are newer than the target, with spaces between them. For prerequisites
which are archive members, only the named member is used.

- `$^` The names of all the prerequisites, with spaces between them. For prerequisites which are archive members, only
the named member is used. A target has only one prerequisite on each other file it depends on, no matter how many times
each file is listed as a prerequisite. So if you list a prerequisite more than once for a target, the value of `$^`
contains just one copy of the name. This list does not contain any of the order-only prerequisites; for those see the
`$|` variable, below.

- `$+` This is like `$^`, but prerequisites listed more than once are duplicated in the order they were listed in the
MakeFile. This is primarily useful for use in linking commands where it is meaningful to repeat library file names in a
particular order.

- `$|` The names of all the order-only prerequisites, with spaces between them.

- `$*` The stem with which
[an implicit rule](http://www.gnu.org/software/make/manual/make.html#Pattern-Match){:target="_blank"} matches. If the
target is **dir/a.foo.b** and `the target pattern` is **a.%.b** then `the stem` is **dir/foo**. The stem is useful for
constructing names of related files. In a static pattern rule, the stem is part of the file name that matched the `%`
in the target pattern.

       In an explicit rule, there is no stem; so `$*` cannot be determined in that way. Instead, if the target name ends
with [a recognized suffix](http://www.gnu.org/software/make/manual/make.html#Suffix-Rules){:target="_blank"}, `$*` is
set to the target name minus the suffix. For example, if the target name is ‘foo.c’, then `$*` is set to ‘foo’, since
‘.c’ is a suffix. GNU Make does this bizarre thing only for compatibility with other implementations of make. You
should generally avoid using `$*` except in implicit rules or static pattern rules.

  If the target name in an explicit rule does not end with a recognized suffix, `$*` is set to the empty string for that
rule.

For directory and file of automatic variables, see
[here](http://www.gnu.org/software/make/manual/make.html#Automatic-Variables){:target="_blank"}.

# Autodependencies

The dependencies of the source files can be decided by the included header files of every source file, and compilers
support listing include files as follows:
{% highlight console %}
g++ -M source.cc
g++ -MM source.cc
g++ -H source.cc
{% endhighlight %}

The `-M` flag will list absolute paths of include files, the `-MM` flag will list absolute paths of include files
despite the system includes, the `-H` flag will print the absolute paths of include files in a format that shows which
header includes which.

Based on that, we can let the MakeFile generates the dependencies automatically as follows:

{% highlight make %}
sources = source1.cc source2.cc
CC = g++-4.8
CFLAGS = -std=c++11


executable : $(sources:.cc=.o)
    $(CC) $(CFLAGS) $< -o $@

$(sources:.cc=.d) : %.d:%.cc Makefile
    @set -e;\
    rm -f $@;\
    $(CC) -MM $(CFLAGS) $(filter %.cc, $<) > $@;\
    echo '  $$(CC) $$(CFLAGS) -c $$<' >> $@;\

-include $(sources:.cc=.d)

.PHONY : clean
clean :
    rm -f executable $(sources:.cc=.o) $(sources:.cc=.d*) *~

.PHONY : check-syntax
check-syntax:
    g++-4.8 -std=c++11 -o /dev/null -S $(CHK_SOURCES)
{% endhighlight %}

In this method, we also use the **include** directive to tell GNU Make to suspend reading the current MakeFile and read
one or more MakeFiles before continuing.

To simply ignore a missing MakeFile with no error message, use the **-include** directive instead of **include**
directive.
---
layout: post
category: [linux, tools]
tags: [awk, sed, linux]
infotext: 'notes on using awk and sed for text processing.'
---
{% include JB/setup %}

`awk` and `sed` are two great text processing tools in linux. `awk` is both a programming language and 
text processor that can be used to manipulate text data in very useful ways.

### awk

The format of an awk command is

{% highlight shell linenos=table %}
awk 'BEGIN { actions; } /<search-pattern>/ { actions; } END { actions; }' <input-file>
{% endhighlight %}

The `BEGIN` clause is the commands to execute before the file processing, and the `END` clause is the 
commands to execute after the file processing.

The awk will process the file line by line, if the `<search-pattern>` is not given, it will process all 
the lines of the file; if the `<search-pattern>` is given, it will use the search portion to decide 
if the current line reflects the pattern, and then performs the actions on matches; if the `action`s for 
processing each line are not given, the default behaviour is to `print` the line.

#### Internal variables

The awk uses some internal variables to assign certain pieces of information as it processes a file.

The internal variables that awk uses are:

- `FILENAME`: References the current input file.
- `FNR`: References the number of the current record relative to the current input file.
- `FS`: The current field separator used to denote each field in a record. By default, this is set to 
whitespace.
- `NF`: The number of fields in the current record.
- `NR`: The number of the current record.
- `OFS`: The field separator for the outputted data. By default, this is set to whitespace.
- `ORS`: The record separator for the outputted data. By default, this is a newline character.
- `RS`: The record separator used to distinguish separate records in the input file. By default, 
this is a newline character.

Following is an example:

{% highlight shell linenos=table %}
sudo awk 'BEGIN { FS=":"; print "User\t\tUID\t\tGID\t\tHome\t\tShell\n--------------"; }
{print $1,"\t\t",$3,"\t\t",$4,"\t\t",$6,"\t\t",$7;}
END { print "---------\nFile Complete" }' /etc/passwd
{% endhighlight %}

#### Field searching and Compound expressions

By using the `<search-pattern>` directly, awk will search the whole line for the matches, sometimes we 
want to search in a specific field, this can be done as

{% highlight shell linenos=table %}
awk '$<field-number> ~ /<search-pattern>/ { actions; }' <input-file>
{% endhighlight %}

where the `<field-number>` denotes which field we want to search, it begins from 1, while `$0` denotes 
the whole line. And take care of the `~` in the expression, it is important.

Sometimes we need further complicated logic for determine whether to process a certain line, awk allows 
us to compose compound expressions. For example

{% highlight shell linenos=table %}
awk '$2 !~ /^sa/ && $1 < 5 {print;}' example.txt
{% endhighlight %}

In the example, it specifies a compound expression that the second field should not begin with 
__sa__, and the first field should be a number that is less than __5__, and __print__ all the lines 
in __the example.txt__ that satisfies the compound condition.

And it is also possible to utilize external script with awk:

{% highlight shell linenos=table %}
awk -f <ext-script.awk> <input-file>
{% endhighlight %}

where `<ext-script.awk>` is like

{% highlight shell linenos=table %}
BEGIN { actions; } 
/<search-pattern>/ { actions; } 
END { actions; }
{% endhighlight %}

For more examples, see [here](http://www.funtoo.org/Awk_by_Example,_Part_1){:target='_blank'}.

### sed

The sed is a non-interactive `s`tream `ed`itor. It receives text input, whether from `stdin` or from a 
file, performs certain operations on specified lines of the input, one line at a time, then outputs 
the result to `stdout` or to a file.

The sed determines which lines of its input that it will operate on from the `address range` passed 
to it. Specify this address range either by line number or by a pattern to match.

The sed provides a large amount of commands, the most used three are `print`, `delete`, and `substitute`.

Following is a list of some commonly used commands:

- `-e`: Interpret the next string as an editing instruction.
- `p`: The action of print the line

{% highlight shell linenos=table %}
sed -e 'p' <file>
{% endhighlight %}

It prints all the lines of the `<file>` to the screen.

- `d`: The action of delete the line from the output

{% highlight shell linenos=table %}
sed -e 'd' <file>
{% endhighlight %}

It prints nothing to the screen, and the content of `<file>` keeps not modified, as the `delete` 
means to delete the line in the line buffer of sed

- `[line-address][action]`: specify the line of the file to take the action

{% highlight shell linenos=table %}
sed -e '1d' <file>
{% endhighlight %}

It deletes the first line of the `<file>` from the output to the screen.

- `[line-range-address][action]`: specify the range of lines of the file to take the action

{% highlight shell linenos=table %}
sed -e '1,10d' <file>
{% endhighlight %}

It prints the lines from 11th line of the `<file>` to the screen.

- `[regexp-address][action]`: specify the line to take action with regular expression

{% highlight shell linenos=table %}
sed -e '/^#/d' <file>
{% endhighlight %}

It ignores all the lines of `<file>` start with '#' from printing to the screen.

- `[regexp-address-begin],[regexp-address-end][action]`: specify the lines to take action from the 
line matches `[regexp-address-begin]` up to and including the line matches `[regexp-address-end]`

{% highlight shell linenos=table %}
sed -e '/BEGIN/,/END/p' <file>
{% endhighlight %}

It prints a block of lines of `<file>` start with a line containing 'BEGIN' end with a line 
containing 'END'.

- `s/pattern1/pattern2/`: Substitute pattern2 for first instance of pattern1 in a line

{% highlight shell linenos=table %}
sed -e 's/##/--/' <file>
{% endhighlight %}

It prints every line of `<file>` with first occurrence of '##' substituted with '--'.

{% highlight shell linenos=table %}
sed -e 's/.*/some-word &/' <file>
{% endhighlight %}

The `&` in pattern2 refers to the matched content in pattern1.

{% highlight shell linenos=table %}
sed -e 's/\(.*\) \(.*\) \(.*\)/some-word \1 some-other-word \2 some-more-other-word \3/' <file>
{% endhighlight %}

The `\num` in pattern2 refers to the nth matched content in pattern1.

- `g`: Operate on every pattern match within each matched line of input

{% highlight shell linenos=table %}
sed -e 's/foo/bar/' <file>
{% endhighlight %}

It prints every line of `<file>` with every occurrence of 'foo' substituted with 'bar'.

- `s:pattern1:pattern2:g`: Substitution with ':' as the separator
- `[line-range-address]/s/pattern1/pattern2/`: Substitute pattern2 for first instance of pattern1 in a 
line, over lines in range
- `[line-range-address]/y/pattern1/pattern2/`: Replace any character in pattern1 with the corresponding 
character in pattern2, over lines in range (equivalent of tr)
- `[address] i pattern Filename`: Insert pattern at address indicated in file Filename. Usually used 
with -i in-place option
- `-e '[action1];[action2]'`: specify multiple actions

{% highlight shell linenos=table %}
sed -e '=;p' <file>
{% endhighlight %}

Action(command) `=` tells sed to print the line number, the whole command prints every line of 
`<file>` with line number at the head of the line.

- `-e '[action1]' -e '[action2]'`: specify multiple actions
- `-f <script-file>.sed`: specify actions from script file with file name end with '.sed'
- `-e {...}`: specify multiple actions

{% highlight shell linenos=table %}
1,/^END/{
        s/[Ll]inux/GNU\/Linux/g 
        s/samba/Samba/g 
        s/posix/POSIX/g 
       p
}
{% endhighlight %}

It specifies the actions to take from the first line to the line start with 'END'

- `i`: insert before the current line

{% highlight shell linenos=table %}
i\
first line\
second line\
third line
}
{% endhighlight %}

It insert multiple lines before the current line.

- `a`: insert after the current line
- `c`: replace the current line
- `''`: Strong quotes protect the RE characters in the instruction from reinterpretation as special 
characters by the body of the script
- `""`: Double quotes allow expansion in the instruction

three sources: [source 1](http://www.computerhope.com/unix/used.htm){:target='_blank'}, 
[source 2](http://sed.sourceforge.net/sed1line.txt){:target='_blank'}, 
[source 3](http://www.funtoo.org/Sed_by_Example,_Part_3){:target='_blank'}.
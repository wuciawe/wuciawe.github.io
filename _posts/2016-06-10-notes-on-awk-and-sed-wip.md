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

- `[address-range]/p`: Print [specified address range]
- `[address-range]/d`: Delete [specified address range]
- `s/pattern1/pattern2/`: Substitute pattern2 for first instance of pattern1 in a line
- `[address-range]/s/pattern1/pattern2/`: Substitute pattern2 for first instance of pattern1 in a 
line, over address-range
- `[address-range]/y/pattern1/pattern2/`: Replace any character in pattern1 with the corresponding 
character in pattern2, over address-range (equivalent of tr)
- `[address] i pattern Filename`: Insert pattern at address indicated in file Filename. Usually used 
with -i in-place option
- `g`: Operate on every pattern match within each matched line of input
- `-e`: Interpret the next string as an editing instruction.
- `''`: Strong quotes protect the RE characters in the instruction from reinterpretation as special 
characters by the body of the script
- `""`: Double quotes allow expansion in the instruction

I think more time should be taken on sed, two sources: [source 1](http://www.computerhope.com/unix/used.htm){:target='_blank'}, [source 2](http://sed.sourceforge.net/sed1line.txt){:target='_blank'}.
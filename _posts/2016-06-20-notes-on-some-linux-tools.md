---
layout: post
category: [linux, tools]
tags: [linux]
infotext: "An illustration to some linux command line tools, such as sort, uniq, tee."
---
{% include JB/setup %}

### sort

Use `sort` as follows:

{% highlight shell linenos=table %}
sort [options] -k<field_start[type][,field_end[type]]> [...] <input-source>
{% endhighlight %}

The `field_start` denotes the start column to sort by, and the optional 
`field_end` denotes the end column to sort by. If there is no `-k`, then 
it's sorted on the entire line. `type` is a subset of options. All options 
are like:

- `n`: denotes to treat as number
- `r`: denotes to sort in reverse order
- `s`: denotes to sort stably
- `f`: denotes to sort case insensitively
- `b`: denotes to ignore blank
- `o`: denotes the output file
- `u`: denotes the `uniq`
- `t`: denotes the separator
- `R`: denotes to sort randomly
- `c`: check if sorted
- `m`: merge sorted inputs

If multiple `<input-source>`s are provided, the output will be the merged 
sorted result.

### uniq

It works only when the duplicate lines are adjacent.

{% highlight shell linenos=table %}
uniq [options] <input-source>
{% endhighlight %}

The options are like:

- `c`: count the duplicates
- `d`: print only duplicates
- `D`: print duplicates all occurrences
- `u`: print only uniqs
- `w <num>`: compare with `<num>` limited first characters
- `s <num>`: skip comparing with first `<num>` characters
- `f <num>`: avoid comparing with first `<num>` fields

### tee

It reads standard input and writes it to both standard output and files.

{% highlight shell linenos=table %}
tee [options] <file> [...]
{% endhighlight %}

The options are like:

- `a`: append mode
- `i`: ignore interrupt
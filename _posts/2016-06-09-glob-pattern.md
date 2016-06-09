---
layout: post
category: [linux]
tags: [linux, glob, regex]
infotext: "An overview on the glob pattern for file system, also including the distinguish between glob pattern and regular expression pattern."
---
{% include JB/setup %}

The __glob patterns__, an abbreviation for global command patterns, specify sets of filenames with 
wildcard characters.

The syntax of glob patterns are listed as follows:

- `*`: matches any number of any characters including none
- `?`: matches any single character
- `[abc]`: matches one character given in the bracket
- `[a-z]`: matches one character from the range given in the bracket

In all cases the `file path separator` (`/` on unix) will never be matched.

On Linux and POSIX systems, there are two additional wildcards:

- `[!abc]`: matches one character that is not given in the bracket
- `[!a-z]`: matches one character that is not from the range given in the bracket

### Comparison with Regex

Globs do not include syntax for the [Kleene star](https://en.wikipedia.org/wiki/Kleene_star){:target='_blank'} 
which allows multiple repetitions of the preceding part of the expression; thus they are not 
considered regular expressions, which can describe the full set of regular languages over any given 
finite alphabet.

<style>
table{
    border-collapse: collapse;
    border-spacing: 0;
    border:2px solid #000000;
}

th{
    border:2px solid #000000;
    padding: 2px;
    text-align: center !important;
}

td{
    border:1px solid #000000;
    padding: 2px;
    text-align: left !important;
}
</style>

| glob wildcard | equivalent regex |
|:--------------|:----------------:|
| `?` | `.` |
| `*` | `.*` |

Globs attempt to match the entire string, whereas regular expressions match a substring unless the 
expression is enclosed with `^` and `$`.
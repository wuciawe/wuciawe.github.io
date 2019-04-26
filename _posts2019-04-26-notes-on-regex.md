---
layout: post
category: [tools]
tags: [regex]
infotext: 'quick reference to regex'
---
{% include JB/setup %}

### Characters

- `\d` one digit
- `\w` word character: ASCII letter, digit or underscore
- `\s` whitespace character: space, tab, newline, carriage return, vertical tab
- `\D` negate of `\d`
- `\W` negate of `\w`
- `\S` negate of `\s`

### Quantifiers

- `+` one or more
- `{3}` exactly three times
- `{2， 4}` two to four times
- `{3,}` three or more times
- `*` zero or more times
- `?` once or none

### More characters

- `.` any character except line break
- `\` escapes a special character

### Logic

- `|` alternation/or operand, e.g., `22|33` mathes `33`
- `()` capturing group, e.g., `A(nt|pple)` mathes `Apple`
- `\1` contents of group 1, e.g., `r(\w)g\1x` mathes `regex`
- `(?:)` non-capturing group

### More white-space

- `\t` tab
- `\r` carriage return
- `\n` line feed character
- `\r\n` line separator on Windows
- `\N` one character that is not a line break
- `\h` one horizontal whitespace character: tab or unicode space separator
- `\H` negate of `\h`
- `\v` one vertical whitespace character: line feed, carriage return, vertical tab, form feed, paragraph or line separator
- `\V` negate of `\v`
- `\R` one line break (carriage return + line feed pair, and all the characters matched by `\v`)

### Character classes

- `[]` one of the characters in the brackets
- `-` range indicator
- `[^]` negate of `[]`

### Anchors and boundaries

- `^` start of string or start of line
- `$` end of string or end of line
- `\A` beginning of string
- `\z` very end of the string
- `\Z` end of string or before final line break
- `\G` beginning of string or end of previous match
- `\b` word boundary
- `\B` negate of `\b`

### Inline modifiers

- `(?i)` case-insensitive mode
- `(?s)` dotall mode, the dot `.` matches new line characters, also known as "single-line mode"
- `(?m)` multiline mode, `^` and `$` match at the beginning and end of every line
- `(?x)` free-spacing mode
- `(?n)` named capture only
- `(?d)` unix linebreaks only
- `(?^)` unset modifiers

### Lookarounds

- `(?=)` positive lookahead
- `(?<=)` positive lookbehind
- `(?!)` negative lookahead
- `(?<!)` negative lookbehind

A lookahead or a lookbehind does not "consume" any characters on the string.

### Greedy, lazy and possessive

#### Greedy

By default, a quantifier tells the engine to match as many instances of its 
quantified token or subpattern as possible. This behaviour is called greedy.

If the quantified token has matched so many characters that the rest of the 
pattern can not match, the engine whill bcktrack to the quantified token and 
make it give up characters it matched earlier -- one character or chunk at a 
time, depending on whether the quantifier applies to a single character or to 
a subpattern that can match chunks of serveral characters. After giving up 
each character or chunk, the engine tries once again to match the rest of the 
pattern. People call this behaviour of greedy quantifiers docile.

#### Lazy

In contrast to the standard greedy quantifier, which eats up as many instances 
of the quantified token as possible, a lazy (sometimes called reluctant) 
quantifier tells the engine to match as few of the quantified tokens as needed. 
A regular quantifier is made lazy by appending a `?` to it.

Since the `*` quantifier allows the engine to match zero or more characters, 
`*?` might be none at all.

If the quantified token has matched so few characters that the rest of the 
pattern can not match, the engine backtracks to the quantified token and makes 
it expand its match—one step at a time. After matching each new character or 
subexpression, the engine tries once again to match the rest of the pattern. 
People call this behavior of lazy quantifiers helpful.

#### Possesive: Don't give up characters

In contrast to the standard docile quantifier, which gives up characters if 
needed in order to allow the rest of the pattern to match, a possessive quantifier 
tells the engine that even if what follows in the pattern fails to match, it will 
hang on to its characters. A quantifier is made possessive by appending a `+` to it.

Whereas the regex `A+.` matches the string AAA, `A++.` doesn't. At first, the token 
`A++` greedily matches all the A characters in the string. The engine then advances 
to the next token in the pattern. The dot `.` fails to match because there are no 
characters left to match. The engine looks if there is something to backtrack. But 
`A++` is possessive, so it will not give up any characters. There is nothing to 
backtrack, and the pattern fails. In contrast, with `A+.`, the `A+` would have given 
up the final A, allowing the dot to match. 

Possessive quantifiers match fragments of string as solid blocks that cannot be 
backtracked into: it's all or nothing. This behavior is particularly useful when you 
know there is no valid reason why the engine should ever backtrack into a section of 
matched text, as you can save the engine a lot of needless work. 

For more information on greedy trap and lazy trap, refer to 
[the link](https://www.rexegg.com/regex-quantifiers.html#greedytrap).

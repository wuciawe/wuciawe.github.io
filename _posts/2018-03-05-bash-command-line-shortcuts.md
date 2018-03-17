---
layout: post
category: [tools]
tags: [bash]
infotext: 'a list of shortcuts of bash command line'
---
{% include JB/setup %}

<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

It had been a long while not writing any blog posts. Busy in the work.

And also to record the precious moment of yesterday. May God bless us.

When you log in a remote system via shell, you may sometimes find that the `Home` key and 
the `End` key not working in the remote shell. The problem may be solved by configuring the 
terminal and shell environment. But recently I find that there are some shortcuts provided 
by the shell very useful in such cases.

## Move in the command line

- Move to the start of the line: `Ctrl` + `a`
- Move to the end of the line: `Ctrl` + `e`
- Move forward a word: `Alt` + `f`
- Move backward a word: `Alt` + `b`
- Move forward a character: `Ctrl` + `f`
- Move backward a character: `Ctrl` + `b`
- Move between the beginning of the line and the current position of the cursor: `Ctrl` + `xx`

## Delete and clear

- Delete current character: `Ctrl` + `d`
- Delete previous character: `Backspace`

## Kill and yank

- Cut from cursor to the end of line: `Ctrl` + `k`
- Cut from cursor to the start of line: `Ctrl` + `u`
- Cut from cursor to the end of word: `Alt` + `d`
- Cut from cursor to the start of word: `Alt` + `Backspace`
- Cut from cursor to previous whitespace: `Ctrl` + `w`
- Paste the last cut: `Ctrl` + `y`
- Loop through and paste previously cut: `Alt` + `y` (use after `Ctrl` + `y`)
- Loop through and paste the last argument of previous commands: `Alt` + `.`

## Work with processes

- Interrupt (`SIGINT`) the current foreground process: `Ctrl` + `c`
- Suspend (`SIGSTP`) the current foreground process: `Ctrl` + `z`, use `fg process_name`
- Close the bash shell, sending an `EOF` to bash: `Ctrl` + `d`

## Search the history

- Search: `Ctrl` + `r`
- Run the command: `Ctrl` + `o`
- Search the last remembered search term: `Ctrl` + `r` twice
- End the search at current history entry: `Ctrl` + `j`
- Cancel the search and restore original line: `Ctrl` + `g`
- Go to the previous command: `Ctrl` + `p`
- Go to the next command: `Ctrl` + `n`
- Revert any changes to a command pulled from history: `Alt` + `r`

## Control the Screen

- Clear the screen: `Ctrl` + `l`
- Stop all output to the screen: `Ctrl` + `s`
- Resume output to the screen: `Ctrl` +`q`

## Others

- Undo: `Ctrl` + `-`

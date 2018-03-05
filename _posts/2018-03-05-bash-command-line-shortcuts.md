It had been a long while not writing any blogs. Busy in the work.

And also to record the precious moment of yesterday. May God bless us.

When you log in a remote system via shell, you may somtimes find that the `Home` key and the `End` key 
not working in the remote shell. The problem may be solved by configuring the terminal and shell 
environment. But recently I find that there are some shortcuts provided by the shell very useful in 
such cases.

## Move in the command line

- Move to the start of the line: `Ctrl` + `a`
- Move to the end of the line: `Ctrl` + `e`
- Move forward a word: `Alt` + `f`
- Move backward a word: `Alt` + `b`
- Move forward a character: `Ctrl` + `f`
- Move backward a character: `Ctrl` + `b`

## Delete and clear

- Delete current character: `Ctrl` + `d`
- Delete previous character: `Backspace`
- Clear the screen: `Ctrl` + `l`

## Kill and yank

- Cut from cursor to the end of line: `Ctrl` + `k`
- Cut from cursor to the end of word: `Alt` + `d`
- Cut from cursor to the start of word: `Alt` + `Backspace`
- Cut from cursor to previous whitespace: `Ctrl` + `w`
- Paste the last cut: `Ctrl` + `y`
- Loop through and paste previously cut: `Alt` + `y` (use after `Ctrl` + `y`)
- Loop through and paste the last argument of previous commands: `Alt` + `.`

## Search the history

- Search: `Ctrl` + `r`
- Search the last remembered search term: `Ctrl` + `r` twice
- End the search at current history entry: `Ctrl` + `j`
- Cancel the search and restore original line: `Ctrl` + `g`

## Others

- Undo: `Ctrl` + `-`

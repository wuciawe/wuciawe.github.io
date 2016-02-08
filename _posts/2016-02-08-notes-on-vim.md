---
layout: post
category: [tools]
tags: [vim]
infotext: 'notes on using vim'
---
{% include JB/setup %}

`vi`, short for `vi`sual editor, is a very useful pre-installed standard text editor in most systems. (A joke: vi is not the six editor.) And `vim` is a clone of `vi`, which is short for `v`i `im`proved.

### Open, Save, and Close a file

    # open a file
    vim <path to file> # open a specific file
    vim # open a new file without a name yet
    vim -d <file1> <file2> ... <filen> # diff mode

    # save changes
    :w # write changes to the file
    :sav # save the changed file as other file

    # close a file
    :e! # back to the last saved version of the file
    :q! # close without saving changes
    :q # close the file, assuming there is no change

### Move in a file

- move by character, can be combined with number argument
  - `h`: left one space
  - `j`: down one line
  - `k`: up one line
  - `l`: right one space
- move in a line
  - `0`: head of line
  - `^`: first non-blank character of line
  - `$`: end of line
  - `<num>``|`: \<num>-th column of line
- move by word, can be combined with number argument
  - `w`: forward by a word
  - `W`: forward by a word, ignore punctuation
  - `b`: backward by a word
  - `e`: forward by a word, at the end of word
  - `E`: forward by a word, at the end of word, ignore punctuation
  - `(`: head of current sentence
  - `)`: end of current sentence
  - `{`: head of current paragraph
  - `}`: end of current paragraph
  - `[[`: head of current section
  - `]]`: end of current section
- move to line
  - `<num>``G`: go to \<num>-th line
  - `g``g`: go to top line of file
  - `:<num>`: go to \<num>-th line
  - `C-g`: display total line number

### Screen movement

- scroll screen:
  - `C-f`: scroll full screen forward
  - `C-b`: scroll full screen backward
  - `C-d`: scroll half screen forward
  - `C-u`: scroll half screen backward
- reposition
  - `z``<Enter>`: scroll current line to top
  - `z``.`: scroll current line to middle of screen
  - `z``-`: scroll current line to bottom
- redraw the screen
  - `C-l`: redraw the screen
- move in screen
  - `H`: move to top of screen
  - `M`: move to middle of screen
  - `L`: move to bottom of screen
  - `<num>``H`: move \<num> line below top line of screen
  - `<num>``L`: move \<num> line above bottom line of screen

### Search

- `/``<pattern>`: search \<pattern> forward
- `?``<pattern>`: search \<pattern> backward
- `n`: search next in the same direction
- `N`: search next in the opposite direction

### Mark

- `m``<mark>`: mark current position with \<mark>
- `'``<mark>`: move to head of the line which is marked by \<mark>
- `<Backquote>``<mark>`: move to the character marked by \<mark>
- `<Backquote>``<Backquote>`: return to previous mark
- `'``'`: return to the head of line of previous mark

### Edit

- `i`: start inserting at current carnet position
- `I`: insert at head of the current line
- `a`: append after the current carnet position
- `A`: append after the end of current line
- `o`: open a blank line below carnet
- `O`: open a blank line above carnet
- `c`: change text
  - `c``<num>``w|b`: change \<num> words, forward or backward
  - `c``0|$`: change to the head or end of the line
  - `c``c`: change the whole line
- `C`: change from current carnet position to the end of line
- `r`: replace current carnet position character, no need to press `ESC` after typing
- `R`: replace in `overstrike mode`
- `s`: substitute current carnet position character
  - `<num>``s`: substitute \<num> characters from current carnet position
- `S`: substitute the entire line
  - `<num>``S`: substitute \<num> line
- `~`: change case

### Join

- `J`: join current line with the line below it
  - `<num>``J`: join \<num> lines

### Delete

- `d`: delete current carnet position character
  - `d``<num>``<action>`: delete \<num> movement actions
  - `d``d`: delete the entire line
- `D`: delete to the end of the line
- `x`: delete current carnet position character

### Paste

- `p`: paste after current carnet position
  - `"``<num>``p`: paste from buffer \<num>
  - `"``<name>``p`: paste from a named buffer
- `P`: paste before current carnet position

### Yank

- `y`: yank the selected text
  - `y``<num>``<action>`: yank \<num> movement actions
  - `"``<name>``y`: yank to a named buffer
  - `y``y`: yank the entire line
- `Y`: yank the entire line

### Replace

- `:s/old/new/`: replace first occurrence of pattern old with new, on current line
- `:s/old/new/g`: replace all occurrence of pattern old with new, on current line
- `:<n1>,<n2>s/old/new/[g]`: replace between line \<n1> and \<n2>, i.e., 1,$ denotes full file
- `:%s/old/new/[g]`: replace for every line in the file
- `:s/old/new/c`: confirmation
- `:g/pattern/s/old/new/g`: limit replacement by pattern, first g denotes for all lines in the file, last g denotes replacement happens globally in the filtered line

Actually, `:g` denotes for repeating command.

### Repeat and Undo

- `.`: repeat the last edit command
- `u`: undo the last edit command
- `U`: undo all edits on the current line

### Fold

To preserve folds between sessions, use `:mkview` and `:loadview`.

- `z``A`: toggle state of folds, recursively
- `z``a`: toggle state of one fold
- `z``C`: close folds, recursively
- `z``c`: close one fold
- `z``O`: open folds, recursively
- `z``o`: open one fold
- `z``D`: delete folds, recursively
- `z``d`: delete one fold
- `z``E`: eliminate all folds
- `z``f`: create fold from current line to the line denoted by move action
- `<num>``z``F`: create fold covering \<num> lines from current line
- `z``M`: set `foldlevel` to 0
- `z``m`: decrement `foldlevel`
- `z``r`: increment `foldlevel`
- `z``i`: toggle `foldenable`
- `z``N`: set `foldenable`
- `z``n`: reset `foldenable`
- `z``j`: move cursor to start of next fold
- `z``k`: move cursor to end of previous fold

### Other

    :set spell
    :set spelllang=en,da,de,it
    :set spellsuggest=5

To show the suggestions, press `z-=`

---
layout: post
category: [tools]
tags: [emacs]
infotext: 'notes on using emacs'
---
{% include JB/setup %}

Emacs is another powerful text editor, unlike vim, its shortcuts are mainly accessed through 
modifiers.

### Start Emacs

{% highlight bash linenos=table %}
# start a single session [or process single file]
emacs [<path to file>]

# start emacs without x
emacs -nw

# start a service
emacs --daemon

# attach a service [without x]
emacs-client [-t]

# open emacs with gui with alternative non-daemon
emacs-client -c -a emacs
{% endhighlight %}

### Open, Save, and Close a file

{% highlight bash linenos=table %}
# open a file / reopen a buffer
C-x C-f <path to file>|<buffer name>

# save current buffer (save-buffer)
C-x C-s

# save any/all buffer (save-some-buffer)
C-x s

# save as
C-x C-w

# forget changes
M-~

# close current[/specific] file
C-x k [<buffer> RET]

# kill any/all buffer
M-x kill-some-buffers

# kill all buffers matching a regular expression
M-x kill-matching-buffers

# exit
C-x C-c

# suspend
C-z
{% endhighlight %}

### Move in a file

{% highlight bash linenos=table %}
# move forward a character
C-f

# move backward a character
C-b

# move next line
C-n

# move previous line
C-p

# move forward a word
M-f

# move backward a word
M-b

# move end of the line
C-e

# move beginning of the line
C-a

# move forward sentence
M-e

# move backward sentence
M-a

# cycle point between top-left center-left and bottom-left
M-r

# move point to position <n> in current line
M-g TAB <n> RET

# move point to <n> line
M-g g <n> RET
{% endhighlight %}

### Screen movement

{% highlight bash linenos=table %}
# display screen forward
C-v

# display screen backward
M-v

# cycle center
C-l

# move to the beginning of the buffer
M-<

# move to the end of the buffer
M->
{% endhighlight %}

### Window operation

{% highlight bash linenos=table %}
# split window below
C-x 2

# split window right
C-x 3

# delete other windows
C-x 1

# delete current window
C-x 0

# move point to other window
C-x o

# scroll window forward in other window
C-M-v

# scroll window backward in other window
C-M-S-v
{% endhighlight %}

### Search and replace

{% highlight bash linenos=table %}
# search incrementally
C-s

# search incrementally in reverse
C-r

# replace some string
M-% <string> RET <new-string> RET

# replace with regex
C-M-% <regex> RET <new-string> RET
{% endhighlight %}

### Mark

{% highlight bash linenos=table %}
# set mark
C-SPC

# set mark with last mark
C-x C-x
{% endhighlight %}

### Copy and Paste

{% highlight bash linenos=table %}
# copy marked
M-w

# kill marked
C-w

# kill til end of line
C-k

# kill whole line
C-S-DEL

# kill word
M-d

# kill word backward
M-DEL

# yank
C-y

# cycle kill ring
M-y

# rectangular kill
C-x r k

# rectangular yank
C-x r y
{% endhighlight %}

### Delete

{% highlight bash linenos=table %}
# delete next character
C-d

# delete spaces and tabs around point
M-\

# delete spaces and tabs around point leaving one space
M-SPC

# delete blank lines around point
C-x C-o
{% endhighlight %}

### Join

{% highlight bash linenos=table %}
# join two lines
M-^
{% endhighlight %}

### Repeat and Undo

{% highlight bash linenos=table %}
# undo
C-/
C-_
C-x u

# repeat commands
C-x z
{% endhighlight %}

### Argument times

{% highlight bash linenos=table %}
# perform <c> <n> time
C-u <n> <c>
{% endhighlight %}

### Fill

{% highlight bash linenos=table %}
# fill paragraph
M-q
{% endhighlight %}

### Packages

Add following lines into `~/.emacs.d/init.el`:

{% highlight bash linenos=table %}
;;; Emacs is not a package manager, and here we load its package manager!
(require 'package)
(dolist (source '(("marmalade" . "https://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ;; TODO: Maybe, use this after emacs24 is released
                  ;; (development versions of packages)
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
    (add-to-list 'package-archives source t))
(package-initialize)
{% endhighlight %}

Then reload `~/.emacs.d/init.el` with `M-x load-file` `RET` `~/.emacs.d/init.el` `RET`. 
Or re-eval the region/buffer if `~/.emacs.d/init.el` edited in emacs with:

{% highlight bash linenos=table %}
M-x eval-region RET
M-x eval-buffer RET
{% endhighlight %}

After that, list packages with:

{% highlight bash linenos=table %}
M-x list-packages
{% endhighlight %}

For more details, refer to [emacs package manager and theme setup]({%post_url 2014-08-14-emacs-package-manager-and-theme-setup%})

### Shell

{% highlight bash linenos=table %}
# run shell <cmd> and display output
M-! <cmd> RET

# Run a subshell with input and output through an Emacs buffer.
M-x shell

# Run a subshell with input and output through an Emacs buffer. Full terminal evaluation.
M-x term
{% endhighlight %}
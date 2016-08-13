---
layout: post
category : [emacs]
tags : [emacs, package manager]
infotext: 'A very simple tutorial on using Package Manager in Emacs.'
---
{% include JB/setup %}

## Load Emacs package manager

Add the following into the Emacs configuration file `.emacs`:

{% highlight cl linenos=table %}
;;; Emacs is not a package manager, and here we load its package manager!
(require 'package)
(dolist (source '(("marmalade" . "https://marmalade-repo.org/packages/") ;;; this one not work in win
                  ("elpa" . "http://tromey.com/elpa/")
                  ;; TODO: Maybe, use this after emacs24 is released
                  ;; (development versions of packages)
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
    (add-to-list 'package-archives source t))
(package-initialize)
{% endhighlight %}

Start Emacs and press `M-x` type **list-packages**, move cursor to the line, press `enter` click **Install** to install 
the package you want.

<!-- more -->

In the `package-menu-mode`, there are some useful shotkeys:

-   `enter` Describe the package under cursor. (describe-package)
-   `i` Mark for installation. (package-menu-mark-install)
-   `u` Unmark. (package-menu-mark-unmark)
-   `d` Mark for deletion (removal of a installed package). (package-menu-mark-delete)
-   `x` Execute (start install/uninstall of marked items). (package-menu-execute)
-   `r` Refresh the list from server. (package-menu-refresh)

For complete list of keys, call `describe-mode` with `Ctrl+h m`.

## Setup dark theme

I use the [solarized-dark-theme](https://github.com/sellout/emacs-color-theme-solarized){:target='_blank'}.

*   Install the **color-theme-solarized** with the emacs package managder.
*   Add following code into `.emacs`.
{% highlight cl linenos=table %}
(load-theme 'solarized-dark t)
{% endhighlight %}
*   Reload the init file with `M-x eval-region RET`.

`NOTE:` `dracula` is great.
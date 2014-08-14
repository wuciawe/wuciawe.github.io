---
layout: post
category: [emacs]
tags: [emacs, c++, environment]
---
{% include JB/setup %}

I choose [Intellij IDEA](http://www.jetbrains.com/idea/){:target="_blank"} as my programming IDE. It is a perfect IDE, 
but currently it doesn't support C++ which is supposed coming soon. But until that, I will use Emacs as the editor for 
writing C++ programs.

Following I will describe how to configure Emacs as a C++ specified editor.

## Basic configuration

Add following code into the `.emacs`:

{% highlight cl%}
;;; enable C++ mode when opening a file with extension .h, .c, .cc and so on.
(require 'cc-mode)
;;; make Emacs to indent code correctly
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
;;; load Autopair for auto-pairing brackets and parenthesis
(require 'autopair)
(autopair-global-mode 1)
(setq autopair-autowrap t)
{% endhighlight %}

In order to use `autopair`, you need to install it with the 
[emacs package managder]({%post_url 2014-08-14-emacs-package-manager-and-theme-setup%}). Reload the init file with 
`M-x eval-region RET` to make the changes take effect.

<!-- more -->

## Install ECB

See this post: [Emacs With Emacs Code Brawser]({% post_url 2014-08-14-emacs-with-emacs-code-browser %}).

## Code Snippets and Autocompletetion

See this post: 
[Emacs With Yasnippet And Autocompletion]({% post_url 2014-08-14-emacs-with-yasnippet-and-autocompletion %}).

## Autocomplete source for C Header files

Install the `auto-complete-c-headers` with the 
[emacs package managder]({%post_url 2014-08-14-emacs-package-manager-and-theme-setup%}). Add the following code into 
the `.emacs`:

{% highlight cl %}
(defun my:ac-c-headers-init ()
    (require 'auto-complete-c-headers)
    (add-to-list 'ac-sources 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'my:ac-c-headers-init)
{% endhighlight %}

## Expand member function for C++ class

Install the `member-function` with the 
[emacs package managder]({%post_url 2014-08-14-emacs-package-manager-and-theme-setup%}). Add the following code into 
the `.emacs`:

{% highlight cl %}
(require 'member-function)
(setq mf--source-file-extension "cpp")
{% endhighlight %}

This package can help expand the function headers defined in .h file into a .cc file.

## Check Syntax on the fly

Now, the `flymake` is part of Emacs, so just add the following code to enable it upon opening files with syntax 
checking available:

{% highlight cl %}
(require 'flymake)
(add-hook 'find-file-hook 'flymake-find-file-hook)
{% endhighlight %}

The `flymake` requires the `MakeFile` with the file name **Makefile**. To use `flymake` with C++ programs, add the 
following MakeFile code into the **Makefile**:

{% highlight make %}
check-syntax:
    g++ -o nul -S ${CHK_SOURCES}
{% endhighlight %}
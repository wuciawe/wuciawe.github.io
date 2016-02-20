---
layout: post
category: [emacs]
tags: [emacs, yasnippet, autocompletion, c++]
infotext: 'Simple steps to setup Emacs with Yasnippet and Autocomplete.'
---
{% include JB/setup %}

`YASnippet` is a template system for Emacs. It allows you to type an abbreviation and automatically expand it into 
function templates. Bundled language templates include: C, C++, C#, Perl, Python, Ruby, SQL, LaTeX, HTML, CSS and more.

## Installation of Yasnippet and Autocomplete

First, install `yasnippet` and `autocomplete` with the 
[emacs package managder]({%post_url 2014-08-14-emacs-package-manager-and-theme-setup%}).

Then, add the following code into the `.emacs`:

{% highlight cl linenos=table %}
;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)
;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")
{% endhighlight %}

Now, reload the init file with `M-x eval-region RET` to make changes take effect.

After that, every time you press `TAB`, `yasnippet` will run first searching for snippet, if failed, the `autocomplete` 
will be activated.

<!-- more -->

## C++ Autocompletion with Clang

In order to autocomplete codes with Clang, you need first install Clang on your system. Then install the 
`auto-complete-clang` with  the [emacs package managder]({%post_url 2014-08-14-emacs-package-manager-and-theme-setup%}).

After that, add the following code into the `.emacs`:

{% highlight cl linenos=table %}
(require 'auto-complete-clang)
(define-key c++-mode-map (kbd "C-S-<return>") 'ac-complete-clang)
;; replace C-S-<return> with a key binding that you want

(require 'auto-complete)
{% endhighlight %}

Now, reload the init file with `M-x eval-region RET` to make changes take effect.
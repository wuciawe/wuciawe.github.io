---
layout: post
category : [emacs]
tags : [emacs, ecb]
infotext: 'Emacs Code Browser, which makes Emacs like an IDE.'
---
{% include JB/setup %}

ECB is the Emacs Code Browser, it makes Emacs more like IDE. You can install it as following:

*   Install the **ecb** with the [emacs package managder]({%post_url 2014-08-14-emacs-package-manager-and-theme-setup%}).
*   Add following code into `.emacs`.
{% highlight cl %}
;;; activate ecb
(require 'ecb)
(require 'ecb-autoloads)
{% endhighlight %}
*   Reload the init file with `M-x eval-region RET`.


Now, you can activate ECB with `M-x ecb-activate RET` and deactivate it with `M-x ecb-deactivate RET` respectively.

<!-- more -->

## Basic configurations

Below are my ECB configuration in `.emacs`:

{% highlight cl %}
;;; set layout for ECB
(setq ecb-layout-name "left2")

;;; show source files in directories buffer
(setq ecb-show-sources-in-directories-buffer 'always)

;;; keep a persistent compile window in ECB
(setq ecb-compile-window-height 12)

;;; activate and deactivate ecb
(global-set-key (kbd "C-x C-;") 'ecb-activate)
(global-set-key (kbd "C-x C-'") 'ecb-deactivate)
;;; show/hide ecb window
(global-set-key (kbd "C-;") 'ecb-show-ecb-windows)
(global-set-key (kbd "C-'") 'ecb-hide-ecb-windows)
;;; quick navigation between ecb windows
(global-set-key (kbd "C-)") 'ecb-goto-window-edit1)
(global-set-key (kbd "C-!") 'ecb-goto-window-directories)
(global-set-key (kbd "C-@") 'ecb-goto-window-sources)
(global-set-key (kbd "C-#") 'ecb-goto-window-methods)
(global-set-key (kbd "C-$") 'ecb-goto-window-compilation)
{% endhighlight %}

[Here](https://github.com/kiwanami/emacs-window-manager){:target="_blank"} is another browser plugin for Emacs.
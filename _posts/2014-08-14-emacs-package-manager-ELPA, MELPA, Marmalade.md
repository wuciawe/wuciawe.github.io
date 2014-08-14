---
layout: post
category : [emacs]
tags : [emacs, package manager]
---
{% include JB/setup %}

## Load Emacs package manager

Add the following into the Emacs configuration file `.emacs`:

``` cl
;;; Emacs is not a package manager, and here we load its package manager!
(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ;; TODO: Maybe, use this after emacs24 is released
                  ;; (development versions of packages)
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
  (add-to-list 'package-archives source t))
(package-initialize)
```

<!-- more -->
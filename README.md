# Base Config
Having existed for more than 40 years, GNU Emacs has some strange default behaviours that one would not expect, especially for a modern user. There are also other features built-in that are incredibly useful, however, are turned off by default. This emacs package aims to improve the vanilla Emacs experience by making some slight tweaks.

# Installation
## Manual
```elisp
(add-to-list 'load-path "PATH_TO_THIS_FOLDER")
(require 'base-config)
```

## Using straight.el
[straight.el](https://github.com/radian-software/straight.el) is another package manager for Emacs.

### With use-package
```elisp
(use-package base-config
  :straight (:type git :host github :repo "JessebotX/emacs-base-config"))
```

### Without use-package
```elisp
(straight-use-package
 '(base-config :type git :host github :repo "JessebotX/emacs-base-config"))
```

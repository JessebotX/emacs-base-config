;;; -*- lexical-binding: t; -*-

(defcustom base-enable-backups-and-lockfiles nil
  "Let emacs create backup and lockfiles in your directories."
  :group 'base)

(defcustom base-enable-warning-error-bells nil
  "Enable flashing frame and bell sounds when you perform an invalid
operation such as trying to go to the beginning of the file when
you're already at the top."
  :group 'base)

(defcustom base-tab-size 4
  "Number of columns a tab character (\t) occupies. Supports
`evil-shift-width' for `evil-mode'"
  :group 'base)

(defcustom base-tab-expand-to-spaces t
  "Expand a tab character into columns of spaces equal to `tab-width'"
  :group 'base)

(defcustom base-enable-symbols-and-emojis t
  "Setup fonts so that most unicode and emoji characters would show.

If non-nil, fonts will be setup, else, nothing will be done."
  :group 'base)

(defcustom base-enable-separate-config-for-customize t
  "Move settings done in the `customize' interface be saved in custom.el"
  :group 'base)

(defcustom base-enable-vertical-minibuffer t
  "Enable vertical minibuffer candidate selection"
  :group 'base)

;;; Indentation

;; When deleting a tab, delete all whitespace including tabs and spaces
(customize-set-variable 'backward-delete-char-untabify-method 'hungry)

;; Set tab size and whether to expand tabs to spaces
(customize-set-variable 'tab-width base-tab-size)
(customize-set-variable 'indent-tabs-mode (not base-tab-expand-to-spaces))

;; `evil-mode' only: Set evil-shift-width to the same as tab-size
(customize-set-variable 'evil-shift-width base-tab-size)

;;; Backups and Lockfiles
(unless base-enable-backups-and-lockfiles
  (customize-set-variable 'create-lockfiles nil)
  (customize-set-variable 'make-backup-files nil))

;;; Warning flashes and bells
(unless base-enable-warning-error-bells
  (customize-set-variable 'ring-bell-function 'ignore)
  (customize-set-variable 'visible-bell nil))

;;; Fill-column
(customize-set-variable 'fill-column 80) ; set ideal max column width of chars to 80

;;; Scrolling
(setq auto-window-vscroll nil)
(customize-set-variable 'fast-but-imprecise-scrolling t)

;; Stop screen from jumping around when you're scrolling
(customize-set-variable 'scroll-conservatively 101)

;; Scrolling margin at the top and bottom of window
(customize-set-variable 'scroll-margin 0)

;; Move cursor so that it doesn't change screen position
(customize-set-variable 'scroll-preserve-screen-position t)

;; Scroll text pixel-by-pixel
(pixel-scroll-mode 1)

;;; Load saved customizations (done in `customize' menu) in custom.el
(when base-enable-separate-config-for-customize
  (customize-set-variable 'custom-file
  			(expand-file-name "custom.el" user-emacs-directory))
  (load custom-file 'noerror 'nomessage))

;;; Shorten yes/no prompts
(if (boundp 'use-short-answers)
    (customize-set-variable 'use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))

;;; Automatically update file and buffer contents when they are changed
(customize-set-variable 'global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)

;;; Dont save duplicates in kill-ring (where "cut/deleted" text is stored)
(customize-set-variable 'kill-do-not-save-duplicates t)

;;; Line numbers
(customize-set-variable 'display-line-numbers-width 4)

(global-display-line-numbers-mode 1)

;;; Minibuffer improvements
(defun base-minibuffer-backward-kill (arg)
  "When minibuffer is completing a file name delete up to parent
folder, otherwise delete a word"
  (interactive "p")
  (if minibuffer-completing-file-name
      (if (string-match-p "/." (minibuffer-contents))
          (zap-up-to-char (- arg) ?/)
        (delete-minibuffer-contents))
      (delete-word (- arg))))

;; Delete contents up to parent folder when minibuffer is completing a file name
(let ((map minibuffer-local-map))
  (define-key map (kbd "C-<backspace>") #'base-minibuffer-backward-kill)
  (define-key map (kbd "M-<backspace>") #'base-minibuffer-backward-kill))

;; Save minibuffer command history
(savehist-mode 1)

;; Display minibuffer candidates vertically
(when base-enable-vertical-minibuffer
  (fido-vertical-mode 1)
  (define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-force-complete))

;;; Mode-line improvements
(column-number-mode 1) ; Show column position in mode line

;;; Use `ibuffer-list-buffers' instead of `list-buffers'
(customize-set-variable 'ibuffer-movement-cycle nil) ; no forward/backward movement cycling in ibuffer
(customize-set-variable 'ibuffer-old-time 24)
(global-set-key [remap list-buffers] #'ibuffer-list-buffers)

;;; Fonts
;;;; Symbols (symbol . [8220 8704 9472])
(when base-enable-symbols-and-emojis
  (set-fontset-font t
   'symbol
   (cond
    ((string-equal system-type "windows-nt")
     (cond
      ((member "Segoe UI Symbol" (font-family-list)) "Segoe UI Symbol")))
    ((string-equal system-type "darwin")
     (cond
      ((member "Apple Symbols" (font-family-list)) "Apple Symbols")))
    ((string-equal system-type "gnu/linux")
     (cond
      ((member "Symbola" (font-family-list)) "Symbola")))))
  
;;;; Emojis
;; NOTE: Load this last (after you configured ALL your fonts)
  (progn
    (set-fontset-font t
     (if (version< emacs-version "28.1")
         '(#x1f300 . #x1fad0)
       'emoji)
     (cond
      ((member "Segoe UI Emoji" (font-family-list)) "Segoe UI Emoji")
      ((member "Apple Color Emoji" (font-family-list)) "Apple Color Emoji")
      ((member "Noto Color Emoji" (font-family-list)) "Noto Color Emoji")
      ((member "Noto Emoji" (font-family-list)) "Noto Emoji")
      ((member "Symbola" (font-family-list)) "Symbola")))))

;;; Better buffer names when opening files with the same name
(customize-set-variable 'uniquify-buffer-name-style 'forward)

;;; Better keybindings
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Superior text expansion with `hippie-expand'
(global-set-key [remap dabbrev-expand] 'hippie-expand) 

(customize-set-variable 'require-final-newline t)

;;; Enable some other modes
(delete-selection-mode 1) ; delete currently selected text when inserting characters
(electric-pair-mode 1)    ; Auto insert matching bracket
(global-so-long-mode 1)   ; Better performance for minified files
(winner-mode 1)           ; Save window configurations

;;; END OF FILE
(provide 'base-config)

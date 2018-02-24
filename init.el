;; init.el --- Azzamsa  Emacs configuration
;;
;; Copyright (c) 2016 Azzamsa
;;
;; Author: Azzamsa <me at azzamsa dot com>
;; https://github.com/azzamsa/emacs.d
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This is my personal Emacs configuration.  Nothing more, nothing less.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.


;;; Code:

;; Initialize the package system.
(require 'package)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("SC"   . "http://joseito.republika.pl/sunrise-commander/")
                         ("org" . "http://orgmode.org/elpa/")))

;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)
;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(setq user-full-name "azzamsa"
      user-mail-address "me@azzamsa.com")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(defconst azzamsa-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p azzamsa-savefile-dir)
  (make-directory azzamsa-savefile-dir))

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)
;;better bar cursor type
(setq-default cursor-type 'bar)
;;line number everywhere
(global-linum-mode t)
;; cursor color dissappear on emacs 25
(set-cursor-color "#f0fff0")

(set-frame-font "InconsolataGo-13")
;;evaluate this everytime load emacs from daemon.
(setq default-frame-alist '((font . "InconsolataGo-13")))
;; highlight the current line
(global-hl-line-mode +1)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; no need double click to insert, Yey!
(delete-selection-mode +1)

;;;loading my org configuration
(load "~/.emacs.d/my-elisp/myorg.el")

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; revert buffers automatically when underlying files are changed externally
                                        ;(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)


;; misc useful keybindings
(global-set-key (kbd "s-<") #'beginning-of-buffer)
(global-set-key (kbd "s->") #'end-of-buffer)


;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "s-/") #'hippie-expand)

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Make use-package available.
(require 'use-package)
(setq use-package-verbose t)

;; Theming
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))


;; hooks
;; startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (helm-mode t)
            (visual-line-mode t)))
;;(pomodoro-start 25))) ;25 is minutes for work

;; Common Lisp
(add-hook 'lisp-mode-hook
          (lambda ()
            (slime-mode t)
            (rainbow-delimiters-mode t)
            (show-paren-mode t)
            (prettify-symbols-mode t)))

;; packages
(use-package projectile
  :ensure t
  :bind ("s-p" . projectile-command-map))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package paren
  :config
  (show-paren-mode +1))

(use-package abbrev
  :ensure nil
  :config
  (setq-default abbrev-mode t)
  (cond ((file-exists-p "~/.abbrev_defs")
         (read-abbrev-file "~/.abbrev_defs")))
  (setq save-abbrevs t)
  (setq save-abbrevs 'silently))

(use-package dired
  :ensure nil
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil)

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package helm
  :ensure nil
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list))
  :init
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-display-header-line nil)
  :config
  ;; No idea why here find-file is set to nil (so it uses the native find-file
  ;; for Emacs. This makes stuff like (find-file (read-file-name ...)) work with
  ;; Helm again.
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (add-to-list 'helm-completing-read-handlers-alist '(find-file . helm-completing-read-symbols)))

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)))

(use-package pomodoro
  :disabled
  :load-path "elisp/pomodoro/"
  :config
  (progn
    (pomodoro-add-to-mode-line)
    (setq pomodoro-break-start-sound
          "~/.emacs.d/elisp/pomodoro/Wind-chime.wav")
    (setq pomodoro-long-break-time 20)
    (setq pomodoro-show-number t)
    (setq pomodoro-sound-player "/usr/bin/aplay")
    (setq pomodoro-work-start-sound
          "~/.emacs.d/elisp/pomodoro/Sparkle.wav")))

(use-package rainbow-delimiters
  :ensure t)

(use-package rainbow-mode
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))

(use-package smart-mode-line
  :ensure t
  :init
  (setq
   sml/no-confirm-load-theme t
   sml/theme 'respectful
   sml/shorten-modes t
   rm-blacklist '(" Rbow"
                  " yas"
                  " Projectile"
                  " Undo-Tree"
                  " Ind"
                  " super-save"))
  (sml/setup))

(use-package org
  :ensure t
  :bind(
        :map org-mode-map
             ("C-c l" . org-store-link)
             ("C-c a" . org-agenda))
  :init
  (progn
    (setq org-src-tab-acts-natively t)
    (setq org-log-done t)
    (setq org-startup-indented t)
    (setq org-agenda-files (list "~/.emacs.d/documents/planz.org"))
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((java . t)
       (sh   . t)
       (shell . t)
       (lisp . t))))
  :config
  (add-hook 'org-mode-hook #'my-org-mode-hook))

(use-package ox-gfm
  :load-path "/elisp/ox-gfm/")

(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init (add-hook 'org-mode-hook
                  (lambda ()
                    (org-bullets-mode 1))))

(use-package calfw
  :bind ("C-c A" . my-calendar)
  :init
  (progn
    (use-package calfw-cal)
    (use-package calfw-org)
    (use-package calfw-ical)
    :preface
    (defun my-calendar ()
      (interactive)
      (let ((buf (get-buffer "*cfw-calendar*")))
        (if buf
            (pop-to-buffer buf nil)
          (cfw:open-calendar-buffer
           :contents-sources
           (list (cfw:org-create-source "#d6c9a7")
                 (cfw:cal-create-source "White"))))))
    ;;:view 'four-weeks))))
    :config
    (progn
      (bind-key "g" 'cfw:refresh-calendar-buffer cfw:calendar-mode-map)
      (setq cfw:display-calendar-holidays nil)
      (custom-set-faces
       '(cfw:face-title ((t (:foreground "#f0dfaf" :weight bold :height 2.0 :inherit variable-pitch))))
       '(cfw:face-header ((t (:foreground "#d0bf8f" :weight bold))))
       '(cfw:face-sunday ((t :foreground "#cc9393" :weight bold)))
       '(cfw:face-saturday ((t :foreground "8cd0d3"  :weight bold)))
       '(cfw:face-holiday ((t :background "grey10" :foreground "#8c5353" :weight bold)))
       '(cfw:face-grid ((t :foreground "#BADEAC")))
       '(cfw:face-default-content ((t :foreground "#ffffff")))
       '(cfw:face-periods ((t :foreground "#ffe259"))) ;;?
       '(cfw:face-day-title ((t :background "grey10"))) ;; rectangle in header
       '(cfw:face-default-day ((t :foreground "#b4eeb4" :weight bold :inherit cfw:face-day-title)))
       '(cfw:face-annotation ((t :foreground "#ffffff" :inherit cfw:face-day-title))) ;; data number in box(23 - 24)
       '(cfw:face-disable ((t :foreground "DarkGray" :inherit cfw:face-day-title)))
       '(cfw:face-today-title ((t :background "#7f9f7f" :weight bold)))
       '(cfw:face-today ((t :background: "grey10" :weight bold)))
       '(cfw:face-select ((t :background "#2f2f2f")))
       '(cfw:face-toolbar ((t :foreground "Steelblue4" :background "#3F3F3F")))
       '(cfw:face-toolbar-button-off ((t :foreground "#f5f5f5" :weight bold))) ;;top botton
       '(cfw:face-toolbar-button-on ((t :foreground "#ffffff" :weight bold))))
      (setq holiday-christian-holidays nil)
      (setq holiday-bahai-holidays nil)
      (setq holiday-hebrew-holidays nil)
      (setq holiday-islamic-holidays nil)
      (setq holiday-oriental-holidays nil))))

(setq diary-file "~/.emacs.d/documents/diary")


(use-package magit
  :ensure t
  :bind ("C-c g" . magit-status))

(use-package dired+
  :ensure t
  :config
  (diredp-toggle-find-file-reuse-dir 1))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
(windmove-default-keybindings))

;; Modes for programming languages and such.

(use-package web-mode
  :ensure t
  :mode ("\\.html?\\'"
         "\\.css\\'"
         "\\.php\\'")
  :init (add-hook 'web-mode-hook
                  (lambda ()
                    (emmet-mode 1)
                    (smartparens-mode nil)))
  :config
  (progn
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-enable-auto-quoting nil)))

(use-package js
  ;; built-in
  :init
  (setq js-indent-level 2))

(use-package slime
  :ensure nil
  ;;load-path "~/quicklisp/dists/quicklisp/software/slime-v2.20"
  :config
  (add-hook 'slime-repl-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (rainbow-delimiters-mode 1)
              (show-paren-mode 1)))
  (setq inferior-lisp-program (executable-find "sbcl")
        slime-contribs '(slime-company slime-fancy)
        slime-net-coding-system 'utf-8-unix))

(use-package slime-company
  :ensure nil
  :config
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  (setq inferior-lisp-program "sbcl"))

(use-package yasnippet
  :ensure t
  :init (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config (yas-reload-all))

(use-package php-beautifier
  :load-path "elisp/php-beautifier/")

(use-package emmet-mode
  :ensure t
  :bind (:map emmet-mode-keymap
              ("M-e" . emmet-expand-line))
  :config (add-hook 'web-mode-hook 'emmet-mode))

(use-package php-mode
  :ensure t
  :mode "\\.php\\'"
  :config
  (add-hook 'php-mode-hook
            '(lambda ()
               (require 'company-php)
               (company-mode t)
               (ac-php-core-eldoc-setup) ;; enable eldoc
               (make-local-variable 'company-backends)
               (add-to-list 'company-backends 'company-ac-php-backend))))

(use-package lispy
  :ensure t
  :disabled)

(use-package closure-template-html-mode
  :ensure nil
  :mode "\\.tmpl\\'"
  :load-path "/elisp/closure-template/")

(use-package neotree
  :ensure nil
  :bind ([f8] . neotree-toggle)
  :config
  (setq neo-theme
        (if (display-graphic-p)
            'icons
          'arrow))
  (setq neo-smart-open t)
  ;;work with projectile
  (setq projectile-switch-project-action 'neotree-projectile-action))

(use-package all-the-icons
  :ensure nil)

(use-package markdown-toc
  :ensure nil)

(use-package flyspell
  :config
  (setq ispell-program-name "aspell" ; use aspell instead of ispell
        ispell-extra-args '("--sug-mode=ultra"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode))

(use-package flyspell-correct-helm
  :config
  (define-key flyspell-mode-map (kbd "C-;")
    'flyspell-correct-previous-word-generic))

(use-package whitespace
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail)))


(use-package multiple-cursors
  :init
  (progn
    ;; these need to be defined here - if they're lazily loaded with
    ;; :bind they don't work.
    (global-set-key (kbd "C-c .") 'mc/mark-next-like-this)
    (global-set-key (kbd "C->") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-c ,") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)))

(use-package avy
  :ensure t
  :bind (("s-." . avy-goto-word-or-subword-1)
         ("s-," . avy-goto-char))
  :config
  (setq avy-background t))

(use-package skewer-mode
  :ensure t
  :disabled)

(use-package js2-mode
  :mode ("\\.js$" . js2-mode))

(use-package indent-guide
  :ensure t)

(use-package tex
  :defer t
  :ensure auctex
  :config
  (setq LaTeX-verbatim-environments
        '("verbatim" "Verbatim" "lstlisting" "minted")))


;; Unbind Pesky Sleep Button
(global-unset-key [(control z)])
(global-unset-key [(control x)(control z)])


;; from emacs
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; misc
(elpy-enable)

;; Global keyboarding
(global-set-key [f7] (lambda () (interactive) (find-file user-init-file)))

(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/.emacs.d/documents/planz.org")))

(global-set-key (kbd "C-c n")
                (lambda () (interactive) (find-file "~/.emacs.d/documents/notes.org")))

(global-set-key (kbd "C-c s")
                (lambda () (interactive) (find-file "~/.emacs.d/documents/sletz.org")))

(global-set-key (kbd "C-c b")
                (lambda () (interactive) (find-file "~/.emacs.d/bookmarks.org")))

;;; init.el ends here

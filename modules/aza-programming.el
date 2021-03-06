;;------------------------------------------------
;; Programming Utilities
;;------------------------------------------------

(use-package yasnippet
  :defer t
  :delight yas-minor-mode " Ys"
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook #'yas-minor-mode))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package diff-hl
  :defer 0.9
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package symbol-overlay
  :defer t
  :delight ""
  :bind (( "C-c '" . symbol-overlay-put)))

(use-package editorconfig
  :defer 0.9
  :delight
  :config
  (add-hook 'prog-mode-hook #'editorconfig-mode))

(use-package format-all)

(use-package prettify-symbols-mode
  :straight (:type built-in)
  :defer t
  :config
  (add-hook 'prog-mode-hook #'prettify-symbols-mode))

(use-package hl-todo
  :defer 0.9
  :config
  (setq hl-todo-keyword-faces
        '(("HOLD" . "#d0bf8f")
          ("TODO" . "#cc9393")
          ("DONE" . "#afd8af")
          ("NOTE"   . "#d0bf8f")
          ("MAYBE" . "#d0bf8f")
          ("FIXME"  . "#cc9393")))
  (add-hook 'prog-mode-hook #'hl-todo-mode))


(use-package gitconfig-mode :defer t)
(use-package gitignore-mode :defer t)
(use-package gitattributes-mode :defer t)

(use-package subword
  :ensure nil
  :defer t
  :delight "")

(use-package highlight-indentation
  :ensure nil
  :defer t
  :delight "")

(use-package yaml-mode
  :mode "\\.yml\\'"
  :interpreter (("yml" . yml-mode))
  :config
  (setq yaml-indent-offset 4))

(use-package rst-mode
  :straight (:type built-in)
  :mode "\\.rst\\'")

(use-package sphinx-mode
  :delight " Sphinx"
  :after rst)

(use-package json-mode
  :delight " J"
  :mode "\\.json\\'")

(use-package toml-mode)
(use-package fish-mode)

(defun aza-prog-mode-defaults ()
  (flyspell-prog-mode)
  (smartparens-mode +1)
  (symbol-overlay-mode))

(setq aza-prog-mode-hook 'aza-prog-mode-defaults)

(add-hook 'prog-mode-hook (lambda ()
                            (run-hooks 'aza-prog-mode-hook)))

;; enable on-the-fly syntax checking
(if (fboundp 'global-flycheck-mode)
    (global-flycheck-mode +1)
  (add-hook 'prog-mode-hook 'flycheck-mode))

;; make a shell script executable automatically on save
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(provide 'aza-programming)

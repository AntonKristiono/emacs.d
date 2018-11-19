(use-package prettify-symbols-mode
  :defer t
  :ensure nil
  :config
  (add-hook 'prog-mode-hook #'prettify-symbols-mode))

(use-package which-function
  :ensure nil
  :disabled
  :defer 3
  :config
  (add-hook 'prog-mode-hook #'which-function-mode))

(use-package hl-todo
  :defer 3
  :config
  (add-hook 'prog-mode-hook #'hl-todo-mode))

(defun aza-prog-mode-defaults ()
  (flyspell-prog-mode)
  (smartparens-mode +1)
  (ws-butler-global-mode +1))

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

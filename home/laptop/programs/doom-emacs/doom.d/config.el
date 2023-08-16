;;; config.el --- the emacs config
;;; Commentary:

;;; Code:
(setq doom-theme 'doom-tokyo-night)

(setq company-idle-delay 0.0)

(setq +format-with-lsp nil)

(advice-add 'json-parse-buffer :around
              (lambda (orig &rest rest)
                (save-excursion
                  (while (re-search-forward "\\\\u0000" nil t)
                    (replace-match "")))
                (apply orig rest)))

(use-package! lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))

(use-package! prisma-mode)
(add-hook 'prisma-mode-hook 'lsp)

;;; config.el ends here

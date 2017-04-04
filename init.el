(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (tango-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(global-set-key "\C-f" 'compile)
(global-set-key "\C-h" 'dired-up-directory)
(global-set-key "\C-z" 'grep-find)
(global-set-key "\C-b" 'revert-buffer)

;; tab size

;;(add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))
;;(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
;;(setq-default tab-width 2)
;;(setq-default indent-tabs-mode nil)

(setq-default c-basic-offset 2)
(setq c-default-style "linux"
          c-basic-offset 2)

(add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))

;;(cua-mode 1)
(which-function-mode 1)
(recentf-mode 1)
(global-set-key "\C-xf" 'recentf-open-files)

(require 'gtags)
(global-set-key "\M-t" 'gtags-find-tag)
(global-set-key "\M-r" 'gtags-find-rtag)
(global-set-key "\M-s" 'gtags-find-symbol)
(global-set-key "\C-t" 'gtags-pop-stack)

(set-face-attribute 'default nil :height 100)

(global-set-key (kbd "C-<left>")  'windmove-left)
(global-set-key (kbd "C-<right>") 'windmove-right)
(global-set-key (kbd "C-<up>")    'windmove-up)
(global-set-key (kbd "C-<down>")  'windmove-down)


(global-set-key "\C-q" 'toggle-truncate-lines)

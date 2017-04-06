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

;; change default mode
;;(cua-mode 1)
(which-function-mode 1)
(recentf-mode 1)
(delete-selection-mode 1)
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

;;copy word
(defun copy-word (&optional arg)
 "Copy words at point into kill-ring"
  (interactive "P")
  (copy-thing 'backward-word 'forward-word arg)
  ;;(paste-to-mark arg)
  )
(global-set-key (kbd "C-c o") 'copy-word)

;;copy line
(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without mark the line "
  (interactive "P")
  (copy-thing 'beginning-of-line 'end-of-line arg)
  ;;(paste-to-mark arg)
  )
(global-set-key (kbd "C-c l") 'copy-line)

;;copy paragraph
(defun copy-paragraph (&optional arg)
  "Copy paragraphes at point"
  (interactive "P")
  (copy-thing 'backward-paragraph 'forward-paragraph arg)
  ;;(paste-to-mark arg)
  )
(global-set-key (kbd "C-c p") 'copy-paragraph)

;; copy string
(defun beginning-of-string(&optional arg)
  "  "
  (re-search-backward "[ \t]" (line-beginning-position) 3 1)
  (if (looking-at "[\t ]")  (goto-char (+ (point) 1)) )
  )

(defun end-of-string(&optional arg)
  " "
  (re-search-forward "[ \t]" (line-end-position) 3 arg)
  (if (looking-back "[\t ]") (goto-char (- (point) 1)) )
  )

(defun thing-copy-string-to-mark(&optional arg)
  " Try to copy a string and paste it to the mark
     When used in shell-mode, it will paste string on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-string 'end-of-string arg)
  ;;(paste-to-mark arg)
  )
(global-set-key (kbd "C-c s") 'thing-copy-string-to-mark)

;;copy parenthesis
(defun beginning-of-parenthesis(&optional arg)
  "  "
  (re-search-backward "[[<(?\"]" (line-beginning-position) 3 1)
  (if (looking-at "[[<(?\"]")  (goto-char (+ (point) 1)) )
  )
(defun end-of-parenthesis(&optional arg)
  " "
  (re-search-forward "[]>)?\"]" (line-end-position) 3 arg)
  (if (looking-back "[]>)?\"]") (goto-char (- (point) 1)) )
  )

(defun thing-copy-parenthesis-to-mark(&optional arg)
  " Try to copy a parenthesis and paste it to the mark
     When used in shell-mode, it will paste parenthesis on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-parenthesis 'end-of-parenthesis arg)
  ;;(paste-to-mark arg)
  )
(global-set-key (kbd "C-c a") 'thing-copy-parenthesis-to-mark)

;; copy group word
(defun beginning-of-group_word(&optional arg)
  "  "
  (re-search-backward "[ )(]" (line-beginning-position) 3 1)
  (if (looking-at "[)( ]")  (goto-char (+ (point) 1)) )
  )

(defun end-of-group_word(&optional arg)
  " "
  (re-search-forward "[ )(]" (line-end-position) 3 arg)
  (if (looking-back "[)( ]") (goto-char (- (point) 1)) )
  )

(defun thing-copy-group_word(&optional arg)
  " Try to copy a string and paste it to the mark
     When used in shell-mode, it will paste string on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-group_word 'end-of-group_word arg)
  ;;(paste-to-mark arg)
  )
(global-set-key (kbd "C-c w") 'thing-copy-group_word)

;; proxy
;;(setq url-proxy-services '(("http" . "pac.mei.co.jp/proxy.pac:80")))

;;(load-file "~/.emacs.d/elpa/setup-cygwin.el")
(load-file "~/.emacs.d/elpa/gtags-el/gtags.el")
(load-file "~/.emacs.d/elpa/csharp-mode/csharp-mode.el")
;;(require 'csharp-mode)
;;(csharp-mode 1)
;; Setting PATH ENV

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;(setenv "PATH" (concat (getenv "PATH") ":/bin"))
;;(setq exec-path (append exec-path '("/bin")))

;;(setenv "SHELL" "/bin/bash")
;;(setq explicit-shell-file-name "/bin/bash")
;; Setting PATH ENV

;; add package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (wheatgrass))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))

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

;;(add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))

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

;; base copy fucntion
(defun get-point (symbol &optional arg)
  "get the point"
  (funcall symbol arg)
  (point)
  )

(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "copy thing between beg & end into kill ring"
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
	  (end (get-point end-of-thing arg)))
      (copy-region-as-kill beg end)))
  )

(defun paste-to-mark(&optional arg)
  "Paste things to mark, or to the prompt in shell-mode"
  (let ((pasteMe 
     	 (lambda()
     	   (if (string= "shell-mode" major-mode)
	       (progn (comint-next-prompt 25535) (yank))
	     (progn (goto-char (mark)) (yank) )))))
    (if arg
	(if (= arg 1)
	    nil
	  (funcall pasteMe))
      (funcall pasteMe))
    ))

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
  (re-search-backward "[ .;)(]" (line-beginning-position) 3 1)
  (if (looking-at "[.;)( ]")  (goto-char (+ (point) 1)) )
  )

(defun end-of-group_word(&optional arg)
  " "
  (re-search-forward "[ .;)(]" (line-end-position) 3 arg)
  (if (looking-back "[.;)( ]") (goto-char (- (point) 1)) )
  )

(defun thing-copy-group_word(&optional arg)
  " Try to copy a string and paste it to the mark
     When used in shell-mode, it will paste string on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-group_word 'end-of-group_word arg)
  ;;(paste-to-mark arg)
  )
(global-set-key (kbd "C-c w") 'thing-copy-group_word)

;;enable CUA-MODE
(cua-mode t)
(setq cua-enable-cua-keys nil) ; デフォルトキーバインドを無効化
(define-key global-map (kbd "C-x SPC") 'cua-set-rectangle-mark)

;;open file/folder from dired mode
(defun w32-browser (doc) (w32-shell-execute 1 doc))
(eval-after-load "dired" '(define-key dired-mode-map "\z" (lambda () (interactive) (w32-browser (dired-replace-in-string "/" "\\" (dired-get-filename))))))

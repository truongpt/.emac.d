;; Package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Setting PATH ENV
(setenv "PATH" (concat (getenv "PATH") ":/bin"))
(setenv "PATH" (format "c:\\cygwin64\\bin;%s" (getenv "PATH")))

;; setting theme, font
;;(load-theme 'deeper-blue)
;;(load-theme 'tango-dark)
(load-theme 'manoj-dark)

(if (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :family "Consolas" :height 130)
)

(if (eq system-type 'darwin) (eq system-type 'linux)
  (set-face-attribute 'default nil :height 130)
)


;; Indentation
(setq-default c-default-style "linux")
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4) ; or any other preferred value
(defvaralias 'c-basic-offset 'tab-width)

;; Change default mode
(which-function-mode 1)
(recentf-mode 1)
(delete-selection-mode 1)
;;(global-linum-mode 1) ;;Display line number
(global-hl-line-mode 1) ;;High light line
(global-visual-line-mode 1)

(set-face-background 'highlight nil)
(set-face-foreground 'highlight nil)
(set-face-underline-p 'highlight t)
(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

(show-paren-mode 1) ;; Display paren (highlight matching brackets)
(setq show-paren-delay 0)

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; Gtags
(load-file "~/.emacs.d/elpa/gtags-el/gtags.el")
(require 'gtags)
(setq gtags-path-style 'relative)
(global-set-key "\M-t" 'gtags-find-tag)
(global-set-key "\M-r" 'gtags-find-rtag)
(global-set-key "\M-s" 'gtags-find-symbol)
(global-set-key "\C-t" 'gtags-pop-stack)
(global-set-key "\M-z" 'gtags-find-with-grep)

;; utility
(global-set-key "\C-h" 'dired-up-directory)
(global-set-key "\C-f" 'grep-find)
(global-set-key "\C-i" 'forward-word)
(global-set-key "\C-u" 'backward-word)

;;utility kbd
(global-set-key (kbd "C-<left>")  'windmove-left)
(global-set-key (kbd "C-<right>") 'windmove-right)
(global-set-key (kbd "C-<up>")    'windmove-up)
(global-set-key (kbd "C-<down>")  'windmove-down)
(global-set-key (kbd "C-:")  'isearch-forward-symbol-at-point)

(global-set-key "\C-xf" 'recentf-open-files)
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

;; Remove tool bar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(unless (and (eq system-type 'darwin) (display-graphic-p))
  (when (fboundp 'menu-bar-mode)
    (menu-bar-mode -1)))

;; turn off cursor blink
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))

;; turn off beep
(setq ring-bell-function 'ignore)

;; keep current buffer for M-x shell
(push (cons "\\*shell\\*" display-buffer--same-window-action) display-buffer-alist)

;;scroll
(global-set-key (kbd "M-<up>") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "M-<down>") (lambda () (interactive) (scroll-up 1)))

(global-set-key (kbd "M-S-<up>") (lambda () (interactive) (scroll-down 5)))
(global-set-key (kbd "M-S-<down>") (lambda () (interactive) (scroll-up 5)))

;; Convert to unix LF
(defun unix-file ()
  "Change the current buffer to Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'unix t))

;; Automatic change to unix LF
(defun no-junk-please-were-unixish ()
  (let ((coding-str (symbol-name buffer-file-coding-system)))
    (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
      (set-buffer-file-coding-system 'unix))))

(add-hook 'find-file-hooks 'no-junk-please-were-unixish)

(defun my-dired-mode-setup ()
  "show less information in dired buffers"
  (dired-hide-details-mode 1))
(add-hook 'dired-mode-hook 'my-dired-mode-setup)

;; Auto-complete
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-local")
(require 'auto-complete)
(global-auto-complete-mode t)

;; Neotree
(add-to-list 'load-path "~/.emacs.d/elpa/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-smart-open t)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))
(add-hook 'text-mode-hook 'remove-dos-eol)

(defun remap-faces-default-attributes ()
  (let ((family (face-attribute 'default :family))
        (height (face-attribute 'default :height)))
    (mapcar (lambda (face)
              (face-remap-add-relative
               face :family family :weight 'normal :height height))
          (face-list))))

(when (display-graphic-p)
  (add-hook 'minibuffer-setup-hook 'remap-faces-default-attributes)
  (add-hook 'change-major-mode-after-body-hook 'remap-faces-default-attributes))

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(mapc (lambda (elt)
        (define-key dired-mode-map (car elt)
          `(lambda ()
            (interactive)
            (dired-sort-other (concat dired-listing-switches ,(cadr elt))))))
      '(([(control f3)]       ""     "by name")
        ([(control f4)]       " -X"  "by extension")
        ([(control f5)]       " -t"  "by date")
        ([(control f6)]       " -S"  "by size")
        ([(control shift f3)] " -r"  "by reverse name")
        ([(control shift f4)] " -rX" "by reverse extension")
        ([(control shift f5)] " -rt" "by reverse date")
        ([(control shift f6)] " -rS" "by reverse size")))

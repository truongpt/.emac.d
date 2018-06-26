
;;(load-file "~/.emacs.d/elpa/setup-cygwin.el")

;;add package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Setting PATH ENV
(setenv "PATH" (concat (getenv "PATH") ":/bin"))
;;(setq exec-path (append exec-path '("/bin")))
;;(setenv "PATH" "c:\\cygwin64\\bin")
(setenv "PATH" (format "c:\\cygwin64\\bin;%s" (getenv "PATH")))
;;(setq find-dired-find-program "c:\\cygwin64\\bin\\find.exe")
;;(setq find-program "c:\\cygwin64\\bin\\find.exe")

;;(setenv "SHELL" "/bin/bash")
;;(setq explicit-shell-file-name "/bin/bash")
;; Setting PATH ENV

;; setting theme, font
;;(load-theme 'deeper-blue)
(load-theme 'tango-dark)

(if (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :family "Consolas" :height 110)
)

;; Indentation
(setq-default c-basic-offset 4)
(setq c-default-style "linux"
          c-basic-offset 4)


;; Change default mode
;;(cua-mode 1)
(which-function-mode 1)
(recentf-mode 1)
(delete-selection-mode 1)
;; Display line number
(global-linum-mode 1)

;; High light line
(global-hl-line-mode 1)

;; Gtags
(load-file "~/.emacs.d/elpa/gtags-el/gtags.el")
(require 'gtags)
(setq gtags-path-style 'relative)
(global-set-key "\M-t" 'gtags-find-tag)
(global-set-key "\M-r" 'gtags-find-rtag)
(global-set-key "\M-s" 'gtags-find-symbol)
(global-set-key "\C-t" 'gtags-pop-stack)
(global-set-key "\M-z" 'gtags-find-symbol)

;; utility
(global-set-key "\C-h" 'dired-up-directory)
(global-set-key "\C-z" 'grep-find)
(global-set-key "\C-i" 'forward-word)
(global-set-key "\C-u" 'backward-word)

;;utility kbd
(global-set-key (kbd "C-<left>")  'windmove-left)
(global-set-key (kbd "C-<right>") 'windmove-right)
(global-set-key (kbd "C-<up>")    'windmove-up)
(global-set-key (kbd "C-<down>")  'windmove-down)

(global-set-key "\C-xf" 'recentf-open-files)
(global-set-key "\C-q" 'toggle-truncate-lines)

(set-face-attribute 'default nil :height 100)

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

;; remove tool bar
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

;; NeoTree
(add-to-list 'load-path "~/.emacs.d/elpa/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-smart-open t)

;; Auto-complete
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-local")
(require 'auto-complete)
(setq auto-complete-mode t)

;; Use counsel
;;(require 'counsel)
;;(ivy-mode 1)
;;(setq ivy-use-virtual-buffers t)
;;(setq enable-recursive-minibuffers t)
;;(global-set-key (kbd "M-s") 'swiper)
;;(global-set-key (kbd "C-x m") 'counsel-M-x)
;;(global-set-key (kbd "C-c C-r") 'ivy-resume)
;;(global-set-key (kbd "<f6>") 'ivy-resume)
;;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;(global-set-key (kbd "<f1> f") 'counsel-describe-function)
;;(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;;(global-set-key (kbd "<f1> l") 'counsel-find-library)
;;(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;;(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;;(global-set-key (kbd "C-c g") 'counsel-git)
;;(global-set-key (kbd "C-c j") 'counsel-git-grep)
;;(global-set-key (kbd "C-c k") 'counsel-ag)
;;(global-set-key (kbd "C-x l") 'counsel-locate)
;;(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;;(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (helm with-editor popup counsel))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

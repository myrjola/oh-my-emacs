
;; believe me, you don't need menubar, toolbar nor scrollbar
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode horizontal-scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))

(package-initialize)
(add-to-list 'package-archives
 '("melpa" . "http://melpa.milkbox.net/packages/") t)

(defun package-safe-install (&rest packages)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))
    (if (featurep package)
        (require package))))

(setf user-full-name "Martin Yrjölä")
(setf user-mail-address "martin.yrjola@gmail.com")

(setf custom-file "~/.emacs.d/custom.el")
(load custom-file)

(setf hostname
      (with-temp-buffer
        (call-process "hostname" nil t)
        (let ((hostname* (buffer-string)))
          (while (string-match "[\r\n\t ]+" hostname*)
            (setq hostname* (replace-match "" t t hostname*)))
          hostname*)))

(setf inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; fix the mac PATH variable
(defun ome-set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when (eq system-type 'darwin)
  (when window-system (ome-set-exec-path-from-shell-PATH)))

;; set backup-directory
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs_backup"))
      backup-by-copying t
      version-control t
      kept-old-versions 2
      kept-new-versions 20
      delete-old-versions t)
(setq tramp-backup-directory-alist backup-directory-alist)
(setq auto-save-file-name-transforms nil)

;; set environment coding system
(set-language-environment "UTF-8")
;; auto revert buffer globally
(global-auto-revert-mode t)
;; set TAB and indention
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
;; y or n is suffice for a yes or no question
(fset 'yes-or-no-p 'y-or-n-p)
;; always add new line to the end of a file
(setq require-final-newline t)
;; add no new lines when "arrow-down key" at the end of a buffer
(setq next-line-add-newlines nil)
;; prevent the annoying beep on errors
(setq ring-bell-function 'ignore)
;; remove trailing whitespaces before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; enable to support navigate in camelCase words
(global-subword-mode t)

;; shell-mode settings
(unless (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "/bin/bash")
  (setq shell-file-name "/bin/bash"))
;; always insert at the bottom
(setq comint-scroll-to-bottom-on-input t)
;; no duplicates in command history
(setq comint-input-ignoredups t)
;; what to run when i press enter on a line above the current prompt
(setq comint-get-old-input (lambda () ""))
;; max shell history size
(setq comint-input-ring-size 1000)
;; show all in emacs interactive output
(setenv "PAGER" "cat")
;; set lang to enable Chinese display in shell-mode
(setenv "LANG" "en_US.UTF-8")

;; set text-mode as the default major mode, instead of fundamental-mode
;; The first of the two lines in parentheses tells Emacs to turn on Text mode
;; when you find a file, unless that file should go into some other mode, such
;; as C mode.
(setq-default major-mode 'text-mode)

;; Max 80 chars per column
(setq-default fill-column 80)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'prog-mode-hook 'turn-on-auto-fill)

;; When you visit a file, point goes to the last place where it was when you
;; previously visited the same file.
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory ".saved-places"))
(require 'saveplace)


;; Enable recent files mode.
(require 'recentf)
(recentf-mode t)

;; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

;; No more <1> <2> after buffer names
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(require 'uniquify)

;; use aspell instead of ispell
(setq ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra"))

;; On-the-fly syntax checking
(package-safe-install 'flycheck 'flycheck-ledger)
(add-hook 'prog-mode-hook 'flycheck-mode)

;; show column number and line number
(dolist (mode '(column-number-mode line-number-mode))
  (when (fboundp mode) (funcall mode t)))

;; Hide scroll-bars
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)

;; Toggle line highlighting in all buffers except org-mode because linum can't
;; handle big files that well
(global-linum-mode t)
(add-hook 'org-mode-hook (lambda () (linum-mode 0)))

;; Toggle line highlighting in all buffers
(global-hl-line-mode t)

;; if in gui-mode
(when (display-graphic-p)
  ;; make the fringe thinner (default is 8 in pixels)
  (fringe-mode 4))

;; Enable xterm mouse reporting from the terminal
(unless (display-graphic-p)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1))))


;; show parenthesis match
(show-paren-mode 1)
(setq show-paren-style 'expression)


;; frame font
(if (member "Source Code Pro" (font-family-list))
    (set-face-attribute
     'default nil :font "Source Code Pro 9"))

;; I love solarized-dark
(package-safe-install 'color-theme-solarized)
(load-theme 'solarized-dark t)
;; Make underlines more readable on X11
(if (equal window-system 'x) (setq x-underline-at-descent-line t) ())

;; Smart modeline
(package-safe-install 'smart-mode-line)
(sml/setup)
(sml/apply-theme 'automatic)

;; Relative line numbering
(package-safe-install 'linum-relative)
(require 'linum-relative)
(setq linum-relative-current-symbol "")

(package-safe-install 'evil)
(require 'evil)
(setq evil-auto-indent t)
(setq evil-regexp-search t)
(setq evil-want-C-i-jump t)
(evil-mode)
;; Don't quit beacause of old habits
(evil-ex-define-cmd "q[uit]" (message "quit disabled"))
(evil-ex-define-cmd "wq" (message "quit disabled"))

;; Take vim's window management features
(global-unset-key (kbd "C-w"))
(global-set-key (kbd "C-w C-w") 'evil-window-prev)
(global-set-key (kbd "C-w C-j") 'evil-window-down)
(global-set-key (kbd "C-w C-k") 'evil-window-up)
(global-set-key (kbd "C-w C-h") 'evil-window-left)
(global-set-key (kbd "C-w C-l") 'evil-window-right)
(global-set-key (kbd "C-w w") 'evil-window-prev)
(global-set-key (kbd "C-w j") 'evil-window-down)
(global-set-key (kbd "C-w k") 'evil-window-up)
(global-set-key (kbd "C-w h") 'evil-window-left)
(global-set-key (kbd "C-w l") 'evil-window-right)

;; Don't wait for any other keys after escape is pressed.
(setq evil-esc-delay 0)

;; Make sure escape gets back to normal state and quits things.
(define-key evil-insert-state-map [escape] 'evil-normal-state)
(define-key evil-visual-state-map [escape] 'evil-normal-state)
(define-key evil-emacs-state-map [escape] 'evil-normal-state)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-ns-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-completion-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-must-match-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-isearch-map [escape] 'abort-recursive-edit)

;; Misc mappings
(define-key evil-normal-state-map (kbd ",-") 'calc-dispatch)
(define-key evil-normal-state-map (kbd ",k") 'kill-buffer)

;; More helm mappings
(eval-after-load "helm"
  (progn
    (define-key evil-normal-state-map (kbd ",gf") 'helm-ls-git-ls)
    (define-key evil-normal-state-map (kbd ",o") 'helm-occur)
    (define-key evil-normal-state-map (kbd "gf") 'helm-for-files)
    (define-key evil-normal-state-map (kbd ",r") 'helm-show-kill-ring)
    (define-key evil-normal-state-map (kbd ",,") 'helm-mini)
    (define-key evil-normal-state-map (kbd ",e") 'helm-find-files)))

(eval-after-load "git-gutter-mode"
  (progn
    (define-key evil-normal-state-map (kbd ",ga") 'git-gutter:stage-hunk)
    (define-key evil-normal-state-map (kbd ",gn") 'git-gutter:next-hunk)
    (define-key evil-normal-state-map (kbd ",gp") 'git-gutter:previous-hunk)))

;; Indent region in visual-mode with tab
(define-key evil-visual-state-map (kbd "<tab>") 'indent-region)

(package-safe-install 'evil-nerd-commenter)
(define-key evil-normal-state-map (kbd ",cp") 'evilnc-comment-or-uncomment-paragraphs)
;; Comment or uncomment the current line or marked region
(define-key evil-normal-state-map (kbd ",cc") 'evilnc-comment-or-uncomment-lines)

(package-safe-install 'evil-surround)
(global-evil-surround-mode 1)
(package-safe-install 'evil-numbers)
(package-safe-install 'evil-god-state)

(package-safe-install )


;; believe me, you don't need menubar, toolbar nor scrollbar
(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode horizontal-scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))

;; Some extra packages not found in elpa
(add-to-list 'load-path "~/.emacs.d/lisp/")

(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(defun package-safe-install (&rest packages)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))
    (if (featurep package)
        (require package))))

;; use-package is awesome! https://github.com/jwiegley/use-package
(package-safe-install 'use-package)
(require 'use-package)

(use-package diminish :ensure t)

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
;; newline indents
(define-key global-map (kbd "RET") 'newline-and-indent)

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
(use-package flycheck
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'flycheck-mode))
(use-package flycheck-ledger
  :ensure t)

;; show column number and line number
(dolist (mode '(column-number-mode line-number-mode))
  (when (fboundp mode) (funcall mode t)))

;; Toggle line highlighting in all buffers except org-mode because linum can't
;; handle big files that well
(global-linum-mode t)
(add-hook 'org-mode-hook (lambda () (linum-mode -1)))
;; mu4e windows don't need line numbers as well
(add-hook 'mu4e-view-mode-hook (lambda () (linum-mode -1)))
(add-hook 'mu4e-main-mode-hook (lambda () (linum-mode -1)))
(add-hook 'mu4e-compose-mode-hook (lambda () (linum-mode -1)))
(add-hook 'mu4e-headers-mode-hook (lambda () (linum-mode -1)))
(add-hook 'mu4e-about-mode-hook (lambda () (linum-mode -1)))

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
(if (member "Dejavu Sans Mono" (font-family-list))
    (set-face-attribute
     'default nil :font "Dejavu Sans Mono 9"))

;; I love solarized-dark
(package-safe-install 'color-theme-solarized)
(load-theme 'solarized-dark t)
;; Make underlines more readable on X11
(if (equal window-system 'x) (setq x-underline-at-descent-line t) ())

;; Smart modeline
(use-package smart-mode-line
  :ensure t
  :init
  (progn
    (sml/setup)
    (sml/apply-theme 'automatic)))

;; Relative line numbering
(use-package linum-relative
  :ensure t
  :init
  ;; Show current line instead of 0
  (setq linum-relative-current-symbol ""))

;; Smooth scrolling
(use-package smooth-scrolling
  :ensure t
  :init
  (progn
    (setq smooth-scroll-margin 5)
    (setq scroll-conservatively 9999
          scroll-preserve-screen-position t)))

(use-package fill-column-indicator
  :ensure t
  :init (progn
  (add-hook 'text-mode-hook 'turn-on-fci-mode)
  (add-hook 'prog-mode-hook 'turn-on-fci-mode)))

(defun helm-occur-on-symbol ()
  (interactive)
  (setq isearch-string (evil-find-symbol t))
  (helm-occur-from-isearch))

(use-package evil
  :ensure t
  :init
  (progn
    (setq evil-auto-indent t)
    (setq evil-regexp-search t)
    (setq evil-want-C-i-jump t)
    (evil-mode)
    ;; Don't quit because of old habits
    (evil-ex-define-cmd "q[uit]" (message "quit disabled"))
    (evil-ex-define-cmd "wq" (message "quit disabled"))

    ;; Page up and down with C-j and C-k
    (define-key evil-normal-state-map (kbd "C-k") (lambda ()
                                                    (interactive)
                                                    (evil-scroll-up nil)))
    (define-key evil-normal-state-map (kbd "C-j") (lambda ()
                                                    (interactive)
                                                    (evil-scroll-down nil)))


    ;; Evil doesn't make sense in certain modes
    (add-hook 'text-mode-hook 'turn-on-evil-mode)
    (add-hook 'prog-mode-hook 'turn-on-evil-mode)
    (add-hook 'comint-mode-hook 'turn-on-evil-mode)
    (add-hook 'Info-mode-hook 'turn-off-evil-mode)

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

    ;; Little bit illogical that < means next, but you often want the next error
    ;; so I make it more convenient
    (define-key evil-normal-state-map (kbd ",<") 'next-error)
    (define-key evil-normal-state-map (kbd ",>") 'previous-error)

    ;; More helm mappings
    (define-key evil-normal-state-map (kbd ",gf") 'helm-ls-git-ls)
    (define-key evil-normal-state-map (kbd ",o") 'helm-occur-on-symbol)
    (define-key evil-normal-state-map (kbd "gf") 'helm-for-files)
    (define-key evil-normal-state-map (kbd ",r") 'helm-show-kill-ring)
    (define-key evil-normal-state-map (kbd ",,") 'helm-mini)
    (define-key evil-normal-state-map (kbd ",e") 'helm-find-files)

    ;; Indent region in visual-mode with tab
    (define-key evil-visual-state-map (kbd "<tab>") 'indent-region)))

(use-package evil-nerd-commenter
  :ensure t
  :init
  (progn
    (define-key evil-normal-state-map (kbd ",cp") 'evilnc-comment-or-uncomment-paragraphs)
    ;; Comment or uncomment the current line or marked region
    (define-key evil-normal-state-map (kbd ",cc") 'evilnc-comment-or-uncomment-lines)))

(use-package evil-surround
  :ensure t
  :init
  (progn
    (global-evil-surround-mode 1)))
(use-package evil-numbers :ensure t)
;; a.k.a. satan-mode, I map space for one-off god-mode commands
;; essentially Control-key always pressed
(use-package evil-god-state
  :ensure t
  :init
  (evil-define-key 'normal global-map (kbd "SPC") 'evil-execute-in-god-state))

(use-package evil-matchit
  :ensure t
  :init (global-evil-matchit-mode 1))

(defun company-complete-lambda (arg)
  "Ignores passed in arg like a lambda and runs company-complete"
  (company-complete))

(use-package company-c-headers :ensure t)
(use-package company
  :ensure t
  :init
  (progn
    (setq
     ;; never start auto-completion unless I ask for it
     company-idle-delay nil
     ;; autocomplete right after '.'
     company-minimum-prefix-length 0
     ;; remove echo delay
     company-echo-delay 0
     ;; don't complete in certain modes
     company-global-modes '(not git-commit-mode)
     ;; make sure evil uses the right completion functions
     evil-complete-next-func 'company-complete-lambda
     evil-complete-previous-func 'company-complete-lambda)
    ;; There are faster backends for c/c++ completion
    (delete 'company-semantic company-backends)
    ;; company-c-headers
    (add-to-list 'company-backends 'company-c-headers)
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous)
    (define-key company-active-map (kbd "C-SPC") 'company-complete-selection)
    (add-hook 'after-init-hook 'global-company-mode)))

(use-package helm-config
  :ensure helm
  :init
  (progn
    (require 'helm-config)
    (setq
     helm-input-idle-delay 0.1
     helm-m-occur-idle-delay 0.1)
    (helm-mode t)
    (define-key evil-normal-state-map (kbd "gt") 'helm-semantic-or-imenu)
    (define-key evil-normal-state-map (kbd "gD") 'helm-etags-select)
    (global-set-key (kbd "M-x") 'helm-M-x)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)))

(use-package helm-ls-git :ensure t)

(use-package yasnippet
  :ensure t
  :init
  (progn
    (yas-global-mode 1)
    (global-set-key (kbd "C-x y") 'company-yasnippet)))

;; Package: smartparens
(use-package smartparens
  :ensure t
  :init (progn
          (require 'smartparens-config)
          (show-smartparens-global-mode +1)
          (smartparens-global-mode 1)))

(use-package projectile
    :ensure t
    :init
    (progn
      (projectile-global-mode)
      (setq projectile-enable-caching t)
      (global-set-key (kbd "C-x c h") 'helm-projectile)
      (define-key evil-normal-state-map (kbd ",ps") 'helm-projectile-switch-project)
      (define-key evil-normal-state-map (kbd ",pa") 'projectile-ag)
      (define-key evil-normal-state-map (kbd ",ph") 'helm-projectile)
      (define-key evil-normal-state-map (kbd ",pr") 'projectile-replace)
      (define-key evil-normal-state-map (kbd ",pc") 'projectile-compile-project)
      (define-key evil-normal-state-map (kbd ",po") 'projectile-find-other-file)
      (define-key evil-normal-state-map (kbd ",pt") 'projectile-test-project)))

(use-package helm-projectile :ensure t)

(use-package ag :ensure t)

(use-package org
  :ensure t
  :init
  (progn

    ;; Babel configs
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((emacs-lisp . t)
       (gnuplot . t)
       (java . t)
       (latex . t)
       (ledger . t)
       (python . t)
       (ruby . t)
       (sh . t)
       (ditaa . t)
       (plantuml . t)
       (sql . t)
       (awk . t)
       (sqlite . t)))

    (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

    (setq
     org-plantuml-jar-path "/opt/plantuml/plantuml.jar"
     org-confirm-babel-evaluate nil
     org-edit-src-auto-save-idle-delay 5
     org-edit-src-content-indentation 0)

    ;; Save works in src blocks
    (add-hook 'org-src-mode-hook
              (lambda ()
                (make-local-variable 'evil-ex-commands)
                (setq evil-ex-commands (copy-list evil-ex-commands))
                (evil-ex-define-cmd "w[rite]" 'org-edit-src-save)))
    )

  ;; Syntax colored src blocks
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t))

(require 'org-protocol)
(require 'org-agenda)
(require 'org-habit)

(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; Shortcut to gtd-file
(defun gtd ()
  (interactive)
  (find-file "~/org/gtd.org"))

(defun my-org-archive-all-done (&optional tag)
  "Archive sublevels of the current tree without open TODO items.
      If the cursor is not on a headline, try all level 1 trees.  If
      it is on a headline, try all direct children.
      When TAG is non-nil, don't move trees, but mark them with the ARCHIVE tag."
  (interactive)
  (let ((re org-not-done-heading-regexp) re1
        (rea (concat ".*:" org-archive-tag ":"))
        (begm (make-marker))
        (endm (make-marker))
        beg end (cntarch 0))
    (if (org-at-heading-p)
        (progn
          (setq re1 (concat "^" (regexp-quote
                                 (make-string
                                  (+ (- (match-end 0) (match-beginning 0) 1)
                                     (if org-odd-levels-only 2 1))
                                  ?*))
                            " "))
          (move-marker begm (point))
          (move-marker endm (org-end-of-subtree t)))
      (setq re1 "^* ")
      (move-marker begm (point-min))
      (move-marker endm (point-max)))
    (save-excursion
      (goto-char begm)
      (while (re-search-forward re1 endm t)
        (setq beg (match-beginning 0)
              end (save-excursion (org-end-of-subtree t) (point)))
        (goto-char beg)
        (if (re-search-forward re end t)
            (goto-char end)
          (goto-char beg)
          (if (or (not tag) (not (looking-at rea)))
              (progn
                (if tag
                    (org-toggle-tag org-archive-tag 'on)
                  (org-archive-subtree))
                (setq cntarch (1+ cntarch)))
            (goto-char end)))))
    (message "%d trees archived" cntarch)))

;; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 5)
                                 (org-agenda-files :maxlevel . 5))))

(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
(setq org-mobile-files
      (list "~/org/gtd.org" "~/org/notes.org" "~/org/captures.org" "~/org/journal.org"))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(setq org-agenda-files org-mobile-files)

;; I prefer return to activate a link
(setq org-return-follows-link t)

;; org agenda -- leave in emacs mode but add j & k
(define-key org-agenda-mode-map "j" 'evil-next-line)
(define-key org-agenda-mode-map "k" 'evil-previous-line)
(define-key org-agenda-mode-map "s" 'org-agenda-schedule)
(define-key org-agenda-mode-map "d" 'org-agenda-deadline)

(setq org-default-notes-file (concat org-directory "/captures.org"))

(define-key evil-normal-state-map (kbd ",ag") 'org-agenda)
(define-key evil-normal-state-map (kbd ",cj") 'org-clock-goto)
(define-key evil-normal-state-map (kbd ",mi") 'org-mobile-pull)
(define-key evil-normal-state-map (kbd ",me") 'org-mobile-push)

(setq org-agenda-custom-commands
      '(("r" "Relex agenda"
         ;; agenda for today
         ((agenda "" ((org-agenda-ndays 1)))
          ;; scheduled todos
          (tags-todo "CATEGORY=\"Relex\""
                     ((org-agenda-skip-function '(org-agenda-skip-subtree-if
                                                  'deadline 'scheduled)))
                     (org-agenda-overriding-header "Unscheduled Relex TODOs"))))))

(setq org-capture-templates
      (quote
       (("w"
         "Default template"
         entry
         (file+headline "~/org/captures.org" "Notes")
         "* %c\n%u\n %i"
         :empty-lines 1)
        ("l" "ticket todo" entry (file+olp "~/org/gtd.org" "RELEX" "Misc tasks")
         "* TODO %c\n%U\n%i" :clock-in t :clock-resume t)
        ("m" "Mail" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO %?\n%i\n%a")
        ("r" "RELEX")
        ("rs" "Sokos" entry (file+olp "~/org/gtd.org" "RELEX" "Sokos")
         "* TODO %?\n%U" :clock-in t :clock-resume t)
        ("rm" "Misc tasks" entry (file+olp "~/org/gtd.org" "RELEX" "Misc tasks")
         "* TODO %?\n%U" :clock-in t :clock-resume t)
        ("rM" "Mail" entry (file+olp "~/org/gtd.org" "RELEX" "Mail")
         "* TODO %?\n%U\n%a" :clock-in t :clock-resume t)
        ("rK" "KiiltoClean" entry (file+olp "~/org/gtd.org" "RELEX" "KiiltoClean")
         "* TODO %?\n%U" :clock-in t :clock-resume t)
        ("rk" "Karl Hedin" entry (file+olp "~/org/gtd.org" "RELEX" "Karl Hedin")
         "* TODO %?\n%U" :clock-in t :clock-resume t)
        ("ra" "Atria or AKB")
        ("rat" "Atria" entry (file+olp "~/org/gtd.org" "RELEX" "Atria")
         "* TODO %?\n%U" :clock-in t :clock-resume t)
        ("rak" "Akademibokhandeln" entry (file+olp "~/org/gtd.org" "RELEX" "Akademibokhandeln")
         "* TODO %?\n%U" :clock-in t :clock-resume t)
        ("rv" "Victoria" entry (file+olp "~/org/gtd.org" "RELEX" "Victoria")
         "* TODO %?\n%U" :clock-in t :clock-resume t)
        ("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO %?\n%i")
        ("x" "X Clipboard" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO %?\n%i%x")
        ("c" "Capture" entry (file "~/org/captures.org")
         "* %?\nEntered on %U\n%i")
        ("h" "Habit" entry (file+headline "~/org/gtd.org" "Habits")
         "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n"))))

;; position the habit graph on the agenda to the right of the default
(setq org-habit-graph-column 50)
(run-at-time "06:00" 86400 '(lambda () (setq org-habit-show-habits t)))

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "MAYBE(m)" "|" "DONE(d)"))))

;; Keep tasks with timestamps on the global todo lists
(setq org-agenda-todo-ignore-timestamp nil)

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done t)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done t)

;; Automatic mobileorg syncing
(defvar org-mobile-sync-timer nil)
(defvar org-mobile-sync-idle-secs (* 60 10))
(defun org-mobile-sync ()
  (interactive)
  (org-mobile-pull)
  (org-mobile-push))

(defun org-mobile-sync-enable ()
  "enable mobile org idle sync"
  (interactive)
  (setq org-mobile-sync-timer
        (run-with-idle-timer org-mobile-sync-idle-secs t
                             'org-mobile-sync)));

(defun org-mobile-sync-disable ()
  "disable mobile org idle sync"
  (interactive)
  (cancel-timer org-mobile-sync-timer))
(org-mobile-sync-enable)

(run-at-time "00:59" 3600 'org-save-all-org-buffers)

(define-minor-mode evil-org-mode
  "Buffer local minor mode for evil-org"
  :init-value nil
  :lighter " EvilOrg"
  :keymap (make-sparse-keymap) ; defines evil-org-mode-map
  :group 'evil-org)

(add-hook 'org-mode-hook 'evil-org-mode) ;; only load with org-mode

(define-key evil-normal-state-map (kbd ",sl") 'org-store-link)
(define-key evil-normal-state-map (kbd ",ca") 'org-capture)
(define-key evil-normal-state-map (kbd ",gt") 'gtd)
(define-key evil-normal-state-map (kbd ",at") 'org-attach)
(define-key evil-normal-state-map (kbd ",ba") 'previous-buffer)

;; regular normal state shortcuts.
(evil-define-key 'normal evil-org-mode-map
  "gh" 'outline-up-heading
  "gj" 'org-forward-heading-same-level
  "gk" 'org-backward-heading-same-level
  "gl" 'outline-next-visible-heading
  "H" 'org-beginning-of-line
  "L" 'org-end-of-line
  "t" 'org-todo
  "$" 'org-end-of-line
  "^" 'org-beginning-of-line
  "-" 'org-ctrl-c-minus
  "<" 'org-metaleft
  ">" 'org-metaright
  ",r" 'org-refile
  ",t" 'org-show-todo-tree
  ",." 'org-ctrl-c-ctrl-c
  ",*" 'org-toggle-heading
  (kbd ",ar") 'org-archive-subtree
  (kbd ",na") 'org-narrow-to-element
  (kbd ",nw") 'widen
  (kbd ",s") 'org-schedule
  (kbd ",d") 'org-deadline
  (kbd ",/") 'org-sparse-tree
  (kbd "RET") 'org-return
  (kbd ",cs") 'org-screenshot
  (kbd ",ci") 'org-clock-in
  (kbd ",co") 'org-clock-out
  (kbd ",cc") 'org-edit-special
  )

;; normal & insert state shortcuts.
(mapcar (lambda (state)
          (evil-define-key state evil-org-mode-map
        (kbd "TAB") 'org-cycle
            (kbd "C-<return>") 'org-insert-heading
            (kbd "C-<") 'org-metaleft
            (kbd "C->") 'org-metaright
            (kbd "C-S-<return>") 'org-insert-todo-heading)) '(normal insert))

;; For some reason this binding was broken in org-mode in terminal
;;(evil-define-key 'insert evil-org-mode-map
            ;;(kbd "ESC") 'evil-normal-state)

(define-minor-mode evil-org-capture-mode
  "Buffer local minor mode for evil-org-capture"
  :init-value nil
  :lighter " EvilOrgCapture"
  :keymap (make-sparse-keymap) ; defines evil-org-mode-map
  :group 'evil-org)

(add-hook 'org-capture-mode-hook 'evil-org-capture-mode) ;; only load with org-capture-mode

;; regular normal state shortcuts.
(evil-define-key 'normal evil-org-capture-mode-map
  (kbd ",cf") 'org-capture-finalize
  (kbd ",ck") 'org-capture-kill
  (kbd ",cr") 'org-capture-refile)

(setq org-edit-src-auto-save-idle-delay 1)

(define-minor-mode evil-org-src-mode
  "Buffer local minor mode for evil-org-src"
  :init-value nil
  :lighter " EvilOrgSrc"
  :keymap (make-sparse-keymap) ; defines evil-org-mode-map
  :group 'evil-org)

(add-hook 'org-src-mode-hook 'evil-org-src-mode) ;; only load with org-capture-mode

;; regular normal state shortcuts.
(evil-define-key 'normal evil-org-src-mode-map
  (kbd ",cf") 'org-edit-src-exit
  (kbd ",ck") 'org-edit-src-abort)

(eval-after-load 'diminish '(progn
                              (diminish 'evil-org-mode)
                              (diminish 'evil-org-capture-mode)
                              (diminish 'evil-org-src-mode)))

(use-package org-octopress
  :ensure t
  :init
  (progn
    (setq org-octopress-directory-top "~/git/octopress/source")
    org-octopress-directory-posts     "~/git/octopress/source/_posts"
    org-octopress-directory-org-top   "~/git/octopress/source"
    org-octopress-directory-org-posts "~/git/octopress/source/blog"
    org-octopress-setup-file          "~/org/setupfile.org"))

(defun org-screenshot ()
    "Take a screenshot into a time stamped unique-named file in the same directory as the org-buffer and insert a link to this file. Also copy filename to clipboard"
    (interactive)
    (setq filename (concat (make-temp-name (concat "/home/martin/org/screenshots/" (format-time-string "%Y%m%d_%H%M%S_")) ) ".jpg"))
    (call-process "import" nil nil nil filename)
    (insert (concat "[[" filename "]]"))
    (with-temp-buffer
      (insert filename)
      (clipboard-kill-region (point-min) (point-max)))
    (org-redisplay-inline-images))

(defun deploy-customer-config(server instance)
  "Deploy customer-config to server"
  (interactive (list (read-string "Deploy to server: ") (read-string "Instance name: ")))
  (let (
        (old-or-new-current (if (equal (car (split-string server "_")) "old")
                                "/processor_ui/current/" "/current/WEB-INF/"))
        (apps-or-capistrano (if (equal (car (split-string server "_")) "old")
                                "capistrano" "apps")))
    (let ((remotepath (concat "/ssh:" (car (split-string server "old_" t))
                              ":/opt/" apps-or-capistrano "/" instance
                              old-or-new-current "customer/"
                              (file-name-nondirectory(buffer-file-name)))))
      (message "remotepath: %s" remotepath)

      (let ((remotecopypath (concat remotepath ".cp." (format-time-string "%s")))
            (currentfile (buffer-file-name)))
        (message "remotecopypath: %s" remotecopypath)
        (find-file remotepath)
        (save-restriction
          (widen)
          (write-region (point-min) (point-max) remotecopypath nil nil nil 'confirm))
        (diff-no-select (current-buffer) currentfile)
        (kill-buffer (buffer-name))
        (find-file currentfile)
        (save-restriction
          (widen)
          (write-region (point-min) (point-max) remotepath nil nil nil 'confirm))

        (find-file currentfile)
        (display-buffer "*Diff*")))))

(define-minor-mode evil-ruby-mode
  "Evil ruby bindings"
  :keymap (make-sparse-keymap)
  (evil-normalize-keymaps))

(evil-define-key 'normal evil-ruby-mode-map (kbd ",d")
  'deploy-customer-config)
(add-hook 'ruby-mode-hook 'evil-ruby-mode)

(defun gtags-or-evil-goto-definition ()
  (interactive)
  (if (locate-dominating-file default-directory "GTAGS")
      (helm-gtags-dwim)
    (evil-goto-definition)))

(use-package helm-gtags
  :ensure t
  :init
  (progn
    ;; this variables must be set before load helm-gtags
    ;; you can change to any prefix key of your choice
    (setq helm-gtags-prefix-key "\C-cg")
    (setq
     helm-gtags-ignore-case t
     helm-gtags-auto-update t
     helm-gtags-use-input-at-cursor t
     helm-gtags-pulse-at-cursor t

     helm-gtags-suggested-key-mapping t
     )

    ;; Enable helm-gtags-mode in Dired so you can jump to any tag
    ;; when navigate project tree with Dired
    (add-hook 'dired-mode-hook 'helm-gtags-mode)

    ;; Enable helm-gtags-mode in Eshell for the same reason as above
    (add-hook 'eshell-mode-hook 'helm-gtags-mode)

    ;; Enable helm-gtags-mode in languages that GNU Global supports
    (add-hook 'c-mode-hook 'helm-gtags-mode)
    (add-hook 'c++-mode-hook 'helm-gtags-mode)
    (add-hook 'java-mode-hook 'helm-gtags-mode)
    (add-hook 'asm-mode-hook 'helm-gtags-mode)

    ;; key bindings
    (define-key evil-normal-state-map (kbd "gs") 'helm-gtags-select)
    (define-key evil-normal-state-map (kbd "gd") 'gtags-or-evil-goto-definition)
    (define-key evil-normal-state-map (kbd "gp") 'helm-gtags-pop-stack)
    (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
    (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)))

(require 'cc-mode)

(use-package function-args
  :ensure t
  :init
  (progn
    (require 'function-args)
    (fa-config-default)
    (define-key c-mode-map  [(tab)] 'moo-complete)
    (define-key c++-mode-map  [(tab)] 'moo-complete)))

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)

(use-package clean-aindent-mode
  :ensure t
  :init (progn
          (add-hook 'prog-mode-hook 'clean-aindent-mode)))

(use-package dtrt-indent
  :ensure t
  :init (progn
          (dtrt-indent-mode 1)))

(use-package ws-butler
  :ensure t
  :init (progn
          (remove-hook 'prog-mode-hook 'ws-butler-mode)))

(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(use-package irony
  :ensure irony
  :init (progn
          (add-hook 'c++-mode-hook 'irony-mode)
          (add-hook 'c-mode-hook 'irony-mode)
          (add-hook 'objc-mode-hook 'irony-mode)

          ;; replace the `completion-at-point' and `complete-symbol' bindings in
          ;; irony-mode's buffers by irony-mode's function
          (add-hook 'irony-mode-hook 'my-irony-mode-hook)))

(use-package company-irony
 :ensure t
 :init (progn
         (add-to-list 'company-backends 'company-irony)
         (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)))

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t)

;; Setup CEDET
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-stickyfunc-mode 1)

(semantic-mode 1)

(server-mode t)

(defun on-edit-server-done-do-backup ()
  (interactive)
  "Run when text is sent to Google Chrome. Do a backup of the
    stuff sent there in case something goes wrong, e.g. Chrome
    crashes."
  (let* ((backup-dir "~/._emacs_chrome-backup")
         (backup-file (format "%s.txt" (float-time)))
         (backup-path (concat backup-dir "/" backup-file)))
    (unless (file-directory-p backup-dir)
      (make-directory backup-dir))
    (write-region (point-min) (point-max) backup-path)))

(use-package edit-server
  :ensure t
  :init
  (progn
    (setq edit-server-new-frame nil)
      (require 'edit-server)
      (setq edit-server-new-frame nil)
      (add-hook 'edit-server-done-hook 'on-edit-server-done-do-backup)
      ;; Save works in edit-server buffers
      (add-hook 'edit-server-edit-mode-hook
                (lambda ()
                  (make-local-variable 'evil-ex-commands)
                  (setq evil-ex-commands (copy-list evil-ex-commands))
                  (evil-ex-define-cmd "w[rite]" 'on-edit-server-done-do-backup)))
      (edit-server-start)))

(use-package rainbow-delimiters
  :ensure t
  :init
  (global-rainbow-delimiters-mode))

(use-package ledger-mode
  :ensure t
  :init
  (add-hook 'ledger-mode-hook
            (lambda ()
              (local-set-key (kbd "TAB") 'ledger-magic-tab))))

(add-hook 'ediff-prepare-buffer-hook 'f-ediff-prepare-buffer-hook-setup)
(defun f-ediff-prepare-buffer-hook-setup ()
  ;; specific modes
  (cond ((eq major-mode 'org-mode)
         (f-org-vis-mod-maximum))
        ;; room for more modes
        )
  ;; all modes
  (setq truncate-lines nil))
(defun f-org-vis-mod-maximum ()
  "Visibility: Show the most possible."
  (cond
   ((eq major-mode 'org-mode)
    (visible-mode 1)  ; default 0
    (setq truncate-lines nil)  ; no `org-startup-truncated' in hook
    (setq org-hide-leading-stars t))  ; default nil
   (t
    (message "ERR: not in Org mode")
    (ding))))

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

;; full screen magit-status

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(use-package magit
  :ensure t
  :init
  (progn
    (define-key evil-normal-state-map (kbd ",gh") 'magit-file-log) ; Commit history for current file
    (define-key evil-normal-state-map (kbd ",gb") 'magit-blame-mode) ; Blame for current file
    (define-key evil-normal-state-map (kbd ",gs") 'magit-status)
    (add-hook 'git-rebase-mode-hook
              (lambda ()
                (evil-local-mode -1)))

    (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

    (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)))

(use-package discover
  :ensure t
  :init (global-discover-mode 1))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")
(require 'mu4e)
(require 'smtpmail)
;; use the offlineimap command to sync
(setq mu4e-get-mail-command "true")
;; tell message-mode how to send mail
(setq message-send-mail-function 'smtpmail-send-it)
;; org-link support
(require 'org-mu4e)

;; enable inline images
(setq mu4e-view-show-images t)
;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
   (imagemagick-register-types))

;; Convert html-messages. This needs python2-html2text on arch linux
(setq mu4e-html2text-command "html2text_py -b 79")

;; Use unicode characters in some views
(setq mu4e-use-fancy-chars t)

;; Set mu4e to the default mail client
(setq mail-user-agent 'mu4e-user-agent)

;; Don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; Don't save message to Sent Messages, DavMail/Gmail takes care of this
(setq mu4e-sent-messages-behavior 'delete)

(defvar my-mu4e-account-alist
  '(("Gmail"
     (mu4e-sent-folder "/Gmail/[Gmail].Sent Mail")
     (mu4e-drafts-folder "/Gmail/[Gmail].Drafts")
     (mu4e-trash-folder "/Gmail/[Gmail].Trash")
     (user-mail-address "martin.yrjola@gmail.com")
     (user-full-name "Martin Yrjölä")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (mu4e-compose-signature (string-join '("Martin Yrjölä"
                                            "martin.yrjola@gmail.com"
                                            "+358 44 040 7895")
                                          "\n"))
     (smtpmail-stream-type starttls)
     (smtpmail-smtp-service 25))
    ("Aalto"
     (mu4e-sent-folder "/Gmail/[Gmail].Sent Mail")
     (mu4e-drafts-folder "/Gmail/[Gmail].Drafts")
     (mu4e-trash-folder "/Gmail/[Gmail].Trash")
     (user-mail-address "martin.yrjola@aalto.fi")
     (user-full-name "Martin Yrjölä")
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (mu4e-compose-signature (string-join '("Martin Yrjölä"
                                            "martin.yrjola@aalto.fi"
                                            "+358 44 040 7895")
                                          "\n"))
     (smtpmail-stream-type starttls)
     (smtpmail-smtp-user "martin.yrjola@gmail.com")
     (smtpmail-mail-address "martin.yrjola@aalto.fi")
     (smtpmail-smtp-service 25))
    ("Relex"
     (mu4e-sent-folder "/Relex/Sent")
     (mu4e-drafts-folder "/Relex/Drafts")
     (mu4e-trash-folder "/Relex/Deleted Items")
     (user-mail-address "martin.yrjola@relex.fi")
     (user-full-name "Martin Yrjölä")
     (smtpmail-default-smtp-server "localhost")
     (smtpmail-smtp-server "localhost")
     (mu4e-compose-signature (string-join '("Martin Yrjölä"
                                            "RELEX"
                                            "Solutions Specialist"
                                            "+358 44 040 7895")
                                          "\n"))
     (smtpmail-stream-type nil)
     (smtpmail-smtp-service 1025))))

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
          (if mu4e-compose-parent-message
              (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                (string-match "/\\(.*?\\)/" maildir)
                (match-string 1 maildir))
            (completing-read (format "Compose with account: (%s) "
                                     (mapconcat #'(lambda (var) (car var))
                                                my-mu4e-account-alist "/"))
                             (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                             nil t nil nil (caar my-mu4e-account-alist))))
         (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

(add-to-list 'mu4e-bookmarks '("flag:attach"    "Messages with attachment"   ?a) t)
(add-to-list 'mu4e-bookmarks '("size:5M..500M"  "Big messages"               ?b) t)
(add-to-list 'mu4e-bookmarks '("flag:flagged"   "Flagged messages"           ?f) t)

(setq mu4e-maildir-shortcuts
    '(("/Gmail/INBOX"             . ?i)
      ("/Relex/INBOX"             . ?r)
      ("/Relex/Sent"              . ?s)
      ("/Gmail/[Gmail].Sent Mail" . ?S)
      ("/Gmail/!plasma"           . ?p)
      ("/Gmail/?mailing_lists"    . ?l)
      ("/Gmail/[Gmail].Trash"     . ?t)))

;; define 'b' as the shortcut
(add-to-list 'mu4e-view-actions
   '("bView in browser" . mu4e-action-view-in-browser) t)

(require 'helm-mu)

(defun helm-mu-contacts-insert-action (candidate)
  "Insert email in current buffer."
  (let* ((cand (split-string candidate "\t"))
         (name (cadr cand))
         (address (car cand)))
    (with-helm-current-buffer
      (insert address))))

(helm-add-action-to-source
 "Insert email to current buffer"
 'helm-mu-contacts-insert-action
 helm-source-mu-contacts)

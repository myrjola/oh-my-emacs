(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b8714d3e17ae1b52e42ceb8ddeb41f49cd635cb38efc48ee05bf070c10a3268f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(evilnc-hotkey-comment-operator ",cc")
 '(magit-save-some-buffers (quote dontask))
 '(magit-use-overlays nil)
 '(org-attach-method (quote lns))
 '(org-file-apps
   (quote
    ((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . "okular %s"))))
 '(rbenv-show-active-ruby-in-modeline nil)
 '(safe-local-variable-values
   (quote
    ((eval ignore-errors "Write-contents-functions is a buffer-local alternative to before-save-hook"
           (add-hook
            (quote write-contents-functions)
            (lambda nil
              (delete-trailing-whitespace)
              nil))
           (require
            (quote whitespace))
           "Sometimes the mode needs to be toggled off and on."
           (whitespace-mode 0)
           (whitespace-mode 1))
     (whitespace-line-column . 80)
     (whitespace-style face tabs trailing lines-tail)
     (require-final-newline . t)
     (pony-settings make-pony-project :python "/home/martin/git/neverlate/neverlate_ve/bin/python")
     (pony-settings make-pony-project :python "/home/martin/git/neverlate/neverlate_ve/bin/python" :pythonpath "/home/martin/git/neverlate/django" :settings "neverlate.settings")
     (pony-settings make-pony-project :python "/home/martin/git/neverlate/neverlate_ve/bin/python" :pythonpath "/home/david/megacorp/libs/projectzero" :settings "neverlate.settings")
     (python-shell-interpreter . "python2")
     (python-shell-interpreter-args . "/home/martin/git/djangotutorial/manage.py shell")
     (python-shell-completion-string-code . "';'.join(get_ipython().Completer.all_completions('''%s'''))
")
     (python-shell-completion-module-string-code . "';'.join(module_completion('''%s'''))
")
     (python-shell-completion-setup-code . "from IPython.core.completerlib import module_completion")
     (python-shell-interpreter-args . "/home/martin/git/neverlate/django/manage.py shell")
     (python-shell-interpreter . "python")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

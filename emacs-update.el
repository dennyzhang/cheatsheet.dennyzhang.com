;; https://github.com/DennyZhang/challenges-leetcode-interesting/blob/master/automate.sh
;; Invoke elisp from command line: /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_9 --batch -l ../update_md.el
;;
;; (add-to-list 'load-path "/Applications/Emacs.app/Contents/Resources/lisp/emacs-lisp")
;; (add-to-list 'load-path "/Applications/Emacs.app/Contents/Resources/lisp/org")

;; (defconst CONF-EMACS-VENDOR "~/Dropbox/private_data/emacs_vendor/")
;; (defconst CONF-EMACS-DATA "~/Dropbox/private_data/emacs_data")
;; (defconst CONF-SHARE-DIR "~/Dropbox/")
;; (defconst CONF-DENNY-EMACS "~/Dropbox/Denny-s-emacs-configuration/")
;; (defconst CONF-GITHUB-DIR "~/git_code/github")
;; (package-initialize)
;; (load-file (concat CONF-DENNY-EMACS "/packages.el"))
;; (load-file (concat CONF-DENNY-EMACS "/org-setting.el"))
;; (load-file (concat CONF-DENNY-EMACS "/org-publish/org-publish-to-wordpress.el"))

(load-file "~/Dropbox/Denny-s-emacs-configuration/myemacs.el")

(progn
   (find-file "README.org")
   (brain-update-wordpress-current-entry)
   (kill-buffer)
   (dolist (f (file-expand-wildcards "*.html~"))
     (if (file-exists-p f)
         (delete-file f)))
   (message "Finished")
   ;; (quit-process)
  )

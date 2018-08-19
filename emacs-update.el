;; Invoke elisp from command line: /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_9 --batch -l ../update_md.el

(load-file "~/Dropbox/Denny-s-emacs-configuration/myemacs.el")

(progn
   (find-file "README.org")
   (cheatsheet-update-wordpress-current-entry)
   (kill-buffer)
   (dolist (f (file-expand-wildcards "*.html~"))
     (if (file-exists-p f)
         (delete-file f)))
   (message "Finished")
   ;; (quit-process)
  )

;; Invoke elisp from command line: /Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_9 --batch -l ../update_md.el

(load-file "~/Dropbox/Denny-s-emacs-configuration/myemacs.el")
(setenv "PATH" "/usr/local/google-cloud-sdk/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin/:/usr/local/texlive/2013/bin/universal-darwin/:/opt/local/bin:/usr/local/opt/go/libexec/bin:/usr/local/Cellar/go/1.10.3/bin:/usr/local/opt/go/libexec/bin://usr/local/Cellar/go/1.10.3/libexec/bin:/Library/TeX/texbin")
(load-file "~/Dropbox/Denny-s-emacs-configuration/org-publish/wordpress-cheatsheet-post.el")

(progn
   (find-file "README.org")
   (my-org-latex-export-to-pdf)
   (kill-buffer)
  )

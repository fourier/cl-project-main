#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
          (load quicklisp-init)))

;; add Sources/ directory to quicklisp local directories

(push (merge-pathnames "Sources/lisp"
                       (user-homedir-pathname))
      ql:*local-project-directories*)
(ql:register-local-projects)

;;(ql:quickload :swank)
(load (merge-pathnames "Sources/lisp/lw-project/lw-project.lisp"
                       (user-homedir-pathname)))

(save-lisp-and-die "cl-project" :executable t :toplevel 'cl-project-main:create-project)

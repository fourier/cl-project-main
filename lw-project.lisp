;;; lw-project.lisp
;; A simple LispWorks GUI/wrapper for cl-project project skeleton generation tool
;; 
;; If running on SBCL, provides an interface for command-line project skeleton generation tool
;; 
(ql:quickload :cl-project)

(defpackage #-lispworks #:cl-project-main #+lispworks #:lw-project
  (:documentation "Simple browser of all symbols in package")
  (:use #:cl #+lispworks #:capi)
  (:export create-project)
  #+lispworks (:add-use-defaults t))

(in-package #-lispworks #:cl-project-main #+lispworks #:lw-project)


;;----------------------------------------------------------------------------
;; The project GUI interface
;;----------------------------------------------------------------------------


#+lispworks (capi:define-interface lw-project (lispworks-tools::lispworks-interface)
  ()
  (:panes
   (path-edit text-input-choice :callback 'on-create-button
                         :title "Project path"
                         :buttons 
                         '(:browse-file (:directory t :image :std-file-open) :ok nil))
   (name-edit text-input-choice :title "Name"
              :visible-max-width nil
              :visible-max-height '(:character 1)
              :callback 'on-create-button)
   (description-edit text-input-choice :title "Description"
                     :visible-max-width nil
                     :visible-max-height '(:character 1)
                     :callback 'on-create-button)
   (author-edit text-input-choice :title "Author"
                :text "Alexey Veretennikov"
              :visible-max-width nil
              :visible-max-height '(:character 1)
              :callback 'on-create-button)
   (email-edit text-input-choice :title "Email"
              :text "alexey.veretennikov@gmail.com"
              :visible-max-width nil
              :visible-max-height '(:character 1)
              :callback 'on-create-button)
   (license-edit text-input-choice :title "License"
                 :text "MIT"
              :visible-max-width nil
              :visible-max-height '(:character 1)
              :callback 'on-create-button)
   (create-button push-button :text "Create" :callback 'on-create-button))

  
  (:layouts
   (main-layout column-layout '(path-edit
                                name-edit
                                description-edit
                                author-edit
                                email-edit
                                license-edit
                                create-button)
                :gap 15
                :adjust :center))

  (:default-initargs
   :layout 'main-layout
   :title "Create Project"
   :best-height 600
   ))

#+lispworks (defun on-create-button (data self)
  (declare (ignore data))
  (with-slots (path-edit
               name-edit
               description-edit
               author-edit
               email-edit
               license-edit) self
    (let (args
          (path (text-input-pane-text path-edit))
          (name (text-input-pane-text name-edit))
          (description (text-input-pane-text description-edit))
          (author (text-input-pane-text author-edit))
          (email (text-input-pane-text email-edit))
          (license (text-input-pane-text license-edit)))
      (when (create-project-impl
             path name author email license)
        (capi:display-message "Created"))
      (capi:destroy self))))

(defun create-project-impl (path name &optional
                                        description
                                        author
                                        email
                                        license)
  (let (args)
    (when (> (length path) 0)
      (when (> (length name) 0)
        (push :name args)
        (push name args))
      (when (> (length description) 0)
        (push :description args)
        (push description args))          
      (when (> (length author) 0)
        (push :author args)
        (push author args))          
      (when (> (length email) 0)
        (push :email args)
        (push email args))          
      (when (> (length license) 0)
        (push :license args)
        (push license args))
      (apply #'cl-project:make-project (pathname path) args))))
  
(defun command-line ()
  (or 
   #+SBCL sb-ext:*posix-argv*  
   #+LISPWORKS system:*line-arguments-list*
   #+CMU extensions:*command-line-words*
   nil))

(defun usage (appname)
  (format *standard-output* (concatenate 'string  "Usage: " appname " path-to-project project-name~%"))
  (format *standard-output* "where path-to-project the full directory path to the new project directory(including the project directory itself)~%")
  (format *standard-output* "and project name - the project name~%")
  #+SBCL (sb-ext:exit)
  #+LISPWORKS (lispworks:quit)
  )

;;; Entry point

(defun create-project ()
  (let ((cl-project.specials:*skeleton-directory*
          (merge-pathnames "Sources/lisp/skeleton/"
                           (user-homedir-pathname))))
    #+lispworks (capi:display  (make-instance 'lw-project))
    #-lispworks
    (let ((cmdargs (command-line)))
      (if (/= (length cmdargs) 2)
          (usage (car cmdargs))
          (let ((name (second cmdargs)))
            (create-project-impl
             (namestring (merge-pathnames (concatenate 'string "Sources/lisp/" name)
                                          (user-homedir-pathname)))
             name))))))

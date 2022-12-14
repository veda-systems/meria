;;;; config.lisp

(uiop:define-package #:pierre/config
  (:use #:cl
        #:marie))

(in-package #:pierre/config)

(defvar *default-config*
  '((:listen-address "127.0.0.1"))
  "The default configuration.")

(def sys-object (name)
  "Return the system object for the current system."
  (asdf:find-system name))

(def sys-path (system)
  "Return the ASDF file path for the current system."
  (uiop:merge-pathnames* (cat system ".asd")
                         (asdf:system-source-directory (sys-object system))))

(def read-sys-path (system)
  "Return the system ASDF file as s-expressions."
  (uiop:read-file-forms (sys-path system)))

(def sys-version (name)
  "Return the version number extracted from the system resources."
  (asdf:system-version (sys-object name)))

(def config-directory (name)
  "Return the path to the default configuration and storage directory."
  (let ((base (uiop:merge-pathnames* (make-pathname :directory '(:relative ".config"))
                                     (user-homedir-pathname))))
    (flet ((fn (name base)
               (uiop:merge-pathnames* (make-pathname :directory `(:relative ,name))
                                      base)))
      (uiop:os-cond
       ((uiop:os-unix-p) (fn name base))
       (t (error "Oops, this function does not work on your system."))))))

(def config-file (name)
  "Return the location of the config file of NAME on the disk"
  (uiop:merge-pathnames* "config.lisp" (config-directory name)))

(def config-file-exists-p (name)
  "Return true if the config file exists."
  (when (uiop:file-exists-p (config-file name))
    t))

(def read-config-file (name)
  "Read the configuration file."
  (uiop:with-safe-io-syntax ()
    (uiop:read-file-forms (config-file name))))

(def read-config (name)
  "Return the most proximate configuration."
  (if (config-file-exists-p name)
      (read-config-file name)
      *default-config*))

(def config-value (name index)
  "Return the value associated with an index."
  (let ((config (read-config name)))
    (car (assoc-value index config))))

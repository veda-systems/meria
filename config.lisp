;;;; config.lisp

(uiop:define-package #:pierre/config
  (:use #:cl
        #:marie))

(in-package #:pierre/config)

(defvar *default-config*
  '((listen-address "127.0.0.1"))
  "The default configuration.")

(def system-object (name)
  "Return the system object for the current system."
  (asdf:find-system name))

(def asdf-path (system)
  "Return the ASDF file path for the current system."
  (uiop:merge-pathnames* (cat system ".asd")
                         (asdf:system-source-directory (system-object system))))

(def read-asdf-path (system)
  "Return the system ASDF file as s-expressions."
  (uiop:read-file-forms (asdf-path system)))

(def system-version (name)
  "Return the version number extracted from the system resources."
  (let* ((system (system-object name))
         (asdf-base-name (cat name ".asd"))
         (source-directory (asdf:system-source-directory system))
         (forms (read-asdf-path system)))
    (getf (assoc 'defsystem forms :test #'equal) :version)))

(def config-directory (name)
  "Return the path to the default configuration and storage directory."
  (~ (cat #\. name #\/)))

(def config-file (name)
  "Return the location of the config file of NAME on the disk"
  (uiop:merge-pathnames* "config.lisp" (config-directory name)))

(def config-file-exists-p (name)
  "Return true if the config file exists."
  (when (uiop:file-exists-p (config-file name))
    t))

(def read-config-file (name)
  "Read the configuration file."
  (uiop:read-file-forms (config-file name)))

(def read-config (name)
  "Return the most proximate configuration."
  (if (config-file-exists-p name)
      (read-config-file name)
      *default-config*))

(def config-value (name index)
  "Return the value associated with an index."
  (let ((config (read-config name)))
    (car (assoc-value index config))))

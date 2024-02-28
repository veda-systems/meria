;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; config.lisp: configuration management

(uiop:define-package #:pierre/src/config
  (:use #:cl
        #:marie))

(in-package #:pierre/src/config)


;;; systems

(def system-object^sys-object (name)
  "Return the system object for the current system."
  (asdf:find-system name))

(def system-path^sys-path (system)
  "Return the ASDF file path for the current system."
  (let ((object (system-object system)))
    (uiop:merge-pathnames* (cat system ".asd")
                           (asdf:system-source-directory object))))

(def system-directory^sys-directory (system)
  "Return the top-level directory of a system."
  (let ((path (sys-path system)))
    nil))

(def read-system-path^read-sys-path (system)
  "Return the system ASDF file as s-expressions."
  (uiop:read-file-forms (sys-path system)))

(def system-version^sys-version (name)
  "Return the version number extracted from the system resources."
  (asdf:system-version (sys-object name)))

(def driver-path (system &optional (name "driver"))
  "Return the driver file of SYSTEM."
  (let* ((directory (asdf:system-source-directory system))
         (driver (make-pathname :directory '(:relative "src") :name name)))
    (uiop:merge-pathnames* driver directory)))

(def reload-driver^rl (system)
  "Reload the driver file of SYSTEM."
  (let* ((path (driver-path system)))
    (load path)))

(defm @ (system)
  "Reload SYSTEM using symbol name."
  `(let* ((base (prin1-to-string ',system))
          (string (string-downcase base))
          (*standard-output* (make-broadcast-stream)))
     (mute
       (reload-driver string)
       (values))))


;;; config files

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

(defv- *default-config*
  '((:listen-address "127.0.0.1"))
  "The default configuration.")

(def read-config (name)
  "Return the most proximate configuration."
  (if (config-file-exists-p name)
      (read-config-file name)
      *default-config*))

(def config-value (name index)
  "Return the value associated with an index."
  (let ((config (read-config name)))
    (car (assoc-value index config))))

;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; utilities.lisp --- useful utilities using the operating system

(uiop:define-package #:meria/src/utilities
  (:use #:cl
           #:marie
           #:meria/src/common))

(in-package #:meria/src/utilities)

(def notify (title &optional subtitle message)
  "Display a system notification."
  (uiop:launch-program
   #+macosx
   (fmt "terminal-notifier -sound default -title '~A' -subtitle '~A' -message '~A' -activate org.gnu.Emacs" title subtitle message)
   #+linux
   (fmt "notify-send -i gtk-dialog-info '~A'" title)))

(defm time-notify^@ (&rest args)
  "Time the evaluation of ARGS then display a notification after it has finished
the evaluation."
  `(let ((result (time ,@args)))
     (notify (lisp-implementation-type) (fmt "~&") result)
     result))

(def slots (object)
  "Return the slot names of OBJECT."
  (mapcar #'closer-mop:slot-definition-name
          (closer-mop:class-slots (class-of object))))

;;; File processors

(def get-base-dir (system-name)
  "Get the base source directory for the given system."
  (let* ((source-directory (asdf:system-source-directory
                            (asdf:find-system system-name)))
         (directory (uiop:merge-pathnames*
                     (make-pathname :directory '(:relative "t"))
                     source-directory)))
    (when (uiop:directory-exists-p directory)
      directory)))

(def read-file (file-path &optional system-name)
  "Read contents from file at the given path.
   If system-name is provided, file-path is relative to that system's test directory."
  (let ((full-path (if system-name
                       (uiop:merge-pathnames* file-path (get-base-dir system-name))
                       file-path)))
    (when (pathnamep full-path)
      (uiop:read-file-string full-path))))

(def unique-ids (path)
  "Return unique ID for path."
  (when (pathnamep path)
    (cat (current-custom-date)
         (ironclad:byte-array-to-hex-string
          (ironclad:digest-sequence
           :md5 (ironclad:ascii-string-to-byte-array (namestring path)))))))

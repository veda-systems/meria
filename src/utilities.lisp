;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; utilities.lisp --- useful utilities using the operating system

(uiop:define-package #:meria/src/utilities
  (:use #:cl
        #:marie))

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

(def dir ()
  "Path from file disk"
  (let* ((source-directory (asdf:system-source-directory
                            (asdf:find-system "vera")))
         (directory (uiop:merge-pathnames*
                     (make-pathname :directory '(:relative "t"))
                     source-directory)))
    (when (uiop:directory-exists-p directory)
      directory)))

(def read-file (file-path)
  "Reading the path from file disk."
  (let ((full-path (uiop:merge-pathnames* file-path (dir))))
    (when (pathnamep file-path)
      (uiop:read-file-string full-path))))

(def vera-date ()
  "Return the current date and time in custom format."
  (local-time:format-timestring nil (local-time:now)
                                :format `((:year 4) (:month 2) (:day 2) (:hour 2)
                                                    (:min 2) (:sec 2) (:usec 6))))

(def unique-ids (path)
  "Return unique ID for path."
  (when (pathnamep path)
    (cat (vera-date)
         (ironclad:byte-array-to-hex-string
          (ironclad:digest-sequence
           :md5 (ironclad:ascii-string-to-byte-array (namestring path)))))))


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
   (fmt "notify-send -i gtk-dialog-info '~A'" message)))

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

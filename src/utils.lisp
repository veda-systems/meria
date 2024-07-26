;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; utils.lisp: useful utilities using the operating system

(uiop:define-package #:meria/src/utils
  (:use #:cl
        #:marie))

(in-package #:meria/src/utils)

(def notify (message)
  "Display a system notification."
  (uiop:launch-program
   #+linux
   (format nil "notify-send -i gtk-dialog-info '~A'" message)
   #+macosx
   (format nil "terminal-notifier -sound default -message '~A'" message)))

(defm tnotify^tn (&rest args)
  "Time the evaluation of ARGS then dispaly a notification after it has finished the evaluation."
  `(time (progn ,@args
                (notify "Evaluation has finished."))))

(def slots (object)
  "Return the slot names of OBJECT."
  (mapcar #'closer-mop:slot-definition-name
          (closer-mop:class-slots (class-of object))))

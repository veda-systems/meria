;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; utils.lisp: useful utilities using the operating system

(uiop:define-package #:pierre/src/utils
  (:use #:cl
        #:marie))

(in-package #:pierre/src/utils)

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

;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; utils.lisp: useful utilities using the operating system

(uiop:define-package #:pierre/utils
  (:use #:cl
        #:marie))

(in-package #:pierre/utils)

(def notify (message)
  "Display a system notification."
  (uiop:launch-program (format nil "terminal-notifier -sound default -message '~A'" message)))

(defm tnotify (&rest args)
  "Time the evaluation of ARGS then send a notification."
  `(time (progn ,@args
                (notify "Evaluation has finished."))))

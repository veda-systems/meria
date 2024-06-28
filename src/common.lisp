;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; common.lisp: common utilities

(uiop:define-package #:meria/src/common
  (:use #:cl
        #:marie))

(in-package #:meria/src/common)

(def current-iso-8601-date ()
  "Return the current date and time in ISO 8601 format."
  (local-time:format-timestring nil (local-time:now)))

(def current-custom-date ()
  "Return the current date and time in custom format."
  (local-time:format-timestring
   nil (local-time:now)
   :format `((:year 4) (:month 2) (:day 2)
             #\T
             (:hour 2) (:min 2) (:sec 2)
             #\.
             (:usec 6) :gmt-offset-hhmm)))

(defv *debug-print*
  t
  "Whether to print debugging information using a dedicated outputter.")

(def debug-print (text &optional (stream *standard-output*))
  "Display TEXT to STREAM prefixing it with the the current date and time."
  (when *debug-print*
    (format stream "[~A] ~A~%" (current-custom-date) text)
    (force-output stream)))

(def debug-print* (text &optional (stream *standard-output*))
  "Like DEBUG-PRINT sans the newline."
  (when *debug-print*
    (format stream "[~A] ~A" (current-custom-date) text)
    (force-output stream)))

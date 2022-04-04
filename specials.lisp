;;;; specials.lisp

(uiop:define-package #:pierre/specials
    (:use #:cl
          #:marie))

(in-package #:pierre/specials)

(defv *debug-print*
  t
  "Whether to print debugging information using a dedicated outputter.")

;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; driver.lisp: top-level definitions for the tests

(uiop:define-package #:meria/t/driver
  (:nicknames #:meria-t)
  (:use #:uiop/common-lisp
        #:marie)
  (:use-reexport #:meria/t/run))

(provide "meria/t")
(provide "MERIA/T")

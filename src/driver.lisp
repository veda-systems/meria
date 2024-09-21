;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; driver.lisp --- top-level definitions for exporting meria symbols

(uiop:define-package :meria/src/driver
  (:nicknames :meria)
  (:use :uiop/common-lisp)
  (:use-reexport #:meria/src/common
                 #:meria/src/config
                 #:meria/src/server
                 #:meria/src/threads
                 #:meria/src/os
                 #:meria/src/utilities
                 #+lispworks #:meria/src/stack))

(provide "meria")
(provide "MERIA")

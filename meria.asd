;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; meria.asd --- main ASDF file for the meria system

(defsystem #:meria
    :name "meria"
    :version (:read-file-form #P"version.lisp")
    :description "A small collection of CL utilities with external dependencies"
    :author "Rommel Martínez <ebzzry@icloud.com>"
    :class :package-inferred-system
    :depends-on (#:local-time
                 #:hunchentoot
                 #:clack
                 #:clack-handler-hunchentoot
                 #:websocket-driver
                 #:bordeaux-threads
                 #:closer-mop
                 #:cl-cpus
                 #:marie
                 #:meria/src/common
                 #:meria/src/config
                 #:meria/src/server
                 #:meria/src/threads
                 #:meria/src/os
                 #:meria/src/utilities
                 #+lispworks #:meria/src/stack
                 #:meria/src/driver)
    :in-order-to ((test-op (test-op "meria-tests"))))

;;;; -*- mode: lisp; syntax: common-lisp; base: 10 -*-
;;;; meria.asd --- main ASDF file for the meria system

(defsystem #:meria
    :name "meria"
    :version (:read-file-form #P"version.lisp")
    :description "A tiny collection of CL utilities with external dependencies"
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
                 #:ironclad
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

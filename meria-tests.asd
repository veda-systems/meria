;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; meria-tests.asd --- test ASDF file for the meria system

(defsystem #:meria-tests
    :name "meria-tests"
    :version (:read-file-form #P"version-tests.lisp")
    :description "Tests for the meria system"
    :class :package-inferred-system
    :depends-on (#:fiveam
                 #:meria
                 #:meria/t/run
                 #:meria/t/driver)
    :perform (test-op (o c) (uiop:symbol-call :meria/t/run :run-tests)))

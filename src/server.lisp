;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; server.lisp --- server management

(uiop:define-package #:meria/src/server
  (:use #:cl
        #:marie
        #:meria/src/common))

(in-package #:meria/src/server)

(def start-httpd (name port address)
  "Start the HTTP server under port PORT."
  (let* ((server :hunchentoot)
         (value (clack:clackup name :server server :address address :port port :silent t)))
    (when value
      (debug-print (fmt "Server is started." (string-capitalize (string* server))))
      (debug-print (fmt "Listening on ~A:~A." address port))
      value)))

(def stop-httpd (server)
  "Stop the HTTP SERVER."
  (clack:stop server))

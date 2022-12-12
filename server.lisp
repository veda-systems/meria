;;;; server.lisp

(uiop:define-package #:pierre/server
  (:use #:cl
        #:marie
        #:pierre/specials
        #:pierre/common))

(in-package #:pierre/server)

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

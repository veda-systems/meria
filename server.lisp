;;;; server.lisp

(uiop:define-package #:pierre/server
    (:use #:cl
          #:marie
          #:pierre/specials
          #:pierre/common))

(in-package #:pierre/server)

(def clack-start (name port address)
  "Start the clack server SERVER under port PORT."
  (let* ((server :hunchentoot)
         (value (clack:clackup name :server server :address address :port port :silent t)))
    (when value
      (debug-print (fmt "Server is started." (string-capitalize (string* server))))
      (debug-print (fmt "Listening on ~A:~A." address port))
      value)))

(def clack-stop (server)
  "Stop the clack server SERVER."
  (clack:stop server))



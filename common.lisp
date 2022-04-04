;;;; common.lisp

(uiop:define-package #:pierre/common
    (:use #:cl
          #:marie
          #:pierre/specials))

(in-package #:pierre/common)

(def current-date-iso-8601 ()
  "Return the current date and time in ISO 8601 format."
  (local-time:format-timestring nil (local-time:now)))

(def current-date-custom ()
  "Return the current date and time in custom format."
  (local-time:format-timestring
   nil (local-time:now)
   :format `((:year 4) #\- (:month 2) #\- (:day 2)
             #\T
             (:hour 2) #\- (:min 2) #\- (:sec 2)
             #\.
             (:usec 6) :gmt-offset-hhmm)))

(def debug-print (text &optional (stream *standard-output*))
  "Display TEXT to STREAM prefixing it with the the current date and time."
  (when *debug-print*
    (format stream "[~A] ~A~%" (current-date-iso-8601) text)
    (force-output stream)))

;;;; threads.lisp

(uiop:define-package #:pierre/threads
    (:use #:cl
          #:marie
          #:pierre/specials))

(in-package #:pierre/threads)

(def show-threads ()
  "Print a list of running threads."
  (loop :for thread :in (bt:all-threads)
        :do (format t "~A~%" thread)))

(def show-thread-names ()
  "Print a list of the names of the running threads."
  (loop :for thread :in (bt:all-threads)
        :do (format t "~A~%" (bt:thread-name thread))))

(def find-threads (query)
  "Find threads matching QUERY."
  (remove-if-not (λ (thread)
                   (string= query (bt:thread-name thread)))
                 (bt:all-threads)))

(def destroy-threads (query)
  "Destroy threads matching QUERY."
  (loop :for thread :in (find-threads query) :do (bt:destroy-thread thread)))

;; (destroy-other-threads "main thread")
(def destroy-other-threads (query)
  "Destroy threads not matching QUERY."
  (loop :for thread :in (bt:all-threads)
        :when (¬ (string= query (bt:thread-name thread)))
          :do (bt:destroy-thread thread)))

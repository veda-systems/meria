;;;; threads.lisp

(uiop:define-package #:pierre/threads
  (:use #:cl
        #:marie
        #:pierre/specials))

(in-package #:pierre/threads)

(def show-threads ()
  "Print a list of running threads."
  (loop :for thread :in (mp:list-all-processes)
        :do (format t "~A~%" thread)))

(def show-thread-names ()
  "Print a list of the names of the running threads."
  (loop :for thread :in (mp:list-all-processes)
        :do (format t "~A~%" (mp:process-name thread))))

(def find-threads (query)
  "Find threads matching QUERY."
  (remove-if-not (λ (thread)
                   (string= query (mp:process-name thread)))
                 (mp:list-all-processes)))

(def destroy-threads (query)
  "Destroy threads matching QUERY."
  (loop :for thread :in (find-threads query)
        :do (mp:process-kill thread)))

(def destroy-other-threads (query)
  "Destroy threads not matching QUERY."
  (loop :for thread :in (mp:list-all-processes)
        :when (¬ (string= query (mp:process-name thread)))
          :do (mp:process-kill thread)))

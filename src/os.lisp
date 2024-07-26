;;;; -*- mode: lisp; syntax: common-lisp; base: 10; coding: utf-8-unix; external-format: (:utf-8 :eol-style :lf); -*-
;;;; os.lisp: useful utilities using the operating system

(uiop:define-package #:meria/src/os
  (:use #:cl
        #:marie))

(in-package #:meria/src/os)


;;; definitions

#+lispworks
(progn
  #+linux
  (progn
    (defconstant +sc-nprocessors-onln+ 84)

    (fli:define-foreign-function (sysconf% "sysconf")
        ((name :int))
      :result-type :long)

    (defun number-of-processors% ()
      (sysconf% +sc-nprocessors-onln+)))

  #+(or bsd freebsd darwin)
  (progn
    (defconstant +ctl-hw+ 6)
    (defconstant +hw-ncpu+ 3)

    ;; sysctl(int *name, u_int namelen, void *oldp, size_t *oldlenp, void *newp,
    ;;        size_t newlen);
    (fli:define-foreign-function (sysctl% "sysctl")
        ((name    :pointer)
         (namelen :unsigned-int)
         (oldp    :pointer)
         (oldlenp :pointer)
         (newp    :pointer)
         (newlen  :unsigned-int))
      :result-type :long)

    (defun number-of-processors% ()
      (fli:with-dynamic-foreign-objects ((name-ptr (:c-array :int 2)))
        (setf (fli:foreign-aref name-ptr 0) +ctl-hw+
              (fli:foreign-aref name-ptr 1) +hw-ncpu+)
        (fli:with-dynamic-foreign-objects ((old-ptr :pointer)
                                           (oldlen-ptr :pointer))
          (let ((result (sysctl% name-ptr 2 old-ptr oldlen-ptr fli:*null-pointer* 0)))
            (if (zerop result)
                (fli:dereference old-ptr :type :int)
                0))))))

  #+(or win32 windows)
  (progn
    (eval-when (:load-toplevel :execute)
      (fli:register-module 'kernel32-library
                           :connection-style :immediate
                           :real-name "C:/WINDOWS/system32/kernel32.dll"))

    ;; C++ Syntax from https://msdn.microsoft.com/en-us/library/windows/desktop/ms724958(v=vs.85).aspx
    ;; typedef struct _SYSTEM_INFO {
    ;;   union {
    ;;     DWORD  dwOemId;
    ;;     struct {
    ;;       WORD wProcessorArchitecture;
    ;;       WORD wReserved;
    ;;     };
    ;;   };
    ;;   DWORD     dwPageSize;
    ;;   LPVOID    lpMinimumApplicationAddress;
    ;;   LPVOID    lpMaximumApplicationAddress;
    ;;   DWORD_PTR dwActiveProcessorMask;
    ;;   DWORD     dwNumberOfProcessors;
    ;;   DWORD     dwProcessorType;
    ;;   DWORD     dwAllocationGranularity;
    ;;   WORD      wProcessorLevel;
    ;;   WORD      wProcessorRevision;
    ;; } SYSTEM_INFO;

    (fli:define-c-typedef dword :unsigned-long)
    (fli:define-c-typedef word :unsigned-short)

    (fli:define-c-struct processor-struct
        (processor-architecture word)
      (reserved word))

    (fli:define-c-union oem-union
        (oem-ide dword)
      (processor-struct (:struct processor-struct)))

    (fli:define-c-struct system-info
        (oem-info (:union oem-union))
      (page-size dword)
      (minimum-application-address :pointer)
      (maximum-application-address :pointer)
      (active-processor-mask (:pointer dword))
      (number-of-processors dword)
      (processor-type dword)
      (allocation-granularity dword)
      (processor-level word)
      (processor-revision word))

    ;; C++ Syntax from https://msdn.microsoft.com/en-us/library/windows/desktop/ms724381(v=vs.85).aspx
    ;; void WINAPI GetSystemInfo(
    ;;   _Out_ LPSYSTEM_INFO lpSystemInfo
    ;; );
    (fli:define-foreign-function (get-system-info% "GetSystemInfo")
        ((data (:pointer (:struct system-info))))
      :result-type :void
      :module 'kernel32-library)

    (defun number-of-processors% ()
      (fli:with-dynamic-foreign-objects ((info (:struct system-info)))
        (get-system-info% info)
        (fli:foreign-slot-value info 'number-of-processors
                                :type 'dword
                                :object-type '(:struct system-info))))))


;;; top-level

(def number-of-processors ()
  #+lispworks
  (number-of-processors%)
  #-lispworks
  (cpus:get-number-of-processors))

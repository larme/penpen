(eval-when (:compile-toplevel :load-toplevel)
  (ql:quickload :penpen)
  (defpackage osc-examples (:use :cl :penpen)))
(in-package :penpen-examples)

(defclass <example-commander> () ())

(defmethod increase-counter ((me <example-commander>) state n)
  (with-slots (count) state
    (format t "count before: ~a~%" count)
    (setf count (+ count n))
    (format t "count after: ~a~%" count)))

(defclass <example-state> ()
  ((count
    :initarg :count
    :accessor count-of
    :initform 0
    :documentation "a trivial counter")))

(defclass <example-translator> () ())

(defmethod translate ((translator <example-translator>) state msg)
  (let ((path (car msg))
	(args (cdr msg)))
    (print "kakak")
    (when (string= path "/increase")
      (print "hahaha")
      (cons #'increase-counter args))))

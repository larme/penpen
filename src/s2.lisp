 ;;;; s2.lisp

(in-package #:penpen)

(defclass <s2> ()
  ((commander
    :initarg :commander
    :accessor commander-of
    :documentation "state transformation functions collection object")
   (translator
    :initarg :translator
    :accessor translator-of
    :documentation "external command translator object")
   (state :initarg :state
	  :accessor state-of
	  :documentation "state object")))

(defgeneric translate (translator state message)
  (:documentation "translate message to a (meth arg1 arg2 ...) list for commander"))

(defgeneric exec (s2-engine meth args)
  (:documentation "execute a method of commander"))

(defmethod exec ((s2-engine <s2>) meth args)
  (with-slots (commander state) s2-engine
    (apply meth commander state args)))

(defmethod exec-ctrl-message ((s2-engine <s2>) message)
  (with-slots (commander translator state) s2-engine
    (let ((res (translate translator state message)))
      (when res
	(let ((meth (car res))
	      (args (cdr res)))
	  (exec s2-engine meth args))))))

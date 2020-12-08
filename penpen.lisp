 ;;;; penpen.lisp

(in-package #:penpen)

(defvar *render-actor* nil)
(defvar *ctrl-osc-actor* nil)

(defactor <test-actor> () (cmd)
  (let ((res (funcall cmd 1 2)))
    (format t "haha ~a~%" res))
  next)

;; use a func handler sub obj here
(defactor <render-actor> (init-actor) (func args)
  (case func
    (:replace 'replace)
    (otherwise (apply func args)))
  next)

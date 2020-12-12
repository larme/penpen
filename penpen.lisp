 ;;;; penpen.lisp

(in-package #:penpen)

(defvar *render-actor* nil)
(defvar *ctrl-osc-actor* nil)

(defun actor-alive-p (actor)
  (bt:thread-alive-p (slot-value actor 'bt:thread)))


(defactor <test-actor> () (cmd)
  (let ((res (funcall cmd 1 2)))
    (format t "haha ~a~%" res))
  next)


(defactor <render-actor> (commander state) (func args)
  (case func
    (:debug (cl-actors::pr (format nil
				   "commander: ~a state: ~a"
				   commander state)))
    (:replace-commander (setf commander args))
    (:replace-state (setf state args))
    (otherwise (apply func commander state args)))
  next)


(defun ctrl-actors-change-render-actor (actor)
  (send *ctrl-osc-actor* :replace-render-actor actor))


(defun set-render-actor (actor &key (stop-previous t) (adjust-ctrl-actors t))
  (when stop-previous
    (cl-actors::stop-actor *render-actor*))
  (when adjust-ctrl-actors
    (ctrl-actors-change-render-actor actor))
  (setf *render-actor* actor))


(defun reset-render-actor (commander state
			   &key
			     (stop-previous t)
			     (adjust-ctrl-actors t))

  (let ((actor (<render-actor> :commander commander
			       :state state)))
    (set-render-actor actor :stop-previous stop-previous
			    :adjust-ctrl-actors adjust-ctrl-actors)))

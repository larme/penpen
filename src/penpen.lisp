 ;;;; penpen.lisp

(in-package #:penpen)

(defvar *render-actor* nil)

(defun actor-alive-p (actor)
  (bt:thread-alive-p (slot-value actor 'bt:thread)))


(defactor <test-actor> () (cmd)
  (let ((res (funcall cmd 1 2)))
    (format t "haha ~a~%" res))
  next)


(defactor <render-actor> (s2-engine) (message)
  (let ((func (car message))
	(args (cdr message)))
    (case func
      (:debug (cl-actors::pr (format nil
				     "commander: ~a state: ~a"
				     1 2)))
      (:replace-commander (setf (commander-of s2-engine) args))
      (:replace-state (setf (state-of s2-engine) args))
      (:replace-translator (setf (translator-of s2-engine) args))
      (:ctrl (exec-ctrl-message s2-engine args))
      (otherwise (exec s2-engine func args))))
  next)


(defun change-render-actor-for-ctrl-actors (actor)
  ;; osc listener
  (penpen/osc:replace-listener-handler (penpen/osc:make-render-handler actor)))


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

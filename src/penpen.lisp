 ;;;; penpen.lisp

(in-package #:penpen)

(defvar *render-actor* nil)

(defun actor-alive-p (actor)
  (bt:thread-alive-p (slot-value actor 'bt:thread)))

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


(defun start-ctrl-actors (&optional (kill-previous t))
  ;; start osc listener
  (penpen/osc:start-listener :kill-previous kill-previous))

(defun change-render-actor-for-ctrl-actors (actor)
  ;; osc listener
  (penpen/osc:replace-listener-handler (penpen/osc:make-render-handler actor)))

(defun set-render-actor (actor &key (kill-previous t) (adjust-ctrl-actors t))
  (when (and kill-previous *render-actor*)
    (cl-actors::stop-actor *render-actor*))
  (when adjust-ctrl-actors
    (change-render-actor-for-ctrl-actors actor))
  (setf *render-actor* actor))

(defun init (commander state translator
	     &key (kill-previous t))
  (let* ((s2-engine (make-instance '<s2>
				   :commander commander
				   :state state
				   :translator translator))
	 (actor (<render-actor> :s2-engine s2-engine)))
    (start-ctrl-actors)
    (set-render-actor actor :kill-previous kill-previous)))

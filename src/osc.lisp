 ;;;; osc.lisp

(in-package #:penpen/osc)

(defvar *listener* nil)
(defvar *listen-port* 7377)

(defun make-udp-socket (host port)
  (usocket:socket-connect host
			  port
			  :protocol :datagram
			  :element-type '(unsigned-byte 8)))

(defun send-to-udp-socket (socket osc-msg-list)
  (let* ((bytes (apply #'osc:encode-message osc-msg-list))
	 (len (length bytes)))
    (usocket:socket-send socket bytes len)))

(defun close-socket (socket)
  (when socket
    (usocket:socket-close socket)))

(defun speak-to-listener (msg &optional (port *listen-port*))
  (let ((socket (make-udp-socket "127.0.0.1" port)))
    (send-to-udp-socket socket msg)
    (close-socket socket)))

(defactor <speaker> (host port socket) (cmd osc-msg-list)
  (case cmd
    (:start (progn
	      (format t "~a~%" socket)
	      (close-socket socket)
	      (setf socket (make-udp-socket host port))))
    (:stop (close-socket socket))
    (:send (send-to-udp-socket socket osc-msg-list)))
  next)

(defun make-speaker (host port)
  (let ((actor (<speaker> :host host :port port)))
    (send actor :start nil)
    actor))

(defun stop-speaker (speaker)
  (when speaker
    (send speaker :stop nil)
    (stop-actor speaker)))

(defun listen-to (msg-handler &optional (port *listen-port*) (buff_size 2048))
  "listen to a port"
  (let ((buffer (make-array buff_size :element-type '(unsigned-byte 8))))
    (usocket:with-connected-socket
	(s (usocket:socket-connect nil nil
				   :local-port port
				   :protocol :datagram
				   :element-type '(unsigned-byte 8)))
      (format t "osc listener ~a start at port ~a!~%" s port)
      (loop
	(usocket:socket-receive s buffer buff_size)
	(let* ((msg (osc:decode-bundle buffer))
	       (terminatep (funcall msg-handler msg)))
	  (when terminatep
	    (return)))))))

(defun trivial-handler (msg)
  (let ((cmd (car msg)))
    (format t "get ~a~%" msg)
    (if (string= cmd "/exit")
	t
	nil)))

(defun make-render-handler (render-actor)
  (lambda (msg)
    (let ((cmd (car msg)))
      (if (string= cmd "/exit")
	  t
	  (progn
	    (send render-actor (cons :ctrl msg))
	    nil)))))

(defactor <listener> (msg-handler port) (cmd args)
  (case cmd
    (:start (listen-to msg-handler port))
    (:replace-handler (setf msg-handler args)))
  next)

(defun start-listener (&key
			 (msg-handler #'trivial-handler)
			 (port *listen-port*)
			 (kill-previous t))
  (when kill-previous
    (kill-listener))

  (let ((actor (<listener> :msg-handler msg-handler :port port)))
    (send actor :start nil)
    (setf *listener* actor)))

(defun kill-listener ()
  (when *listener*
    (speak-to-listener '("/exit"))
    (stop-actor *listener*)
    (setf *listener* nil)))

(defun replace-listener-handler (msg-handler)
  (speak-to-listener '("/exit"))
  (send *listener* :replace-handler msg-handler)
  (send *listener* :start nil))

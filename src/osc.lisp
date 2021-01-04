 ;;;; osc.lisp

(in-package #:penpen/osc)

(defvar *osc-speak-port* 7477)
(defvar *osc-listen-port* 7377)

(defun make-udp-socket (host port)
  (usocket:socket-connect host
			  port
			  :protocol :datagram
			  :element-type '(unsigned-byte 8)))

(defun send-osc-to-udp-socket (socket osc-msg-list)
  (let* ((bytes (apply #'osc:encode-message osc-msg-list))
	 (len (length bytes)))
    (usocket:socket-send socket bytes len)))

(defun close-socket (socket)
  (when socket
    (usocket:socket-close socket)))

(defun osc-listen (msg-handler &optional (port *osc-listen-port*) (buff_size 2048))
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
    (if (string= cmd "/exit")
	t
	nil)))

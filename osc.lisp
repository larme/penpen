 ;;;; osc.lisp

(in-package #:penpen)


(defun osc-listen (port &optional (buff_size 2048))
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
	(let* ((content (osc:decode-bundle buffer)))
	  (format t "get ~a~%" content)
	  (format t "type is ~a~%" (type-of content)))))))

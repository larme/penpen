;;;; test of socket

(in-package #:penpen)

(defvar *master-socket*)
(defvar *client*)

(defun create-master-socket (host port)
  (usocket:socket-listen host port
			 :reuse-address t
			 :element-type 'unsigned-byte))

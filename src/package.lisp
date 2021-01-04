;;;; package.lisp

(defpackage #:penpen
  (:use #:cl
	#:cl-actors)
  (:export #:<s2>
	   #:exec
	   #:exec-ctrl-message
	   #:translate
	   #:*render-actor*
	   #:*ctrl-osc-actor*
	   #:actor-alive-p
	   #:<render-actor>
	   #:set-render-actor))

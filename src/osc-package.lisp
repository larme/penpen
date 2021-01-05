(defpackage #:penpen/osc
  (:use #:cl
	#:cl-actors)
  (:export #:*listener*
	   #:*listen-port*
	   #:start-listener
	   #:kill-listener
	   #:make-render-handler
	   #:make-speaker
	   #:stop-speaker
	   #:speak-to-listener)
  (:documentation
   "penpen's osc lib"))

(defpackage #:penpen/osc
  (:use #:cl
	#:cl-actors)
  (:export #:*osc-speak-port*
	   #:*osc-listen-port*)
  (:documentation
   "penpen's osc lib"))

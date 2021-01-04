;;;; penpen.asd

(asdf:defsystem #:penpen
  :description "Describe penpen here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-actors
	       #:usocket
	       #:osc
	       #:penpen/osc)
  :pathname "src"
  :class :package-inferred-system
  :components ((:file "package")
	       (:file "s2")
	       (:file "penpen")))

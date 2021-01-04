;;;; penpen.asd

(asdf:defsystem #:penpen
    :description "penpen's core lib"
    :author "Zhao Shenyang <dev@zsy.im>"
    :license  "MIT"
    :version "0.0.1"
    :serial t
    :depends-on (#:cl-actors
		 #:penpen/osc)
    :pathname "src"
    :components ((:file "package")
		 (:file "s2")
		 (:file "penpen")))


(asdf:defsystem #:penpen/osc
    :description "penpen's osc lib"
    :author "Zhao Shenyang <dev@zsy.im>"
    :license  "MIT"
    :version "0.0.1"
    :serial t
    :depends-on (#:cl-actors
		 #:usocket
		 #:osc)
    :pathname "src"
    :components ((:file "osc-package")
		 (:file "osc")))

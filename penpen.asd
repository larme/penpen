;;;; penpen.asd

(asdf:defsystem #:penpen
  :description "Describe penpen here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-actors)
  :components ((:file "package")
               (:file "penpen")))

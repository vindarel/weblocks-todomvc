#|
  This file is a part of weblocks-todomvc project.
|#

(asdf:defsystem weblocks-todomvc
  :version "0.1"
  :author ""
  :license ""
  :depends-on (:weblocks
               :weblocks-ui
               :ceramic
               :bordeaux-threads
               :find-port)
  :components ((:module "src"
                :components
                ((:file "weblocks-todomvc")
                 (:file "desktop"))))
  :description "TodoMVC example with the Weblocks Common Lisp web framework."

  ;; Build an executable with asdf:make.
  :build-operation "program-op"
  :build-pathname "weblocks-todomvc"
  :entry-point "weblocks-todomvc:main"

  :in-order-to ((test-op (test-op weblocks-todomvc-test))))

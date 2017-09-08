#|
  This file is a part of weblocks-todomvc project.
|#

(in-package :cl-user)
(defpackage weblocks-todomvc-test-asd
  (:use :cl :asdf))
(in-package :weblocks-todomvc-test-asd)

(defsystem weblocks-todomvc-test
  :author ""
  :license ""
  :depends-on (:weblocks-todomvc
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "weblocks-todomvc"))))
  :description "Test system for weblocks-todomvc"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))

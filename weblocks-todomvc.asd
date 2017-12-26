#|
  This file is a part of weblocks-todomvc project.
|#

(in-package :cl-user)
(defpackage weblocks-todomvc-asd
  (:use :cl :asdf))
(in-package :weblocks-todomvc-asd)

(defsystem weblocks-todomvc
  :version "0.1"
  :author ""
  :license ""
  :depends-on (:weblocks
               :weblocks-ui
               :ceramic
               :find-port)
  :components ((:module "src"
                :components
                ((:file "weblocks-todomvc")
                 (:file "desktop"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.org"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op weblocks-todomvc-test))))

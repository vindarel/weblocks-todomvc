(in-package :cl-user)
(defpackage weblocks-todomvc
  (:use :cl)
  (:import-from #:weblocks/widget
                #:render
                #:update
                #:defwidget)
  (:import-from #:weblocks/html
                #:with-html)
  (:import-from #:weblocks-ui/form
                #:with-html-form)
  (:import-from #:weblocks/actions
                #:make-js-action)
  (:export #:start-app
           #:restart-app
           #:stop-app))
(in-package :weblocks-todomvc)

(defwidget task ()
    ((title
      :initarg :title
      :reader title)
     (done
      :initarg :done
      :initform nil
      :accessor done)))

(defmethod print-object ((task task) stream)
  (print-unreadable-object (task stream :type t)
    (format stream "~a, done ? ~a" (title task) (done task))))

(defmethod toggle ((task task))
  (setf (done task)
        (if (done task)
            nil
            t))
  (update task))

(defmethod render ((task task))
  (with-html
    (:p (:input :type "checkbox"
                :checked (done task)
                :onclick (make-js-action
                          (lambda (&rest rest)
                            (declare (ignore rest))
                            (toggle task))))
        (:span (if (done task)
                   (with-html
                     (:s (title task)))
                   (title task))))))

(defun make-task (&key title done)
  "Create a task, not done by default."
  ;; todo can not compile, need to remove the struct.
  ;; todo: can we have functions outside of init-user-session ?? Last time I tried, no.
  (make-instance 'task :title title :done done))

(defvar some-tasks (list
                    (make-task :title "1st task")
                    (make-task :title "second task")))

(defun add-task (&rest rest &key title &allow-other-keys)
  (log:info "Pushing " title " to " (tasks *root*) rest)
  (push (make-task :title title) (tasks *root*))
  (log:info "updating root: " *root*)
  (update *root*))

(defwidget task-list ()
  ((tasks
    :initarg :tasks
    :accessor tasks)))

(defmethod render ((widget task-list))
  (with-html
    (:h1 "Tasks")
    (loop for task in (tasks widget) do
         (render task))
    (with-html-form (:POST #'add-task)
      (:input :type "text"
              :name "title"
              :placeholder "Task's title")
      (:input :type "submit"
              :value "Add"))))


(declaim (optimize (debug 3)))

(setf weblocks/variables:*invoke-debugger-on-error* nil)

(defvar *root* nil
  "Our root widget.")

(defmethod weblocks/session:init ((app tasks-mvc))
  (declare (ignorable app))
  (setf *root* (make-instance 'task-list :tasks some-tasks)))

(defun start-app (&key (port 8080))
  "To use a custom port, we can pass :port (find-port:find-port) as argument."
  ;; xxx give the port as argument.
  (weblocks/app:defapp tasks-mvc)
  (weblocks/debug:on)
  ;; the following argument also defines the url to access the app
  ;; (better a string ?).
  (weblocks/app:start 'tasks-mvc)
  (weblocks/server:start :port port))

(defun restart-app ()
  (progn (weblocks/app:restart 'tasks-mvc)
         (weblocks/debug:reset-latest-session)))

(defun stop-app ()
  (weblocks/server:stop))

(in-package :cl-user)
(defpackage weblocks-todomvc
  (:use :cl
        :weblocks
        :weblocks.ui.form)
  (:export #:start-app
           #:restart-app
           #:stop-app))
(in-package :weblocks-todomvc)

(defstruct task
  (title)
  (done))

(defun init-user-session (root)
  (let ((tasks (reverse (list (make-task :title "Make my first app in Weblocks" :done t)
                              (make-task :title "Deploy it somewhere" :done nil)
                              (make-task :title "Have a profit" :done nil)))))
    (labels ((add-task (&rest rest &key task &allow-other-keys)
               (log:info "Pushing" task "to" tasks rest)
               (push (make-task :title task :done nil) tasks)
               (mark-dirty root))
             (toggle-task (task)
               (setf (task-done task)
                     (if (task-done task)
                         nil
                         t))
               (mark-dirty root))
             (render-task (task)
               (let ((title (task-title task))
                     (done (task-done task)))
                 (with-html
                   (:p (:input :type "checkbox"
                               :checked done
                               :onclick (weblocks::make-js-action
                                         (lambda (&rest rest)
                                           (declare (ignore rest))
                                           (toggle-task task))))
                       (:span (if done
                                  (cl-who:htm (:strike (str title)))
                                  (str title))))))))
      (setf (widget-children root)
            (lambda ()
              (with-html
                (:h1 "Tasks")
                (:div :class "tasks"
                      (loop for task in (reverse tasks)
                         do (cl-who:htm (render-task task))))
                (with-html-form (:POST #'add-task)
                  (:input :type "text"
                          :name "task"
                          :placeholder "Task's title")
                  (:input :type "submit"
                          :value "Add"))))))))

(defun start-app (&key (port 8080))
  "To use a custom port, we can pass :port (find-port:find-port) as argument."
  ;; xxx give the port as argument.
  (defwebapp tasks-mvc
      :init-user-session #'init-user-session)
  ;; the following argument also defines the url to access the app
  ;; (better a string ?).
  (start-webapp 'tasks-mvc)
  (weblocks.server:start-weblocks :port port))

(defun restart-app ()
  (progn (weblocks:restart-webapp 'tasks-mvc)
         (weblocks.debug:reset-latest-session)))

(defun stop-app (&rest args)
  (weblocks.server:stop-weblocks))

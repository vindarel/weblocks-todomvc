(defpackage #:weblocks-todomvc.desktop
  (:use #:cl)
  (:export
   #:start-dev-app
   #:stop-dev-app))
(in-package weblocks-todomvc.desktop)

(defvar *window* nil)

;; from hacrm
(defun run ()
  (let ((port (find-port:find-port)))
    (log:info "Starting weblocks-todomvc on port"
              ;; port
              8080)
    (weblocks-todomvc:start-app)

    (log:debug "Creating window")
    (setf *window*
          ;; the url is composed of the name of our app.
          (ceramic:make-window :url (format nil "http://localhost:~D/tasks-mvc" 8080))) ;; xx give the port.
    (ceramic:show *window*)))


(defun start-dev-app ()
  ""
  (ceramic:start)
  (run))

(defun stop-dev-app ()
  (weblocks-todomvc:stop-app)
  (ceramic:stop))

(ceramic:define-entry-point :todomvc ()
  ;; we need to muffle warnings from Weblocks about
  ;; missing asset files
  (handler-bind ((warning #'muffle-warning))
    (run)))

(defun build-ceramic ()
  (ceramic:bundle :WEBLOCKS-TODOMVC :bundle-pathname #p"build/todomvc.tar")
  )

LISP?=sbcl

all: build

build:
	$(LISP) --non-interactive \
		--load weblocks-todomvc.asd \
		--eval '(ql:quickload :weblocks-todomvc)' \
		--eval '(asdf:make :weblocks-todomvc)'

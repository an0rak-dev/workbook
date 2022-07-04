.PHONY: blog
.SILENT: help

all: help

blog:
	make -C blog dev

help:
	echo Handle the operations available on this project.
	echo usage: make [target]
	echo With targets :
	echo     - blog : Run the blog in dev mode 
	echo     - help : Display this help text
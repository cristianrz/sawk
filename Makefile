DST = ${HOME}/.local

all:

install:
	mkdir -p $(DST)/bin
	cp awkfmt $(DST)/bin
	cp awklint $(DST)/bin
	cp awkrun $(DST)/bin


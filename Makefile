all: sawk.1

sawk.1: sawk.1.md
	pandoc -s -t man -f markdown -o sawk.1 sawk.1.md

clean:
	rm -f sawk.1

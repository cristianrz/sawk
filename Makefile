PREFIX = /usr/local

all: sawk.1

sawk.1: sawk.1.md
	@pandoc -s -t man -f markdown -o sawk.1 sawk.1.md

install:
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
	@cp -p sawk $(DESTDIR)$(PREFIX)/bin/awkexe
	@cp -p sawk $(DESTDIR)$(PREFIX)/bin/awkfmt
	@cp -p sawk $(DESTDIR)$(PREFIX)/bin/sawk
	@cp -p sawk.1 $(DESTDIR)$(PREFIX)/share/man/man1
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/sawk

clean:
	@rm -f sawk.1

uninstall:
	@rm -rf $(DESTDIR)$(PREFIX)/bin/awkexe
	@rm -rf $(DESTDIR)$(PREFIX)/bin/awkfmt
	@rm -rf $(DESTDIR)$(PREFIX)/bin/sawk
	@rm -rf $(DESTDIR)$(PREFIX)/share/man/man1/sawk.1

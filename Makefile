PREFIX = /usr/local

# sawk.1 is kept pre-built in the repo so pandoc is not required to install.
# Run 'make sawk.1' manually after editing sawk.1.md.
all:

sawk.1: sawk.1.md
	pandoc -s -t man -f markdown -o sawk.1 sawk.1.md

install: sawk awkfmt sawk-run sawk.1
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
	@cp -p sawk $(DESTDIR)$(PREFIX)/bin/sawk
	@cp -p awkfmt $(DESTDIR)$(PREFIX)/bin/awkfmt
	@cp -p sawk-run $(DESTDIR)$(PREFIX)/bin/sawk-run
	@cp -p sawk.1 $(DESTDIR)$(PREFIX)/share/man/man1/sawk.1
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/sawk
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/awkfmt
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/sawk-run

uninstall:
	@rm -f $(DESTDIR)$(PREFIX)/bin/sawk
	@rm -f $(DESTDIR)$(PREFIX)/bin/awkfmt
	@rm -f $(DESTDIR)$(PREFIX)/bin/sawk-run
	@rm -f $(DESTDIR)$(PREFIX)/share/man/man1/sawk.1

clean:
	@rm -f sawk.1

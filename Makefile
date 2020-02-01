PKGNAME     := mons
PKGDESC     := POSIX Shell script to quickly manage 2-monitors display.

SCRIPT      = $(PKGNAME).sh
MANPAGE     = $(PKGNAME).1.gz

PREFIX      = /usr
LICENSEDIR  = $(DESTDIR)$(PREFIX)/share/licenses/$(PKGNAME)
MANDIR      = $(DESTDIR)$(PREFIX)/share/man/man1
BINDIR      = $(DESTDIR)$(PREFIX)/bin
LIBDIR      = $(DESTDIR)$(PREFIX)/lib/libshlist

LIB         = libshlist/liblist.sh

install: $(LIB) $(MANPAGE)
	mkdir -p $(LIBDIR)
	mkdir -p $(LICENSEDIR)
	mkdir -p $(MANDIR)
	mkdir -p $(BINDIR)
	chmod 644 $(LIB)
	chmod 644 LICENSE
	chmod 644 $(MANPAGE)
	chmod 755 $(SCRIPT)
	cp $(LIB) $(LIBDIR)/liblist.sh
	cp LICENSE $(LICENSEDIR)/LICENSE
	cp $(MANPAGE) $(MANDIR)/$(MANPAGE)
	cp $(SCRIPT) $(BINDIR)/$(PKGNAME)
	sed -i -e "s#%LIBDIR%#$(LIBDIR)#" $(BINDIR)/$(PKGNAME)

$(MANPAGE):
	help2man -N -n "$(PKGDESC)" -h -h -v -v ./$(SCRIPT) | gzip - > $@

uninstall:
	$(RM) -r $(LICENSEDIR) $(LIBDIR)
	$(RM) $(MANDIR)/$(MANPAGE) $(BINDIR)/$(PKGNAME)

.PHONY: install uninstall

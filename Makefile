PKGNAME		= mons
PKGDESC		= POSIX Shell script to quickly manage 2-monitors display.

LICENSEDIR  = $(DESTDIR)/usr/share/licenses/$(PKGNAME)
MANDIR		= $(DESTDIR)/usr/share/man/man1
BINDIR  	= $(DESTDIR)/usr/bin
LIBDIR  	= $(DESTDIR)/usr/lib/libshlist
LIB     	= libshlist/liblist.sh

install:
	@if ! [ -r "$(LIB)" ]; then \
		echo "$(LIB): missing file"; \
		exit 1; \
	fi
	help2man -N -n "$(PKGDESC)" -h -h -v -v ./$(PKGNAME) | gzip - > $(PKGNAME).1.gz
	@if ! [ -r "$(PKGNAME).1.gz" ]; then \
		echo "$(PKGNAME).1.gz: missing manpage"; \
		exit 1; \
	fi
	mkdir -p $(MANDIR)
	mkdir -p $(LICENSEDIR)
	mkdir -p $(LIBDIR)
	mkdir -p $(BINDIR)
	chmod 644 $(PKGNAME).1.gz
	chmod 644 LICENSE
	chmod 644 $(LIB)
	chmod 755 mons
	cp $(PKGNAME).1.gz $(MANDIR)/$(PKGNAME).1.gz
	cp LICENSE $(LICENSEDIR)/LICENSE
	cp $(LIB) $(LIBDIR)/liblist.sh
	cp mons $(BINDIR)/mons

uninstall:
	$(RM) -r $(LIBDIR)
	$(RM) $(BINDIR)/mons

.PHONY: install uninstall

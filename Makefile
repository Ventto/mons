BINDIR  = $(DESTDIR)/usr/bin
LIBDIR  = $(DESTDIR)/usr/lib/posix-shell-list
LIB     = posix-shell-list/list.sh

install:
	@if ! [ -r "$(LIB)" ]; then \
		echo "$(LIB): missing file"; \
		exit 1; \
	fi
	mkdir -p $(LIBDIR)
	mkdir -p $(BINDIR)
	chmod 644 $(LIB)
	chmod 755 mons
	cp $(LIB) $(LIBDIR)/list.sh
	cp mons $(BINDIR)/mons

uninstall:
	$(RM) -r $(LIBDIR)
	$(RM) $(BINDIR)/mons

.PHONY: install uninstall

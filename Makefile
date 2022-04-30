PREFIX ?= /usr/local
MANPREFIX ?= $(PREFIX)/share/man
# If set, must be suffixed with a '/'
DESTDIR ?= 

.PHONY: all test install uninstall

test:
	./pic2img -k -b <test/diag.pic | display

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	install -m 755 pic2img $(DESTDIR)$(PREFIX)/bin
	install -m 644 pic2img.1 $(DESTDIR)$(MANPREFIX)/man1


uninstall: 
	rm -f $(DESTDIR)$(PREFIX)/bin/pic2img
	rm -f $(DESTDIR)$(MANPREFIX)/man1/pic2img.1



PREFIX ?= /usr/local
MANPREFIX ?= $(PREFIX)/share/man
# If set, must be suffixed with a '/'
DESTDIR ?= 

TEST_ARGS = -f PNG -q 2 -s 700x -k -b

.PHONY: all test install uninstall

test:
	DEBUG=yes ./pic2img $(TEST_ARGS) -set colorspace Gray -define png:compression-level=9 -define png:format=8 -define png:color-type=0 -define png:bit-depth=8 <test/diag.pic | tee test/diag.png | display
	which pngquant 2>&1 1>/dev/null && pngquant 8 -f --ext .png test/diag.png

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	install -m 755 pic2img $(DESTDIR)$(PREFIX)/bin
	install -m 644 pic2img.1 $(DESTDIR)$(MANPREFIX)/man1


uninstall: 
	rm -f $(DESTDIR)$(PREFIX)/bin/pic2img
	rm -f $(DESTDIR)$(MANPREFIX)/man1/pic2img.1

README.md:
	./pic2img -h | sed 's/^pic2img/***pic2img***/ ; s/groff/*groff*/ ; s/pic2graph/*pic2graph*/' > README.md
	echo -e "# Example\n\n\`pic2img $(TEST_ARGS)\` turns this:\n\`\`\`" >> README.md
	cat ./test/diag.pic >> README.md
	echo -e "\`\`\`\ninto this:\n" >> README.md
	echo -e "<img src=https://raw.githubusercontent.com/sylsau/pic2img/master/test/diag.png width=700>" >> README.md


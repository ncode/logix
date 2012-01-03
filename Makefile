.PHONY: install
DESTDIR=$(PWD)/debian/logix

install:
	install -d --mode=755 $(DESTDIR)
	install -d --mode=755 $(DESTDIR)/usr/bin
	install -d --mode=755 $(DESTDIR)/etc/logix
	install -v --mode=755 src/bin/logix $(DESTDIR)/usr/bin/logix
	install -v --mode=755 src/etc/logix.conf $(DESTDIR)/etc/logix/logix.conf

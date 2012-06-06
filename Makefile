.PHONY: install
DESTDIR=$(CURDIR)/debian/logix
SRCDIR=$(CURDIR)

install:
	install -d --mode=755 $(DESTDIR)
	install -d --mode=755 $(DESTDIR)/usr/sbin
	install -d --mode=755 $(DESTDIR)/etc/logix
	install -d --mode=755 $(DESTDIR)/etc/rsyslog.d
	install -v --mode=755 $(SRCDIR)/src/sbin/logix $(DESTDIR)/usr/sbin/logix
	install -v --mode=644 $(SRCDIR)/src/etc/logix.conf $(DESTDIR)/etc/logix/logix.conf
	install -v --mode=644 $(SRCDIR)/src/rsyslog.d/logix.conf $(DESTDIR)/etc/rsyslog.d/logix.conf

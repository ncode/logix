.PHONY: install
DESTDIR=$(PWD)/debian/logix

install:
	install -d --mode=755 $(DESTDIR)
	install -d --mode=755 $(DESTDIR)/usr/sbin
	install -d --mode=755 $(DESTDIR)/etc/logix
	install -d --mode=755 $(DESTDIR)/etc/rsyslog.d
	install -v --mode=755 src/bin/logix $(DESTDIR)/usr/sbin/logix
	install -v --mode=755 src/etc/logix.conf $(DESTDIR)/etc/logix/logix.conf
	install -v --mode=755 src/rsyslog.d/logix.conf $(DESTDIR)/etc/rsyslog.d/logix.conf

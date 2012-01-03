.PHONY: install

install:
	install -d --mode=755 --owner=root --group=root $(DESTDIR)/bin
	install -d --mode=755 --owner=root --group=root $(DESTDIR)/etc/logix
	install -v --mode=755 --owner=root --group=root src/bin/logix $(DESTDIR)/bin/logix
	install -v --mode=755 --owner=root --group=root src/etc/logix.conf $(DESTDIR)/etc/logix/logix.conf

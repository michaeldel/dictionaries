include config.mk

install:
	install -d $(DESTDIR)$(PREFIX)/share/dict
	install -m 644 adjectives animals colors countries names star-wars \
		$(DESTDIR)$(PREFIX)/share/dict

uninstall:
	pushd $(DESTDIR)$(PREFIX)/share/dict && \
	rm -f adjectives animals colors countries names star-wars && \
	popd

.PHONY: install uninstall

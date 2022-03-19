include config.mk

docker-url = 'https://raw.githubusercontent.com/moby/moby/master/pkg/namesgenerator/names-generator.go' 

all: docker/adjectives docker/names

docker/adjectives:
	mkdir -p docker
	curl -sSL $(docker-url) | \
		sed -n '/^var (/,/^)$$/p' | \
		sed -n '/left =/,/}$$/p' | \
		sed -n -E 's/\t*"(.+)",$$/\1/p' \
		> $@

docker/names:
	mkdir -p docker
	curl -sSL $(docker-url) | \
		sed -n '/^var (/,/^)$$/p' | \
		sed -n '/right =/,/}$$/p' | \
		sed -n -E 's/\t*"(.+)",$$/\1/p' \
		> $@

install:
	install -d $(DESTDIR)$(PREFIX)/share/dict
	install -m 644 adjectives animals colors countries elements names star-wars \
		$(DESTDIR)$(PREFIX)/share/dict

uninstall:
	pushd $(DESTDIR)$(PREFIX)/share/dict && \
	rm -f adjectives animals colors countries elements names star-wars && \
	popd

clean:
	rm -rf docker

.PHONY: all clean install uninstall

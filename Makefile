include config.mk

docker-url = 'https://raw.githubusercontent.com/moby/moby/master/pkg/namesgenerator/names-generator.go' 

all: docker/adjectives docker/names
dictionaries = adjectives animals colors countries elements names star-wars

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

check: $(dictionaries)
	@for f in $^; do \
		diff $$f <(./scripts/trim.sh $$f) > /dev/null || echo "$$f must be trimmed"; \
	done

trim: $(dictionaries)
	for f in $^; do \
		diff $$f <(./scripts/trim.sh $$f) > /dev/null || ./scripts/trim.sh -i $$f; \
	done

install: $(dictionaries)
	install -d $(DESTDIR)$(PREFIX)/share/dict
	install -m 644 $(dictionaries) $(DESTDIR)$(PREFIX)/share/dict

uninstall: $(dictionaries)
	pushd $(DESTDIR)$(PREFIX)/share/dict && \
	rm -f $(dictionaries) && popd

clean:
	rm -rf docker

.PHONY: all check clean install trim uninstall

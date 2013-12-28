COFFEE = node_modules/.bin/coffee
DOCTEST = node_modules/.bin/doctest --module commonjs
SEMVER = node_modules/.bin/semver

SRC_IMAGES = $(shell find src/svg -type f)
SVG_IMAGES = $(patsubst src/svg/%.coffee,lib/svg/%.svg,$(SRC_IMAGES))
PNG_IMAGES = $(patsubst lib/svg/%.svg,lib/png/%@2x.png,$(SVG_IMAGES))
LIB = lib/orthogonal.js $(SVG_IMAGES) $(PNG_IMAGES)


.PHONY: all
all: $(LIB)

lib/%.js: src/%.coffee
	$(COFFEE) --compile --output '$(@D)' -- '$<'

lib/%.svg: src/%.coffee
	mkdir -p '$(@D)'
	$(COFFEE) '$<' >'$@'

lib/png/%@2x.png: lib/svg/%.svg
	mkdir -p '$(@D)'
	rsvg-convert --format=png --zoom=2.0 '$<' >'$@'


.PHONY: clean
clean:
	rm -f -- $(LIB)


.PHONY: release-patch release-minor release-major
VERSION = $(shell node -p 'require("./package.json").version')
release-patch: NEXT_VERSION = $(shell $(SEMVER) -i patch $(VERSION))
release-minor: NEXT_VERSION = $(shell $(SEMVER) -i minor $(VERSION))
release-major: NEXT_VERSION = $(shell $(SEMVER) -i major $(VERSION))

release-patch release-minor release-major:
	@printf 'Current version is $(VERSION). This will publish version $(NEXT_VERSION). Press [enter] to continue.' >&2
	@read
	node -e '\
		var o = require("./package.json"); o.version = "$(NEXT_VERSION)"; \
		require("fs").writeFileSync("./package.json", JSON.stringify(o, null, 2) + "\n")'
	git commit --message '$(NEXT_VERSION)' -- package.json
	git tag --annotate '$(NEXT_VERSION)' --message '$(NEXT_VERSION)'
	git push origin refs/heads/master 'refs/tags/$(NEXT_VERSION)'
	npm publish


.PHONY: setup
setup:
	npm install


.PHONY: test
test:
	find src -name '*.coffee' -not -path 'src/svg/*' -print0 | xargs -0 $(DOCTEST)

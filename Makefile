COFFEE = node_modules/.bin/coffee
DOCTEST = node_modules/.bin/doctest --module commonjs
XYZ = node_modules/.bin/xyz --message X.Y.Z --tag X.Y.Z --repo git@github.com:davidchambers/orthogonal.git --script scripts/prepublish

SRC_IMAGES = $(shell find src/svg -type f)
SVG_IMAGES = $(patsubst src/svg/%.coffee,lib/svg/%.svg,$(SRC_IMAGES))
LIB = lib/orthogonal.js $(SVG_IMAGES)


.PHONY: all
all: $(LIB)

lib/%.js: src/%.coffee
	$(COFFEE) --compile --output '$(@D)' -- '$<'

lib/%.svg: src/%.coffee
	mkdir -p '$(@D)'
	$(COFFEE) '$<' >'$@'


.PHONY: clean
clean:
	rm -f -- $(LIB)


.PHONY: release-major release-minor release-patch
release-major release-minor release-patch:
	@$(XYZ) --increment $(@:release-%=%)


.PHONY: setup
setup:
	npm install
	make clean
	git update-index --assume-unchanged lib/orthogonal.js


.PHONY: test
test:
	find src -name '*.coffee' -not -path 'src/svg/*' -print0 | xargs -0 $(DOCTEST)

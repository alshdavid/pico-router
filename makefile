CONCURRENTLY := npx concurrently --kill-others
WAIT_ON := npx wait-on

ARTIFACT_KIT="./src/kit/dist/index.js"
ARTIFACT_CRAYON="./src/crayon/dist/lib/index.js"

DIR_ANIMATE := cd src/animate
DIR_CRAYON := cd src/crayon
DIR_KIT := cd src/kit
DIR_PREACT := cd src/preact
DIR_REACT := cd src/react
DIR_SVELTE := cd src/svelte
DIR_TRANSITION := cd src/transition
DIR_VUE := cd src/vue

ANIMATE := $(DIR_ANIMATE) && pnpm run
CRAYON := $(DIR_CRAYON) && pnpm run
KIT := $(DIR_KIT) && pnpm run
PREACT := $(DIR_PREACT) && pnpm run
REACT := $(DIR_REACT) && pnpm run
SVELTE := $(DIR_SVELTE) && pnpm run
TRANSITION := $(DIR_TRANSITION) && pnpm run
VUE := $(DIR_VUE) && pnpm run


default: clean build test

clean-hard:
	git clean -d -f
	git clean -d -f -X

upgrade:
	$(DIR_KIT) && ncu -u
	$(DIR_ANIMATE) && ncu -u
	$(DIR_PREACT) && ncu -u
	$(DIR_REACT) && ncu -u
	$(DIR_CRAYON) && ncu -u
	$(DIR_SVELTE) && ncu -u
	$(DIR_TRANSITION) && ncu -u
	$(DIR_VUE) && ncu -u

clean:
	$(ANIMATE) clean
	$(CRAYON) clean
	$(KIT) clean
	$(PREACT) clean
	$(REACT) clean
	$(SVELTE) clean
	$(TRANSITION) clean
	$(VUE) clean
	cd src && find . -name dist -exec rm -r -f '{}' +
	cd examples && find . -name dist -exec rm -r -f '{}' +
	cd examples && find . -name build -exec rm -r -f '{}' +

build:
	make clean
	$(KIT) build
	$(CRAYON) build
	$(ANIMATE) build
	$(PREACT) build
	$(REACT) build
	$(SVELTE) build
	$(TRANSITION) build
	$(VUE) build

dev:
	make clean
	$(CONCURRENTLY) \
		"$(KIT) build-watch" \
		"$(WAIT_ON) ${ARTIFACT_KIT} && $(CRAYON) build-watch" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(ANIMATE) build-watch" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(PREACT) build-watch" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(REACT) build-watch" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(SVELTE) build-watch" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(TRANSITION) build-watch" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(VUE) build-watch"

dev-prod:
	make clean
	$(CONCURRENTLY) \
		"$(KIT) build:watch:prod" \
		"$(WAIT_ON) ${ARTIFACT_KIT} && $(CRAYON) build-watch-prod" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(ANIMATE) build-watch-prod" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(PREACT) build-watch-prod" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(REACT) build-watch-prod" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(SVELTE) build-watch-prod" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(TRANSITION) build-watch-prod" \
		"$(WAIT_ON) ${ARTIFACT_CRAYON} && $(VUE) build-watch-prod"

test:
	$(KIT) test
	$(CRAYON) test
	$(ANIMATE) test
	$(PREACT) test
	$(REACT) test
	$(SVELTE) test
	$(TRANSITION) test
	$(VUE) test
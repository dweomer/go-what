REPO ?= dweomer/what
TAG  ?= $(if $(DRONE_TAG),$(DRONE_TAG),$(shell git describe --tags --always))

DOCKERIZED_TAG 	?= $(if $(TAG),$(subst +,-,$(TAG)),latest)

GOARCH ?= $(shell go env GOARCH)
ifeq (arm,$(GOARCH))
GOARM ?= $(shell go env GOARM)
endif

ci: $(file > .tags,$(DOCKERIZED_TAG)) | build package

build: dist/artifacts/what-$(GOARCH)
	@file $<

package: dist/artifacts/what-$(GOARCH).tar

clean:
	@rm -rf ./bin ./dist ./build

bin/what:
	@go build -o $@ ./cmd/what/.

dist/artifacts/what-$(GOARCH): $(shell mkdir -p dist/artifacts) | bin/what
	@install -s bin/what dist/artifacts/what-$(GOARCH)

dist/artifacts/what-$(GOARCH).tar: dist/artifacts/what-$(GOARCH)
	@docker build --build-arg GOARCH=$(GOARCH) --tag dweomer/what:$(DOCKERIZED_TAG) --target=package .
	@docker save --output dist/artifacts/what-$(GOARCH).tar dweomer/what:$(DOCKERIZED_TAG)

.PHONY: build package clean ci .tags

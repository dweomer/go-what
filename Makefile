DRONE_TAG ?= latest
DOCKERIZED_TAG = $(subst +,-,$(DRONE_TAG))

GOARCH ?= $(shell go env GOARCH)
ifeq (GOARCH,arm)
GOARM ?= $(shell go env GOARM)
endif

build: dist/artifacts/what-$(GOARCH)

ci: build package

clean:
	@rm -rf ./bin ./dist ./build

dist/artifacts:
	mkdir -vp dist/artifacts

dist/artifacts/what-$(GOARCH): dist/artifacts
	go build -o $@ ./cmd/what/.

package:
	docker build --tag dweomer/what:$(DOCKERIZED_TAG) --target=package .

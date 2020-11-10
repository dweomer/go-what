DRONE_TAG ?= latest
DOCKERIZED_TAG = $(subst +,-,$(DRONE_TAG))

GOARCH ?= $(shell go env GOARCH)
ifeq (GOARCH,arm)
GOARM ?= $(shell go env GOARM)
endif

ci: build package

build: bin/what
	@file $<

bin/what:
	go build -o $@ ./cmd/what/.

clean:
	@rm -rf ./bin ./dist ./build

dist/artifacts:
	mkdir -vp dist/artifacts

dist/artifacts/what-$(GOARCH): dist/artifacts bin/what
	cp -vf bin/what dist/artifacts/what-$(GOARCH)

dist/artifacts/what-$(GOARCH).tar: dist/artifacts Dockerfile machine.go
	docker build --tag dweomer/what:$(DOCKERIZED_TAG) --target=package .
	docker save --output dist/artifacts/what-$(GOARCH).tar dweomer/what:$(DOCKERIZED_TAG)

package: dist/artifacts/what-$(GOARCH) dist/artifacts/what-$(GOARCH).tar

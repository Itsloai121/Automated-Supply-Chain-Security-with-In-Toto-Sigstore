SHELL := /usr/bin/env bash
IMAGE ?= chainshield:dev

.PHONY: test vet fmt-check run image policy-test render deploy install-hooks

test:
	go test -race -cover ./...

vet:
	go vet ./...

fmt-check:
	@test -z "$$(gofmt -l app)" || (echo "Run: gofmt -w app"; exit 1)

run:
	go run ./app

image:
	docker build --build-arg VERSION=dev --build-arg COMMIT=$$(git rev-parse --short HEAD) --build-arg BUILD_DATE=$$(date -u +%Y-%m-%dT%H:%M:%SZ) -t $(IMAGE) .

policy-test:
	conftest test deploy/base --policy policies/opa

render:
	kubectl kustomize deploy/base

deploy:
	kubectl apply -k deploy/base

install-hooks:
	./scripts/install-git-hooks.sh

SHELL:= bash

DOCKER_COMPOSE_RUN := docker-compose run --rm 

export DOCKER_GROUP_ID := $(shell getent group docker | cut -d: -f3)

_build:
	docker-compose build

_test:
	$(DOCKER_COMPOSE_RUN) pulumi bash

.PHONY: test
test: _build _test

_setup:
	$(DOCKER_COMPOSE_RUN) pulumi  scripts/strimzi-install.sh
	kind export kubeconfig > /tmp/kind-kubeconfig
	KUBECONFIG=~/.kube/config:/tmp/kind-kubeconfig kubectl config view --flatten > ~/.kube/merged_kubeconfig && mv ~/.kube/merged_kubeconfig ~/.kube/config


.PHONY: setup
setup: _build _setup

_demo: 
	kubectl apply -f ./scripts/kafka.yaml
	kubectl apply -f ./scripts/dashboard-access.yaml
	kubectl apply -f ./scripts/app.yaml

.PHONY: demo
demo: _demo

_clean:
	$(DOCKER_COMPOSE_RUN) pulumi kind delete cluster

.PHONY: clean
clean: _clean

_help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  test: Run tests"
	@echo "  setup: Setup the environment"
	@echo "  demo: Deploy the demo"
	@echo "  clean: Clean the environment"
	@echo "  help: Show this help message"

.PHONY: help
help: _help
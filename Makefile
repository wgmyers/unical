# Self-documenting Makefile
# See https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/

MAKEFILE_LIST ?= Makefile

.PHONY: help install install-bundle test

help: ## Show this help
	@egrep -h '[[:space:]]##[[:space:]]' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: install-bundle ## Install everything (just run bundle for now)

install-bundle: ## Run bundle install
	bundle install --path vendor/bundle

test: ## Run tests
	cd test; ./test_output.rb

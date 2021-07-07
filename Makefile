IMAGE=devops
TAG=1.0.1
CMD=sh
PACKAGE_MOUNT=$(shell pwd)/package:/app
BUILD_DIR=.
DOCKERFILE=docker/Dockerfile
TERRAFORM_VERSION=1.0.1
TEST_WS=test
DEV_WS=dev
PROD_WS=prod


build:
	docker build --build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION)  -t $(IMAGE):$(TAG) -f $(DOCKERFILE) $(BUILD_DIR)
.PHONY: build

run:
	docker run -v $(PACKAGE_MOUNT) $(IMAGE):$(TAG)
.PHONY: run

debug:
	docker run -v $(PACKAGE_MOUNT) -ti --entrypoint=$(CMD) $(IMAGE):$(TAG)
.PHONY: debug

_workspace:
	docker exec $(IMAGE):$(TAG) workspace new $(WORKSPACE)
.phony: _workspaces

workspaces:
	$(MAKE) _workspace WORKSPACE=$(TEST_WS)
	$(MAKE) _workspace WORKSPACE=$(DEV_WS)
	$(MAKE) _workspaces WORKSPACE=$(PROD_WS)
.phony: _workspaces
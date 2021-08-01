IMAGE=paulb/devops
TAG=1.0.1
DOCKER_VERSION=20.10.7
TERRAFORM_VERSION=1.0.3
HELM_VERSION=3.0.0
CMD=terraform
PACKAGE_VOL=$(shell pwd):/app
BUILD_DIR=.
DOCKERFILE=docker-images/ops/Dockerfile
VAR_FILE=/app/config/vars.tfvars
TEST_WS=test
DEV_WS=dev
PROD_WS=prod




build:
	docker build --build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION)  --build-arg DOCKER_VERSION=$(DOCKER_VERSION) \
	--build-arg HELM_VERSION=$(HELM_VERSION) -t $(IMAGE):$(TAG) -f $(DOCKERFILE) $(BUILD_DIR)
.PHONY: build

# run:
# 	docker run -v $(PACKAGE_VOL) $(IMAGE):$(TAG) sh -c "cd gcp-cluster && terraform apply -f -var-file"
# .PHONY: run

debug:
	docker run -v $(PACKAGE_VOL) -ti $(IMAGE):$(TAG)
.PHONY: debug


_workspace:
	docker exec $(IMAGE):$(TAG) workspace new $(WORKSPACE)
.PHONY: _workspaces

workspaces:
	$(MAKE) _workspace WORKSPACE=$(TEST_WS)
	$(MAKE) _workspace WORKSPACE=$(DEV_WS)
	$(MAKE) _workspaces WORKSPACE=$(PROD_WS)
.phony: _workspaces
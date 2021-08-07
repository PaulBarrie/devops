.DEFAULT_GOAL := help

SCRIPT_VERSION=v1.0
SCRIPT_AUTHOR="Paul Barrié"

IMAGE=paulb/devops
TAG=1.0.1
CONTAINER=cloud-svc
DOCKER_VERSION="20.10.7"

AZURE_CLI_VERSION="2.27.0"
TERRAFORM_VERSION="1.0.3"
HELM_VERSION="3.6.3"
CMD="sleep infinity"
PACKAGE_VOL=$(shell pwd)/app:/app
BUILD_DIR=.
DOCKERFILE=Dockerfile
VAR_FILE=/app/config/vars.tfvars
TEST_WS=test
DEV_WS=dev
PROD_WS=prod

CLOUD_PROVIDER=azure #none #gcp aws
GCP_KEY=keys/gcp-key.json
AZURE_KEY=keys/azure-key.json

#help:  @ List available tasks on this project
# help: 
# 	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| sort | tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
# .PHONY: help

build-docker: 		#help: @ Build the docker image
	DOCKER_BUILDKIT=1 docker build --secret id=azure-key,src=$(AZURE_KEY) \
	--target $(CLOUD_PROVIDER) \
	--build-arg TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
	--build-arg AZURE_CLI_VERSION=$(AZURE_CLI_VERSION) \
	--build-arg GCP_KEY=$(GCP_KEY) \
	--build-arg DOCKER_VERSION=$(DOCKER_VERSION) \
	--build-arg HELM_VERSION=$(HELM_VERSION) \
	-t $(IMAGE):$(TAG) -f $(DOCKERFILE) $(BUILD_DIR)
.PHONY: build-docker


rm-docker:
	docker rm --force $(CONTAINER)
vendor-gcp: rm-docker

run-docker: rm-docker
	docker run -d -v $(PACKAGE_VOL) --name $(CONTAINER) $(IMAGE):$(TAG) $(CMD)
.PHONY: run-docker

runit-docker: rm-docker
	docker run -ti --entrypoint=sh -v $(PACKAGE_VOL) --name $(CONTAINER) $(IMAGE):$(TAG)
.PHONY: runit-docker

vendor-gcp:
	docker exec $(CONTAINER) ./cloud-provider.sh install_gcp
.PHONY: vendor-gcp

auth-gcp: run-docker
	docker cp $(IMAGE):$(TAG):$(GCP_KEY) /etc/pwd/gcp-key.json 
	docker exec $(CONTAINER) bash -c  "./cloud-provider.sh auth_gcp"
.PHONY: auth-gcp

vendor-azure: run-docker
	docker run $(IMAGE):$(TAG) ./cloud-provider.sh install_azure
.PHONY: vendor-azure

auth-azure: run-docker
	docker cp $(IMAGE):$(TAG):$(GCP_KEY) /etc/pwd/azure-key.json 
	docker exec $(IMAGE):$(TAG) bash -c  "./cloud-provider.sh auth_azure"
.PHONY: auth-azure

all: _build_docker run-docker

vendor-all: vendor-gcp vendor-azure
.PHONHY: vendor-all






azure-tf:
	@echo "terraform apply"
.PHONY: azure-tf


gcp-tf:
	@echo "terraform apply"
.PHONY: gcp-tf

_workspace:of the docker image
	docker exec $(IMAGE):$(TAG) workspace new $(WORKSPACE)
.PHONY: _workspaces

workspaces:
	$(MAKE) _workspace WORKSPACE=$(TEST_WS)
	$(MAKE) _workspace WORKSPACE=$(DEV_WS)
	$(MAKE) _workspaces WORKSPACE=$(PROD_WS)
.phony: _workspaces

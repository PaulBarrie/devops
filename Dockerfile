# syntax=docker/dockerfile:1

ARG DOCKER_VERSION=20.10.7

FROM docker:${DOCKER_VERSION} as none

ARG TERRAFORM_VERSION
ARG HELM_VERSION
ARG GCP_KEY
ARG AZURE_CLI_VERSION

ENV AZURE_CLI_VERSION=${AZURE_CLI_VERSION}
ENV GCP_KEY=${GCP_KEY}
ENV AZURE_CLI_VERSION=${AZURE_CLI_VERSION}

#Install dependencies
ENV PYTHONUNBUFFERED=1


RUN apk update && apk add --no-cache --upgrade make curl gcc libffi-dev musl-dev \
     openssl-dev make bash jq && mkdir -p /etc/pwd

# Install terraform
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip &&\
    unzip terraform.zip && rm terraform.zip && mv terraform /usr/bin/terraform

#Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl &&\
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl 

# Install helm
RUN mkdir helm && wget -O helm.tar.gz https://github.com/helm/helm/archive/refs/tags/v${HELM_VERSION}.tar.gz &&\
    tar -C helm -zxvf helm.tar.gz  && rm -rf helm.tar.gz &&\
    mv helm /usr/local/bin/helm

WORKDIR /app

FROM none as gcp
#Install GCP client
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz &&\
    mkdir -p /usr/local/gcloud &&\
    tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz &&\
    /usr/local/gcloud/google-cloud-sdk/install.sh --quiet 

# Adding the package path to local²
ENV PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin

#Configure GCP access
ENV GOOGLE_APPLICATION_CREDENTIALS "/etc/pwd/gcp-key.json"

FROM none as azure
# Install Azure client
# ENV UID=12345
# ENV GID=23456

# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "$(pwd)" \
#     --ingroup "pip" \
#     --no-create-home \
#     --uid "$UID" \
#     "$USER"

RUN apk add py-pip && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make &&\
    pip --no-cache install azure-cli==${AZURE_CLI_VERSION}
# Login Azure
# RUN --mount=type=secret,id=azure-key,dst=/run/secrets/azure-key \
#     az login  -u $($(cat /run/secrets/azure-key) | jq '.login') -p $($(cat /run/secrets/azure-key) | jq '.password')



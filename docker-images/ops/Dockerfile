ARG DOCKER_VERSION=20.10.7
ARG TERRAFORM_VERSION=1.0.3
ARG HELM_VERSION=3.0.0

FROM docker:${DOCKER_VERSION}
USER root
RUN apk update && apk add --no-cache curl bash python3 py3-pip &&\
    curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz &&\
    mkdir -p /usr/local/gcloud &&\
    tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz &&\
    /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
ADD package/config/key.json /pwd/gcp/credentials.json
ENV GOOGLE_APPLICATION_CREDENTIALS "/pwd/gcp/credentials.json"


# Install terraform
RUN wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION/terraform_${ TERRAFORM_VERSION}_linux_amd64.zip &&\
    unzip terraform.zip && rm terraform.zip && mv terraform /usr/bin/terraform



#Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl &&\
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl 

RUN wget https://github.com/helm/helm/releases/tag/v3.6.3 &&\
    tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz &&\
    mv linux-amd64/helm /usr/local/bin/helm

WORKDIR /app
COPY package .

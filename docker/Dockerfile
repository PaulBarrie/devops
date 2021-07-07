ARG TERRAFORM_VERSION=1.0.1
FROM hashicorp/terraform:latest


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
WORKDIR /app
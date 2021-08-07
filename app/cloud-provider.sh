#!/bin/bash

set -e

function install_azure() {
  pip3 --no-cache-dir install azure-cli==AZURE_CLI_VERSION
}

function install_gcp() {
  if ! az -v COMMAND &> /dev/null; then
    curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz &&\
    mkdir -p /usr/local/gcloud &&\
    tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz &&\
    /usr/local/gcloud/google-cloud-sdk/install.sh --quiet
  else
    echo "GCP CLI  already installed, nothing to do."
  fi
}

function install_all() {  
    install_azure
    install_gcp
}

function auth_azure() {
  az login  --username $(cat /etc/pwd/pwd| jq '.appId') \
  --password $(cat /run/secrets/azure-key | jq '.password') \
  --tenant $(cat /run/secrets/azure-key | jq '.tenant')
}

function auth_gcp() {

}



$*
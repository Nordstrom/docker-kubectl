#!/bin/bash
: ${CA_CERT?"Need to set CA_CERT"}
: ${USER_CERT?"Need to set USER_CERT"}
: ${USER_KEY?"Need to set USER_KEY"}

if [[ -z ${PLATFORM_URL} ]]; then : ${platform_env?"Need to set platform_env. Valid values: prod, nonprod"}; fi

mkdir -p ~/.kube
echo "$CA_CERT" > ~/.kube/ca.pem
echo "$USER_KEY" > ~/.kube/user-key.pem
echo "$USER_CERT" > ~/.kube/user.pem

platform_url=${PLATFORM_URL:=https://current.platform.r53.nordstrom.net}

kubectl config set-cluster platform \
  --server=${platform_url} \
  --certificate-authority=${HOME}/.kube/ca.pem

kubectl config set-credentials platform_user \
  --client-key=${HOME}/.kube/user-key.pem \
  --client-certificate=${HOME}/.kube/user.pem

kubectl config set-context platform \
  --cluster=platform \
  --user=platform_user

kubectl config use-context platform

#!/bin/bash
if [ -z ${CA} ]; then echo "CA is undefined"; exit 1; fi
if [ -z ${USER} ]; then echo "USER is undefined"; exit 1; fi
if [ -z ${USER_KEY} ]; then echo "USER_KEY is undefined"; exit 1; fi
if [ -z ${PLATFORM_URL} ]; then echo "platform is undefined"; exit 1; fi

mkdir -p ~/.kube
echo "$CA" > ~/.kube/ca.pem
echo "$USER_KEY" > ~/.kube/user-key.pem
echo "$USER" > ~/.kube/user.pem

kubectl config set-cluster platform \
  --server=${PLATFORM_URL} \
  --certificate-authority=${HOME}/.kube/ca.pem

kubectl config set-credentials platform_user \
  --client-key=${HOME}/.kube/user-key.pem \
  --client-certificate=${HOME}/.kube/user.pem

kubectl config set-context platform \
  --cluster=platform \
  --user=platform_user

kubectl config use-context platform
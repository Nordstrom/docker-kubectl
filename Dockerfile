FROM quay.io/nordstrom/baseimage-ubuntu:16.04
MAINTAINER Store Platform Team "invcldtm@nordstrom.com"

ARG KUBECTL_RELEASE
ENV KUBECTL_RELEASE ${KUBECTL_RELEASE}

USER root

ADD setup_kubectl.sh /usr/local/bin

RUN chmod +x /usr/local/bin/setup_kubectl.sh

RUN apt-get update -qy \
 && apt-get install -qy make gettext-base jq \
 && curl -sLo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl \
 && chmod +x /usr/bin/kubectl

USER ubuntu

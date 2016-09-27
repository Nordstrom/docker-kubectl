FROM quay.io/nordstrom/baseimage-ubuntu:16.04
MAINTAINER Store Platform Team "invcldtm@nordstrom.com"

ARG KUBECTL_RELEASE
ENV KUBECTL_RELEASE ${KUBECTL_RELEASE}

ADD SHA256SUMS.kubectl /tmp/SHA256SUMS.kubectl
ADD setup_kubectl.sh /usr/local/bin

USER root

RUN chmod +x /usr/local/bin/setup_kubectl.sh

RUN apt-get update -qy \
 && apt-get install -qy make gettext-base \
 && curl -sLo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl \
 && cd /usr/bin/ \
 && sha256sum -c /tmp/SHA256SUMS.kubectl \
 && chmod +x /usr/bin/kubectl

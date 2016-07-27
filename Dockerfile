FROM quay.io/nordstrom/baseimage-ubuntu:16.04
MAINTAINER Store Platform Team "invcldtm@nordstrom.com"

ARG KUBECTL_RELEASE
ADD SHA256SUMS.kubectl /tmp/SHA256SUMS.kubectl

USER root

RUN curl -sLo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl \
 && cd /usr/bin/ \
 && sha256sum -c /tmp/SHA256SUMS.kubectl \
 && chmod +x /usr/bin/kubectl

USER ubuntu

ENTRYPOINT ["/usr/bin/kubectl"]

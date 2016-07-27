FROM quay.io/nordstrom/baseimage-ubuntu:16.04
MAINTAINER Store Platform Team "invcldtm@nordstrom.com"

ENV KUBECTL_RELEASE=1.2.2
ADD SHA256SUMS /tmp/SHA256SUMS

RUN apt-get update -qy \
 && apt-get install -qy curl \
 && curl -sLo /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl \
 && cd /tmp/ \
 && sha256sum -c SHA256SUMS \
 && mv /tmp/kubectl /usr/bin/kubectl \
 && chmod +x /usr/bin/kubectl

ENTRYPOINT ["/usr/bin/kubectl"]

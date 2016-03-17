FROM quay.io/nordstrom/baseimage-ubuntu:16.04
MAINTAINER Store Platform Team "invcldtm@nordstrom.com"

RUN apt-get update -qy \
 && apt-get install -qy curl \
 && curl -sLo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.2.0/bin/linux/amd64/kubectl \
 && chmod +x /usr/bin/kubectl

ENTRYPOINT ["/usr/bin/kubectl"]

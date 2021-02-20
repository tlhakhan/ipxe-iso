FROM ubuntu:20.04

# ipxe version
ENV IPXE_VERSION=v1.21.1

WORKDIR /build

# list of packages
COPY packages /packages

# ipxe script to embed
COPY run.ipxe /build/run.ipxe

# install build tools
RUN apt-get update && \
    xargs -a /packages -t -n1 apt-get install -y

RUN git clone -b ${IPXE_VERSION} https://github.com/ipxe/ipxe

# src overrides 
COPY src/config/general.h /build/ipxe/src/config/general.h

# make
RUN cd ipxe/src && \
    make all EMBED=/build/run.ipxe && \
    mv bin/ipxe.iso /build/ipxe.iso

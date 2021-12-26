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
RUN sed -ie 's/\/\/#define\tIMAGE_COMBOOT/#define\tIMAGE_COMBOOT/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define NSLOOKUP_CMD/#define\tNSLOOKUP_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define VLAN_CMD/#define\tVLAN_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define REBOOT_CMD/#define\tREBOOT_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define POWEROFF_CMD/#define\tPOWEROFF_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define PING_CMD/#define\tPING_CMD/' /build/ipxe/src/config/general.h

# make
RUN cd ipxe/src && \
    make all EMBED=/build/run.ipxe && \
    mv bin/ipxe.iso /build/ipxe.iso

FROM ubuntu:20.04

# ipxe version
ENV IPXE_VERSION=v1.21.1

# build area
WORKDIR /build

# ipxe script to embed
COPY run.ipxe /build/run.ipxe

# list of packages
COPY packages /packages

# install build tools
RUN apt-get update && \
    xargs -a /packages -t -n1 apt-get install -y

# clone the ipxe repo
RUN git clone -b ${IPXE_VERSION} https://github.com/ipxe/ipxe

#
# overrides on the general.h config file

# the IMAGE_COMBOOT is needed to iPXE ESXi kernel
RUN sed -ie 's/\/\/#define\tIMAGE_COMBOOT/#define\tIMAGE_COMBOOT/' /build/ipxe/src/config/general.h

# nice commands to have in the iPXE shell for debugging
RUN sed -ie 's/\/\/#define NSLOOKUP_CMD/#define\tNSLOOKUP_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define VLAN_CMD/#define\tVLAN_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define REBOOT_CMD/#define\tREBOOT_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define POWEROFF_CMD/#define\tPOWEROFF_CMD/' /build/ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define PING_CMD/#define\tPING_CMD/' /build/ipxe/src/config/general.h

# make the iso, incorporate a simple run.ipxe script
RUN cd ipxe/src && \
    make all EMBED=/build/run.ipxe && \
    mv bin/ipxe.iso /build/ipxe.iso

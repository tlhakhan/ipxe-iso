FROM ubuntu:22.04

# ipxe version
ENV IPXE_VERSION=master

# build area
WORKDIR /build

# install build tools
RUN apt-get update && \
    apt-get install -y build-essential git isolinux liblzma-dev mkisofs

# clone the ipxe repo
RUN git clone -b ${IPXE_VERSION} https://github.com/ipxe/ipxe

# IMAGE_COMBOOT is needed to iPXE ESXi kernel boot
RUN sed -ie 's/\/\/#define\tIMAGE_COMBOOT/#define\tIMAGE_COMBOOT/' ipxe/src/config/general.h
# iPXE commands to have in the iPXE shell for debugging
RUN sed -ie 's/\/\/#define NSLOOKUP_CMD/#define\tNSLOOKUP_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define VLAN_CMD/#define\tVLAN_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define REBOOT_CMD/#define\tREBOOT_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define POWEROFF_CMD/#define\tPOWEROFF_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define PING_CMD/#define\tPING_CMD/' ipxe/src/config/general.h

RUN <<EOF cat > run.ipxe
#!ipxe
shell
EOF

RUN cd ipxe/src && \
    make all EMBED=/build/run.ipxe

FROM busybox:latest
WORKDIR /dist
COPY --from=0 /build/run.ipxe /dist/run.ipxe
COPY --from=0 /build/ipxe/src/bin/ipxe.usb /dist/ipxe.usb
COPY --from=0 /build/ipxe/src/bin/ipxe.iso /dist/ipxe.iso

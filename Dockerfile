FROM ubuntu:22.04

# ipxe version
ENV IPXE_VERSION=master

# build area
WORKDIR /build

# install build tools
RUN apt-get update && \
    apt-get install -y build-essential git isolinux liblzma-dev mkisofs gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# clone the ipxe repo
RUN git clone -b ${IPXE_VERSION} https://github.com/ipxe/ipxe

# Allow download by HTTPS
# https://ipxe.org/buildcfg/download_proto_https
RUN sed -ie 's/#undef	DOWNLOAD_PROTO_HTTPS/#define DOWNLOAD_PROTO_HTTPS/' ipxe/src/config/general.h

# IMAGE_COMBOOT is needed to iPXE ESXi kernel boot
RUN sed -ie 's/\/\/#define IMAGE_COMBOOT/#define IMAGE_COMBOOT/' ipxe/src/config/general.h

# iPXE commands to have in the iPXE shell for debugging
RUN sed -ie 's/\/\/#define NSLOOKUP_CMD/#define NSLOOKUP_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define VLAN_CMD/#define VLAN_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define REBOOT_CMD/#define REBOOT_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define POWEROFF_CMD/#define POWEROFF_CMD/' ipxe/src/config/general.h
RUN sed -ie 's/\/\/#define PING_CMD/#define PING_CMD/' ipxe/src/config/general.h

RUN <<EOF cat > run.ipxe
#!ipxe
shell
EOF

RUN cd ipxe/src && \
    make EMBED=/build/run.ipxe CROSS_COMPILE=aarch64-linux-gnu- bin-arm64-efi/snp.efi bin/ipxe.iso bin/ipxe.usb

FROM scratch
WORKDIR /dist
COPY --from=0 /build/ipxe/src/bin/ipxe.usb /dist/ipxe.usb
COPY --from=0 /build/ipxe/src/bin/ipxe.iso /dist/ipxe.iso

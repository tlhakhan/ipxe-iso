#!/bin/bash
set -e

readlink -f . | xargs -n1 basename | figlet
sleep 1

# build the image
docker build . \
  -t ipxe-iso:latest \

# run the container
docker run -it -d  --name ipxe-iso ipxe-iso:latest
# copy out the ipxe.iso file
docker cp ipxe-iso:/build/ipxe.iso .
# stop and remove the container
docker stop ipxe-iso
docker rm ipxe-iso

shasum ipxe.iso > ipxe.iso.sha1
shasum -a 256 ipxe.iso > ipxe.iso.sha256

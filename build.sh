#!/bin/bash
set -e

readlink -f . | xargs -n1 basename | figlet
sleep 1

# build the image
docker build . \
  -t ipxe-iso:latest \

# run the container
docker run -it -d  --name ipxe-iso ipxe-iso:latest

set -x
# make a dist folder
test -d dist || mkdir dist
# copy out the ipxe.iso file
docker cp ipxe-iso:/build/ipxe.iso dist/
# stop and remove the container
docker stop ipxe-iso
docker rm ipxe-iso

# checksums
shasum dist/ipxe.iso > dist/ipxe.iso.sha1
shasum -a 256 dist/ipxe.iso > dist/ipxe.iso.sha256

# display
tree dist

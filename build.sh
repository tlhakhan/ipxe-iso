#!/bin/bash
set -e

readlink -f . | xargs -n1 basename | figlet
sleep 1

docker build . \
  -t ipxe-iso:latest \

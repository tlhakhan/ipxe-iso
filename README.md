# README
This repo helps build a simple iPXE ISO and iPXE USB to drop into the iPXE shell on boot.  This iPXE shell is a perfect landing area for Packer to type boot commands, which can invoke DHCP and chain a templated iPXE script from a webserver elsewhere.

## Releases
Get a copy of the ISO file from the releases section <https://github.com/tlhakhan/ipxe-iso/releases>.

## File list
file | description
--- | ---
`build.sh` | A helper script to kickoff the docker build and copy out the ipxe.iso and ipxe.usb files.
`Dockerfile` | The Dockerfile that builds iPXE.

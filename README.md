# README
This repo helps build a simple iPXE CD to drop into the iPXE shell on boot. 

## Releases
- Get a copy of the ISO file from the releases section <https://github.com/tlhakhan/ipxe-iso/releases>.

## File list
file | description
--- | ---
`build.sh` | A helper script to kickoff the docker build and copy out the ipxe.iso file.
`packages` | List of packages installed into the container image to build iPXE source code.
`run.ipxe` | A simple iPXE script that is embedded into the iPXE CD, this launches an iPXE shell instead of an infinite detect/fail loop until Ctrl + B is given.
`Dockerfile` | The Dockerfile that builds the container to build iPXE CD. The built ISO file is located at `/build/ipxe.iso` in the container image.
`src/config/general.h` | This is overrides the default config in the iPXE source code, it will enable various non-default iPXE features.  The default file can be located in the same directory structure of the <https://github.com/ipxe/ipxe> git repo.

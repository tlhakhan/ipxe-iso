# README
This repo helps build a simple iPXE CD that drops into the iPXE shell immediately.  From the shell you can the execute `dhcp` and `chain http://repo/../my_script.ipxe` to launch a remote iPXE script on a webserver.

file | description
--- | ---
`build.sh` | A helper script to kickoff the docker build and push to a private docker registry.
`packages` | List of packages that will be installed in the container.
`run.ipxe` | A simple iPXE script that is embedded into the iPXE CD, this launches an iPXE shell instead of an infinite detect/fail loop until Ctrl + B is given.
`Dockerfile` | The Dockerfile that builds the container to build iPXE CD. The built ISO file is located at `/build/ipxe.iso`.
`src/config/general.h` | This is overrides the default config in the ipxe source code, it will enable various non-default iPXE features.  The default file can be located in the same directory structure of the <https://github.com/ipxe/ipxe> git repo.

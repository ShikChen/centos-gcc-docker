# CentOS 5 GCC Docker

[https://hub.docker.com/r/shik/centos5-gcc/](https://hub.docker.com/r/shik/centos5-gcc/)

CentOS 5 docker for building portable binaries, with recent GCC that support C++14!

Current provided toolchain versions:

* `gcc-7.2.0`
* `binutils-2.29`

## Why not use [Holy Build Box](https://github.com/phusion/holy-build-box)

Because GCC 4.8.2 is too old and C++14 is not supported.

## Why not use "Automated Builds" from Docker Cloud

Since Docker Cloud required the permission to read and write all my public and private repository data.
It doesn't make sense to me.

ref: [Link Docker Cloud to a source code provider](https://docs.docker.com/docker-cloud/builds/link-source/)

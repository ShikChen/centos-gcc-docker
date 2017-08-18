FROM centos:5
LABEL maintainer="shik"
ARG GCC_VERSION=7.2.0
ARG BINUTILS_VERSION=2.29
ARG PREFIX=/toolchain
ARG COMMON_CONFIG_FLAGS="--disable-nls --disable-multilib"
RUN \
# fix yum, see https://github.com/docker-library/official-images/issues/2815#issuecomment-297096847
    sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf && \
    sed -i 's/mirrorlist/#mirrorlist/' /etc/yum.repos.d/*.repo && \
    sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/5.11|' /etc/yum.repos.d/*.repo && \
# install prerequisites, see https://gcc.gnu.org/install/prerequisites.html
# bzip2, gzip and wget are required by `download_prerequisites`
    yum update -y && yum install binutils bzip2 gcc-c++ gzip make tar wget xz -y && yum clean all && \
# download and extract sources without saving to disk
# xz is much smaller then gz!
    wget -qO- https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.xz | unxz | tar x && \
    wget -qO- https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz | unxz | tar x && \
    pushd gcc-${GCC_VERSION} && ./contrib/download_prerequisites && popd && \
# compile binutils
    mkdir build-binutils && pushd build-binutils && \
    ../binutils-${BINUTILS_VERSION}/configure --prefix=${PREFIX} ${COMMON_CONFIG_FLAGS} && \
    make -j $(getconf _NPROCESSORS_ONLN) && make install && popd && \
# compile gcc
    mkdir build-gcc && pushd build-gcc && \
    ../gcc-${GCC_VERSION}/configure --prefix=${PREFIX} ${COMMON_CONFIG_FLAGS} --enable-languages=c,c++ && \
    make -j $(getconf _NPROCESSORS_ONLN) && make install && popd && \
# cleanup
    rm -rf gcc-${GCC_VERSION} binutils-${BINUTILS_VERSION} build-gcc build-binutils 
ENV PATH="/toolchain/bin:${PATH}"
CMD /bin/bash

#!/bin/sh
PWD_LOCATION="/root"

export CPU_ARCH="${1}"
export PRODUCT_ROOT=${PWD_LOCATION}/build/${CPU_ARCH}
export TZ=UTC-8
export LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib

# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# export LANGUAGE=en_US.UTF-8


echo "#### CPU ARCH [${CPU_ARCH}]  ####"
if [ "${CPU_ARCH}" = "x86_64" ]; then
    export PATH=/data/CT/x86_64-QNAP-linux-gnu/cross-tools/bin:${PATH}
    export HOST=x86_64-QNAP-linux-gnu
    export BUILD=x86_64-linux
    export ROOTPATH=/data/CT/x86_64-QNAP-linux-gnu/fs
    export CROSS=x86_64-QNAP-linux-gnu-

elif  [ "${CPU_ARCH}" = "x86" ]; then
    OPTWARE=/opt/optware/ts509/toolchain/i686-unknown-linux-gnu
    export PATH=${OPTWARE}/bin:${PATH}
    export HOST=i686-unknown-linux-gnu
    export BUILD=i686-unknown-linux-gnu
    export ROOTPATH=${OPTWARE}/i686-unknown-linux-gnu/sys-root
    export CROSS=i686-unknown-linux-gnu-

else
    echo "#### Invalid: CPU ARCH [${CPU_ARCH}]  ####"
    exit 1

fi

# rm -rf ${PRODUCT_ROOT}/*

cd ${PWD_LOCATION}/bin
make all  2>&1 | tee ${PWD_LOCATION}/src/build_${CPU_ARCH}.log
cd ${PWD_LOCATION}

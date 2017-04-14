#!/bin/bash
# need copy qdk need binary to /sbin or /usr/lib
# "qdk_binary" is share volume mount by docker run command

echo "*** prepare_in_docker start ... ***"

QDKBIN_DIR="/root/tools/qpkg_builder/qdk_binary"
BUILD_DIR="/root/build"
if [ "${1}"x == "x" ]; then
    echo "missing arch param.."
    exit 1
fi

if [ ! -d "${QDKBIN_DIR}" ]; then
    echo "missing QDK binary directory [${QDKBIN_DIR}].. "
    exit 1
fi

case $1 in
    x86|x86_omx)
        cp -a ${QDKBIN_DIR}/x86/build_binary/* /sbin/
        cp -a ${QDKBIN_DIR}/x86/require_lib/* /usr/lib/
        ln -sf /usr/bin/awk /bin/awk
        rm -rf ${BUILD_DIR}/build/x86/*
        ;;
    x86_64|x86_64_omx)
        cp -a ${QDKBIN_DIR}/x86_64/build_binary/* /sbin/
        ln -sf /usr/bin/awk /bin/awk
        rm -rf ${BUILD_DIR}/build/x86_64/*
        ;;
    *)
        exit 1
        ;;
esac


echo "*** prepare_in_docker end. ***"

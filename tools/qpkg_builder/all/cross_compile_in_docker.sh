#!/bin/bash
echo "=== CROSS start ==="

CPU_ARCH=${1}

BUILD_ROOT=${PWD}


echo "exec cc.sh"
cd ${BUILD_ROOT}/bin
./cc.sh ${CPU_ARCH}

# cd ${BUILD_ROOT}/src
# chmod -R 666 .

# cd ${BUILD_ROOT}/build
# chmod -R 666 .


echo "=== CROSS end ==="

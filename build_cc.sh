#!/bin/bash

COLOR_REST='\e[0m'
COLOR_BLUE='\e[0;37;44m;'

local_path=`pwd`
BUILD_DIR=${local_path}/build

format_date() {
	date "+%Y-%m-%d %H:%M:%S"
}

log() {
	echo -e "${COLOR_BLUE}$(format_date) - $1${COLOR_REST}"
}

cross_compile() {
    log "cross_compile( $1 $2 $3 ) ..."

    cd ${local_path}

    local CPU_ARCH=$1
    local MAKEFILE=$2

	if [ ! -d build/${CPU_ARCH} ]; then
		mkdir -p build/${CPU_ARCH}
	fi

	local DOCKER_IMG="qnapandersen/qdk_toolchain_x86_x64"
	local HOSTDIR=${local_path}
	local CONTAINER_NAME=qdk-cc-python-`date +%s`
	local BASHRC=${local_path}/tools/qpkg_builder/all/bash_config/.bashrc
	local DOCKER_PARAM="
	    --net=host \
	    --rm \
	    -e PNAME=$1-builder-`date +%s` \
	    -e "TZ=Asia/Taipei" \
	    -u root \
	    -w /root \
	    -v ${HOSTDIR}:/root \
	    -v ${BASHRC}:/root/.bashrc \
	    --name=${CONTAINER_NAME}"

    docker run $DOCKER_PARAM $DOCKER_IMG bash -c "\
        /root/tools/qpkg_builder/all/prepare_in_docker.sh ${CPU_ARCH}; \
        /root/tools/qpkg_builder/all/cross_compile_in_docker.sh ${CPU_ARCH} ${MAKEFILE} \
        "
    [ $? != "0" ] && echo "build fail" && exit 1

	log "cross_compile() done."
}

# set -o xtrace
BUILD_DATE=`date +"%Y%m%d-%H%M"`

case ${1} in
	all)
		log "*** CC start ... ***"
		cross_compile "x86_64" ${2}
		cross_compile "x86" ${2}
		log "*** CC done. ***"
		;;
	x86)
		log "*** CC start ... ***"
		cross_compile "x86" ${2}
		log "*** CC done. ***"
		;;
	x86_64)
		log "*** CC start ... ***"
		cross_compile "x86_64" ${2}
		log "*** CC done. ***"
		;;
	*)
		# only for debugging
		eval ${1} ${2} ${3} ${4}
		;;
esac

# set +o xtrace
cd ${local_path}

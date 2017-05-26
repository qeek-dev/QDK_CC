
SRC_LOCATION=/root/src
shell_var_check = $(if ${CPU_ARCH},,$(error Shell variable problem))

ifeq "$(CPU_ARCH)" "x86"
	OPENSSL_TARGET = "linux-generic32"
else
	OPENSSL_TARGET = "linux-x86_64"
endif


all: openssl-1.0.2k zlib-1.2.11 sqlite-autoconf-3180000 Python-2.7.13 pip

openssl-1.0.2k:
	@echo "checking $@..."
	# linux-generic32 , linux-x86_64
	rm -rf $@
	tar zxf ${SRC_LOCATION}/$@.tar.gz
	cd $@ && CC=${CROSS}gcc AR=${CROSS}ar RANLIB=${CROSS}ranlib ./Configure no-ssl2 no-ssl3 -DOPENSSL_NO_HEARTBEATS ${OPENSSL_TARGET} --shared --prefix=${PRODUCT_ROOT} && make clean && make && make install
	rm -rf $@


zlib-1.2.11:
	@echo "checking $@..."
	${shell_var_check}
	rm -rf $@
	tar zxf ${SRC_LOCATION}/$@.tar.gz
	cd $@ && AR=${CROSS}ar AS=${CROSS}as LD=${CROSS}ld NM=${CROSS}nm CC=${CROSS}gcc CPP="${CROSS}gcc -E" GCC=${CROSS}gcc CXX=${CROSS}g++ RANLIB=${CROSS}ranlib STRIP=${CROSS}strip prefix=${PRODUCT_ROOT} \
		./configure --shared && make clean && make && make install
	rm -rf $@


sqlite-autoconf-3180000:
	@echo "checking $@..."
	rm -rf $@
	tar zxf ${SRC_LOCATION}/$@.tar.gz
	cd $@ && ./configure --host=${HOST} --build=${HOST} --target=${HOST} --prefix=${PRODUCT_ROOT} --enable-shared && make clean && make && make install
	rm -rf $@


Python-2.7.13:
	@echo "checking $@..."
	@echo "CPU_ARCH ${CPU_ARCH}"
	rm -rf $@
	tar zxf ${SRC_LOCATION}/$@.tgz
	cd $@ && ./configure && \
		CPPFLAGS="-g0 -Os -s -I. -I${PRODUCT_ROOT}/include  -I${ROOTPATH}/usr/include -I${ROOTPATH}/include" \
		LDFLAGS="-L${PRODUCT_ROOT}/lib -L${ROOTPATH}/usr/lib -L${ROOTPATH}/lib"  && \
		make clean && make python Parser/pgen && \
		mv python hostpython && mv Parser/pgen Parser/hostpgen && make distclean && \
		CC=${CROSS}gcc CXX=${CROSS}g++ AR=${CROSS}ar RANLIB=${CROSS}ranlib STRIP=${CROSS}strip \
		ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no ac_cv_buggy_getaddrinfo=no \
		./configure HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen --host=${HOST} --build=${HOST} --target=${HOST} --prefix=${PRODUCT_ROOT} --disable-ipv6 --enable-shared \
		CPPFLAGS="-g0 -Os -s -I. -I${PRODUCT_ROOT}/include  -I${ROOTPATH}/usr/include -I${ROOTPATH}/include" \
		LDFLAGS="-L${PRODUCT_ROOT}/lib -L${ROOTPATH}/usr/lib -L${ROOTPATH}/lib"  && \
		make clean && \
		make HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="${CROSS}gcc -shared" CROSS_COMPILE=${CROSS} CROSS_COMPILE_TARGET=yes HOSTARCH=${HOST} BUILDARCH=${BUILD} && \
		make install HOSTPYTHON=./hostpython BLDSHARED="${CROSS}gcc -shared" CROSS_COMPILE=${CROSS} CROSS_COMPILE_TARGET=yes prefix=${PRODUCT_ROOT}
	rm -rf $@

pip:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/bin/pip ]; then \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/python ${SRC_LOCATION}/get-pip.py; \
	fi

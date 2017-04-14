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


Python-2.7.13 Python-3.6.1:
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


setuptools-5.4.1:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/lib/python2.7/site-packages/setuptools-5.4.1-py2.7.egg ]; then \
		rm -rf $@ && \
		tar zxf ${SRC_LOCATION}/$@.tar.gz && cd $@ && LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ../${PYTHON_VER}/python setup.py build install --prefix=${PRODUCT_ROOT}; cd .. && rm -rf $@; \
	fi

MarkupSafe-0.19:
	@echo "checking $@..."
	if [ ! -d ${PRODUCT_ROOT}/lib/python2.7/site-packages/markupsafe ]; then \
		rm -rf $@ && \
		tar zxf ${SRC_LOCATION}/$@.tar.gz && cd $@ && LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ../${PYTHON_VER}/python setup.py build install --prefix=${PRODUCT_ROOT}; cd .. && rm -rf $@; \
	fi

supervisor-3.1.3:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/bin/supervisord ]; then \
		rm -rf $@ && \
		tar zxf ${SRC_LOCATION}/$@.tar.gz && cd $@ && LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ../${PYTHON_VER}/python setup.py build install --prefix=${PRODUCT_ROOT}; cd .. && rm -rf $@; \
	fi

pip:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/bin/pip ]; then \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/python ${SRC_LOCATION}/get-pip.py; \
	fi

api-require-lib:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/lib/python2.7/site-packages/_mysql.so ]; then \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" requests; \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" flask-restful; \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" flask-socketio; \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" gevent; \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" mysql; \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" socketIO_client; \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" gevent-websocket; \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" qrcode; \
		rm -rf pymaging-596a08f ; \
		tar zxf ${SRC_LOCATION}/pymaging-596a08f.tgz && cd pymaging-596a08f && LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ../${PYTHON_VER}/python setup.py build install --prefix=${PRODUCT_ROOT}; cd .. && rm -rf $@; \
		rm -rf pymaging-png-83d85c4 ; \
		tar zxf ${SRC_LOCATION}/pymaging-png-83d85c4.tgz && cd pymaging-png-83d85c4 && LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ../${PYTHON_VER}/python setup.py build install --prefix=${PRODUCT_ROOT}; cd .. && rm -rf $@; \
	fi


normalize-0.7.7:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/bin/normalize ]; then \
		tar zxf ${SRC_LOCATION}/$@.tar.gz && cd $@ && ./configure --host=${HOST} --build=${HOST} --target=${HOST} --prefix=${PRODUCT_ROOT} --enable-shared LDFLAGS="-L${PRODUCT_ROOT}/lib -L${ROOTPATH}/usr/lib -L${ROOTPATH}/lib" \
		&& make clean && make && make install && cd .. && rm -rf $@;\
	fi

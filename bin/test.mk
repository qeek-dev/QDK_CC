
SRC_LOCATION=/root/src
shell_var_check = $(if ${CPU_ARCH},,$(error Shell variable problem))

ifeq "$(CPU_ARCH)" "x86"
	OPENSSL_TARGET = "linux-generic32"
else
	OPENSSL_TARGET = "linux-x86_64"
endif


all: duke-lib

libjpeg-turbo-1.5.1:
	@echo "checking $@..."
	sudo apt-get install nasm
	${shell_var_check}
	rm -rf $@
	tar zxf ${SRC_LOCATION}/$@.tar.gz
	cd $@ && AR=${CROSS}ar AS=${CROSS}as LD=${CROSS}ld NM=${CROSS}nm CC=${CROSS}gcc CPP="${CROSS}gcc -E" GCC=${CROSS}gcc CXX=${CROSS}g++ RANLIB=${CROSS}ranlib STRIP=${CROSS}strip prefix=${PRODUCT_ROOT} \
		autoreconf -fiv && ./configure --prefix=${PRODUCT_ROOT} && make clean
	rm -rf $@

zlib-1.2.11:
	@echo "checking $@..."
	${shell_var_check}
	rm -rf $@
	tar zxf ${SRC_LOCATION}/$@.tar.gz
	cd $@ && AR=${CROSS}ar AS=${CROSS}as LD=${CROSS}ld NM=${CROSS}nm CC=${CROSS}gcc CPP="${CROSS}gcc -E" GCC=${CROSS}gcc CXX=${CROSS}g++ RANLIB=${CROSS}ranlib STRIP=${CROSS}strip prefix=${PRODUCT_ROOT} \
		./configure --shared && make clean && make && make install
	rm -rf $@

pip:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/bin/pip ]; then \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/python ${SRC_LOCATION}/get-pip.py; \
	fi

duke-lib: pip
	@echo "checking $@..."
	LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" -r ${SRC_LOCATION}/requirements.txt

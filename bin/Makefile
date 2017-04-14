
SRC_LOCATION=/root/src
shell_var_check = $(if ${CPU_ARCH},,$(error Shell variable problem))

ifeq "$(CPU_ARCH)" "x86"
	OPENSSL_TARGET = "linux-generic32"
else
	OPENSSL_TARGET = "linux-x86_64"
endif


all: zlib-1.2.11

zlib-1.2.11:
	@echo "checking $@..."
	${shell_var_check}
	rm -rf $@
	tar zxf ${SRC_LOCATION}/$@.tar.gz
	cd $@ && AR=${CROSS}ar AS=${CROSS}as LD=${CROSS}ld NM=${CROSS}nm CC=${CROSS}gcc CPP="${CROSS}gcc -E" GCC=${CROSS}gcc CXX=${CROSS}g++ RANLIB=${CROSS}ranlib STRIP=${CROSS}strip prefix=${PRODUCT_ROOT} \
		./configure --shared && make clean && make && make install
	rm -rf $@

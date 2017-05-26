
SRC_LOCATION=/root/src
shell_var_check = $(if ${CPU_ARCH},,$(error Shell variable problem))

all: duke-lib

pip:
	@echo "checking $@..."
	if [ ! -f ${PRODUCT_ROOT}/bin/pip ]; then \
		LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/python ${SRC_LOCATION}/get-pip.py; \
	fi

duke-lib: pip
	@echo "checking $@..."
	LD_LIBRARY_PATH=${PRODUCT_ROOT}/lib:${LD_LIBRARY_PATH} CC=${CROSS}gcc ${PRODUCT_ROOT}/bin/pip install -I --install-option="--prefix=${PRODUCT_ROOT}" -r ${SRC_LOCATION}/requirements.txt

#!/bin/bash

# Download tar if doesn't exist

PROJ="OpenSSL_1_1_1a.tar.gz"
SRC=https://github.com/openssl/openssl/archive/OpenSSL_1_1_1a.tar.gz

if [ ! -e ${PROJ} ]
then
    wget ${SRC}
fi


#!/bin/bash

# Download tar if doesn't exist

PROJ="zstd-1.3.7.tar.gz"
SRC=https://github.com/facebook/zstd/releases/download/v1.3.7/zstd-1.3.7.tar.gz

if [ ! -e ${PROJ} ]
then
    wget ${SRC}
fi


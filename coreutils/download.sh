#!/bin/bash

# Download tar if doesn't exist

PROJ="v8.29.tar.gz"
SRC=https://github.com/coreutils/coreutils/archive/v8.29.tar.gz

if [ ! -e ${PROJ} ]
then
    wget ${SRC}
fi


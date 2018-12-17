#!/bin/bash

# Download tar if doesn't exist

PROJ="v8.1.0551.tar.gz"
SRC=https://github.com/vim/vim/archive/v8.1.0551.tar.gz

if [ ! -e ${PROJ} ]
then
    wget ${SRC}
fi


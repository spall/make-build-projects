#!/bin/bash

# Download tar if doesn't exist

PROJ="curl-7.62.0.tar.gz"
SRC=https://github.com/curl/curl/releases/download/curl-7_62_0/curl-7.62.0.tar.gz

if [ ! -e ${PROJ} ]
then
    wget ${SRC}
fi


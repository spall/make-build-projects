#!/bin/bash

TAR="curl-7.62.0.tar.gz"  # name of tar
LOC="curl-7.62.0"      # where project is untarred to

PREFIX_PATH="/data/home.local/sjspall/make-build-projects/curl/tmp/"


tar -xf ${TAR}
cd ${LOC}

./configure --prefix=${PREFIX_PATH}


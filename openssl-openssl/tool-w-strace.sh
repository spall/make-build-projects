#!/bin/bash

PATHTOMAKE="/data/home.local/sjspall/compilation-benchmarks/custom-make/bin" # path to custom make
PATHTOSTRACE="/data/home.local/sjspall/strace-bin/bin" # path to custom strace
TAR="OpenSSL_1_1_1a.tar.gz"  # name of tar
LOC="openssl-OpenSSL_1_1_1a"      # where project is untarred to

ORIGDIR=$(pwd)
ORIGPATH=$PATH

PREFIX_PATH="/data/home.local/sjspall/make-build-projects/openssl-openssl/tmp/"
RESULTS_REPO="/data/home.local/sjspall/make-build-data" # this should exist already
RESULTS_DIR="${RESULTS_REPO}/openssl"                       # will create this if it doesn't exist already

mkdir -p ${RESULTS_DIR}

TMP=($(sha1sum ${TAR}))
TAR_SHA=${TMP[0]}                             # sha of tar; will use in file names
TIMESTAMP=$(date +%s)                                      # timestamp will use in file names


STRACE_DIR="${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}/strace"
mkdir -p ${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}
mkdir -p ${STRACE_DIR}

INFO_FILE="${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}.info"    # file with info about machine etc
touch ${INFO_FILE}

cat /proc/cpuinfo >> ${INFO_FILE}
echo "\n" >> ${INFO_FILE}
cat /proc/meminfo >> ${INFO_FILE} 

rm -rf ${PREFIX_PATH}
rm -rf ${LOC}

export SCNUM="${ORIGDIR}/scnum"

export MAKEJ="1"

tar -xf ${TAR}
cd ${LOC}

echo "Building."

./config --prefix=${PREFIX_PATH} --openssldir=${PREFIX_PATH}/ssl

OUTFILE="${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}/openssl.buildinfo"
SOUTFILE="${STRACE_DIR}/vim"
export OUTPUTFILE="${OUTFILE}"

export PATH="${PATHTOMAKE}:${PATHTOSTRACE}:$PATH"
echo 1 > $SCNUM

strace -o ${SOUTFILE} -f -ff make &&

export PATH="${ORIGPATH}"

cd ${ORIGDIR}
echo "Done building."

rm -rf ${PREFIX_PATH}
rm -rf ${LOC}

rm -f ${ORIGDIR}/scnum

echo "Done."


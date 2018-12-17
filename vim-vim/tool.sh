#!/bin/bash


PATHTOMAKE="/data/home.local/sjspall/compilation-benchmarks/custom-make/bin" # path to custom make
TAR="v8.1.0551.tar.gz"  # name of tar
LOC="vim-8.1.0551"      # where project is untarred to

ORIGDIR=$(pwd)
ORIGPATH=$PATH

COUNT=1                 # number of times to run

PREFIX_PATH="/data/home.local/sjspall/make-build-projects/vim-vim/tmp/"
RESULTS_REPO="/data/home.local/sjspall/make-build-data" # this should exist already
RESULTS_DIR="${RESULTS_REPO}/vim"                       # will create this if it doesn't exist already

mkdir -p ${RESULTS_DIR}

TMP=($(sha1sum ${TAR}))
TAR_SHA=${TMP[0]}                             # sha of tar; will use in file names
TIMESTAMP=$(date +%s)                                      # timestamp will use in file names


mkdir -p ${RESULTS_DIR}/${TIMESTAMP}

INFO_FILE="${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}.info"    # file with info about machine etc
touch ${INFO_FILE}

cat /proc/cpuinfo >> ${INFO_FILE}
echo "\n" >> ${INFO_FILE}
cat /proc/meminfo >> ${INFO_FILE} 

rm -rf ${PREFIX_PATH}
rm -rf ${LOC}

export SCNUM="${ORIGDIR}/scnum"

export MAKEJ="1"


i=0

while [ "${i}" -lt "${COUNT}" ];
do
    tar -xf ${TAR}
    cd ${LOC}/src
    
    echo "Building."

    ./configure --prefix=${PREFIX_PATH}

    OUTFILE="${RESULTS_DIR}/${TIMESTAMP}/${i}.buildinfo"
    export OUTPUTFILE="${OUTFILE}"

    export PATH="${PATHTOMAKE}:$PATH"
    echo 1 > $SCNUM

    make && make install

    export PATH="${ORIGPATH}"

    cd ${ORIGDIR}
    echo "Done building."
    
    rm -rf ${PREFIX_PATH}
    rm -rf ${LOC}

    i=$((i + 1))
done

rm -f ${ORIGDIR}/scnum

echo "Done."


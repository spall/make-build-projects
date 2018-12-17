#!/bin/bash

# build vim from 1 to max cores; n number of times

TAR="v8.1.0551.tar.gz"  # name of tar
LOC="vim-8.1.0551"      # where project is untarred to
CORES=1                # number of cores available 
COUNT=1                 # number of times to run at each pcount

PREFIX_PATH="/data/home.local/sjspall/make-build-projects/vim-vim/tmp/"
RESULTS_REPO="/data/home.local/sjspall/make-build-data" # this should exist already
RESULTS_DIR="${RESULTS_REPO}/vim"                       # will create this if it doesn't exist already

ORIGDIR=$(pwd)

mkdir -p ${RESULTS_DIR}

TMP=($(sha1sum ${TAR}))
TAR_SHA=${TMP[0]}                             # sha of tar; will use in file names
TIMESTAMP=$(date +%s)                                      # timestamp will use in file names

RAW_FILE="${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}_RAW.csv"  # all the timing data
AVG_FILE="${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}_AVG.csv"  # file with averages for each core count
INFO_FILE="${RESULTS_DIR}/${TAR_SHA}_${TIMESTAMP}.info"    # file with info about machine etc

touch ${RAW_FILE}
#touch ${AVG_FILE}
touch ${INFO_FILE}

# First, write to file with information about machine used
# create output files
#

cat /proc/cpuinfo >> ${INFO_FILE}
echo "\n" >> ${INFO_FILE}
cat /proc/meminfo >> ${INFO_FILE} 

echo "pcount, real, user, sys" >> ${RAW_FILE}
#echo "pcount, real, user, sys" >> ${AVG_FILE} 

rm -rf ${PREFIX_PATH}
rm -rf ${LOC}

J=1

while [ "${J}" -le "${CORES}" ];
do
    ITERS=0

    UT_SUM=0
    ST_SUM=0
    RT_SUM=0

    echo "Starting builds with -j ${J}."
    
    while [ "${ITERS}" -lt "${COUNT}" ]
    do
	# build with -j count and time it and write to results
	tar -xf ${TAR}
	cd ${LOC}/src
	
	echo "Running configure and make."
	
	# vim uses make to run configure script
	./configure --prefix=${PREFIX_PATH}
	
	# ov1=$(date +%s%N) && overhead=$((($(date +%s%N) - ${ov1})))
	
	tout=($( time ((make -j ${J} &> /dev/null) && (make -j ${J} install &> /dev/null)) 2>&1 ))

	rt=${tout[1]} # real time
	ut=${tout[3]} # user time
	st=${tout[5]} # sys  time

	echo "${J}, ${rt}, ${ut}, ${st}" >> ${RAW_FILE}

#	RT_SUM=$((RT_SUM + rt))
#	UT_SUM=$((UT_SUM + ut))
#	ST_SUM=$((ST_SUM + st))

	cd ${ORIGDIR}
	
	rm -rf ${PREFIX_PATH}
	rm -rf ${LOC}
	
	ITERS=$((ITERS + 1))
    done

 #   rt_avg=$((RT_SUM / COUNT))
  #  ut_avg=$((UT_SUM / COUNT))
   # st_avg=$((ST_SUM / COUNT))
    
   # echo "${J}, ${rt_avg}, ${ut_avg}, ${st_avg}" >> ${AVG_FILE}

    J=$((J + 1))
done

echo "Done."






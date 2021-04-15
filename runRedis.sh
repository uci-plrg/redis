#!/bin/bash
# set -x


# Workload
WORKLOAD=redis
TESTSIZE=$1

# PM Image file
PMIMAGE=./workload/${WORKLOAD}
TEST_ROOT="$PWD"

# variables to use
REDIS_SERVER=${TEST_ROOT}/src/redis-server
REDIS_TEST=${TEST_ROOT}/script/redis_test.sh
REDIS_TEST_POST=${TEST_ROOT}/script/redis_test_post.sh

if ! [[ $TESTSIZE =~ ^[0-9]+$ ]] ; then
   echo -e "${RED}Error:${NC} Invalid workload size ${TESTSIZE}." >&2; usage; exit 1
fi

echo Running ${WORKLOAD}. Test size = ${TESTSIZE}.

# Remove old pmimage and fifo files
rm -f /workload/*
rm -f /tmp/*fifo
rm -f /tmp/func_map

TIMING_OUT=${WORKLOAD}_${TESTSIZE}_time.txt
DEBUG_OUT=${WORKLOAD}_${TESTSIZE}_debug.txt

# Generate config file
CONFIG_FILE=${WORKLOAD}_${TESTSIZE}_config.txt
rm ${CONFIG_FILE}
echo "PINTOOL_PATH ${PINTOOL_SO}" >> ${CONFIG_FILE}
echo "EXEC_PATH ${REDIS_SERVER}" >> ${CONFIG_FILE}
echo "PM_IMAGE ${PMIMAGE}" >> ${CONFIG_FILE}
echo "PRE_FAILURE_COMMAND ${REDIS_SERVER} ${TEST_ROOT}/redis-nvml/redis.conf pmfile ${PMIMAGE} 8mb" >> ${CONFIG_FILE}
# The post-failure program should self-terminate without any input from the client.
echo "POST_FAILURE_COMMAND ${REDIS_SERVER} ${TEST_ROOT}/redis-nvml/redis_post.conf pmfile ${PMIMAGE} 8mb & (sleep 10 ; ${REDIS_TEST_POST} ${TESTSIZE} \${RANDOM}) ; wait" >> ${CONFIG_FILE}

export PMEM_MMAP_HINT=0x10000000000

MAX_TIMEOUT=120

# Run realworkload
# Start XFDetector
timeout ${MAX_TIMEOUT} ${REDIS_SERVER} ${TEST_ROOT}/redis.conf pmfile ${PMIMAGE} 8mb
sleep 10
${REDIS_TEST} ${TESTSIZE} ${RANDOM}
wait


#!/bin/bash
export LD_LIBRARY_PATH=/scratch/nvm/pmcheck/bin/:/scratch/nvm/pmdk/src/nondebug
# For Mac OSX
export DYLD_LIBRARY_PATH=/scratch/nvm/pmcheck/bin/:/scratch/nvm/pmdk/src/nondebug
#export PMCheck="-d$3 -p1 -v3 -e -c3"
#export PMCheck="-d$3 -p1 -v3 -e"
export PMCheck="-p2 -v3"
echo "src/redis-server ./redis.conf workload/pmfile.file workload/tmp.log 8mb"
#./src/redis-server ./redis.conf workload/pmfile.file workload/tmp.log 8mb
echo $@

$@

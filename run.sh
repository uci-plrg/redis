#!/bin/bash
export NDCTL_ENABLE=n
export LD_LIBRARY_PATH=/scratch/nvm/pmcheck/bin/:/scratch/nvm/pmdk/src/debug
# For Mac OSX
export DYLD_LIBRARY_PATH=/scratch/nvm/pmcheck/bin/
#export PMCheck="-d/ramfs/redis.pm -x5 -p1 -y -r15000000"
export PMCheck="-d/ramfs/redis.pm -x5 -p1 -y -r4000000"
echo "./run.sh src/redis-server ./redis.conf"
echo $@

$@

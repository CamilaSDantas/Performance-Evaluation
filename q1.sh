#!/bin/bash

APPNAME=$1
PID=$(pidof ${APPNAME} | awk 'NF>1{print $NF}')
PROCPATH="/proc/${PID}"
SAMPLES=$2
SAMPLE_TIME=$3

if [ ! -r "${PROCPATH}/stat" ]; then
  echo "invalid pid"
  exit 1
fi

clock_ticks=$(getconf CLK_TCK)

echo "uptime, num_threads, memory_usage, cpu_time"

for i in $(seq 1 $SAMPLES); do
    start=$(date +%s%3N)

    stat_array=( $(sed -E 's/(\([^\s)]+)\s([^)]+\))/\1_\2/g' "${PROCPATH}/stat") )

    uptime_array=( $(cat /proc/uptime) )
    uptime=${uptime_array[0]}
    starttime=${stat_array[21]}
    seconds=$( awk 'BEGIN {print ( '$uptime' - ('$starttime' / '$clock_ticks') )}' )

    num_threads=${stat_array[19]}

    # cpu
    utime=${stat_array[13]}
    stime=${stat_array[14]}
    cutime=${stat_array[15]}
    cstime=${stat_array[16]}
    total_time=$(( $utime + $stime + $cstime + $cutime ))
    cpu_time=$( awk 'BEGIN {print ( '$total_time' / '$clock_ticks' )}' )

    # memory
    statm_array=( $(cat ${PROCPATH}/statm) )
    resident=${statm_array[1]}
    data_and_stack=${statm_array[5]}
    memory_usage=$(( $resident + $data_and_stack ))

    printf "\n%f, %u, %d, %f" ${seconds} ${num_threads} ${memory_usage} ${cpu_time}
    sleep $(awk 'BEGIN {print ( ('$SAMPLE_TIME' - ('$(date +%s%3N)' - '$start') ) / 1000 )}')
done

#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <system_time.cfg>"
    exit;
fi

while true
do
    SYS_TIME=`date -Iseconds`
    Y_M_D=`echo ${SYS_TIME} | awk -F "[T+]" '{print $1}'`
    H_M_S=`echo ${SYS_TIME} | awk -F "[T+]" '{print $2}'`
    echo \"${Y_M_D} ${H_M_S}\" > $1
    sleep 20
done
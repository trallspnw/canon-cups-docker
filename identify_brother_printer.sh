#!/bin/bash

echo "Please plug your Brother USB printer..."

# wait for a Brother printer to be detected
while [ $(/usr/bin/lsusb | grep -c Brother) -lt 1 ]; do
	echo "no Brother USB printer found, waiting";
	sleep 1
done

echo "Getting printers info..."

# Output all Brother USB printer found
OLD_IFS="${IFS}"
IFS=$'\n'
PRINTER_VID_PID_ARRAY=( $(/usr/bin/lsusb | grep Brother | awk '{print $6}') )
IFS="${OLD_IFS}"

# For each brother printer get its vid and pid.
for PRINTER_VID_PID in "${PRINTER_VID_PID_ARRAY[@]}"
do
	PRINTER_VID_PID_SPLIT=(${PRINTER_VID_PID/:/ })
	PRINTER_VID="${PRINTER_VID_PID_SPLIT[0]}"
	PRINTER_PID="${PRINTER_VID_PID_SPLIT[1]}"
	echo "found Brother USB printer with VID ${PRINTER_VID} and PID ${PRINTER_PID}"
done

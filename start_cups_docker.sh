#!/bin/bash

# VID/PID for my Canon PIXMA iP3600 printer
PRINTER_VID=0x04a9
PRINTER_PID=0x10ca

# Stop Container (if running)
echo "Stopping current container..."
/usr/bin/docker stop canon-cups-docker
/usr/bin/docker rm canon-cups-docker

# Get Printer address on host, ex : /dev/bus/usb/002/008
echo "Getting printer info..."
OLD_IFS="${IFS}"
IFS=$'\n'
PRINTER_LSUSB=( $(/usr/bin/lsusb -d ${PRINTER_VID}:${PRINTER_PID}) )
IFS="${OLD_IFS}"
if [ ${#PRINTER_LSUSB[@]} -gt 1 ]; then
        echo "Warning : more than one printer found with specified VID and PID, selecting first one"
fi
PRINTER_BUS=$( ${PRINTER_LSUSB[0]} | awk '{print $2}')
PRINTER_DEV=$( ${PRINTER_LSUSB[0]} | awk '{print $4}')
PRINTER_DEV="${PRINTER_DEV%?}"
if [[ ! -z ${PRINTER_BUS+x} && ! -z ${PRINTER_DEV+x} ]];  then
        PRINTER_ADDRESS="/dev/bus/usb/${PRINTER_BUS}/${PRINTER_DEV}"
fi

# Run docker container if Canon printer is found
if [ -z ${PRINTER_ADDRESS+x} ]; then
        echo "Canon printer cannot be found, cannot run container";
else
        echo "Running container for Canon printer at ${PRINTER_ADDRESS}..."
        exec env PRINTER_ADDRESS="${PRINTER_ADDRESS}" /usr/bin/docker-compose -f /path/to/docker-compose.yml up
fi

exit 0

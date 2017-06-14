#!/bin/bash

# wait for the CUPS server to start
while [ $(pgrep cupsd | wc -l) -ne 1 ]; do
	echo "CUPS server not started";
	sleep 1
done

echo "CUPS server started";

# check if PRINTER_MODEL env var is set
if [ -z ${PRINTER_MODEL+x} ]; then 
	echo "PRINTER_MODEL env var is unset, cannot run Brother printer setup"; 
else 
	echo "Running Brother setup for printer ${PRINTER_MODEL}"
	printf 'y\ny\ny\nn\nn\n' | /root/linux-brprinter-installer-2.1.1-1 $PRINTER_MODEL
fi
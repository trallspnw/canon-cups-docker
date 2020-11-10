# Current version

CUPS 2.2.10

# What is CUPS?

CUPS is an open source printing system that supports IPP along with other protocols. More information can be found at [cups.org](http://cups.org/)

# About this image

This image is based off didrip/cups-docker (https://github.com/didrip/cups-docker) with the following modifications:

* Debian buster is used as the base image.
* Modified USB backend for Canon printers.

# Running this image

## Way 1 : `docker run`

```
docker run -e CUPS_USER_ADMIN=admin \
-e CUPS_USER_PASSWORD=secr3t \
-p 631:631/tcp \
-v /path/to/cupsd.conf:/etc/cups/cupsd.conf \
--device=/dev/bus/usb/xxx/yyy \
stonecan/canon-cups-docker:latest
```

## Way 2 : `docker compose`

See provided `docker-compose.yml` file.
Don't forget to set the `PRINTER_ADDRESS` var.

## Way 3 : startup script `start_cups_docker.sh`

The provided startup script `start_cups_docker.sh` automatically gets the printer address /dev/bus/usb/xxx/yyy by looking at 
any Canon printer matching the provided VID (USB vendor ID) and PID (USB product ID).
Don't forget to change the `PRINTER_MODEL`, `PRINTER_VID` and `PRINTER_PID` values according to your model of Canon printer.

To get the information about the correct VID and PID, one could check the available lists online (ex : http://www.linux-usb.org/usb.ids, https://usb-ids.gowdy.us/read/UD/04f9 or http://www.the-sz.com/products/usbid/).

Also you can use the provided script `identify_canon_printer.sh` which output the VID and PID for any connected Canon USB printer.

Access the CUPS server at http://127.0.0.1:631.
To access it remotely at http://server-ip:631, add the line `DefaultEncryption IfRequested` to `cupsd.conf`.

FROM debian:buster

MAINTAINER stonecan

RUN apt-get update && apt-get -y install \
cups \
cups-filters \
cups-pdf \
whois \
usbutils \
lib32stdc++6 \
lib32gcc1 \
libc6-i386 \
wget \
&& rm -rf /var/lib/apt/lists/*

# Remove backends that don't make sense for container
RUN rm /usr/lib/cups/backend/parallel \
  && rm /usr/lib/cups/backend/serial

COPY etc-cups /etc/cups

VOLUME /etc/cups/ /var/log/cups /var/spool/cups /var/cache/cups

COPY etc-pam.d-cups /etc/pam.d/cups

COPY start_cups.sh /root/start_cups.sh
RUN chmod +x /root/start_cups.sh \
  && mkdir -p /etc/cups/ssl

CMD /root/start_cups.sh

EXPOSE 631

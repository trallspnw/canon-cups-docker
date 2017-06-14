FROM debian:stretch

MAINTAINER monkeydri <monkeydri@github.com>

RUN apt-get update && apt-get -y install \
cups=2.2.1* \
cups-filters \
cups-pdf \
whois \
usbutils \
lib32stdc++6 \
lib32gcc1 \
libc6-i386 \
&& rm -rf /var/lib/apt/lists/*

# Remove backends that don't make sense for container
RUN rm /usr/lib/cups/backend/parallel \
  && rm /usr/lib/cups/backend/serial

COPY etc-cups /etc/cups

VOLUME /etc/cups/ /var/log/cups /var/spool/cups /var/cache/cups

COPY etc-pam.d-cups /etc/pam.d/cups

# Install brother HL-L2300D drivers deb packages
COPY brother-hl-l2300d /var/brother-hl-l2300d
RUN ln -s /etc/init.d/cupsys /etc/init.d/lpd \
  && mkdir /var/spool/lpd \
  && dpkg --install --force-architecture /var/brother-hl-l2300d/hll2300dlpr-3.2.0-1.i386.deb \
  && dpkg --install --force-architecture /var/brother-hl-l2300d/hll2300dcupswrapper-3.2.0-1.i386.deb

COPY start_cups.sh /root/start_cups.sh
RUN chmod +x /root/start_cups.sh \
  && mkdir -p /etc/cups/ssl

CMD ["/root/start_cups.sh"]

EXPOSE 631

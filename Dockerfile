FROM debian:buster

RUN apt-get update && apt-get -y upgrade && apt-get -y cups

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

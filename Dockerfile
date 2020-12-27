FROM debian:buster

RUN apt-get -y update && apt-get -y install certbot curl dnsutils && apt-get -y clean

COPY authenticator.sh /authenticator.sh
COPY entry.sh /entry.sh

VOLUME [ "/etc/letsencrypt" ]

ENV ROOT_DOMAIN="mydomain.com"
ENV API_KEY=""
ENV API_SECRET=""
ENV REGISTER_EMAIL="me@mydomain.com"
ENV TEST="true"

ENTRYPOINT ["./entry.sh"]



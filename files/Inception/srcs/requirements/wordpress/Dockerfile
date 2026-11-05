
FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl php php8.2-fpm php-mysql mariadb-client
RUN apt-get install -y swaks


COPY ./tools/wordpress-conf.sh /


RUN  chmod +x wordpress-conf.sh

ENTRYPOINT ["/wordpress-conf.sh"]
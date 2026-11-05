
FROM debian:bookworm


RUN apt-get update -y && apt-get upgrade -y && apt-get install -y mariadb-server

COPY ./tools/mariadb-conf.sh /mariadb-conf.sh

RUN chown -R mysql:mysql /var/lib/mysql

RUN chmod +x mariadb-conf.sh
ENTRYPOINT ["./mariadb-conf.sh"]
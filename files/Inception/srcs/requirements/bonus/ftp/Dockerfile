FROM debian:bookworm

RUN apt update && apt upgrade -y 

RUN apt install vsftpd -y

COPY tools/ftpconf.conf /etc/vsftpd.conf

COPY tools/ftpconf.sh ftpconf.sh

RUN chmod +x ftpconf.sh

EXPOSE 21 30000-30100

ENTRYPOINT ["./ftpconf.sh"]
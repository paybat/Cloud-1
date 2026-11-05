FROM debian:bookworm

RUN apt-get update && apt upgrade -y && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/www/wordpress



RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=MO/ST=KH/L=KH/O=SELF/OU=Dev/CN=hidriouc.42.fr"

RUN rm -f /etc/nginx/sites-enabled/default

COPY ./tools/nginx.conf  /etc/nginx/conf.d/default.conf


ENTRYPOINT ["nginx", "-g", "daemon off;"]
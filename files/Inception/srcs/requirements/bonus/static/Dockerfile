
FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y php

COPY ./tools/staticContent.html /var/www/html

ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "/var/www/html/staticContent.html"]
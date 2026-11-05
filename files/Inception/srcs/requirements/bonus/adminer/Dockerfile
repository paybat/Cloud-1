FROM debian:bookworm

RUN	apt update && apt upgrade -y && apt install -y php php-mysql adminer
RUN	mv /usr/share/adminer/adminer.php /usr/share/adminer/index.php


ENTRYPOINT ["php", "-S", "0.0.0.0:9090", "-t", "/usr/share/adminer/"]
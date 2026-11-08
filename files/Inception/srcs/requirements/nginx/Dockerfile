FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends nginx openssl gettext-base \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl /etc/nginx/templates /var/www/wordpress \
    && rm -f /etc/nginx/sites-enabled/default

COPY ./tools/nginx.conf.template /etc/nginx/templates/default.conf.template
COPY ./tools/nginx-entrypoint.sh /usr/local/bin/nginx-entrypoint
RUN chmod 0755 /usr/local/bin/nginx-entrypoint

ENTRYPOINT ["/usr/local/bin/nginx-entrypoint"]

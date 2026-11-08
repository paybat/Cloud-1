#!/bin/sh
set -eu

: "${DOMAINNAME:?DOMAINNAME must be set}"
mkdir -p /etc/nginx/ssl
if [ ! -s /etc/nginx/ssl/inception.crt ] || [ ! -s /etc/nginx/ssl/inception.key ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/CN=${DOMAINNAME}" \
        -addext "subjectAltName=DNS:${DOMAINNAME}"
fi
envsubst '${DOMAINNAME}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf
exec nginx -g 'daemon off;'

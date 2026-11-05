#!/bin/bash

set -e

mkdir -p /var/run/vsftpd/empty
mkdir -p /data/uploads 

if ! id -u "$FTP_USER_NAME" >/dev/null 2>&1; then
    useradd --create-home "$FTP_USER_NAME"
fi

echo "$FTP_USER_NAME:$FTP_USER_PASSWORD" | chpasswd

chown -R $FTP_USER_NAME:$FTP_USER_NAME /data/uploads

chmod -R 775 /data/uploads

exec vsftpd /etc/vsftpd.conf
#!/bin/bash
set -euo pipefail

WPPATH=/var/www/wordpress

if ! command -v wp >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp
    chmod 0755 /usr/local/bin/wp
fi

mkdir -p "$WPPATH"
chown -R www-data:www-data "$WPPATH"
cd "$WPPATH"

if [ ! -f wp-config.php ]; then
    wp core download --force --allow-root
    wp core config --dbhost=mariadb:3306 --dbname="$DATABASENAME" --dbuser="$DATABASEUSER" --dbpass="$USERPASSWORD" --allow-root
    wp core install --url="https://${DOMAINNAME}" --title="$WORDPRESSTITLE" \
        --admin_user="$WORDPRESSADMINNAME" --admin_password="$WORDPRESSADMINPASS" \
        --admin_email="$WORDPRESSADMINEMAIL" --allow-root
fi

if ! wp user get "$WORDPRESSUSERNAME" --field=ID --allow-root >/dev/null 2>&1; then
    wp user create "$WORDPRESSUSERNAME" "$WORDPRESSUSEREMAIL" \
        --user_pass="$WORDPRESSUSERPASS" --role="$WORDPRESSUSERROLE" --allow-root
fi

wp --allow-root config set WP_REDIS_HOST redis
wp --allow-root config set WP_REDIS_PORT 6379
if ! wp --allow-root plugin is-installed redis-cache; then
    wp --allow-root plugin install redis-cache
fi
if ! wp --allow-root plugin is-active redis-cache; then
    wp --allow-root plugin activate redis-cache
fi
wp --allow-root redis enable

sed -i 's@/run/php/php8.2-fpm.sock@9000@' /etc/php/8.2/fpm/pool.d/www.conf
mkdir -p /run/php
exec /usr/sbin/php-fpm8.2 -F

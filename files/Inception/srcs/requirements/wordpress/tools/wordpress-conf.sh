#!/bin/bash

set -e
WPPATH="/var/www/wordpress"

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp


mkdir -p "$WPPATH"
cd "$WPPATH"
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress


if [ -f wp-config.php ]; then
	echo "wp-config.php already exists, skipping WordPress installation."
else
	wp core download --allow-root
	wp core config --dbhost=mariadb:3306 --dbname="$DATABASENAME" --dbuser="$DATABASEUSER" --dbpass="$USERPASSWORD" --allow-root
	wp core install --url="https://${DOMAINNAME}" --title="$WORDPRESSTITLE" --admin_user="$WORDPRESSADMINNAME" --admin_password="$WORDPRESSADMINPASS" --admin_email="$WORDPRESSADMINEMAIL" --allow-root
	wp user create "$WORDPRESSUSERNAME" "$WORDPRESSUSEREMAIL" --user_pass="$WORDPRESSUSERPASS" --role="$WORDPRESSUSERROLE" --allow-root
fi

wp --allow-root --path=$WPPATH config set WP_REDIS_HOST "redis"
wp --allow-root --path=$WPPATH config set WP_REDIS_PORT "6379"
wp plugin install redis-cache --activate --allow-root --path=$WPPATH
wp redis enable --allow-root --path=$WPPATH

sed -i 's@/run/php/php8.2-fpm.sock@9000@' /etc/php/8.2/fpm/pool.d/www.conf
mkdir -p /run/php

/usr/sbin/php-fpm8.2 -F
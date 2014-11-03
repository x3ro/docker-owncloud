
cat <<EOF
---------------------------------------------
MySQL User: root
MySQL DB: owncloud
MySQL Host: $DB_PORT_3306_TCP_ADDR
MySQL Password: $DB_ENV_MYSQL_ROOT_PASSWORD
---------------------------------------------

EOF

chown -Rf www-data:www-data /var/www/owncloud/data
chown -Rf www-data:www-data /var/www/owncloud/config

/usr/sbin/apache2 -c "ErrorLog /dev/stdout" -DFOREGROUND

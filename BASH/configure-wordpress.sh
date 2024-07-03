#!/bin/bash

echo "*************************************WORDPRESS CONFIGURING*************************************"

WORDPRESS_PATH="/srv/www"
WORDPRESS_CONFIG_FILE=$WORDPRESS_PATH/wordpress/wp-config.php

function INSTALL_WORDPRESS {

    if ! [ -d "$WORDPRESS_PATH" ]; then
        echo "Wordpress folder in $WORDPRESS_PATH is empty. Create it now!"
        sudo mkdir -p /srv/www
        sudo chown www-data: $WORDPRESS_PATH
        curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www
    else 
        echo "Wordpress folder in $WORDPRESS_PATH exist. Skip downloading."
    fi
}

function UPDATE_CONFIGS {

    sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php


    sudo -u www-data sed -i "s/database_name_here/$MYSQL_DATABASE_NAME/" /srv/www/wordpress/wp-config.php
    sudo -u www-data sed -i "s/username_here/$MYSQL_USER/" /srv/www/wordpress/wp-config.php
    sudo -u www-data sed -i "s/password_here/$MYSQL_PASSWORD/" /srv/www/wordpress/wp-config.php

    sed -i '/define( 'AUTH_KEY',         'put your unique phrase here' );/d' $WORDPRESS_CONFIG_FILE
    sed -i '/define( 'SECURE_AUTH_KEY'/d' $WORDPRESS_CONFIG_FILE
    sed -i '/define( 'LOGGED_IN_KEY'/d' $WORDPRESS_CONFIG_FILE
    sed -i '/define( 'NONCE_KEY'/d' $WORDPRESS_CONFIG_FILE
    sed -i '/define( 'AUTH_SALT'/d' $WORDPRESS_CONFIG_FILE
    sed -i '/define( 'SECURE_AUTH_SALT'/d' $WORDPRESS_CONFIG_FILE
    sed -i '/define( 'LOGGED_IN_SALT'/d' $WORDPRESS_CONFIG_FILE
    sed -i '/define( 'NONCE_SALT'/d' $WORDPRESS_CONFIG_FILE


    sed -i '/<?php/TESTSSTSTST' filename

}

INSTALL_WORDPRESS
UPDATE_CONFIGS
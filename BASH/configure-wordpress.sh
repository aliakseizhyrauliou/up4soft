#!/bin/bash

echo "*************************************WORDPRESS CONFIGURING*************************************"

WORDPRESS_PATH="/srv/www"
WP_CONFIG_TEMPLATE_PATH="../templates/wp-config.php"
DOMAIN_AND_PREFIX="$DOMAIN_NAME$WORDPRESS_PREFIX"

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


#private 
function CREATE_NEW_CONIFG {
    touch "$WORDPRESS_PATH/wordpress/wp-config.php"

    cat $WP_CONFIG_TEMPLATE_PATH > $WORDPRESS_PATH/wordpress/wp-config.php

    sudo -u www-data sed -i "s/DATABASE_NAME/$MYSQL_DATABASE_NAME/" /srv/www/wordpress/wp-config.php
    sudo -u www-data sed -i "s/DATABASE_USER/$MYSQL_USER/" /srv/www/wordpress/wp-config.php
    sudo -u www-data sed -i "s/DATABASE_PASSWORD/$MYSQL_PASSWORD/" /srv/www/wordpress/wp-config.php


    sudo -u www-data sed -i "s#DOMAIN_NAME_PREFIX#https://$DOMAIN_AND_PREFIX#g" /srv/www/wordpress/wp-config.php
    sudo -u www-data sed -i "s#WORDPRESS_PREFIX#$WORDPRESS_PREFIX/#g" /srv/www/wordpress/wp-config.php


    

}
function UPDATE_CONFIGS {

    if [ -f "$WORDPRESS_PATH/wordpress/wp-config.php" ]; then 
        echo "Wordpress wp-config exist in $WORDPRESS_PATH/wordpress/wp-config.php. Rewrite it"

        rm $WORDPRESS_PATH/wordpress/wp-config.php

        CREATE_NEW_CONIFG

        touch "$WORDPRESS_PATH/wordpress/wp-config.php"
    else 
        echo "Wordpress wp-config doesent exist in $WORDPRESS_PATH/wordpress/wp-config.php. Create it now!"
        CREATE_NEW_CONIFG
    fi
}

INSTALL_WORDPRESS
UPDATE_CONFIGS
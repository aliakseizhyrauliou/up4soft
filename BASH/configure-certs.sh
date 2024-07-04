#!/bin/bash

echo "*************************************CERTS CONFIGURING*************************************"

CERT_PATH="/etc/nginx/ssl/cert"
KEY_PATH="/etc/nginx/ssl/private"

SITE_CONFIG_PATH="/etc/nginx/sites-available/$DOMAIN_NAME"

SSLNAME="wordpress"
SSLDAYS=365


function CREATE_CERTS {
    echo "Creating a new Certificate ..."

    openssl req -x509 -nodes -newkey rsa:2048 -keyout $SSLNAME.key -out $SSLNAME.crt -days $SSLDAYS

    if [[ ! -d $KEY_PATH ]]; then
        mkdir -p $KEY_PATH
    fi

    if [[ ! -d $CERT_PATH ]]; then
        mkdir -p $CERT_PATH
    fi

    cp $SSLNAME.key $KEY_PATH/$SSLNAME.key
    cp $SSLNAME.crt $CERT_PATH/$SSLNAME.crt
}

function UPDATE_NGINX_CONF {
    sed -i "s#CERT_PATH#$CERT_PATH/$SSLNAME.crt#g" $SITE_CONFIG_PATH
    sed -i "s#KEY_PATH#$KEY_PATH/$SSLNAME.key#g" $SITE_CONFIG_PATH
}


CREATE_CERTS
UPDATE_NGINX_CONF

sudo nginx -t
sudo systemctl restart nginx
sudo systemctl status nginx
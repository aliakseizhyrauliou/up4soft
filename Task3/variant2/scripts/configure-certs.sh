#!/bin/bash

echo "*************************************CERTS CONFIGURING*************************************"


#PARAMS
CERT_NAME="${CERT_NAME:-wordpress}"
#------

#VARIABLES
SELF_PATH=$(pwd)
CERT_PATH="$SELF_PATH/../nginx/ssl/cert"
KEY_PATH="$SELF_PATH/../nginx/ssl/private"
SSLDAYS=365
SITE_CONFIG_PATH="$SELF_PATH/../nginx/nginx.conf"
#---------


while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -cn|--cert-name)
            CERT_NAME="$2"
            shift 
            shift 
            ;;
        *)  
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done


function REMOVE_OLD_SSL_FOLDER {
    if [ -d "$SELF_PATH/../nginx/ssl" ]; then
        rm -rf "$SELF_PATH/../nginx/ssl"
    fi
}
function CREATE_CERTS {
    echo "Creating a new Certificate ..."

    openssl req -x509 -nodes -newkey rsa:2048 -keyout "$CERT_NAME.key" -out "$CERT_NAME.crt" -days "$SSLDAYS" -subj "/C=/ST=/L=/O=/OU=/CN="
    

    if [[ ! -d $KEY_PATH ]]; then
        mkdir -p "$KEY_PATH"
    fi

    if [[ ! -d $CERT_PATH ]]; then
        mkdir -p "$CERT_PATH"
    fi

    mv "$CERT_NAME.key" "$KEY_PATH/$CERT_NAME.key"
    mv "$CERT_NAME.crt" "$CERT_PATH/$CERT_NAME.crt"
}


function UPDATE_NGINX_CONF {
    old_cert_name=$(grep -oP 'ssl_certificate\s+/etc/nginx/ssl/cert/\K[^.]*' "$SITE_CONFIG_PATH")

    if [[ -n "$old_cert_name" ]]; then
        sed -i "s/$old_cert_name/$CERT_NAME/g" "$SITE_CONFIG_PATH"
        echo "Updated Nginx configuration with new certificate name: $CERT_NAME"
    else
        echo "Old certificate name not found in the Nginx configuration."
    fi
}

REMOVE_OLD_SSL_FOLDER
CREATE_CERTS
UPDATE_NGINX_CONF
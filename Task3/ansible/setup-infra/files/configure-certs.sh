#!/bin/bash

echo "*************************************CERTS CONFIGURING*************************************"
SELF_PATH=$(pwd)

#PARAMS
SSL_PATH="${SSL_PATH:-$HOME/nginx/ssl}"
CERT_NAME="${CERT_NAME:-wordpress}"
#------

#VARIABLES
SSLDAYS=365
#---------


while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -sslp|--ssl-path)
            SSL_PATH="$2"
            shift 
            shift 
            ;;
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
    if [ -d "$SSL_PATH" ]; then
        rm -rf "$SSL_PATH"
    fi
}
function CREATE_CERTS {
    echo "Creating a new Certificate ..."

    openssl req -x509 -nodes -newkey rsa:2048 -keyout "$CERT_NAME.key" -out "$CERT_NAME.crt" -days "$SSLDAYS" -subj "/C=/ST=/L=/O=/OU=/CN="
    

    if [[ ! -d "$SSL_PATH/private" ]]; then
        mkdir -p "$SSL_PATH/private"
    fi

    if [[ ! -d "$SSL_PATH/cert"  ]]; then
        mkdir -p "$SSL_PATH/cert" 
    fi

    mv "$CERT_NAME.key" "$SSL_PATH/private/$CERT_NAME.key"
    mv "$CERT_NAME.crt" "$SSL_PATH/cert/$CERT_NAME.crt"
}


REMOVE_OLD_SSL_FOLDER
CREATE_CERTS

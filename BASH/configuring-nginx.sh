#!/bin/bash

echo "*************************************NGINX CONFIGURING*************************************"

function INSTALL_NGINX {
        if ! dpkg-query -W nginx; then
        echo "Install NGINX"

        {
            echo "-------- Install NGINX at $(date) --------"
            sudo apt install nginx -y
            echo "-------- Install NGINX finished at $(date) --------"
        } >> "$LOGS_FILE_PATH" 2>&1

        sudo systemctl status nginx
    else
        echo "NGINX already installed"
    fi
}

function CREATE_CONFIGS {
    if ! [ -f "/etc/nginx/sites-avaliable/$DOMAIN_NAME" ]; then
        echo "/etc/nginx/sites-avaliable/$DOMAIN_NAME doesnt exists. Create it now!"
        touch "/etc/nginx/sites-avaliable/$DOMAIN_NAME"
    else
        echo "/etc/nginx/sites-avaliable/$DOMAIN_NAME alredy exists"
    fi
}

INSTALL_NGINX
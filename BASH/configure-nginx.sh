#!/bin/bash

echo "*************************************NGINX CONFIGURING*************************************"

SITE_CONFIG_PATH="/etc/nginx/sites-available"
SITE_CONFIG_TEMPLATE_PATH="../templates/nginx.conf"


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

#private
function CREATE_NEW_CONFIG {

    cd $SITE_CONFIG_PATH && touch $DOMAIN_NAME

    cd $HOME/BASH 

    cat $SITE_CONFIG_TEMPLATE_PATH > $SITE_CONFIG_PATH/$DOMAIN_NAME

    sed -i "s/DOMAIN_NAME/$DOMAIN_NAME/g" "$SITE_CONFIG_PATH/$DOMAIN_NAME"

}

function UPDATE_CONFIGS {
    if [ -f "$SITE_CONFIG_PATH/$DOMAIN_NAME" ]; then
        echo "$SITE_CONFIG_PATH/$DOMAIN_NAME already exist. Recreate according to template and DOMAIN_NAME"

        rm $SITE_CONFIG_PATH/$DOMAIN_NAME

        CREATE_NEW_CONFIG

        echo "Domain name in the config file has been updated to $DOMAIN_NAME"
    else
        CREATE_NEW_CONFIG
    fi
}



INSTALL_NGINX
UPDATE_CONFIGS

sudo nginx -t

sudo systemctl restart nginx
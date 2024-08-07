#!/bin/bash

echo "*************************************NGINX CONFIGURING*************************************"

SITE_CONFIG_PATH="/etc/nginx/sites-available"
SITE_CONFIG_TEMPLATE_PATH="$SELF_ADDRESS/../templates/nginx.conf"
NGINX_TEST_PAGE="$SELF_ADDRESS/../templates/nginx-custom-page.html"



function INSTALL_NGINX {
        if ! dpkg-query -W nginx; then
        echo "Install NGINX"

        {
            echo "-------- Install NGINX at $(date) --------"
            sudo apt install nginx -y
            echo "-------- Install NGINX finished at $(date) --------"
        } >> "$LOGS_FILE_PATH" 2>&1

    else
        echo "NGINX already installed"
    fi
}


#private 
function CREATE_CUSTOM_NGINX_FOLDER {
    if ! [ -d "$CUSTOM_NGINX_PAGE_FOLDER_PATH" ]; then
        mkdir "$CUSTOM_NGINX_PAGE_FOLDER_PATH" 
    fi

    cd "$CUSTOM_NGINX_PAGE_FOLDER_PATH" && mkdir nginx

    cp "$NGINX_TEST_PAGE"  "$CUSTOM_NGINX_PAGE_FOLDER_PATH/nginx/index.html"
}
#private
function CREATE_NEW_CONFIG {

    cd "$SITE_CONFIG_PATH" && touch "$DOMAIN_NAME"

    cat "$SITE_CONFIG_TEMPLATE_PATH" > "$SITE_CONFIG_PATH/$DOMAIN_NAME"


    sed -i "s#DOMAIN_NAME#$DOMAIN_NAME#g" "$SITE_CONFIG_PATH/$DOMAIN_NAME"
    sed -i "s#CUSTOM_NGINX_PAGE_FOLDER_PATH#$CUSTOM_NGINX_PAGE_FOLDER_PATH#g" "$SITE_CONFIG_PATH/$DOMAIN_NAME"
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

function DELETE_DEFAULT_SITE {
    SITE_PATH_ENABLED="/etc/nginx/sites-enabled/default"
    SITE_PATH_AVALIABLE="/etc/nginx/sites-available/default"


    if [ -f "$SITE_PATH_ENABLED" ]; then
        sudo rm $SITE_PATH_ENABLED
    fi

    if [ -f "$SITE_PATH_AVALIABLE" ]; then
        sudo rm $SITE_PATH_AVALIABLE
    fi
}


INSTALL_NGINX
CREATE_CUSTOM_NGINX_FOLDER
UPDATE_CONFIGS
DELETE_DEFAULT_SITE

sudo ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/$DOMAIN_NAME


#!/bin/bash

echo "*************************************APACHE2 CONFIGURING*************************************"

SITE_CONFIG_PATH="/etc/apache2/sites-available/wordpress.conf"
SITE_CONFIG_TEMPLATE_PATH="../templates/apache.xml"


function ENSURE_APACHE_INSTALLED {
        if ! dpkg-query -W apache2; then
        echo "Install APACHE2"
        {
            echo "-------- Install APACHE2 at $(date) --------"
            sudo apt install apache2 -y
            echo "-------- Install APACHE2 finished at $(date) --------"
        } >> "$LOGS_FILE_PATH" 2>&1

        sudo systemctl status apache2
    else
        echo "APACHE2 already installed"
    fi
}

#private
function CREATE_NEW_CONFIG {

    touch $SITE_CONFIG_PATH

    cat $SITE_CONFIG_TEMPLATE_PATH > $SITE_CONFIG_PATH

    #sed -i "s/DOMAIN/$DOMAIN_NAME/g" "$SITE_CONFIG_PATH"
    #Пока ничего менять не требуется
}

function UPDATE_CONFIGS {
    if [ -f "$SITE_CONFIG_PATH" ]; then
        echo "$SITE_CONFIG_PATH already exist. Recreate according to template"

        rm $SITE_CONFIG_PATH

        CREATE_NEW_CONFIG

        echo "$SITE_CONFIG_PATH was updated"
    else
        CREATE_NEW_CONFIG
    fi
}


function UPDATE_PORTS {
    sed -i "s/Listen 80/Listen 8080/g" /etc/apache2/ports.conf

    cat /etc/apache2/ports.conf
}


ENSURE_APACHE_INSTALLED
UPDATE_CONFIGS
UPDATE_PORTS

#sudo systemctl restart apache2
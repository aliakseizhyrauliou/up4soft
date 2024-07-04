#!/bin/bash

echo "*************************************DEPENDENCIES CONFIGURING*************************************"


function INSTALL_DEPENDENCIES {

        {
            echo "-------- Install DEPENDENCIES at $(date) --------"
                sudo apt install apache2 \
                        ghostscript \
                        libapache2-mod-php \
                        php \
                        php-bcmath \
                        php-curl \
                        php-imagick \
                        php-intl \
                        php-json \
                        php-mbstring \
                        php-mysql \
                        php-xml \
                        php-zip -y          
                echo "-------- Install DEPENDENCIES finished at $(date) --------"
        } >> "$LOGS_FILE_PATH" 2>&1

}


INSTALL_DEPENDENCIES
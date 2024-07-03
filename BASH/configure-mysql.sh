#!/bin/bash

echo "*************************************MYSQL CONFIGURING*************************************"

function INSTALL_MYSQL {
    if ! dpkg-query -W mysql-server; then
        echo "Install MYSQL"

        {
            echo "-------- Install MYSQL at $(date) --------"
            sudo apt install mysql-server -y
            echo "-------- Install MYSQL finished at $(date) --------"
        } >> "$LOGS_FILE_PATH" 2>&1

        sudo service mysql status
    else
        echo "MYSQL already installed"
    fi
}

function CONFIGURING_WORDPRESS_USER {
    sudo mysql <<EOF

        CREATE DATABASE $MYSQL_DATABASE_NAME;

        CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';

        GRANT ALL PRIVILEGES ON $MYSQL_DATABASE_NAME.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;

        FLUSH PRIVILEGES;
EOF
}


function SECURE_INSTALLATION {
        sudo mysql <<EOF

        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

        DELETE FROM mysql.user WHERE User='';

        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

        DROP DATABASE IF EXISTS test;

        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

        FLUSH PRIVILEGES;
EOF
}

INSTALL_MYSQL
SECURE_INSTALLATION
CONFIGURING_WORDPRESS_USER


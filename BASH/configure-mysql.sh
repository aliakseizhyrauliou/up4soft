#!/bin/bash


function INSTALL_MYSQL {
    if ! dpkg-query -W mysql-server; then
        echo "Install MYSQL"

        {
            echo "-------- Install MYSQL at $(date) --------"
            sudo apt install mysql-server -y
            echo "-------- Install MYSQL finished at $(date) --------"
        } >> "$LOGS_FILE_PATH" 2>&1

        # Проверяем статус установки MySQL
        sudo systemctl status mysql
    else
        echo "MYSQL already installed"
    fi
}

function CONFIGURE_MYSQL {
    sudo mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
        CREATE DATABASE wordpress;


        SELECT * FROM table1;

        INSERT INTO table2 (col1, col2) VALUES ('value1', 'value2');

        UPDATE table3 SET col1 = 'new_value' WHERE id = 1;
EOF
}

INSTALL_MYSQL
CONFIGURE_MYSQL
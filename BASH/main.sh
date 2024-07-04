#!/bin/bash

# Ensure the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Re-running with sudo..."
    exec sudo "$0" "$@"
fi

# Ensure all sub-scripts have executable permissions
chmod +x configure-params.sh
chmod +x update-system.sh
chmod +x configure-ssh.sh
chmod +x configure-mysql.sh
chmod +x configure-nginx.sh
chmod +x configure-certs.sh
chmod +x configure-dependencies.sh
chmod +x configure-apache.sh
chmod +x configure-wordpress.sh
chmod +x configure-firewall.sh



# Run sub-scripts
source ./configure-params.sh

./update-system.sh
./configure-ssh.sh
./configure-mysql.sh
./configure-nginx.sh
./configure-certs.sh
./configure-dependencies.sh
./configure-apache.sh
./configure-wordpress.sh
./configure-firewall.sh

echo "All done!"
#!/bin/bash

echo "*************************************FIREWALL CONFIGURING*************************************"


function CONFIGURE_FIREWALL {
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

    sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A INPUT -i lo -j ACCEPT

    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT ACCEPT

    sudo apt-get install iptables-persistent -y
    sudo iptables-save | sudo tee /etc/iptables/rules.v4
    sudo netfilter-persistent save
    sudo netfilter-persistent reload
}


CONFIGURE_FIREWALL

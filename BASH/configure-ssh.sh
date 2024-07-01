#!/bin/bash

SSH_KEYS_PATH="$HOME/.ssh2"
SSH_AUTHORIZED_KEYS_PATH="$HOME/.ssh2/authorized_keys"

function IS_SSH_KEYS_EXISTS {
  if [ -d "$SSH_KEYS_PATH" ]; then
    echo "SSH keys exist in $SSH_KEYS_PATH"
  else
    echo "SSH keys don't exist. Generating new keys using ssh-keygen."
    mkdir -p "$SSH_KEYS_PATH"
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEYS_PATH/id_rsa" -N "" -q
  fi
}

function ADD_PUBLICKEY_TO_AUTHORIZED_KEYS {
  if ! [ -f "$SSH_AUTHORIZED_KEYS_PATH" ]; then
    echo "authorized_keys file doesn't exist. Creating it now."
    touch "$SSH_AUTHORIZED_KEYS_PATH"
  fi

  PUBLIC_KEY=$(cat "$SSH_KEYS_PATH/id_rsa.pub")
  if ! grep -q "$PUBLIC_KEY" "$SSH_AUTHORIZED_KEYS_PATH"; then
    echo "Adding public key to authorized_keys."
    echo "$PUBLIC_KEY" >> "$SSH_AUTHORIZED_KEYS_PATH"
  else
    echo "Public key already exists in authorized_keys."
  fi
}


function DISABLE_PASSWORD_LOGIN {
  SSHD_CONFIG="/etc/ssh/sshd_config"

  if grep -q "^PasswordAuthentication no" "$SSHD_CONFIG"; then
    echo "Password authentication is already disabled."
  else
    echo "Disabling password authentication."
    sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' "$SSHD_CONFIG"
    sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$SSHD_CONFIG"
    echo "Password authentication has been disabled."
  fi
}

IS_SSH_KEYS_EXISTS
ADD_PUBLICKEY_TO_AUTHORIZED_KEYS
DISABLE_PASSWORD_LOGIN

sudo systemctl restart ssh

echo "SSH server was restarted"
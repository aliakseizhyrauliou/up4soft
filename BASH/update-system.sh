#!/bin/bash

function CREATE_LOGS_FILE {
    if ! [ -f "$LOGS_FILE_PATH" ]; then
        echo "Creating update system logs file at $LOGS_FILE_PATH"
        touch "$LOGS_FILE_PATH"
    fi
}

function UPDATE_SYSTEM {
    echo "Updating system"
    {
        echo "---- Update started at $(date) ----"
        sudo apt update -y
        sudo apt upgrade -y
        echo "---- Update finished at $(date) ----"
    } >> "$LOGS_FILE_PATH" 2>&1
}

CREATE_LOGS_FILE
UPDATE_SYSTEM
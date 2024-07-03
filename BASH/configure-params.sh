#!/bin/bash

export MYSQL_USER="${MYSQL_USER:-wordpress}"
export MYSQL_PASSWORD="${MYSQL_PASSWORD:-pass}"
export MYSQL_DATABASE_NAME="${MYSQL_DATABASE_NAME:-wordpress}"
export LOGS_FILE_PATH="${LOGS_FILE_PATH:-/var/log/up4soft_task.log}"
export DOMAIN_NAME="${DOMAIN_NAME:-appka.com}"
export WORDPRESS_PREFIX="${WORDPRESS_PREFIX:-/wordpress}"
export CUSTOM_PAGE_PREFIX="${CUSTOM_PAGE_PREFIX:-/site}"
export ROOT_DATABASE_PASSWORD="${ROOT_DATABASE_PASSWORD:-Root123*}"


while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -mu|--mysql-user)
            MYSQL_USER="$2"
            shift 
            shift 
            ;;
        -mp|--mysql-password)
            MYSQL_PASSWORD="$2"
            shift 
            shift 
            ;;
        -l|--logs-file)
            LOGS_FILE_PATH="$2"
            shift 
            shift 
            ;;
        -d|--domain)
            DOMAIN_NAME="$2"
            shift 
            shift 
            ;;
        -wp|--wordpress-prefix)
            WORDPRESS_PREFIX="$2"
            shift 
            shift 
            ;;
        -rdp|--root-database-password)
            ROOT_DATABASE_PASSWORD="$2"
            shift 
            shift 
            ;;
        -cp|--custom-page-prefix)
            CUSTOM_PAGE_PREFIX="$2"
            shift 
            shift 
            ;;
        *)  
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "*************************************EXPORTED VARIABLES*************************************"
echo "MYSQL_USER is set to: $MYSQL_USER"
echo "MYSQL_PASSWORD is set to: $MYSQL_PASSWORD"
echo "LOGS_FILE_PATH is set to: $LOGS_FILE_PATH"
echo "DOMAIN_NAME is set to: $DOMAIN_NAME"
echo "WORDPRESS_PREFIX is set to: $WORDPRESS_PREFIX"
echo "CUSTOM_PAGE_PREFIX is set to: $CUSTOM_PAGE_PREFIX"

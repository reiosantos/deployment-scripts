#!/usr/bin/env bash

. ./base_dirs.sh

cd ${APP_BASE_DIR}

rm -rf ${APP_SSL_SCRIPTS}
mkdir ${APP_SSL_SCRIPTS}
cd ${APP_SSL_SCRIPTS}

KEY_NAME=${COMMON_SCRIPTS_NAME}

openssl genrsa -out ${KEY_NAME}.key 2048
openssl rsa -in ${KEY_NAME}.key -out ${KEY_NAME}.key
openssl req -new -key ${KEY_NAME}.key -out ${KEY_NAME}.csr
openssl x509 -req -days 365 -in ${KEY_NAME}.csr -signkey ${KEY_NAME}.key -out ${KEY_NAME}.crt

cat ${KEY_NAME}.key > ${KEY_NAME}.pem
cat ${KEY_NAME}.crt >> ${KEY_NAME}.pem

cd ${APP_BASE_DIR}

sudo mkdir /etc/nginx/ssl
sudo cp ${KEY_NAME}.key /etc/nginx/ssl
sudo cp ${KEY_NAME}.pem /etc/nginx/ssl

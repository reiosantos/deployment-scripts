#!/usr/bin/env bash

. ./base_dirs.sh

setupEnvironment() {
    printf '=============Setup NodeJS environment=============== \n'
    cd $HOME
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt install nodejs -y
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update -y && sudo apt install nginx git yarn g++ make -y
}

setupApp() {
    printf '===============Setup the Application ================== \n'
    git clone ${REPOSITORY_URL} ${APP_BASE_DIR}
    cd ${APP_BASE_DIR}
    yarn install
}

configureNginx() {
    printf '==================== Configure nginx =================== \n'
    # Create the nginx configuration
    cd ${APP_DEPLOY_SCRIPTS}

    sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
    sudo rm -rf /etc/nginx/sites-enabled/${COMMON_SCRIPTS_NAME}-vhost.conf
    sudo rm -rf /etc/nginx/sites-enabled/${COMMON_SCRIPTS_NAME}-ssl-vhost.conf

    sudo cp -rf ./${COMMON_SCRIPTS_NAME}-vhost.conf /etc/nginx/sites-available/
    sudo cp -rf ./${COMMON_SCRIPTS_NAME}-ssl-vhost.conf /etc/nginx/sites-available/

    sudo ln -s /etc/nginx/sites-available/${COMMON_SCRIPTS_NAME}-vhost.conf /etc/nginx/sites-enabled/${COMMON_SCRIPTS_NAME}-vhost.conf
    sudo ln -s /etc/nginx/sites-available/${COMMON_SCRIPTS_NAME}-ssl-vhost.conf /etc/nginx/sites-enabled/${COMMON_SCRIPTS_NAME}-ssl-vhost.conf
    sudo service nginx restart
}

setupStartScript() {
    printf '=============== Create a startup script =============== \n'

    # create a startup script to load the environment variables and start the app
    cd ${APP_DEPLOY_SCRIPTS} && . ./env.sh && cd ${APP_BASE_DIR}
}

setupStartService() {
    printf '============ Configure startup service ============= \n'

    # Create service that starts the app from the startup script
    cd ${APP_DEPLOY_SCRIPTS}
    sudo cp -rf ./${COMMON_SCRIPTS_NAME}.service /etc/systemd/system/
    sudo chmod 664 /etc/systemd/system/${COMMON_SCRIPTS_NAME}.service
    sudo systemctl daemon-reload
    sudo systemctl enable ${COMMON_SCRIPTS_NAME}.service
    sudo systemctl start ${COMMON_SCRIPTS_NAME}.service
}

run () {
    setupEnvironment
    setupApp
    configureNginx
    setupStartScript
    setupStartService
}

run

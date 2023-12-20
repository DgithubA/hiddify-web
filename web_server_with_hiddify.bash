#!/bin/bash
cd $( dirname -- "$0"; )


red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
ERROR="${red}ERROR:"
OK="${green}ok.! "


# install php
PHP_VERSION="8.1"
FPM_PORT=9005
echo "========install php version {$PHP_VERSION}======="

sudo apt install software-properties-common apt-transport-https -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install php$PHP_VERSION-fpm php$PHP_VERSION-cli php$PHP_VERSION-common php$PHP_VERSION-mbstring php$PHP_VERSION-xmlrpc php$PHP_VERSION-soap php$PHP_VERSION-gd php$PHP_VERSION-xml php$PHP_VERSION-intl php$PHP_VERSION-mysql php$PHP_VERSION-cli php$PHP_VERSION-ldap php$PHP_VERSION-zip php$PHP_VERSION-curl php$PHP_VERSION-opcache php$PHP_VERSION-readline php$PHP_VERSION-xml php$PHP_VERSION-gd -y

# edit /etc/php/VERSION/fpm/pool.d/www.conf
echo "edit configs file...."
WWW_CONF_FILE="/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" 
if [ -f WWW_CONF_FILE ]; then
    cp ${WWW_CONF_FILE} ${WWW_CONF_FILE}.default
    sudo sed -i -E "s/^listen\s*=\s*\/run\/php\/php${PHP_VERSION}-fpm\.sock/;listen = \/run\/php\/php${PHP_VERSION}-fpm.sock/g" ${WWW_CONF_FILE}
    sudo sed -i -E "s/^;?listen\s*=\s*\/run\/php\/php${PHP_VERSION}-fpm\.sock/listen = ${FPM_PORT}/g" ${WWW_CONF_FILE}
    sudo sed -i -E "s/^listen\.owner\s*=\s*[^[:space:]]+/listen.owner = nginx/g" ${WWW_CONF_FILE}
    sudo sed -i -E "s/^listen\.group\s*=\s*[^[:space:]]+/listen.group = nginx/g" ${WWW_CONF_FILE}
    sudo sed -i -E "s/^;?listen\.mode\s*=\s*[^[:space:]]+/listen.mode = 0660/g" ${WWW_CONF_FILE}
    # enable php fpm
    sudo systemctl enable php$PHP_VERSION-fpm --now
    systemctl status php$PHP_VERSION-fpm
    # edit /etc/nginx/snippets/fastcgi-php.conf
    if [-f /etc/nginx/snippets/fastcgi-php.conf ]; than
        sudo sed -i 's/include fastcgi\.conf;/include \/etc\/nginx\/fastcgi.conf;/g' /etc/nginx/snippets/fastcgi-php.conf
        echo "${OK}config file ${green}edited."
    else
        echo "${ERROR}fastcgi file not exist";
else
    echo "${ERROR}www conf file not exist"
fi

#edit /opt/hiddify-manager/nginx/parts/def-link.conf
DEF_LINK_PATH="/opt/hiddify-manager/nginx/parts/def-link.conf"
DEF_LINK_URL="https://github.com/DgithubA/"
cp ${DEF_LINK_PATH} ${DEF_LINK_PATH}.default
curl -p ${DEF_LINK_PATH} ${DEF_LINK_URL}

#web root path
INDEX_FILE="/var/www/html/index.php"
INDEX_DIRECTORY=$(dirname "$INDEX_FILE")
DEF_INDEX_URL="https://github.com/DgithubA/"
mkdir -p ${INDEX_DIRECTORY}
echo -e "<?php\necho 'hello world'; ?>" > ${INDEX_FILE}
curl -p ${INDEX_FILE} ${DEF_INDEX_URL}

#restart hiddify-nginx.service
systemctl restart hiddify-nginx.service
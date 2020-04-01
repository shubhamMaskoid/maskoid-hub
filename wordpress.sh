#!/bin/bash
echo
read -p "Enter Username as you want : " username
echo
if [ -d "/home/$username" ]; then
    echo User Already Exists
echo
else
    read -p "Enter Domain Name : " domain
    USER=$username
    PASSWORD="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
    DBPASS="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)"
    EMAIL="alert@maskoid.net"
    DOMAIN=$domain
    bash /usr/local/vesta/bin/v-add-user $USER $PASSWORD $EMAIL
    bash /usr/local/vesta/bin/v-add-domain $USER $DOMAIN
    bash /usr/local/vesta/bin/v-add-database $USER db user $DBPASS
    cd /home/$USER/web/$DOMAIN/public_html
    wget http://wp.privateserver.tech/wordpress.zip
    bash /usr/local/vesta/bin/v-extract-fs-archive $USER wordpress.zip /home/$USER/web/$DOMAIN/public_html
    cd /home/$USER/web/$DOMAIN/public_html/wordpress
    mv * /home/$USER/web/$DOMAIN/public_html
    cd /home/$USER/web/$DOMAIN/public_html
    mv wp-config-sample.php wp-config.php
    sed -i 's/'database_name_here'/'$USER'_db/g' /home/$USER/web/$DOMAIN/public_html/wp-config.php
    sed -i 's/'username_here'/'$USER'_user/g' /home/$USER/web/$DOMAIN/public_html/wp-config.php
    sed -i 's/'password_here'/'$DBPASS'/g' /home/$USER/web/$DOMAIN/public_html/wp-config.php
    rm -rf wordpress wordpress.zip y
    echo 'Opreation Done'
    echo
    echo Vesta Username : $USER
    echo
    echo Vesta Password : $PASSWORD
    echo
    echo DB Username : "$USER"_db
    echo
    echo DB Password : $DBPASS
    echo
    echo Wordpress Site : http://$DOMAIN
    echo
fi
exit
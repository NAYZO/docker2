#!/usr/bin/env bash

docker-compose up -d

sudo ./addVhosts.sh hosts

docker exec -it docker_php zsh


# Restart rsyslog
#service rsyslog restart

# Restart rabbitmq server + Add new user
#service rabbitmq-server restart


# Set cache and logs Permissions of the password-tracker project (sf v3.3)
#cd /var/www/html/password-tracker
#
#HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)
#
#setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
#setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var


# Add projects Permissions
#cd /var/www/ && chown -R 1000:www-data *

# cd /var/www/optedif-v2 && chown -R www-data app/cache app/logs


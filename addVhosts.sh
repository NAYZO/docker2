#!/bin/bash

# edit /etc/hosts
container_ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' docker_nginx)

echo "Container IP address is: $container_ip"
echo "${bold}==> Modifying /etc/hosts${normal}"

while IFS='' read -r line || [[ -n "$line" ]]; do

	if [[ ! -z "$line" ]]; then
        sed -i "/$line/d" /etc/hosts
    	echo "$container_ip $line" | sudo tee --append /etc/hosts
	fi

done < "$1"

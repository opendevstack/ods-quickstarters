#!/bin/bash
# this script checks for env variable HTTP_PROXY and add them to settings.xml
# 
if [[ $HTTP_PROXY != "" ]]; then

mvn_proxy="<proxy><id>internal</id><active>true</active><protocol>http</protocol>"

	proxy=$(echo $HTTP_PROXY | sed -e "s|https://||g" | sed -e "s|http://||g")
	proxy_hostp=$(echo $proxy | cut -d "@" -f2)
	
	proxy_host=$(echo $proxy_hostp | cut -d ":" -f1)
	mvn_proxy=$mvn_proxy"<host>$proxy_host</host>"
	
	proxy_port=$(echo $proxy_hostp | cut -d ":" -f2)
	mvn_proxy=$mvn_proxy"<port>$proxy_port</port>"

	proxy_userp=$(echo $proxy | cut -d "@" -f1)
	if [[ $proxy_userp != $proxy_hostp ]]; 
	then
		proxy_user=$(echo $proxy_userp | cut -d ":" -f1)
		mvn_proxy=$mvn_proxy"<username>$proxy_user</username>"
		proxy_pw=$(echo $proxy_userp | sed -e "s|$proxy_user:||g")
		mvn_proxy=$mvn_proxy"<password>$proxy_pw</password>"
 	fi
fi

if [[ $NO_PROXY != "" ]]; then
	noproxy_host=$(echo $NO_PROXY | sed -e 's|\,\.|\,\*\.|g')
	noproxy_host=$(echo $noproxy_host | sed -e "s/,/|/g")
	mvn_proxy=$mvn_proxy"<nonProxyHosts>$noproxy_host</nonProxyHosts>"
fi

if [[ $HTTP_PROXY != "" ]]; then
	mvn_proxy=$mvn_proxy"</proxy>"
fi

echo -e $mvn_proxy > /tmp/mvn_proxy

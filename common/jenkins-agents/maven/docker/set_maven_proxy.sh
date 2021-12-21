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

 	if [[ $NO_PROXY != "" ]]; then
	 	noproxy_host=$(echo $NO_PROXY | sed -e 's|\,\.|\,\*\.|g')
 		noproxy_host=$(echo $noproxy_host | sed -e "s/,/|/g")
 		mvn_proxy=$mvn_proxy"<nonProxyHosts>$noproxy_host</nonProxyHosts>"
 	fi

	mvn_proxy=$mvn_proxy"</proxy>"
fi

if [[ $HTTPS_PROXY != "" ]]; then

mvn_proxy_s="<proxy><id>internal-https</id><active>true</active><protocol>https</protocol>"

	proxy_s=$(echo $HTTPS_PROXY | sed -e "s|https://||g" | sed -e "s|http://||g")
	proxy_s_hostp=$(echo $proxy_s | cut -d "@" -f2)
	
	proxy_s_host=$(echo $proxy_s_hostp | cut -d ":" -f1)
	mvn_proxy_s=$mvn_proxy_s"<host>$proxy_s_host</host>"
	
	proxy_s_port=$(echo $proxy_s_hostp | cut -d ":" -f2)
	mvn_proxy_s=$mvn_proxy_s"<port>$proxy_s_port</port>"

	proxy_s_userp=$(echo $proxy_s | cut -d "@" -f1)
	if [[ $proxy_s_userp != $proxy_s_hostp ]]; 
	then
		proxy_s_user=$(echo $proxy_s_userp | cut -d ":" -f1)
		mvn_proxy_s=$mvn_proxy_s"<username>$proxy_s_user</username>"
		proxy_s_pw=$(echo $proxy_s_userp | sed -e "s|$proxy_s_user:||g")
		mvn_proxy_s=$mvn_proxy_s"<password>$proxy_s_pw</password>"
 	fi

 	if [[ $NO_PROXY != "" ]]; then
	 	noproxy_s_host=$(echo $NO_PROXY | sed -e 's|\,\.|\,\*\.|g')
 		noproxy_s_host=$(echo $noproxy_s_host | sed -e "s/,/|/g")
 		mvn_proxy_s=$mvn_proxy_s"<nonProxyHosts>$noproxy_s_host</nonProxyHosts>"
 	fi

	mvn_proxy_s=$mvn_proxy_s"</proxy>"

	mvn_proxy=$mvn_proxy$mvn_proxy_s
fi

echo -e $mvn_proxy > /tmp/mvn_proxy

#!/bin/bash
# this script checks for env variable HTTP_PROXY and add them to gradle.properties
# 
if [[ $HTTP_PROXY != "" ]]; then

	proxy=$(echo $HTTP_PROXY | sed -e "s|https://||g" | sed -e "s|http://||g")
	proxy_hostp=$(echo $proxy | cut -d "@" -f2)
	
	GRADLE_WRAPPER_HOME=/tmp/gradle/wrapper
	
	echo "systemProp.proxySet=\"true\"" >> $GRADLE_USER_HOME/gradle.properties
	echo "systemProp.proxySet=\"true\"" >> $GRADLE_WRAPPER_HOME/gradle.properties
	
	proxy_host=$(echo $proxy_hostp | cut -d ":" -f1)
	echo "systemProp.http.proxyHost=$proxy_host" >> $GRADLE_USER_HOME/gradle.properties
	echo "systemProp.https.proxyHost=$proxy_host" >> $GRADLE_USER_HOME/gradle.properties
	echo "systemProp.http.proxyHost=$proxy_host" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
	echo "systemProp.https.proxyHost=$proxy_host" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
	
	proxy_port=$(echo $proxy_hostp | cut -d ":" -f2)
	echo "systemProp.http.proxyPort=$proxy_port" >> $GRADLE_USER_HOME/gradle.properties
	echo "systemProp.https.proxyPort=$proxy_port" >> $GRADLE_USER_HOME/gradle.properties
	echo "systemProp.http.proxyPort=$proxy_port" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
	echo "systemProp.https.proxyPort=$proxy_port" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties

	proxy_userp=$(echo $proxy | cut -d "@" -f1)
	if [[ $proxy_userp != "$proxy_hostp" ]];
	then
		proxy_user=$(echo $proxy_userp | cut -d ":" -f1)
		echo "systemProp.http.proxyUser=$proxy_user" >> $GRADLE_USER_HOME/gradle.properties
		echo "systemProp.https.proxyUser=$proxy_user" >> $GRADLE_USER_HOME/gradle.properties
		echo "systemProp.http.proxyUser=$proxy_user" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
		echo "systemProp.https.proxyUser=$proxy_user" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
		
		proxy_pw=$(echo $proxy_userp | sed -e "s|$proxy_user:||g")
		echo "systemProp.http.proxyPassword=$proxy_pw" >> $GRADLE_USER_HOME/gradle.properties
		echo "systemProp.https.proxyPassword=$proxy_pw" >> $GRADLE_USER_HOME/gradle.properties
		echo "systemProp.http.proxyPassword=$proxy_pw" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
		echo "systemProp.https.proxyPassword=$proxy_pw" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
 	fi
fi

if [[ $NO_PROXY != "" ]]; then
	noproxy_host=$(echo $NO_PROXY | sed -e 's|\,\.|\,\*\.|g')
	noproxy_host=$(echo $noproxy_host | sed -e "s/,/|/g")
	echo "systemProp.http.nonProxyHosts=$noproxy_host" >> $GRADLE_USER_HOME/gradle.properties
	echo "systemProp.https.nonProxyHosts=$noproxy_host" >> $GRADLE_USER_HOME/gradle.properties
	echo "systemProp.http.nonProxyHosts=$noproxy_host" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
	echo "systemProp.https.nonProxyHosts=$noproxy_host" >> $GRADLE_WRAPPER_HOME/gradle-wrapper.properties
fi

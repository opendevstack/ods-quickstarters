#!/bin/bash

if [[ $HTTP_PROXY != "" ]]; then
    echo "Setting proxy settings for sbt ..."

    SBT_CONFIG=/etc/sbt/sbtopts
    
    proxy=$(echo $HTTP_PROXY | sed -e "s|https://||g" | sed -e "s|http://||g")
	proxy_hostp=$(echo $proxy | cut -d "@" -f2)
    proxy_host=$(echo $proxy_hostp | cut -d ":" -f1)
    proxy_port=$(echo $proxy_hostp | cut -d ":" -f2)
    proxy_userp=$(echo $proxy | cut -d "@" -f1)

    echo "-Dhttp.proxyHost=\"$proxy_host\"" >> $SBT_CONFIG
    echo "-Dhttps.proxyHost=\"$proxy_host\"" >> $SBT_CONFIG
    
    echo "-Dhttp.proxyPort=\"$proxy_port\"" >> $SBT_CONFIG
    echo "-Dhttps.proxyPort=\"$proxy_port\"" >> $SBT_CONFIG

    if [[ $proxy_userp != $proxy_hostp ]]; then
        proxy_user=$(echo $proxy_userp | cut -d ":" -f1)
        proxy_pw=$(echo $proxy_userp | sed -e "s|$proxy_user:||g")

        echo "-Dhttp.proxyUser=\"$proxy_user\"" >> $SBT_CONFIG
        echo "-Dhttps.proxyUser=\"$proxy_user\"" >> $SBT_CONFIG
        
        echo "-Dhttp.proxyPassword=\"$proxy_pw\"" >> $SBT_CONFIG
        echo "-Dhttps.proxyPassword=\"$proxy_pw\"" >> $SBT_CONFIG
    fi
else 
    echo "No HTTP_PROXY set. Do nothing for sbt proxy settings."
fi

if [[ $NO_PROXY != "" ]]; then
    noproxy_host=$(echo $NO_PROXY | sed -e 's|\,\.|\,\*\.|g')
	noproxy_host=$(echo $noproxy_host | sed -e "s/,/|/g")

    echo "-Dhttp.nonProxyHosts=\"$noproxy_host\"" >> $SBT_CONFIG
    echo "-Dhttps.nonProxyHosts=\"$noproxy_host\"" >> $SBT_CONFIG
fi

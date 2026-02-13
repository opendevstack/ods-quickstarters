#!/bin/bash
set -eu

# Script to import SSL/TLS certificates from remote servers
# Usage: Set APP_DNS environment variable with format "host1:port1;host2:port2"
# Example: APP_DNS="example.com:443;internal.corp:8443"

# If APP_DNS is not set, try to extract hosts from Renovate config
if [[ -z ${APP_DNS:=""} ]]; then
    echo "APP_DNS not set, checking for Renovate configuration..."
    
    # Try to extract endpoint from config file if it exists
    if [ -f /usr/src/app/config.js ]; then
        ENDPOINT=$(grep -oP 'endpoint["\s:]+["'\'']\K[^"'\'']+' /usr/src/app/config.js 2>/dev/null || true)
        if [ -n "$ENDPOINT" ]; then
            # Extract hostname from URL
            HOST=$(echo "$ENDPOINT" | sed -E 's#https?://([^/:]+).*#\1#')
            if [ -n "$HOST" ]; then
                echo "Found endpoint in config: $HOST"
                APP_DNS="$HOST:443"
            fi
        fi
    fi
fi

if [[ ! -z ${APP_DNS:=""} ]]; then
    echo "Setting up certificates from APP_DNS=${APP_DNS} ..."

    # Parse APP_DNS (semicolon-separated list)
    arrIN=(${APP_DNS//;/ })
    for val in "${arrIN[@]}"; do
        dnsPortTuple=(${val//:/ })
        DNS=${dnsPortTuple[0]}
        PORT=${dnsPortTuple[1]:=443}

        echo "Importing certificate from DNS=$DNS PORT=$PORT"
        cert_path="/usr/local/share/ca-certificates/${DNS}.crt"
        
        # Fetch certificate using openssl
        openssl s_client -showcerts -host ${DNS} -port ${PORT} </dev/null 2>/dev/null | \
            sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "${cert_path}"
        
        if [ -s "${cert_path}" ]; then
            echo "  ✓ Certificate saved to ${cert_path}"
        else
            echo "  ✗ Failed to fetch certificate from ${DNS}:${PORT}"
            rm -f "${cert_path}"
        fi
    done
    
    # Try to update system certificate trust store (may fail without root)
    if update-ca-certificates 2>/dev/null; then
        echo "System CA certificates updated"
    else
        echo "Could not update system CA store (no root access)"
    fi
    
    echo "Done with certificate setup"
else
    echo 'No certificates to import (APP_DNS not set and no config found)'
fi

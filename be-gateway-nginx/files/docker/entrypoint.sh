#!/usr/bin/env sh
set -e

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# setting up the resolver for nginx
cat > /usr/local/openresty/nginx/conf/resolver.conf << EOF
$(grep nameserver /etc/resolv.conf | head -n 1 | sed -e 's/nameserver/resolver/' -e 's/$/;/')
EOF

exec "$@"

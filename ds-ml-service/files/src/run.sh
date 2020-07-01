#!/usr/bin/env bash

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

echo "service type:"
echo $SERVICE_TYPE

exec gunicorn -b :8080 mlservice.services.$SERVICE_TYPE.app:gunicorn_app

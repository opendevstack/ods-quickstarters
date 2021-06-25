#!/usr/bin/env bash

exec gunicorn -b :8080 --access-logfile /dev/stdout main:app

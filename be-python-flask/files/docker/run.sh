#!/usr/bin/env bash

exec gunicorn -b :8080 main:app

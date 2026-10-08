#!/usr/bin/env bash

exec uvicorn main:app --host 0.0.0.0 --port 8080 --no-access-log

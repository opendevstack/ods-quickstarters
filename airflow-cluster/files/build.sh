#!/usr/bin/env bash

rsync -ahq --progress --exclude=.keep --delete src/* docker/dist

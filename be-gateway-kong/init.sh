#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while [[ "$#" > 0 ]]; do case $1 in
  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;

  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;

  -g=*|--group=*) GROUP="${1#*=}";;
  -g|--group) GROUP="$2"; shift;;

  -t=*|--target-dir=*) TARGET_DIR="${1#*=}";;
  -t|--target-dir) TARGET_DIR="$2"; shift;;

  -o=*|--owner=*) OWNER="${1#*=}";;
  -o|--owner) OWNER="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

cd $TARGET_DIR

mkdir -p $COMPONENT

cd $COMPONENT

sudo chown -R $OWNER .

echo "copy files from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .


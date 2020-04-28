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

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done



mkdir $COMPONENT
cd $COMPONENT

echo "generate project"
yo --no-insight node-express-typescript
npm install typescript@3.2.1 --save-dev
npm install jest -g
npm install jest-junit --save-dev

echo "copy custom files & fixes from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .
cp -r $SCRIPT_DIR/fix/. src/

echo "adding directories 'lib' and 'docker' to nyc exlude list to fix coverage test issue"
sed -i 's/--reporter=text/--exclude=\\"docker\\" --exclude=\\"lib\\" --reporter=text/g' package.json

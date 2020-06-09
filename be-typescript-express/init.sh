#!/usr/bin/env bash
set -eux

COMPONENT=$1

echo "Get dir"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $COMPONENT
cd $SCRIPT_DIR/files

echo "Generate package json"
npm init -y

echo "Install dependencies"

TYPESCRIPT_VERSION="3.9.5"
NODE_TYPE_VERSION="14.0.13"
EXPRESS_VERSION="4.17.1"
JEST_VERSION="26.0.0"
JEST_JUNIT_VERSION="10.0.0"

npm i typescript@$TYPESCRIPT_VERSION express@$EXPRESS_VERSION @types/node@$NODE_TYPE_VERSION jest@$JEST_VERSION @types/jest@$JEST_VERSION
npm i jest-junit@$JEST_JUNIT_VERSION --save-dev

echo "Generate ts config file. Skip library check and redirect transpiled ts files to dist folder."
npx tsc --init --skipLibCheck --outDir "./dist"

echo "Add npm start to standard package json"
python $SCRIPT_DIR/add-to-package-json.py $SCRIPT_DIR/files/package.json

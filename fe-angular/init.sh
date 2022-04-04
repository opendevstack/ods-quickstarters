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

echo "generate project"
ng new $COMPONENT --style=scss --skip-git --skip-install --defaults

cd $COMPONENT

echo "add additional task parameters to package.json"
sed -i "s|\"test\": \"ng test\"|\"test\": \"ng test --watch=false --code-coverage --reporters=junit,coverage\"|" ./package.json

echo "add required plugins to package.json"
sed -i "s|\"typescript\"|\"karma-junit-reporter\": \"^1.2.0\",\n    \"typescript\"|" ./package.json

echo "configure headless chrome in karma.conf.js"
read -r -d "" CHROME_CONFIG << EOM || true
    browsers: \['ChromeNoSandboxHeadless'\],\\
    customLaunchers: {\\
      ChromeNoSandboxHeadless: {\\
        base: 'Chrome',\\
        flags: \[\\
          '--no-sandbox',\\
          // See https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md\\
          '--headless',\\
          '--disable-gpu',\\
          // Without a remote debugging port, Google Chrome exits immediately.\\
          ' --remote-debugging-port=9222',\\
        \],\\
      },\\
    },
EOM
sed -i "s|\s*browsers: \['Chrome'\],|$CHROME_CONFIG|" ./karma.conf.js
sed -i "s|\(browsers:\)|    \1|g" ./karma.conf.js

echo "configure required plugins in karma.conf.js"
sed -i "/plugins: \[/a\     \ require('karma-junit-reporter')," ./karma.conf.js

echo "configure junit xml reporter in karma.conf.js"
read -r -d "" UNIT_XML_CONFIG << EOM || true
    junitReporter: {\\
      outputDir: './build/test-results/test',\\
      outputFile: 'test-results.xml',\\
      useBrowserName: false,\\
      xmlVersion: 1\\
    },\\
    reporters: \['progress', 'kjhtml'\],
EOM
sed -i "s|\s*reporters: \['progress', 'kjhtml'\],|    $UNIT_XML_CONFIG|" ./karma.conf.js

echo "configure coverage reporter in karma.conf.js"
sed -i "s|{ type: 'text-summary' }|{ type: 'lcovonly' },\n        { type: 'text-summary' }|" ./karma.conf.js

echo "copy custom files from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .

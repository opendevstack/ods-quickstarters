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
ng new $COMPONENT --style=scss --skip-git --skip-install

cd $COMPONENT

echo "Configure headless chrome in karma.conf.j2"
read -r -d "" CHROME_CONFIG << EOM || true
    browsers: \['ChromeNoSandboxHeadless'\],\\
\\
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

echo "Configure required plugins in karma.conf.js"
sed -i "/plugins: \[/a\     \ require('karma-junit-reporter')," ./karma.conf.js

echo "Configure junit xml reporter in karma.conf.js"
read -r -d "" UNIT_XML_CONFIG << EOM || true
    reporters: \['progress', 'junit', 'kjhtml'\],\\
\\
    junitReporter: {\\
      outputDir: './build/test-results/test',\\
      outputFile: 'test-results.xml',\\
      useBrowserName: false,\\
      xmlVersion: 1\\
    },
EOM
sed -i "s|\s*reporters: \['progress', 'kjhtml'\],|$UNIT_XML_CONFIG|" ./karma.conf.js

echo "Configure headless chrome in protractor.conf.js"
read -r -d '' PROTRACTOR_CONFIG << EOM || true
    'browserName': 'chrome',\\
    'chromeOptions': {\\
      'args': \[\\
        'headless',\\
        'no-sandbox',\\
        'disable-web-security'\\
      \]\\
    },
EOM

sed -i "s|\s*'browserName': 'chrome'|$PROTRACTOR_CONFIG|" ./e2e/protractor.conf.js
sed -i "s|\('browserName'\)|    \1|g" ./e2e/protractor.conf.js

echo "fix nexus repo path"
repo_path=$(echo "$GROUP" | tr . /)
sed -i.bak "s|org/opendevstack/projectId|$repo_path|g" $SCRIPT_DIR/files/docker/Dockerfile
rm $SCRIPT_DIR/files/docker/Dockerfile.bak

# The following commands copy custom files over the generated ones from the call
# of "ng new" above. The custom files were created based on the generated ones
# and the following changes:
#   - package.json:
#       - replaced value of "name" with placeholder "$COMPONENT"
#       - added parameters to the commands in "scripts"
#       - added "devDependencies" for "rxjs-tslint" and "tslint-sonarts"
#   - tslint.json:
#       - added linter rules from "rxjs-tslint" and "tslint-sonarts"
#       - explicitly mention or disable some of the stricter SonarQube rules:
#         "cognitive-complexity", "no-commented-code", "no-duplicate-string"
#
# Please note: When updating to a newer Angular version, please update those files accordingly.
echo "copy custom files from quickstart to generated project"
rm ./package.json
rm ./tslint.json
cp -rv $SCRIPT_DIR/files/. .
sed -i "s/\$COMPONENT/${COMPONENT}/" ./package.json

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
# create temp-dir since non-interactive ionic-cli can not generate into existing directories
mkdir start_$COMPONENT
cd start_$COMPONENT

# creating project
ionic start $COMPONENT blank --type=angular --no-deps --no-git --no-interactive

# move generated project to the intended directory
mv $COMPONENT/ ..
# switch to component directory
cd ../$COMPONENT
# remove empty temp-dir
rm -r ../start_$COMPONENT

echo "Copy browsers list "
cp  ../fe-ionic/.browserslistrc .browserslistrc

echo "Change test setup to single run in karma.conf.js"
sed -i "s|\s*singleRun: false|singleRun: true|" ./karma.conf.js

echo "Configure headless chrome in karma.conf.js"
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

echo "Add required plugins in karma.conf.js"
sed -i "/plugins: \[/a\     \ require('karma-junit-reporter')," ./karma.conf.js

echo "Configure junit xml reporter in karma.conf.js"
read -r -d "" UNIT_XML_CONFIG << EOM || true
    reporters: \['progress', 'junit', 'kjhtml'\],\\
\\
    junitReporter: {\\
      outputDir: './build/test-results/test',\\
      outputFile: 'test-results.xml',\\
      useBrowserName: false\\
    },
EOM
sed -i "s|\s*reporters: \['progress', 'kjhtml'\],|$UNIT_XML_CONFIG|" ./karma.conf.js

echo "Fix path for coverage analysis output"
sed -i "s|\s*__dirname, '\.\./coverage'|__dirname, 'coverage'|" ./karma.conf.js

echo "Adjust package.json to have the full test"
sed -i "s|\s*\"test\": \"ng test\"|\"test\": \"ng test --code-coverage --reporters=junit --progress=false\"|" ./package.json
sed -i "s|\s*\"devDependencies\": {|\"devDependencies\": { \"karma-junit-reporter\": \"^2.0.1\",|" ./package.json

echo "fix nexus repo path"
repo_path=$(echo "$GROUP" | tr . /)
sed -i.bak "s|org/opendevstack/projectId|$repo_path|g" $SCRIPT_DIR/files/docker/Dockerfile
rm $SCRIPT_DIR/files/docker/Dockerfile.bak

echo "copy files from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .

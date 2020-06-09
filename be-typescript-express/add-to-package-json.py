#!/usr/bin/python2

import sys
import json

def appendCommandsToPackageJson(packageJson):
    with open(packageJson, 'r') as file:
        package = file.read()

    obj = json.loads(package)
    obj['scripts'].update(
            {
                "build": "tsc --watch",
                "start": "node dist/src/index.js",
                "test": "JEST_JUNIT_OUTPUT_DIR='build/test-results/test' JEST_JUNIT_OUTPUT_NAME='test-results.xml' npx jest --reporters=default --reporters=jest-junit --coverage --coverageDirectory=coverage_output --forceExit ./dist"
            }
        )

    with open(packageJson, 'w') as file:
        file.write(json.dumps(obj, indent=4, sort_keys=True))
        file.close()

if __name__ == "__main__":
    appendCommandsToPackageJson(sys.argv[1])

#!/usr/bin/env bash

GIT_REV_PARSE_HEAD=`git rev-parse HEAD`
GIT_REV_PARSE_HEAD_SHORT=`git rev-parse --short HEAD`
GIT_REV_PARSE_BRANCH=`git rev-parse --abbrev-ref HEAD`
GIT_TOP_LEVEL=`git rev-parse --show-toplevel`
GIT_REPO_NAME=`basename ${GIT_TOP_LEVEL}`
GIT_LAST_CHANGE=`git log -1`

echo "GIT_COMMIT = \"${GIT_REV_PARSE_HEAD}\"" > src/mlservice/services/infrastructure/git_info.py
echo "GIT_COMMIT_SHORT = \"${GIT_REV_PARSE_HEAD_SHORT}\"" >> src/mlservice/services/infrastructure/git_info.py
echo "GIT_BRANCH = \"${GIT_REV_PARSE_BRANCH}\"" >> src/mlservice/services/infrastructure/git_info.py
echo "GIT_REPO_NAME = \"${GIT_REPO_NAME}\"" >> src/mlservice/services/infrastructure/git_info.py
echo "GIT_LAST_CHANGE = \"\"\"${GIT_LAST_CHANGE}\"\"\"" >> src/mlservice/services/infrastructure/git_info.py

rsync -ahq --progress --delete src/* docker/dist
rsync -ahq --progress --delete test docker/dist
rsync -ahq --progress --delete resources docker/dist
rsync -ahq --progress --delete test/run_integration_tests.sh docker/dist
rsync -ahq --progress --delete test/run_unittests.sh docker/dist

# Copy dvc folder if dvc is actually used
if [ -e .dvc ]
 then rsync -ahq --progress --delete .dvc docker/dist
fi

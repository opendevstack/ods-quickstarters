REM This .bat script is for local testing on windows machines

setlocal enableDelayedExpansion

git rev-parse HEAD > temp.txt
set /p GIT_REV_PARSE_HEAD=<temp.txt
@echo GIT_COMMIT = "%GIT_REV_PARSE_HEAD%" > src/mlservice/services/infrastructure/git_info.py

git rev-parse --short HEAD > temp.txt
set /p GIT_REV_PARSE_HEAD_SHORT=<temp.txt
@echo GIT_COMMIT_SHORT = "%GIT_REV_PARSE_HEAD_SHORT%" >> src/mlservice/services/infrastructure/git_info.py

git rev-parse --abbrev-ref HEAD > temp.txt
set /p GIT_REV_PARSE_BRANCH=<temp.txt
@echo GIT_BRANCH = "%GIT_REV_PARSE_BRANCH%" >> src/mlservice/services/infrastructure/git_info.py

git rev-parse --show-toplevel > temp.txt
set /p GIT_TOP_LEVEL=<temp.txt
@echo GIT_REPO_NAME = "%GIT_TOP_LEVEL%" >> src/mlservice/services/infrastructure/git_info.py

@echo GIT_LAST_CHANGE = "Local Test on Windows machine" >> src/mlservice/services/infrastructure/git_info.py
del temp.txt

del docker\dist\ /S /Q

xcopy /s src docker\dist\
xcopy /s resources docker\dist\resources
xcopy /s .dvc docker\dist\.dvc

copy test\run_integration_tests.sh docker\dist
copy test\run_unittests.sh docker\dist


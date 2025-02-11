# ODS Quickstarters

![](https://github.com/opendevstack/ods-quickstarters/workflows/Continous%20Integration%20Tests/badge.svg?branch=master)
![](https://327164e4f0dd.ngrok.io/images/quickstartertestsoutcome_master.svg)
![](https://327164e4f0dd.ngrok.io/images/quickstartertestsoutcome_feature_ods-devenv.svg)

## Introduction

This repository contains quickstarters, which are basically boilerplates that help to start out with a component quickly.


## Documentation

See [OpenDevStack Quickstarters](https://www.opendevstack.org/ods-documentation/opendevstack/latest/quickstarters/index.html) for details.

The source of this documentation is located in the antora folder at https://github.com/opendevstack/ods-quickstarters/tree/master/docs/modules/quickstarters/pages.


## Tests

All tests of quickstarters follow the same scheme. The test information is located in the `testdata` directory of each quickstarter. The file `steps.yml` describes the test steps to execute, and may reference files relative to the `testdata` directory (typically golden files located in `testdata/golden`).

The test logic and the available steps are located in [ods-core](https://github.com/opendevstack/ods-core/tree/master/tests).

Generally, a quickstarter test is made up out of the following:

1. Create the bitbucket repository for the quickstarter
2. Start the provisioning of a quickstarter via the webhook proxy
3. Verify expected stages against the actual stages execute in Jenkins
4. Trigger a jenkins build run instance (for the provisioned component)
5. Verify expected stages against the actual stages execute in Jenkins
6. Verify the created OpenShift artifacts, and if pods are available


## Running the tests

Run `make test-quickstarter` from the `ods-core` directory. By default this will run a test of all quickstarters in this repository. Single quickstarters can be tested via `make test-quickstarter QS=be-golang-plain`.

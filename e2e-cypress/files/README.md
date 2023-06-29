# Cypress end-to-end tests

This end-to-end testing project was generated from the *e2e-cypress* ODS quickstarter.

## Stages: installation / integration / acceptance

With the introduction of the release manager concept in OpenDevStack 3, e2e test quickstarters are expected to run tests in three different stages (installation, integration & acceptance) and generate a JUnit XML result file for each of these stages.

Please note that each stage is executed with its own Cypress configuration file (`cypress-<stage>.config.ts`) that can be adjusted to your particular case (e.g. base URL etc.). Make sure to keep `junit` as reporter and to not change the output path for the JUnit results files as they will be stashed by Jenkins and reused by the release manager.

## Running end-to-end tests

Run `npm run e2e` to execute all end-to-end tests via [Cypress](https://www.cypress.io) against the test instance of the front end.

## Local development

Run `npm start` to develop the e2e tests. The tests will automatically rebuild and run, if you change any of the source files. Ideally the test will run against a local instance of the front end, e.g. `http://localhost:4200` for an Angular app. This destination is configurable in the `cypress.config.ts` file.

## How to upload images or videos to Nexus

Screenshots are only taken when test fails.
  1. Open the Jenkinsfile
  2. Replace `stageTest(context)` by the following lines:
  ```
  def status = stageTest(context)
  if (status != 0) {
    odsComponentStageUploadToNexus(context,
    [
      distributionFile: 'tests/screenshots.zip',
      repository: 'leva-documentation',
      repositoryType: 'raw',
      targetDirectory: "${targetDirectory}"])
  }
  ```

## Reports
From [Merging reports across spec files](https://docs.cypress.io/guides/tooling/reporters#Merging-reports-across-spec-files): each spec file is processed completely separately during each cypress run execution. Thus each spec run overwrites the previous report file. To preserve unique reports for each spec file, use the `[hash]` in the `mochaFile` filename.

In order to generate one xml report per test type (installation, integration and acceptance) we use the junit-report-merger tool. See also the `junit-...-report` tasks in `package.json`.

## E2e test user authentication

With Cypress 12 version is now available `cy.origin()` that allows you to handle redirections. This funcionality eases the login handling.
See `./support/e2e.ts` for a generic login example.

## Cypress Cloud

Cypress Cloud has been enabled as a functionality and can be used by the quickstarter users. Some configuration needs to be done in the quickstarter for the dashboard to start recording executions. 

The steps for configuring this functionality are defined in (https://www.opendevstack.org/ods-documentation/opendevstack/latest/quickstarters/e2e-cypress.html).

For more information on this, please contact the support team.

#### *Obsolete*

This quickstarter provides a login command for Azure SSO with MSALv2 (`./support/msalv2-login.ts`) as well as sample code for a generic login (`./support/generic-login.ts`). 

## Links
* [Cypress](https://www.cypress.io)
* [Cypress API](https://docs.cypress.io/api/introduction/api.html)
* [Cypress Best Practices](https://docs.cypress.io/guides/references/best-practices.html)

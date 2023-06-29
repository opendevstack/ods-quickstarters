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

To use Cypress Cloud, follow these steps:
1. **Request access.** In order to access Cypress Cloud, you will need to request access to the AAD group. This can be done through MyServices using the Active Directory Group - Administration Request form. Once access has been granted, you will be able to log into https://cloud.cypress.io/login using your mail.

2. **Create a project in Cypress Cloud.** Once you have access to the AAD group, you can create a project in Cypress Cloud. This project will be used to store your Cypress tests and results. 

3. **Change the project ID as indicated in Cypress Cloud.** After creating the project, you will need to change the project ID in the four config files, to the one indicated in Cypress Cloud. This ID is used to identify your project and ensure that your tests are associated with the correct project.

4. **Set the Cypress Record Key as an environment variable in Openshift.** To enable recording of your tests in Cypress Cloud, you will need to set the Cypress Record Key as an environment variable named CYPRESS_RECORD_KEY in Openshift. This key is provided by Cypress and is used to authenticate your tests and results. By setting it in Openshift, we ensure that the record functionality will only be used in official runs and not for local development.

5. **Modify the Jenkinsfile for using the record script.** In the Jenkinsfile, change line 59 
    ```
    def status = sh(script: 'npm run e2e', returnStatus: true)
    ```
    for the following block of code, which will run the record script only when in master or in a release branch:
    ```
    if (context.gitBranch == 'master' || context.gitBranch.startsWith('release/')) {
      def status = sh(script: 'npm run e2e:jenkins:record', returnStatus: true)
    } else {
      def status = sh(script: 'npm run e2e', returnStatus: true)
    }
    ```
    
**Only use this functionality in releases, not development.** It is important to note that Cypress Cloud is intended for use in releases, not development. This ensures that your tests are run against stable and reliable code, and that the Dashboard does not get overflooded with non-relevant tests. For the same reason, the Jenkinsfile is configured to only pass the record parameter when running in the master branch, or in a release.

You can find more information about using the Cypress Cloud in the official documentation for Cypress https://docs.cypress.io/guides/cloud/introduction.

#### *Obsolete*

This quickstarter provides a login command for Azure SSO with MSALv2 (`./support/msalv2-login.ts`) as well as sample code for a generic login (`./support/generic-login.ts`). 

## Links
* [Cypress](https://www.cypress.io)
* [Cypress API](https://docs.cypress.io/api/introduction/api.html)
* [Cypress Best Practices](https://docs.cypress.io/guides/references/best-practices.html)

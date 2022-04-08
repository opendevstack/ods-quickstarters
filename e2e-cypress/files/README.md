# Cypress end-to-end tests

This end-to-end testing project was generated from the *e2e-cypress* ODS quickstarter.

## Stages: installation / integration / acceptance

With the introduction of the release manager concept in OpenDevStack 3, e2e test quickstarters are expected to run tests in three different stages (installation, integration & acceptance) and generate a JUnit XML result file for each of these stages.

Please note that each stage is executed with its own Cypress configuration file (`cypress-<stage>.json`) that can be adjusted to your particular case (e.g. base URL etc.). Make sure to keep `junit` as reporter and to not change the output path for the JUnit results files as they will be stashed by Jenkins and reused by the release manager.

## Running end-to-end tests

Run `npm run e2e` to execute all end-to-end tests via [Cypress](https://www.cypress.io) against the test instance of the front end.

## Local development

Run `npm start` to develop the e2e tests. The tests will automatically rebuild and run, if you change any of the source files. Ideally the test will run against a local instance of the front end, e.g. `http://localhost:4200` for an Angular app. This destination is configurable in the `cypress.json` file.

## E2e test user authentication

This quickstarter provides a login command for Azure SSO with MSALv2 (`./support/msalv2-login.ts`) as well as sample code for a generic login (`./support/generic-login.ts`). 

## Links
* [Cypress](https://www.cypress.io)
* [Cypress API](https://docs.cypress.io/api/introduction/api.html)
* [Cypress Best Practices](https://docs.cypress.io/guides/references/best-practices.html)

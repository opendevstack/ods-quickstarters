# cypress e2e tests

This e2e testing project was generated from the e2e-cypress ODS quickstarter.

## Stages: installation / integration / acceptance

With the implementation of the release manager concept in OpenDevStack 3, e2e test quickstarters are expected to run tests in 3 different stages (installation, integration & acceptance) and generate a JUnit XML result file for each of these stages.

Please note that each stage is executed with its own cypress configuration file (` cypress-<stage>.json `) that can be adjusted to your particular case (e.g. base URL etc.). Make sure to keep `junit` as reporter and to not change the output path for the JUnit results files as they will be stashed by Jenkins and reused by the release manager.

## Running end-to-end tests

Run `npm run e2e` to execute all end-to-end tests via [cypress](http://www.cypress.io) against the test instance of the front end.

### Local development 

Run `npm run watch` to develop the e2e test. The tests will automatically rebuild and run, if you change any of the source files.
The test will run against a local instance of the front end, e.g. `localhost:4200`. This destination is configurable in `cypress.json`. Provide credentials for a test user by defining them in a file called `secrets.json` inside the base directory. This file should have the following format:
  {
    "e2e": {
      "testUserName": "User Name",
      "testUserPassword": "xxxx"
    }
  }

Please note: `secrets.json` is mentioned in `.gitignore` to prevent it from being added to version control. Please keep it this way.

## Links
* [cypress](http://www.cypress.io)
* [cypress API](https://docs.cypress.io/api/introduction/api.html)
* [cypress Best Practices](https://docs.cypress.io/guides/references/best-practices.html)

# cypress e2e tests

This e2e testing project was generated from the e2e-cypress quickstarter

## Running end-to-end tests

Run `npm run e2e` to execute the end-to-end tests via [cypress](http://www.cypress.io) against the test instance of the front end.

Please note: For now the URL of this test instance is hard-coded inside the `package.json` file. There should be a better solution for handing this over. It is also possible to run `npm run e2e-at` with an additional parameter, e.g. `npm run e2e-at https://domain.com`.

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

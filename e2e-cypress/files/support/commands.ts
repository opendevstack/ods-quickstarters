// ***********************************************
// This commands.js contains custom commands and
// overwrite existing commands.
//
// For more information about custom commands
// please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************


// Crowd login support
// ***********************************************
// Either use...
//   ... the environment variables cypress_crowduser and cypress_crowdpassword or
//   ... provide a secret.json file
// ...to hand over user name and password of an Atlassian Crowd test user account.

const envCrowduser = 'crowduser';
const envCrowdpassword = 'crowdpassword';
let testUserName = Cypress.env(envCrowduser);
let testUserPassword = Cypress.env(envCrowdpassword);
let testUserToken: string = null;

export interface LoginCommand extends Cypress.Chainable<undefined> {
  crowdLogin: (asTest: boolean) => Cypress.Chainable<undefined>;
}

Cypress.Commands.add('crowdLogin', (asTest: boolean) => {
  if (!testUserName || !testUserPassword) {
    const secretsFileName = 'secrets.json';
    cy.log(`Environment variables ${envCrowduser} or ${envCrowdpassword} are not defined.`);
    cy.log(`Trying to read ${secretsFileName} instead...`);
    cy.readFile(secretsFileName).then(content => {
      testUserName = content.e2e.testUserName;
      testUserPassword = content.e2e.testUserPassword;
      cy.wrap(testUserName).should('not.be.undefined');
      cy.wrap(testUserPassword).should('not.be.undefined');
      loginTestUser(asTest);
    });
  } else {
    loginTestUser(asTest);
  }
});

function loginTestUser(asTest: boolean) {
  if (asTest || !testUserToken) {
    testLoginPage(testUserName, testUserPassword);
  } else {
    cy.log('Running e2e test with user ' + testUserName + ' (reusing last session token)');
    localStorage.setItem('token', testUserToken);
  }
}

function testLoginPage(userName: string, password: string): void {
  cy.log('Running e2e test with user ' + userName);
  testUserToken = null;
  /*
  Example code for manual login on a login page:

  cy.visit('');
  cy.get('[data-test=input-user-name]').type(userName).should('have.value', userName);
  cy.get('[data-test=input-password]').type(password, {log: false}).should('have.value', password);
  cy.get('[data-test=button-login]').click();
  // checks, if login was successful:
  cy.get('header h1').should('contain', 'My Application').then(() => {
    testUserToken = localStorage.getItem('token');
    cy.wrap(testUserToken).should('not.be.undefined');
  });
  */
}

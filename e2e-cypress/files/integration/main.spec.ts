import { LoginCommand } from '../support/commands';

/* tslint:disable:no-unused-expression */
describe('e2e tests', function () {

  it('Application is reachable', function () {
    cy.visit('');
    // cy.title().should('include', 'My Application Title');
  });

  context('Login', function () {
    it('Enter wrong username and password', function () {
      // try to login with false credentials
    });

    it('Enter username and password and check successful login with Crowd test user', function () {
      // (cy as LoginCommand).crowdLogin(true);
      // checks, if login was successful:
      //
    });

    it('Direct login by setting the token', function () {
      // (cy as LoginCommand).crowdLogin(false);
      // cy.visit('');
      // checks, if login was successful:
      //
    });
  });

});

// Generic Login support
// ***********************************************
// Originally developed by @cschweikert
//
// The variables below can be set by providing environment variables upfront. Environment variables for Cypress always need to have
// "CYPRESS_..." prepended, e.g. CYPRESS_USERNAME and CYPRESS_PASSWORD.
//
// ATTENTION: Please also check the "./Jenkinsfile" on how these environment variables are loaded on Jenkins from OpenShift.
//
// For local development it is also possible to inject environment variables via a "./cypress.env.json" file. You can use
// "./cypress.env.json.template" as a template for this. The leading "CYPRESS_..." is not needed here.

const testUserName = Cypress.env('USERNAME') as string;
const testUserPassword = Cypress.env('PASSWORD') as string;

const login = () => {
  Cypress.log({ name: 'login' });

  // do the required login procedures, e.g. by walking through a login screen or calling some API to gather a session token, etc.

  // Example: Running through a login page
  // cy.visit('/login');                                       // go to a login page
  // cy.get('#username').type(`${testUserName}`);              // enter test user's name
  // cy.get('#password').type(`${testUserPassword}{enter}`);   // enter test user's password
  // last but not least check for a sign, that login was successful
};

const logout = () => {
  Cypress.log({ name: 'logout' });

  // do the required logout procedure, e.g. by clicking a logout button, calling an API or simply "forgetting" the session tokens
};

export function addGenericLoginCommands() {
  Cypress.Commands.add('login', login);
  Cypress.Commands.add('logout', logout);
}

declare global {
  namespace Cypress {
    interface Chainable {
      login: typeof login;
      logout: typeof logout;
    }
  }
}

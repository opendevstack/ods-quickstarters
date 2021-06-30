// ***********************************************
// This commands.js contains custom commands and
// overwrite existing commands.
//
// For more information about custom commands
// please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************

// Azure SSO with MSALv2
// ***********************************************
// Originally developed by @tbabik and @herrkoch
//
// ATTENTION: This approach requires a technical, so-called "cloud-only" Azure user (<username>@<domain>.onmicrosoft.com) which does not
// go through federation. (For Boehringer Ingelheim coders: Please refer to the "BI Coders Notebook", section "Cypress and Azure SSO" in
// the "BI Coders" Teams channel for a description on how to order such a technical user in BI)

// Azure environment variables
// ATTENTION: Please check the Jenkinsfile (at root level of this repo) on how these env vars are loaded on Jenkins from OpenShift!
const aadTenantId = Cypress.env('TENANT_ID');
const aadClientId = Cypress.env('CLIENT_ID');
const aadClientSecret = Cypress.env('CLIENT_SECRET');
const aadUsername = Cypress.env('USERNAME');
const aadPassword = Cypress.env('PASSWORD');

const tenant = `https://login.microsoftonline.com/${aadTenantId}`;
const tenantUrl = `${tenant}/oauth2/v2.0/token`;

const scopes = [
  'openid',
  'profile',
  'user.read',
  'email',
  'offline_access' // needed to get a refresh token
];

// Adapted snippet taken from https://stackoverflow.com/a/63490929/1236781
Cypress.Commands.add('msalv2Login', () => {
  // AUTHENTICATE AGAINST OAUTH2 ENDPOINT for MSALv2
  cy.request({
    method: 'POST',
    url: tenantUrl,
    form: true,
    body: {
      client_info: 1, // returns an extra token that MSAL needs
      // grant_type: 'client_credentials',
      // scope: 'https://graph.microsoft.com/.default', // for grant_type: 'client_credentials'
      grant_type: 'password',
      scope: scopes.join(' '), // only works for grant_type: 'password'!
      client_id: aadClientId,
      client_secret: aadClientSecret,
      username: aadUsername, // cloud-only user! see comment at the top
      password: aadPassword
    }
  }).then(response => {
    const tokens = response.body;
    // FILL SESSION STORAGE AS MSALv2 EXPECTS IT
    // The token tells us how many seconds until expiration;
    // MSAL wants to know the timestamp of expiration.
    const cachedAt = Math.round(new Date().getTime() / 1000);
    const expiresOn = cachedAt + tokens.expires_in;
    const extendedExpiresOn = cachedAt + tokens.ext_expires_in;

    // We can pull the rest of the data we need off of the ID token body
    const id_token = tokens.id_token ? JSON.parse(Buffer.from(tokens.id_token.split('.')[1], 'base64').toString('utf-8')) : null;

    const clientId = id_token?.aud;
    const tenantId = id_token?.tid;
    const userId = id_token?.oid;
    const name = id_token?.name;
    const username = id_token?.preferred_username;

    const environment = 'login.microsoftonline.com';
    const homeAccountId = `${userId}.${tenantId}`;

    const cacheEntries = {};

    // client info
    cacheEntries[`${homeAccountId}-${environment}-${tenantId}`] = JSON.stringify({
      authorityType: 'MSSTS',
      clientInfo: tokens.client_info,
      environment,
      homeAccountId,
      localAccountId: userId,
      name,
      realm: tenantId,
      username,
    });

    // access token
    cacheEntries[`${homeAccountId}-${environment}-accesstoken-${clientId}-${tenantId}-${tokens.scope}`] = JSON.stringify({
      cachedAt: cachedAt.toString(),
      clientId,
      credentialType: 'AccessToken',
      environment,
      expiresOn: expiresOn.toString(),
      extendedExpiresOn: extendedExpiresOn.toString(),
      homeAccountId,
      realm: tenantId,
      secret: tokens.access_token,
      target: tokens.scope,
    });

    // id token
    cacheEntries[`${homeAccountId}-${environment}-idtoken-${clientId}-${tenantId}-`] = JSON.stringify({
      clientId,
      credentialType: 'IdToken',
      environment,
      homeAccountId,
      realm: tenantId,
      secret: tokens.id_token,
    });

    // refresh token
    cacheEntries[`${homeAccountId}-${environment}-refreshtoken-${clientId}--`] = JSON.stringify({
      clientId,
      credentialType: 'RefreshToken',
      environment,
      homeAccountId,
      secret: tokens.refresh_token,
    });

    // STORE IN SESSION STORAGE
    cy.window().then(window => {
      for (const [key, value] of Object.entries(cacheEntries)) {
        window.sessionStorage.setItem(key, value as string);
      }
    });
  });
});

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

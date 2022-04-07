// Azure SSO with MSALv2
// ***********************************************
// Originally developed by @tbabik and @herrkoch
//
// ATTENTION: This approach requires a technical, so-called "cloud-only" Azure user (<username>@<domain>.onmicrosoft.com) which does not
// go through federation. (For Boehringer Ingelheim coders: Please refer to the "BI Coders Notebook", section "Cypress and Azure SSO" in
// the "BI Coders" Teams channel for a description on how to order such a technical user in BI)

// Azure environment variables
// The variables below can be set by providing environment variables upfront. Environment variables for Cypress always need to have
// "CYPRESS_..." prepended, e.g. CYPRESS_TENANT_ID, CYPRESS_CLIENT_ID, etc.
//
// ATTENTION: Please also check the "./Jenkinsfile" on how these environment variables are loaded on Jenkins from OpenShift.
//
// For local development it is also possible to inject environment variables via a "./cypress.env.json" file. You can use
// "./cypress.env.json.template" as a template for this. The leading "CYPRESS_..." is not needed here.

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
  'offline_access', // needed to get a refresh token
];

// Adapted snippet taken from https://stackoverflow.com/a/63490929/1236781
const msalv2Login = () => {
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
      password: aadPassword,
    },
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

    const cacheEntries: { [key: string]: any } = {};

    // client info
    cacheEntries[`${homeAccountId}-${environment}-${tenantId}`] = {
      authorityType: 'MSSTS',
      clientInfo: tokens.client_info,
      environment,
      homeAccountId,
      localAccountId: userId,
      name,
      realm: tenantId,
      username,
    };

    // access token
    cacheEntries[`${homeAccountId}-${environment}-accesstoken-${clientId}-${tenantId}-${tokens.scope}`] = {
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
    };

    // id token
    cacheEntries[`${homeAccountId}-${environment}-idtoken-${clientId}-${tenantId}-`] = {
      clientId,
      credentialType: 'IdToken',
      environment,
      homeAccountId,
      realm: tenantId,
      secret: tokens.id_token,
    };

    // refresh token
    cacheEntries[`${homeAccountId}-${environment}-refreshtoken-${clientId}--`] = {
      clientId,
      credentialType: 'RefreshToken',
      environment,
      homeAccountId,
      secret: tokens.refresh_token,
    };

    // STORE IN SESSION STORAGE
    cy.window().then(window =>
      Object.entries(cacheEntries).forEach(([key, value]) => window.sessionStorage.setItem(key, JSON.stringify(value)))
    );
  });
};

export function addMsalv2LoginCommand() {
  Cypress.Commands.add('msalv2Login', msalv2Login);
}

declare global {
  namespace Cypress {
    interface Chainable {
      msalv2Login: typeof msalv2Login;
    }
  }
}

//For more details, you can follow this link:
//https://docs.cypress.io/guides/end-to-end-testing/azure-active-directory-authentication#Microsoft-AAD-Application-Setup

import { authenticator } from 'otplib';

function loginViaAAD(username: string, password: string) {

  //Go to your application URL and trigger the login.
  cy.visit('')

  //If needed, navigate and click on the login button.
  //As an example:
  //cy.get('button#signIn').click()

  //Login to your AAD tenant.
  //ATENTION: The redirection can happen at the 'login.microsoftonline.com' and also it might redirect as well to 'login.live.com'
  cy.origin(
    'https://login.microsoftonline.com',
    {
      args: {
        username,
        password,
      },
    },
    ({ username, password }) => {
      cy.get('input[type="email"]').type(username, {
        log: false,
      })
      cy.get('input[type="submit"]').click()
      cy.get('input[type="password"]').type(password, {
        log: false,
      })
      cy.get('input[type="submit"]').click()
    }
  )

  //Depending on the user and how they are registered with Microsoft, the origin may go to live.com
  //cy.origin(
  //  'login.live.com',
  //  {
  //    args: {
  //      password,
  //    },
  //  },
  //  ({ password }) => {
  //    cy.get('input[type="password"]').type(password, {
  //      log: false,
  //    })
  //    cy.get('input[type="submit"]').click()
  //    cy.get('#idBtn_Back').click()
  //  }
  //)
}

//See how to use it at:
//tests/acceptance/acceptance.spec.cy.ts
export function addLoginToAAD() {
  Cypress.Commands.add('loginToAAD', (username: string, password: string) => {
    cy.session([username], () => {
      const log = Cypress.log({
        autoEnd: false,
        displayName: 'Azure Active Directory Login',
        message: [`🔐 Authenticating | ${username}`],
      });
      log.snapshot('before');

      loginViaAAD(username, password);

      // Ensure Microsoft has redirected us back to the sample app with our logged in user.
      cy.url().should('equal', Cypress.config().baseUrl)

      log.snapshot('after');
      log.end();
    });
  });
}

export function addSessionLoginWithMFA() {
  Cypress.Commands.add('sessionLoginWithMFA', (username: string, password: string) => {
    cy.session('login', () => cy.loginToAADWithMFA(username, password), {
      validate: () => cy.getAllLocalStorage().should(validateLocalStorage),
      cacheAcrossSpecs: true
    })
  })
}

export function addLoginToAADWithMFA() {
  Cypress.Commands.add('loginToAADWithMFA', (username: string, password: string) => {
    loginViaAAD(username, password);
    cy.getTOTP().then((otp1) => {
      const objOTP = { otp: otp1 }
      cy.origin('https://login.microsoftonline.com/', { args: objOTP }, ({ otp }) => {
        cy.get("[name='otc']").type(otp)
        cy.get('input[type="submit"]').click()
      })
    })
  })
}

export function addGetTOTP() {
  Cypress.Commands.add('getTOTP', () => {
    return authenticator.generate(Cypress.env('otp_secret'))
  })
}

const validateLocalStorage = (localStorage: Record<string, unknown>) =>
  Cypress._.some(localStorage, (value: unknown, key: string) =>
    key.includes('CognitoIdentityServiceProvider'),
  )

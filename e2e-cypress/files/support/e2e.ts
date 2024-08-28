//For more details, you can follow this link:
//https://docs.cypress.io/guides/end-to-end-testing/azure-active-directory-authentication#Microsoft-AAD-Application-Setup
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

  // Ensure Microsoft has redirected us back to the sample app with our logged in user.
  cy.url().should('equal', Cypress.config().baseUrl)
}

//See how to use it at:
//tests/acceptance/acceptance.spec.cy.ts
Cypress.Commands.add('loginToAAD', (username: string, password: string) => {
  const log = Cypress.log({
    displayName: 'Azure Active Directory Login',
    message: [`🔐 Authenticating | ${username}`],
    autoEnd: false,
  })
  log.snapshot('before')

  loginViaAAD(username, password)

  log.snapshot('after')
  log.end()
})

let consoleLogs: string[] = []

Cypress.on('log:added', (options) => {
  const message = options.message;
  if(message) {
    consoleLogs.push(message);
  }
});

beforeEach(function() {
  consoleLogs = [];
})

afterEach(function() {
  const testName = this.currentTest.fullTitle().replace(/ /g, '_');
  const fileName = `system-output-${testName}.txt`;
  const filePath = `cypress/results/${fileName}`;

  cy.writeFile(filePath, consoleLogs.join('\n'));

  consoleLogs = [];
})

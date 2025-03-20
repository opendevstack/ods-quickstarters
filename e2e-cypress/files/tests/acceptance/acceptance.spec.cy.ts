import { printTestDOMEvidence, printTestPlainEvidence, takeScreenshotEvidence } from '../../support/test-evidence';

/* tslint:disable:no-unused-expression */
// describe('ADD login example test', () => {
//   beforeEach(() => {
//     // log into Azure Active Directory through our sample SPA using our custom command
//     cy.loginToAAD(Cypress.env('aad_username'), Cypress.env('aad_password'))
//     // or you can use the following command to log in with MFA. Make sure to define the OTP_SECRET environment variable
//     // with your MFA secret before running the test. Please follow the documentation on how to set this up
//     cy.sessionLoginWithMFA(Cypress.env('aad_username'), Cypress.env('aad_password'))
//   })

//   it('Verifies the user can be logged in', () => {
//     cy.contains('title')
//   })
// });

describe('W3 application test', () => {

  it('Application is reachable', function () {
    const testTitle = this.test?.fullTitle() || 'unknown';

    cy.visit('/html/tryit.asp?filename=tryhtml_basic_paragraphs');
    cy.title().should('include', 'Tryit Editor');
    printTestDOMEvidence(testTitle, 1, '#textareaCode', 'code area');
    printTestDOMEvidence(testTitle, 2, '#iframecontainer', 'rendered code area');
    takeScreenshotEvidence(testTitle, 3, 1, 'screenshot');
    takeScreenshotEvidence(testTitle, 3, 2, 'screenshot substep 2');
    cy.title().then(title => {
      printTestPlainEvidence(testTitle, 4, title, 'Tryit Editor', 'Title should include Tryit Editor');
    });
  });
});

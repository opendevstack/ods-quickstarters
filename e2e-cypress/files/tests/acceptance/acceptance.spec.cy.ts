import { printTestEvidence } from '../../support/test-evidence';

/* tslint:disable:no-unused-expression */
// describe('ADD login example test', () => {

//   beforeEach(() => {
//     // log into Azure Active Directory through our sample SPA using our custom command
//     cy.loginToAAD(Cypress.env('aad_username'), Cypress.env('aad_password'))
//   })

//   it('Verifies the user can be logged in', () => {
//     cy.contains('title')
//   })

// });

describe('W3 application test', () => {

  it('Application is reachable', function () {
    cy.visit('/html/tryit.asp?filename=tryhtml_basic_paragraphs');
    cy.title().should('include', 'Tryit Editor');
    printTestEvidence(this.test.fullTitle(), 1, '#textareaCode', 'code area');
    printTestEvidence(this.test.fullTitle(), 2, '#iframecontainer', 'rendered code area');
  });
});

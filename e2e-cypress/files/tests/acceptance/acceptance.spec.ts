import { printTestEvidence } from '../../support/test-evidence';

/* tslint:disable:no-unused-expression */
describe('acceptance e2e tests', () => {
  // see installation.spec.ts for examples

  it('Application is reachable', function () {
    cy.visit('/html/tryit.asp?filename=tryhtml_basic_paragraphs');
    cy.title().should('include', 'Tryit Editor v3.7');
    printTestEvidence(this.test.fullTitle(), 1, '#textareaCode', 'code area');
    printTestEvidence(this.test.fullTitle(), 2, '#iframecontainer', 'rendered code area');
  });
});

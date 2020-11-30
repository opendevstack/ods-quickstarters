function printEvidenceForPageElement
  (testName: string, testStep: number, selector: string, description: string) {
  if (!selector) {
    throw new Error('selector must not NOT be undefined');
  }
  cy.task('log', '=====================================');
  cy.task('log', 'Testname: ' + testName + ' // step: ' + testStep);
  cy.url().then(urlString => {
    cy.task('log', 'URL: ' + urlString);
  });
  cy.task('log', 'Description: ' + description);
  cy.task('log', '----- Test Evidence starts here ----');
  cy.get(selector).then(($selectedElement) => {
    cy.task('log', 'Selector: ' + selector + '\r ' +
      $selectedElement.get(0).outerHTML);
  });
  cy.task('log', '----- Test Evidence ends here ----');
}

/* tslint:disable:no-unused-expression */
describe('acceptance e2e tests', function () {
  // see installation.spec.ts for examples

  it('Application is reachable', function () {
    cy.visit('/html/tryit.asp?filename=tryhtml_basic_paragraphs');
    cy.title().should('include', 'Tryit Editor v3.6');
    printEvidenceForPageElement(
      this.test.fullTitle(), 1, '#textareaCode', 'code area');
    printEvidenceForPageElement(
      this.test.fullTitle(), 2, '#iframecontainer', 'rendered code area');
  });
});

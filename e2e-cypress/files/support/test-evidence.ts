export const printTestEvidence = (testName: string, testStep: number, selector: string, description: string) => {
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
  cy.get(selector).then($selectedElement => {
    cy.task('log', 'Selector: ' + selector + '\r ' + $selectedElement.get(0).outerHTML);
  });
  cy.task('log', '----- Test Evidence ends here ----');
};

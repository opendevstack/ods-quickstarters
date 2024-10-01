import { consoleLogs } from "./e2e";

export const printTestEvidence = (testName: string, testStep: number, selector: string, description: string) => {
  if (!selector) {
    throw new Error('selector must not NOT be undefined');
  }
  const logs: string[] = [];
  logs.push('=====================================');
  logs.push('Testname: ' + testName + ' // step: ' + testStep);
  cy.url().then(urlString => {
    logs.push('URL: ' + urlString);
  });
  logs.push('Description: ' + description);
  logs.push('----- Test Evidence starts here ----');
  cy.get(selector).then($selectedElement => {
    logs.push('Selector: ' + selector + '\r ' + $selectedElement.get(0).outerHTML);
  });
  logs.push('----- Test Evidence ends here ----');
  consoleLogs.push(...logs);
  cy.task('log', logs.join('\n'));
};

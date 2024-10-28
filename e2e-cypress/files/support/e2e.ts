import './commands';

export const consoleLogs: string[] = [];

beforeEach(function() {
  consoleLogs.splice(0);
})

afterEach(function() {
  const testName = this.currentTest.fullTitle().replace(/ /g, '_');
  const fileName = `system-output-${testName}.txt`;
  const filePath = `cypress/results/${fileName}`;

  cy.writeFile(filePath, consoleLogs.join('\n'));

  consoleLogs.splice(0);
})

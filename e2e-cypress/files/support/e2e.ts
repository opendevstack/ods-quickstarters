import './commands';
const addContext = require('mochawesome/addContext');

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

Cypress.Commands.add('addContextPath', (title: string, contextPath: string) => {
  cy.on('test:after:run', (attributes) => {
    // The context needs the path relative to the build/test-results/mochawesome folder
    addContext({ test: attributes }, {
      title: title,
      value: contextPath
    });
  });
})

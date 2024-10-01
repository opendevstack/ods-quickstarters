import path from 'path';
import { isScreenshotEvidenceResult, ScreenshotEvidenceData } from "../plugins/screenshot";
import { consoleLogs } from "./e2e";

export const printTestDOMEvidence = (testName: string, testStep: number, selector: string, description: string) => {
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

export const printTestPlainEvidence = (testName: string, testStep: number, expectedValue: string, actualValue: string, description: string) => {
  if (!expectedValue || !actualValue) {
    throw new Error('expectedValue and actualValue must not NOT be undefined');
  }
  const logs: string[] = [];
  logs.push('=====================================');
  logs.push('Testname: ' + testName + ' // step: ' + testStep);
  cy.url().then(urlString => {
    logs.push('URL: ' + urlString);
  });
  logs.push('Description: ' + description);
  logs.push('----- Test Evidence starts here ----');
  logs.push(`Expected Result:\r ${String(expectedValue)}`);
  logs.push(`Actual Result:\r ${String(actualValue)}`);
  logs.push('----- Test Evidence ends here ----');
  consoleLogs.push(...logs);
  cy.task('log', logs.join('\n'));
};

export const takeScreenshotEvidence = (testName: string, testStep: number, testSubStep: number = 1, description: string, skipMeta = false) => {
  cy.wrap(null).then(() => {
    const data: Omit<ScreenshotEvidenceData, 'path' | 'takenAt'> &
      Partial<Pick<ScreenshotEvidenceData, 'path' | 'takenAt'>> = {
      name: testName,
      step: testStep,
      subStep: testSubStep,
    };

    cy.screenshot(`testevidence_${testName}_${testStep}_${testSubStep}`, {
      onAfterScreenshot(_, { path, takenAt }) {
        data.path = path;
        data.takenAt = new Date(takenAt).toISOString();
      },
    })
      .then<unknown>(() => {
        if (!data.path || !data.takenAt || skipMeta) {
          return null;
        }
        cy.task('takeScreenshotEvidence', data);
      })
      .then((result) => {
        if (!isScreenshotEvidenceResult(result)) {
          return null;
        }

        const logs: string[] = [];
        logs.push('=====================================');
        logs.push('Testname: ' + testName + ' // step: ' + testStep);
        cy.url().then(urlString => {
          logs.push('URL: ' + urlString);
        });
        logs.push('Description: ' + description);
        logs.push('----- Test Evidence starts here ----');
        logs.push(
          `Stored screenshot "${path.basename(result.path)}" with hash (sha256) ${result.hash} taken at ${String(data.takenAt)} as evidence.`
        );
        logs.push('----- Test Evidence ends here ----');
        consoleLogs.push(...logs);
        cy.task('log', logs.join('\n'));
      });
  });
};

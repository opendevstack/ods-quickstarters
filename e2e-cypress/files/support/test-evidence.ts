import * as path from 'path';
import { isScreenshotEvidenceResult, ScreenshotEvidenceData } from "../plugins/screenshot.types";
import { consoleLogs } from "./e2e";

const logEvidence = (name: string, step: number, description: string, evidenceLogs: string[]) => {
  cy.url().then(url => {
    const logs: string[] = [];
    logs.push('=====================================');
    logs.push(`Testname: ${name} // step: ${step}`);
    logs.push(`URL: ${url}`);
    logs.push(`Description: ${description}`);
    logs.push('----- Test Evidence starts here ----');
    logs.push(...evidenceLogs);
    logs.push('----- Test Evidence ends here ----');
    consoleLogs.push(...logs);
    cy.task('log', logs.join('\n'));
  });
}

export const printTestDOMEvidence = (testName: string, testStep: number, selector: string, description: string) => {
  if (!selector) {
    throw new Error('selector must not NOT be undefined');
  }
  cy.get(selector).then($selectedElement => {
    logEvidence(testName, testStep, description, [`Selector: ${selector}\n ${$selectedElement.get(0).outerHTML}`]);
  });
};

export const printTestPlainEvidence = (testName: string, testStep: number, expectedValue: string, actualValue: string, description: string) => {
  if (!expectedValue || !actualValue) {
    throw new Error('expectedValue and actualValue must not NOT be undefined');
  }
  logEvidence(testName, testStep, description, [
    `Expected Result:\n ${String(expectedValue)}`,
    `Actual Result:\n ${String(actualValue)}`
  ]);
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

        logEvidence(testName, testStep, description, [
          `Stored screenshot "${path.basename(result.path)}" with hash (sha256) ${result.hash} taken at ${String(data.takenAt)} as evidence.`
        ]);
      });
  });
};

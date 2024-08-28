'use strict';

const MochaJUnitReporter = require('mocha-junit-reporter');
const fs = require('fs');
const path = require('path');

function CustomJUnitReporter(runner, options) {
  // Call the original MochaJUnitReporter constructor
  MochaJUnitReporter.call(this, runner, options);
}

// Inherit from MochaJUnitReporter
CustomJUnitReporter.prototype = Object.create(MochaJUnitReporter.prototype);
CustomJUnitReporter.prototype.constructor = CustomJUnitReporter;

// Override the getTestcaseData method to include custom logic
CustomJUnitReporter.prototype.getTestcaseData = function(test, err) {
  // Call the original getTestcaseData method to get the base data
  const testcase = MochaJUnitReporter.prototype.getTestcaseData.call(this, test, err);

  // Define the log file path based on the test title
  const logFilePath = path.join('cypress/results', `system-output-${test.fullTitle().replace(/ /g, '_')}.txt`);

  // Check if the log file exists and if so, append its content to the system-out
  if (fs.existsSync(logFilePath)) {
    const logContent = fs.readFileSync(logFilePath, 'utf-8');
    if (logContent && logContent.length > 0) {
      // Append the content of the log file to the system-out section of the test case
      testcase.testcase.push({ 'system-out': { _cdata: logContent } });
    }
  }

  return testcase;
};

module.exports = CustomJUnitReporter;


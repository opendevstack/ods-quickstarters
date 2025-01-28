import { defineConfig } from 'cypress';
import baseConfig from './cypress.config';

export default defineConfig({
  ...baseConfig,
  reporterOptions: {
    ...baseConfig.reporterOptions,
    mochawesomeReporterOptions: {
      ...baseConfig.reporterOptions.mochawesomeReporterOptions,
      reportFilename: 'integration-mochawesome',
    },
    reportersCustomReporterJsReporterOptions: {
      ...baseConfig.reporterOptions.reportersCustomReporterJsReporterOptions,
      mochaFile: 'build/test-results/integration-junit-[hash].xml',
    },
  },
  e2e: {
    ...baseConfig.e2e,
    specPattern: 'tests/integration/**/*.cy.ts',
  },
});

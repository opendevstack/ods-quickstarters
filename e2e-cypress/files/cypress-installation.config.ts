import { defineConfig } from 'cypress';
import baseConfig from './cypress.config';

export default defineConfig({
  ...baseConfig,
  reporterOptions: {
    ...baseConfig.reporterOptions,
    mochawesomeReporterOptions: {
      ...baseConfig.reporterOptions.mochawesomeReporterOptions,
      reportFilename: 'installation-mochawesome',
    },
    reportersCustomReporterJsReporterOptions: {
      ...baseConfig.reporterOptions.reportersCustomReporterJsReporterOptions,
      mochaFile: 'build/test-results/installation-junit-[hash].xml',
    },
  },
  e2e: {
    ...baseConfig.e2e,
    specPattern: 'tests/installation/**/*.cy.ts',
  },
});

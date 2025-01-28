import { defineConfig } from 'cypress';
import baseConfig from './cypress.config';

export default defineConfig({
  ...baseConfig,
  reporterOptions: {
    ...baseConfig.reporterOptions,
    mochawesomeReporterOptions: {
      ...baseConfig.reporterOptions.mochawesomeReporterOptions,
      reportFilename: 'acceptance-mochawesome',
    },
    reportersCustomReporterJsReporterOptions: {
      ...baseConfig.reporterOptions.reportersCustomReporterJsReporterOptions,
      mochaFile: 'build/test-results/acceptance-junit-[hash].xml',
    },
  },
  e2e: {
    ...baseConfig.e2e,
    specPattern: 'tests/acceptance/**/*.cy.ts',
  },
});

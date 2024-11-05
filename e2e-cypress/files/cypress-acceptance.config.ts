import { defineConfig } from 'cypress'
import setupNodeEvents from './plugins/index.js'
export default defineConfig({
  //projectId: '[Your project ID from Cypress cloud]',
  reporter: 'cypress-multi-reporters',
  reporterOptions: {
    reporterEnabled: 'mochawesome,./reporters/custom-reporter.js',
    mochawesomeReporterOptions: {
      reportDir: 'build/test-results/mochawesome',
      reportFilename: 'acceptance-mochawesome',
      charts: true,
      html: true,
      timestamp: true,
      json: true
    },
    reportersCustomReporterJsReporterOptions: {
      mochaFile: 'build/test-results/acceptance-junit-[hash].xml',
      toConsole: true,
    },
  },
  e2e: {
    baseUrl: process.env.CYPRESS_BASE_URL,
    fixturesFolder: "fixtures",
    specPattern: 'tests/acceptance/*.cy.ts',
    supportFile: "support/e2e.ts",
    screenshotsFolder: 'build/test-results/screenshots',
    viewportWidth: 1280,
    viewportHeight: 720,
    experimentalModifyObstructiveThirdPartyCode:true,
    video: true,
    async setupNodeEvents(on, config) {
      return (await import('./plugins/index')).default(on, config);
    },
  },
  // env: {
  //   otp_secret: process.env.OTP_SECRET
  // },
})

import { defineConfig } from 'cypress'
import setupNodeEvents from './plugins/index.js'
export default defineConfig({
  reporter: 'cypress-multi-reporters',
  reporterOptions: {
    reporterEnabled: 'mochawesome,./reporters/custom-reporter.js',
    mochawesomeReporterOptions: {
      reportDir: 'build/test-results/mochawesome',
      reportFilename: 'mochawesome',
      charts: true,
      html: true,
      timestamp: true,
      json: true
    },
    reportersCustomReporterJsReporterOptions: {
      mochaFile: 'build/test-results/tests-[hash].xml',
      toConsole: true,
    },
  },
  e2e: {
    baseUrl: process.env.BASE_URL || 'https://www.w3schools.com',
    fixturesFolder: "fixtures",
    specPattern: 'tests/**/*.cy.ts',
    supportFile: "support/e2e.ts",
    screenshotsFolder: 'build/test-results/screenshots',
    viewportWidth: 1280,
    viewportHeight: 720,
    experimentalModifyObstructiveThirdPartyCode: true,
    video: false,
    async setupNodeEvents(on, config) {
      return (await import('./plugins/index')).default(on, config);
    },
  },
  // env: {
  //   otp_secret: process.env.OTP_SECRET
  // },
})

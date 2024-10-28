import { defineConfig } from 'cypress'
import setupNodeEvents from './plugins/index.js'
export default defineConfig({
  //projectId: '[Your project ID from Cypress cloud]',
  reporter: 'reporters/custom-reporter.js',
  reporterOptions: {
    mochaFile: 'build/test-results/acceptance-junit-[hash].xml',
    toConsole: true,
  },
  e2e: {
    baseUrl: 'https://www.w3schools.com',
    fixturesFolder: "fixtures",
    specPattern: 'tests/acceptance/*.cy.ts',
    supportFile: "support/e2e.ts",
    viewportWidth: 1376,
    viewportHeight: 660,
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

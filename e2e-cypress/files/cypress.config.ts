import { defineConfig } from 'cypress'
import setupNodeEvents from './plugins/index.js'
export default defineConfig({
  projectId: 'isvvsd',
  reporter: 'junit',
  reporterOptions: {
    mochaFile: 'build/test-results/tests.xml',
    toConsole: true,
  },
  e2e: {
    baseUrl: 'https://docs.cypress.io/guides/guides/debugging',
    fixturesFolder: "fixtures",
    specPattern: 'tests/**/*.cy.ts',
    supportFile: "support/e2e.ts",
    viewportWidth: 1376,
    viewportHeight: 660,
    pageLoadTimeout: 60000,
    experimentalModifyObstructiveThirdPartyCode:true,
    //https://github.com/cypress-io/cypress/issues/25806
    // experimentalSkipDomainInjection: ["*.apps.eu-dev.ocp.aws.boehringer.com"],
    video: true,
    setupNodeEvents(on, config) {
      return require('./plugins/index.js')(on, config)
    },
  },
})

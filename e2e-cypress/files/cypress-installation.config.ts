import { defineConfig } from 'cypress'
import setupNodeEvents from './plugins/index.js'
export default defineConfig({
  //projectId: '[Define your project id for Cypress cloud]',
  reporter: 'junit',
  reporterOptions: {
    mochaFile: 'build/test-results/installation/junit-[hash].xml',
    toConsole: true,
  },
  e2e: {
    baseUrl: 'https://www.w3schools.com',
    fixturesFolder: "fixtures",
    specPattern: 'tests/installation/*.cy.ts',
    supportFile: "support/e2e.ts",
    viewportWidth: 1376,
    viewportHeight: 660,
    experimentalModifyObstructiveThirdPartyCode:true,
    video: true,
    setupNodeEvents(on, config) {
      return require('./plugins/index.js')(on, config)
    },
  },
})

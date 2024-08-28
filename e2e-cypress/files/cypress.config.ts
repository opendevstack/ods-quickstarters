import { defineConfig } from 'cypress'
import setupNodeEvents from './plugins/index.js'
export default defineConfig({
  reporter: 'reporters/custom-reporter.js',
  reporterOptions: {
    mochaFile: 'build/test-results/tests-[hash].xml',
    toConsole: true,
  },
  e2e: {
    baseUrl: 'https://www.w3schools.com',
    fixturesFolder: "fixtures",
    specPattern: 'tests/**/*.cy.ts',
    supportFile: "support/e2e.ts",
    viewportWidth: 1376,
    viewportHeight: 660,
    experimentalModifyObstructiveThirdPartyCode: true,
    video: true,
    setupNodeEvents(on, config) {
      return require('./plugins/index.js')(on, config)
    },
  },
})

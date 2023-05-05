import { defineConfig } from 'cypress'
import setupNodeEvents from './plugins/index.js'
export default defineConfig({
  reporter: 'junit',
  reporterOptions: {
    mochaFile: 'build/test-results/tests.xml',
    toConsole: true,
  },
  e2e: {
    baseUrl: 'Introduce your app URL',
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

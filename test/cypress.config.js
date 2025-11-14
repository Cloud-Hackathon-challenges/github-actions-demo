const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: process.env.CYPRESS_BASE_URL || "http://localhost:8080",
    specPattern: "cypress/e2e/**/*.cy.js",
    supportFile: "cypress/support/e2e.js",
    pageLoadTimeout: 120000,
    defaultCommandTimeout: 20000,
    chromeWebSecurity: false,
    retries: 0,
  },
});

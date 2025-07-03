const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "https://ass23847.azurewebsites.net",
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});

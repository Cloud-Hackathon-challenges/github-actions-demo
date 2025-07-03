const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://localhost/books",
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});

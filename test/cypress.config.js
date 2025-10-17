// const { defineConfig } = require("cypress");

// module.exports = defineConfig({
//   e2e: {
//     baseUrl: "https://ass23847.azurewebsites.net",
//     setupNodeEvents(on, config) {
//       // implement node event listeners here
//     },
//   },
// });


// cypress.config.js  (PROJE KÖKÜNDEKİ)
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    // Lokal default + istersek ENV ile override
    baseUrl: process.env.CYPRESS_BASE_URL || 'http://localhost:8080',
    // İstersen:
    // testIsolation: false,
    setupNodeEvents(on, config) {
      // node event listeners
    },
  },
});

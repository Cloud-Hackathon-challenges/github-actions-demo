// describe('template spec', () => {
//   it('passes', () => {
//     cy.visit('https://ass238471.azurewebsites.net/admin')  // same here
//   })
// })

describe('template spec', () => {
  it('opens admin', () => {
    cy.visit('/admin'); // hardcoded URL yok
  });
});


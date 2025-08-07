describe('Simple Book Lending App E2E Test', () => {
  const bookTitle = `New Book Title ${Date.now()}`;

  it('Page is accessible and lists initial books', () => {
    cy.visit('http://localhost/books');
    cy.contains('24 Work Hacks').should('be.visible');
    cy.contains('Agile Software Development with Scrum').should('be.visible');
  });

  it('Adds a new book and verifies it appears in the list', () => {
    cy.visit('http://localhost/admin');

    // Open Add Book dialog
    cy.get('button[aria-label="Add"]').click();

    // Type new book title
    cy.get('#name').type(bookTitle);

    // Submit the form
    cy.contains('button', 'Add').click();

    // Confirm it appears in the list
    cy.contains(bookTitle, { timeout: 6000 }).should('be.visible');
  });

  it('Navigates to book detail page and verifies content', () => {
    cy.visit('http://localhost/admin');

    // Find and click book link (in ID column)
    cy.contains('tr', bookTitle).within(() => {
      cy.get('a').first().click(); // Goes to /books/:id
    });

    // Confirm page loaded correctly
    cy.url().should('include', '/books/');
    cy.contains(bookTitle).should('be.visible');
    cy.contains('Entlehnen').should('be.visible'); // From Rent.js
  });

  it('Deletes a book and verifies it no longer appears', () => {
    cy.visit('http://localhost/admin');

    cy.intercept('DELETE', '/api/books/*').as('deleteBook');

    cy.contains(bookTitle, { timeout: 6000 })
      .parents('tr')
      .within(() => {
        cy.get('button[aria-label="Delete"]').click({ force: true });
      });

    cy.contains('button', 'Delete').click({ force: true });

    cy.wait('@deleteBook');
    cy.wait(1000); // Wait for refresh

    cy.get('table').should('not.contain', bookTitle);
  });
});

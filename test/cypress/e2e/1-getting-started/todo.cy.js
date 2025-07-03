describe('Simple Book Lending App Test', () => {
  beforeEach(() => {
    cy.visit('http://localhost:80')
  })

  it('Page loads and books are listed', () => {
    // Check that "24 Work Hacks" book is visible
    cy.contains('24 Work Hacks').should('be.visible')

    // Check that "Agile Software Development with Scrum" book is visible
    cy.contains('Agile Software Development with Scrum').should('exist')

    // Check availability status of the specific book
    cy.contains('Arbeitsplatz der Zukunft –Die Blockenheimer Landstraße 1904 in Frankfurt am Main-')
      .parent()
      .should($el => {
        expect($el.text()).to.match(/Ausgeliehen|Verfügbar/)
      })
  })
  
})

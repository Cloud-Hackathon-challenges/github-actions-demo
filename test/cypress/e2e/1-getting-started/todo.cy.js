describe('status-toggle', () => {
  it('toggles the status text in the same row when clicking BORROW/RETURN', () => {
    // 1️⃣ Open root (auto-redirects to /books)
    cy.visit('http://localhost:8080/');
    cy.location('pathname', { timeout: 10000 }).should('match', /\/books$/);

    // 2️⃣ Grab the first visible BORROW/RETURN button
    cy.contains('button', /BORROW|RETURN/i, { timeout: 10000 })
      .should('be.visible')
      .and('not.be.disabled')
      .then(($btn) => {
        // 3️⃣ Remember the current button label and the opposite
        const beforeBtn = $btn.text().trim().toUpperCase();
        const afterBtn  = beforeBtn.includes('BORROW') ? 'RETURN' : 'BORROW';

        // 4️⃣ Find the table row for this button
        const $row = $btn.closest('tr');

        // 5️⃣ Within the same row, capture the current status text
        //    We accept common variants: German/English.
        const statusRegex = /(Verfügbar|Ausgeliehen|Available|Borrowed|Loaned)/i;

        let beforeStatusText = '';
        cy.wrap($row).invoke('text').then((txt) => {
          const match = String(txt).match(statusRegex);
          beforeStatusText = match ? match[0] : ''; // may be empty if UI differs
        });

        // 6️⃣ Click the button to toggle state
        cy.wrap($btn).click({ force: true });

        // 7️⃣ In the SAME ROW, wait for the opposite button label to appear
        cy.wrap($row).within(() => {
          cy.contains('button', new RegExp(afterBtn, 'i'), { timeout: 10000 })
            .should('be.visible');
        });

        // 8️⃣ Now assert the status text changed to a different value
        cy.wrap($row)
          .invoke('text')
          .then((txtAfter) => {
            const afterMatch = String(txtAfter).match(statusRegex);
            const afterStatusText = afterMatch ? afterMatch[0] : '';

            // If we captured a before-status, ensure it toggled.
            // If not captured (UI variant), at least ensure there IS a recognizable status now.
            if (beforeStatusText) {
              expect(afterStatusText, 'status text should toggle').to.not.equal(beforeStatusText);
            } else {
              expect(afterStatusText, 'recognizable status text should be present')
                .to.match(statusRegex);
            }
          });
      });

    // 9️⃣ We should still be on /books after the interaction
    cy.location('pathname').should('match', /\/books$/);
  });
});

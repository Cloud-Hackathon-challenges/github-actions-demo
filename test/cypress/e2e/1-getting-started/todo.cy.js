/// <reference types="cypress" />

describe('Book Lending App E2E Tests', () => {
  const newBook = 'Test Driven Development'

  beforeEach(() => {
    // Senin uygulaman localhost:80'de çalışıyor
    cy.visit('http://localhost:80')
  })

  it('Sayfa açılıyor ve kitaplar listeleniyor', () => {
    // Örneğin "Agile Software Development with Scrum" kitabının görünür olduğunu kontrol et
    cy.contains('Agile Software Development with Scrum').should('be.visible')
  })

  it('Yeni kitap ekleyebiliyor', () => {
    // Kitap ekleme inputunu bul ve yeni kitabı yaz
    cy.get('input[name="bookTitle"]').type(newBook)

    // "Add Book" butonuna tıkla
    cy.get('button').contains('Add Book').click()

    // Yeni eklenen kitabın listede olduğunu doğrula
    cy.contains(newBook).should('be.visible')
  })

  it('Kitap ödünç alınıp geri verilebiliyor', () => {
    // Önce ödünç al butonunu bul (örneğin "Borrow") ve tıkla
    cy.contains(newBook)
      .parent()
      .find('button')
      .contains('Borrow')
      .click()

    // Kitabın durumu "Ausgeliehen" (ödünç alınmış) olarak değişmiş olmalı
    cy.contains(newBook)
      .parent()
      .contains('Ausgeliehen')
      .should('be.visible')

    // Geri verme butonuna tıkla (örneğin "Return")
    cy.contains(newBook)
      .parent()
      .find('button')
      .contains('Return')
      .click()

    // Kitabın durumu tekrar "Verfügbar" (mevcut) olmalı
    cy.contains(newBook)
      .parent()
      .contains('Verfügbar')
      .should('be.visible')
  })

  it('Kitap silinebiliyor', () => {
    // Sil butonunu bulup tıkla
    cy.contains(newBook)
      .parent()
      .find('button')
      .contains('Delete')
      .click()

    // Kitabın artık listede olmaması gerekiyor
    cy.contains(newBook).should('not.exist')
  })
})

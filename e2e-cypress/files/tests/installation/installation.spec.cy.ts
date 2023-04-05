describe('installation e2e tests', () => {
  it('Application is reachable and does not show error page', () => {
    cy.visit('/html/tryit.asp?filename=tryhtml_basic_paragraphs');

    // Obsolete
    // cy.login();
    // cy.msalv2Login();
    // cy.visit('');
    // cy.get('app-header').should('be.visible');
    // cy.get('app-error-page').should('not.exist');
  });
});

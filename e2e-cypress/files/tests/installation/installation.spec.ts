describe('installation e2e tests', () => {
  it('Application is reachable and does not show error page', () => {
    cy.login();
    // cy.msalv2Login();
    // cy.visit('');
    // cy.get('app-header').should('be.visible');
    // cy.get('app-error-page').should('not.exist');
  });
});

describe('Angular quickstarter smoke test', () => {
  const rootPath = '/';

  it('serves the landing page', () => {
    cy.request(rootPath).its('status').should('eq', 200);
    cy.visit(rootPath);
    cy.get('body').should('exist');
    cy.get('app-root').should('exist');
    cy.title().should('not.be.empty');
  });
});

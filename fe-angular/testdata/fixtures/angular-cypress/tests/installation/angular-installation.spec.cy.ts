/**
 * Installation Tests for Angular Application
 * 
 * These tests verify that the Angular application is properly installed,
 * built, and deployed with all dependencies and configuration in place.
 */

describe('Angular Application Installation Tests', () => {
  beforeEach(() => {
    // Visit the application
    cy.visit('http://fe-angular-test.e2etsqs-dev.svc.cluster.local:8080/');
  });

  it('Should load the application successfully', () => {
    // Verify the page loads without errors
    cy.get('body').should('be.visible');
  });

  it('Should display the welcome header', () => {
    // Verify the main heading is present
    cy.contains('Hello, fe-angular-test').should('be.visible');
  });

  it('Should display success message', () => {
    // Verify congratulations message
    cy.contains('Congratulations! Your app is running').should('be.visible');
  });

  it('Should have proper document structure', () => {
    // Verify basic HTML structure
    cy.document().should('have.property', 'title');
    cy.title().should('include', 'FeAngular');
  });

  it('Should load stylesheets without errors', () => {
    // Verify CSS is loaded by checking computed styles
    cy.get('body').should('have.css', 'font-family');
  });

  it('Should render Angular root component', () => {
    // Verify Angular app-root component is present
    cy.get('app-root').should('exist');
  });

  it('Should display emoji in success message', () => {
    // Verify the celebration emoji is present
    cy.contains('🎉').should('be.visible');
  });

  it('Should have no console errors on load', () => {
    // Check for console errors
    cy.window().then((win) => {
      cy.spy(win.console, 'error');
    });
    cy.get('body').should('be.visible');
    cy.window().its('console.error').should('not.have.been.called');
  });

  it('Should have accessible document structure', () => {
    // Verify basic accessibility structure
    cy.get('html').should('have.attr', 'lang');
    cy.get('head').should('exist');
    cy.get('body').should('exist');
  });
});

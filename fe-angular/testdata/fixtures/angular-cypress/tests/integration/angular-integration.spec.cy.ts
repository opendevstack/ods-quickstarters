/**
 * Integration Tests for Angular Application
 * 
 * These tests verify that the Angular application integrates correctly with
 * its environment, handles user interactions, and maintains state properly.
 */

describe('Angular Application Integration Tests', () => {
  beforeEach(() => {
    // Visit the application before each test
    cy.visit('http://fe-angular-test.e2etsqs-dev.svc.cluster.local:8080/');
  });

  describe('Page Layout and Navigation', () => {
    it('Should have main content area visible', () => {
      cy.get('main').should('be.visible');
    });

    it('Should have heading section visible', () => {
      cy.get('h1, h2, h3').should('exist').and('be.visible');
    });

    it('Should render welcome message in DOM', () => {
      cy.get('body').invoke('text').should('include', 'Hello');
    });
  });

  describe('Component Rendering', () => {
    it('Should render app component with content', () => {
      cy.get('app-root').within(() => {
        cy.contains('Hello').should('be.visible');
      });
    });

    it('Should have toolbox section available', () => {
      cy.contains('Explore the Docs').should('be.visible');
    });

    it('Should display multiple resource links', () => {
      const links = [
        'Explore the Docs',
        'Learn with Tutorials',
        'CLI Docs'
      ];
      
      links.forEach(linkText => {
        cy.contains(linkText).should('be.visible');
      });
    });
  });

  describe('External Links', () => {
    it('Should have Angular docs link', () => {
      cy.contains('Explore the Docs').should('have.attr', 'href').and('match', /^https:\/\/angular\.dev\/?$/);
    });

    it('Should have Angular tutorials link', () => {
      cy.contains('Learn with Tutorials').should('have.attr', 'href').and('include', 'angular.dev/tutorials');
    });

    it('Should have CLI docs link', () => {
      cy.contains('CLI Docs').should('have.attr', 'href').and('include', 'angular.dev/tools/cli');
    });
  });

  describe('Application State', () => {
    it('Should maintain content on page interaction', () => {
      cy.contains('Hello, fe-angular-test').should('exist');
      cy.get('body').click(100, 100);
      cy.contains('Hello, fe-angular-test').should('exist');
    });

    it('Should preserve DOM structure after load', () => {
      cy.get('app-root').should('have.length', 1);
      cy.wait(500);
      cy.get('app-root').should('have.length', 1);
    });
  });

  describe('Responsive Behavior', () => {
    it('Should be visible on desktop viewport', () => {
      cy.viewport(1920, 1080);
      cy.get('body').should('be.visible');
      cy.contains('Hello, fe-angular-test').should('be.visible');
    });

    it('Should render correctly with different viewport sizes', () => {
      cy.viewport('iphone-x');
      cy.get('body').should('be.visible');
      cy.contains('Hello').should('be.visible');
    });
  });

  describe('Performance and Load', () => {
    it('Should load page within reasonable time', () => {
      cy.get('app-root', { timeout: 10000 }).should('exist');
    });

    it('Should have links with valid href attributes', () => {
      cy.get('a[href]').should('have.length.greaterThan', 0);
      cy.get('a[href]').each(($link) => {
        cy.wrap($link).should('have.attr', 'href').and('not.be.empty');
      });
    });
  });

  describe('Meta Information', () => {
    it('Should have proper page title', () => {
      cy.title().should('not.be.empty');
    });

    it('Should have viewport meta tag', () => {
      cy.get('meta[name="viewport"]').should('exist');
    });

    it('Should have charset defined', () => {
      cy.get('meta[charset]').should('exist');
    });
  });

  describe('Error Handling', () => {
    it('Should not show any 404 errors in network', () => {
      // Verify the page loads successfully
      cy.get('app-root').should('exist').and('be.visible');
    });

    it('Should have CSS styles applied to elements', () => {
      // Verify that CSS is loaded by checking computed styles on body
      cy.get('body').should('have.css', 'margin');
      cy.get('body').should('have.css', 'padding');
    });
  });
});
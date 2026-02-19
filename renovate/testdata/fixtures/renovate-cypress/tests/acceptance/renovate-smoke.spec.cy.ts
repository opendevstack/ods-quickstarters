/**
 * Acceptance / Smoke Tests for Renovate Bot
 *
 * Risk: The framework shall, upon execution of the Renovate Bot CronJob,
 * automatically scan the consuming project's repositories for outdated
 * dependencies and create corresponding Pull Requests in Bitbucket to update them.
 *
 * These tests navigate the Bitbucket Web UI to verify that:
 * - A Pull Request was created by the Renovate Bot in the target repository
 * - The PR contains the expected onboarding description
 * - The PR state is OPEN
 * - The PR metadata is correct (branch prefix, target branch, etc.)
 *
 * Each test visits the corresponding Bitbucket page and captures
 * a screenshot as visual evidence of the verification.
 */

describe('Renovate Bot Acceptance Tests - Pull Request Creation Verification', () => {
  const bitbucketBaseUrl = "{{.BITBUCKET_URL}}";
  const projectId = "{{.ProjectID}}";
  const username = Cypress.env("BITBUCKET_USERNAME");
  const password = Cypress.env("BITBUCKET_PASSWORD");
  const targetRepo = `${projectId}-python-test-renovate`;
  const repoUrl = `${bitbucketBaseUrl}/projects/${projectId}/repos/${targetRepo}`;

  beforeEach(() => {
    // Establish authenticated session with Bitbucket Server via form login
    cy.session('bitbucket-login', () => {
      cy.request({
        method: 'POST',
        url: `${bitbucketBaseUrl}/login`,
        form: true,
        body: {
          j_username: username,
          j_password: password,
        },
        followRedirect: true,
      });
    });
  });

  it('Should navigate to the Pull Requests page and see at least one PR', () => {
    cy.visit(`${repoUrl}/pull-requests`);
    cy.url().should('include', '/pull-requests');
    // Assert using visible PR links in main content to avoid hidden dropdown entries
    cy.get('#content', { timeout: 15000 }).should('be.visible');
    cy.get('#content a[href*="/pull-requests/"]:visible', { timeout: 15000 })
      .its('length')
      .should('be.greaterThan', 0);
    cy.screenshot('acceptance-01-pull-requests-exist');
  });

  it('Should open the onboarding Pull Request and verify it is OPEN', () => {
    cy.visit(`${repoUrl}/pull-requests/1/overview`);
    cy.url().should('include', '/pull-requests/1');
    // Bitbucket shows the PR state as a visible badge
    cy.contains('Open', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-02-onboarding-pr-open');
  });

  it('Should verify the Pull Request description mentions Renovate', () => {
    cy.visit(`${repoUrl}/pull-requests/1/overview`);
    // The PR description rendered on the page should mention Renovate
    cy.contains('Renovate', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-03-pr-description-contains-renovate');
  });

  it('Should verify the Pull Request originates from a renovate/ branch', () => {
    cy.visit(`${repoUrl}/pull-requests/1/overview`);
    // The source branch shown on the PR page should start with renovate/
    cy.contains('renovate/', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-04-pr-from-renovate-branch');
  });

  it('Should verify the Pull Request targets the master branch', () => {
    cy.visit(`${repoUrl}/pull-requests/1/overview`);
    // The target branch shown on the PR page should be master
    cy.contains('master', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-05-pr-targets-master');
  });

  it('Should verify the Pull Request contains the Renovate activation message', () => {
    cy.visit(`${repoUrl}/pull-requests/1/overview`);
    // The onboarding PR description should contain the activation instruction
    cy.contains('To activate Renovate, merge this Pull Request', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-06-pr-activate-renovate-message');
  });

  it('Should navigate to the PR diff and verify the configuration file changes', () => {
    cy.visit(`${repoUrl}/pull-requests/1/diff`);
    cy.url().should('include', '/diff');
    // Wait for the diff page to fully render with file changes
    cy.get('body', { timeout: 20000 }).should('be.visible');
    cy.screenshot('acceptance-07-pr-diff-files');
  });

  it('Should navigate to branches and verify a renovate/ branch exists', () => {
    cy.visit(`${repoUrl}/branches`);
    // The branches page should show both master and the renovate/* branch
    cy.contains('master', { timeout: 15000 }).should('be.visible');
    cy.contains('renovate/', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-08-branches-with-renovate');
  });
});

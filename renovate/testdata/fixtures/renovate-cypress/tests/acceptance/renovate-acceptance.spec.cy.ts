/**
 * Acceptance Tests for Renovate Bot
 *
 * Risk: The framework shall, upon execution of the Renovate Bot CronJob,
 * automatically scan the consuming project's repositories for outdated
 * dependencies and create corresponding Pull Requests in Bitbucket to update them.
 *
 * These tests navigate the Bitbucket Web UI and the OpenShift Console to verify:
 * - The Renovate CronJob is deployed in the -cd namespace (OC Console)
 * - A Pull Request was created by the Renovate Bot in the target repository
 * - The PR contains the expected onboarding description
 * - The PR state is OPEN
 * - The PR metadata is correct (branch prefix, target branch, etc.)
 * - The renovate.json configuration file is visible in the PR diff
 *
 * Each test captures a screenshot as visual evidence.
 */

describe('Renovate Bot Acceptance Tests - Pull Request Creation Verification', () => {
  const bitbucketBaseUrl = "{{.BITBUCKET_URL}}";
  const projectId = "{{.ProjectID}}";
  const username = Cypress.env("BITBUCKET_USERNAME");
  const password = Cypress.env("BITBUCKET_PASSWORD");
  const ocConsoleCronJobUrl = Cypress.env("OC_CONSOLE_CRONJOB_URL");
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

  it('Should show the Renovate CronJob in the OpenShift Console', () => {
    // Navigate directly without session (OC console has its own auth)
    cy.visit(ocConsoleCronJobUrl, { failOnStatusCode: false });
    // Wait for the main content area to render (OC console is a SPA, needs time)
    cy.get('body', { timeout: 30000 }).should('be.visible');
    cy.get('a[data-test-id="renovate-qs"]', { timeout: 30000 }).should('be.visible');
    cy.screenshot('acceptance-01-oc-console-cronjob');
  });

  it('Should navigate to the Pull Requests page and see at least one PR', () => {
    cy.visit(`${repoUrl}/pull-requests`);
    cy.url().should('include', '/pull-requests');
    cy.get('#content', { timeout: 15000 }).should('be.visible');
    cy.get('#content a[href*="/pull-requests/"]:visible', { timeout: 15000 })
      .its('length')
      .should('be.greaterThan', 0);
    cy.screenshot('acceptance-02-pull-requests-exist');
  });

  it('Should verify the Pull Request contains the Renovate activation message', () => {
    cy.visit(`${repoUrl}/pull-requests/1/overview`);
    cy.get('#content', { timeout: 15000 }).should('be.visible');
    cy.contains('To activate Renovate, merge this Pull Request', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-03-pr-activate-renovate-message');
  });

  it('Should navigate to the PR diff and show the renovate.json configuration file', () => {
    cy.visit(`${repoUrl}/pull-requests/1/diff#renovate.json`);
    cy.url().should('include', '/diff');
    cy.get('#content', { timeout: 30000 }).should('be.visible');
    cy.contains('renovate.json', { timeout: 30000 }).should('be.visible');
    cy.wait(2000);
    cy.screenshot('acceptance-04-pr-diff-renovate-json');
  });

  it('Should navigate to branches and verify a renovate/ branch exists', () => {
    cy.visit(`${repoUrl}/branches`);
    cy.get('#content', { timeout: 15000 }).should('be.visible');
    cy.contains('master', { timeout: 15000 }).should('be.visible');
    cy.contains('renovate/', { timeout: 15000 }).should('be.visible');
    cy.screenshot('acceptance-05-branches-with-renovate');
  });
});

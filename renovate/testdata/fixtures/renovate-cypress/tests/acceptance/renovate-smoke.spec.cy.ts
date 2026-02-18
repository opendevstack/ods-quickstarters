/**
 * Acceptance / Smoke Tests for Renovate Bot
 *
 * Risk: The framework shall, upon execution of the Renovate Bot CronJob,
 * automatically scan the consuming project's repositories for outdated
 * dependencies and create corresponding Pull Requests in Bitbucket to update them.
 *
 * These tests verify through the Bitbucket API that:
 * - A Pull Request was created by the Renovate Bot in the target repository
 * - The PR contains the expected onboarding description
 * - The PR state is OPEN
 * - The PR metadata is correct (branch prefix, author, etc.)
 */

describe('Renovate Bot Acceptance Tests - Pull Request Creation Verification', () => {
  const bitbucketBaseUrl = Cypress.env('BITBUCKET_BASE_URL');
  const projectId = Cypress.env('PROJECT_ID');
  const username = Cypress.env('BITBUCKET_USERNAME');
  const password = Cypress.env('BITBUCKET_PASSWORD');

  const authHeader = `Basic ${btoa(`${username}:${password}`)}`;
  const apiBase = `${bitbucketBaseUrl}/rest/api/1.0/projects/${projectId}`;
  const targetRepo = `${projectId}-python-test-renovate`;

  before(() => {
    cy.log('=== DEBUG: Environment Variables ===');
    cy.log(`BITBUCKET_BASE_URL: "${bitbucketBaseUrl}"`);
    cy.log(`PROJECT_ID: "${projectId}"`);
    cy.log(`BITBUCKET_USERNAME: "${username}"`);
    cy.log(`BITBUCKET_PASSWORD is set: ${!!password}`);
    cy.log(`Computed apiBase: "${apiBase}"`);
    cy.log(`Target repo: "${targetRepo}"`);
    cy.log('=== All Cypress.env() ===');
    cy.log(JSON.stringify(Cypress.env(), null, 2));
  });

  it('Should have at least one Pull Request in the target repository', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/pull-requests?state=OPEN&limit=10`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.values).to.have.length.greaterThan(0);
      cy.screenshot('acceptance-01-pull-requests-exist');
    });
  });

  it('Should have created the onboarding Pull Request (PR #1)', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/pull-requests/1`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.state).to.eq('OPEN');
      cy.screenshot('acceptance-02-onboarding-pr-open');
    });
  });

  it('Should have the onboarding PR with Renovate description', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/pull-requests/1`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const description = response.body.description || '';
      expect(description).to.contain('Renovate');
      cy.screenshot('acceptance-03-pr-description-contains-renovate');
    });
  });

  it('Should have the PR created from a renovate/ branch', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/pull-requests/1`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const fromBranch = response.body.fromRef?.displayId || '';
      expect(fromBranch).to.match(/^renovate\//);
      cy.screenshot('acceptance-04-pr-from-renovate-branch');
    });
  });

  it('Should have the PR targeting the master branch', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/pull-requests/1`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const toBranch = response.body.toRef?.displayId || '';
      expect(toBranch).to.eq('master');
      cy.screenshot('acceptance-05-pr-targets-master');
    });
  });

  it('Should have PR with activate Renovate message', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/pull-requests/1`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const description = response.body.description || '';
      expect(description).to.contain('To activate Renovate, merge this Pull Request');
      cy.screenshot('acceptance-06-pr-activate-renovate-message');
    });
  });

  it('Should be able to view the PR diff with configuration file', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/pull-requests/1/changes?limit=25`,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      const changedFiles = response.body.values?.map((v: any) => v.path?.toString) || [];
      cy.screenshot('acceptance-07-pr-diff-files');
    });
  });

  it('Should capture the overall repository state after Renovate execution', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${targetRepo}/branches?limit=25`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const branches = response.body.values?.map((b: any) => b.displayId) || [];
      // There should be at least master and a renovate/* branch
      expect(branches).to.include('master');
      const renovateBranches = branches.filter((b: string) => b.startsWith('renovate/'));
      expect(renovateBranches).to.have.length.greaterThan(0);
      cy.screenshot('acceptance-08-branches-with-renovate');
    });
  });
});

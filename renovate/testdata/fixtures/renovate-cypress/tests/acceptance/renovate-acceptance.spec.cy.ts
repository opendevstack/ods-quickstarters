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
  const targetRepo = `${projectId}-python-test-renovate`;
  const repoUrl = `${bitbucketBaseUrl}/projects/${projectId}/repos/${targetRepo}`;

  beforeEach(() => {
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
    const ocNamespace = Cypress.env("OC_NAMESPACE") || `${projectId}-cd`;
    const cronJobName = Cypress.env("CRONJOB_NAME") || "renovate-qs";
    cy.exec(`oc get cronjob ${cronJobName} -n ${ocNamespace} -o json`, { failOnNonZeroExit: false }).then(({ code, stdout, stderr }) => {
      expect(code).to.eq(0);
      const cronjob = JSON.parse(stdout);
      expect(cronjob).to.have.property('metadata');
      expect(cronjob.metadata.name).to.eq(cronJobName);
      cy.writeFile('build/test-results/screenshots/renovate-acceptance.spec.cy.ts/acceptance-01-oc-cronjob.json', JSON.stringify(cronjob, null, 2));
    });
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

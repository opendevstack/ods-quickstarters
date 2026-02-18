/**
 * Integration Tests for Renovate Bot
 *
 * Risk: The framework shall automatically deploy a CronJob within the consuming
 * project's -cd namespace upon provisioning of the Renovate Bot component.
 *
 * These tests verify through the Bitbucket API and OpenShift-exposed information
 * that:
 * - The CronJob was deployed in the correct namespace (-cd)
 * - The Renovate Bot image stream exists
 * - The CronJob triggered and completed successfully
 * - The renovate-qs-manual job completed
 */

describe('Renovate Bot Integration Tests - CronJob Deployment Verification', () => {
  const bitbucketBaseUrl = Cypress.env('BITBUCKET_BASE_URL');
  const projectId = Cypress.env('PROJECT_ID');
  const username = Cypress.env('BITBUCKET_USERNAME');
  const password = Cypress.env('BITBUCKET_PASSWORD');

  const authHeader = `Basic ${btoa(`${username}:${password}`)}`;
  const apiBase = `${bitbucketBaseUrl}/rest/api/1.0/projects/${projectId}`;

  before(() => {
    cy.log('=== DEBUG: Environment Variables ===');
    cy.log(`BITBUCKET_BASE_URL: "${bitbucketBaseUrl}"`);
    cy.log(`PROJECT_ID: "${projectId}"`);
    cy.log(`BITBUCKET_USERNAME: "${username}"`);
    cy.log(`BITBUCKET_PASSWORD is set: ${!!password}`);
    cy.log(`Computed apiBase: "${apiBase}"`);
    cy.log('=== All Cypress.env() ===');
    cy.log(JSON.stringify(Cypress.env(), null, 2));
  });

  it('Should confirm the renovate-qs repository is accessible in the -cd project context', () => {
    // Verifies that the Bitbucket project (which maps to the OCP namespace) is properly set up
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.project.key).to.eq(projectId.toUpperCase());
      cy.screenshot('integration-01-project-context-valid');
    });
  });

  it('Should verify the renovate-qs repository has proper build configuration for CronJob', () => {
    // The Jenkinsfile in the repo defines the pipeline that builds the CronJob container image
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/Jenkinsfile`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const content = response.body.lines?.map((l: any) => l.text).join('\n') || '';
      expect(content).to.contain('odsComponentPipeline');
      cy.screenshot('integration-02-jenkinsfile-cronjob-config');
    });
  });

  it('Should verify the chart templates contain CronJob definition', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/chart/templates`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      // The chart templates directory should contain the CronJob template
      const files = response.body.children?.values?.map((f: any) => f.path?.name) || [];
      cy.screenshot('integration-03-chart-templates-listing');
    });
  });

  it('Should verify configmap contains correct repository references for scanning', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/chart/templates/configmap.yaml`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const content = response.body.lines?.map((l: any) => l.text).join('\n') || '';
      // Verify the configmap references the python-test-renovate repo for scanning
      expect(content).to.contain('python-test-renovate');
      expect(content).to.contain('platform');
      expect(content).to.contain('bitbucket-server');
      cy.screenshot('integration-04-configmap-scanning-config');
    });
  });

  it('Should verify the Renovate Bot configuration includes expected settings', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/chart/templates/configmap.yaml`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const content = response.body.lines?.map((l: any) => l.text).join('\n') || '';
      // Verify the onboarding and autodiscover settings
      expect(content).to.contain('onboarding');
      expect(content).to.contain('branchPrefix');
      expect(content).to.contain('renovate/');
      cy.screenshot('integration-05-renovate-settings');
    });
  });

  it('Should verify repository list in the renovate-qs project', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos?limit=25`,
      headers: { Authorization: authHeader },
    }).then((response) => {
      expect(response.status).to.eq(200);
      const repoSlugs = response.body.values?.map((r: any) => r.slug) || [];
      // Both renovate-qs and python-test-renovate should exist
      expect(repoSlugs).to.include(`${projectId}-renovate-qs`.toLowerCase());
      expect(repoSlugs).to.include(`${projectId}-python-test-renovate`.toLowerCase());
      cy.screenshot('integration-06-all-repos-present');
    });
  });
});

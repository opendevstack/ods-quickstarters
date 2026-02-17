/**
 * Installation Tests for Renovate Bot
 *
 * Risk: The framework shall automatically create a dedicated Bitbucket repository
 * within the consuming project upon provisioning of the Renovate Bot component,
 * including the configuration files and predefined configuration settings.
 *
 * These tests verify through the Bitbucket API that:
 * - The renovate-qs repository exists in the project
 * - The repository contains the expected configuration files
 * - The configmap with Renovate settings was applied
 */

describe('Renovate Bot Installation Tests - Bitbucket Repository Verification', () => {
  const bitbucketBaseUrl = Cypress.env('BITBUCKET_BASE_URL');
  const projectId = Cypress.env('PROJECT_ID');
  const username = Cypress.env('BITBUCKET_USERNAME');
  const password = Cypress.env('BITBUCKET_PASSWORD');

  const authHeader = `Basic ${btoa(`${username}:${password}`)}`;
  const apiBase = `${bitbucketBaseUrl}/rest/api/1.0/projects/${projectId}`;

  it('Should have the renovate-qs repository created in the project', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs`,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.slug).to.eq(`${projectId}-renovate-qs`.toLowerCase());
      cy.screenshot('installation-01-repository-exists');
    });
  });

  it('Should have the python-test-renovate repository created for testing', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-python-test-renovate`,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.slug).to.eq(`${projectId}-python-test-renovate`.toLowerCase());
      cy.screenshot('installation-02-python-test-repo-exists');
    });
  });

  it('Should have the Jenkinsfile in the renovate-qs repository', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/Jenkinsfile`,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      const content = response.body.lines?.map((l: any) => l.text).join('\n') || '';
      expect(content).to.contain('odsComponentPipeline');
      cy.screenshot('installation-03-jenkinsfile-present');
    });
  });

  it('Should have the sonar-project.properties in the renovate-qs repository', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/sonar-project.properties`,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      cy.screenshot('installation-04-sonar-properties-present');
    });
  });

  it('Should have the chart templates directory in the renovate-qs repository', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/chart/templates`,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      cy.screenshot('installation-05-chart-templates-directory');
    });
  });

  it('Should have the configmap.yaml with Renovate configuration', () => {
    cy.request({
      method: 'GET',
      url: `${apiBase}/repos/${projectId}-renovate-qs/browse/chart/templates/configmap.yaml`,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      const content = response.body.lines?.map((l: any) => l.text).join('\n') || '';
      expect(content).to.contain('renovateconfigjs');
      expect(content).to.contain('repositories');
      cy.screenshot('installation-06-configmap-content');
    });
  });
});

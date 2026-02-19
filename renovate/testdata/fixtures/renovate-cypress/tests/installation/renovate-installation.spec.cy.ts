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
  const bitbucketBaseUrl = "{{.BITBUCKET_URL}}";
  const projectId = "{{.ProjectID}}";
  const username = Cypress.env("CYPRESS_BITBUCKET_USERNAME");
  const password = Cypress.env("CYPRESS_BITBUCKET_PASSWORD");

  const authHeader = `Basic ${btoa(`${username}:${password}`)}`;
  const apiBase = `${bitbucketBaseUrl}/rest/api/1.0/projects/${projectId}`;


  it('Should have the renovate-qs repository created in the project', () => {
    const requestUrl = `${apiBase}/repos/${projectId}-renovate-qs`;
    cy.request({
      method: 'GET',
      url: requestUrl,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.slug).to.eq(`${projectId}-renovate-qs`.toLowerCase());
      cy.screenshot('installation-01-repository-exists');
    });
  });

  it('Should have the python-test-renovate repository created for testing', () => {
    const requestUrl = `${apiBase}/repos/${projectId}-python-test-renovate`;
    cy.request({
      method: 'GET',
      url: requestUrl,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.slug).to.eq(`${projectId}-python-test-renovate`.toLowerCase());
      cy.screenshot('installation-02-python-test-repo-exists');
    });
  });

  it('Should have the Jenkinsfile in the renovate-qs repository', () => {
    const requestUrl = `${apiBase}/repos/${projectId}-renovate-qs/browse/Jenkinsfile`;
    cy.request({
      method: 'GET',
      url: requestUrl,
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
    const requestUrl = `${apiBase}/repos/${projectId}-renovate-qs/browse/sonar-project.properties`;
    cy.request({
      method: 'GET',
      url: requestUrl,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      cy.screenshot('installation-04-sonar-properties-present');
    });
  });

  it('Should have the chart templates directory in the renovate-qs repository', () => {
    const requestUrl = `${apiBase}/repos/${projectId}-renovate-qs/browse/chart/templates`;
    cy.request({
      method: 'GET',
      url: requestUrl,
      headers: { Authorization: authHeader },
      failOnStatusCode: false,
    }).then((response) => {
      expect(response.status).to.eq(200);
      cy.screenshot('installation-05-chart-templates-directory');
    });
  });

  it('Should have the configmap.yaml with Renovate configuration', () => {
    const requestUrl = `${apiBase}/repos/${projectId}-renovate-qs/browse/chart/templates/configmap.yaml`;
    cy.request({
      method: 'GET',
      url: requestUrl,
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

require_relative '../libraries/terraform_data.rb'
require_relative '../libraries/fixture_data.rb'

t    = SpecHelper::TerraformData.new
id   = t['id']
name = t['name']
tags = { :Name => name + '-' + id }

f = SpecHelper::FixtureData.new.for_module(name)

control 'stack' do
  impact 1.0
  title  "Test Suite: 'Stack'"
  desc   "This test suite asserts the correct functionality of the stack under test."
  tag    name

  # Test Resource Group
  describe azure_generic_resource(resource_id: t['resource_group_id']) do
    it { should exist }
  end

  # Test ARM Template Deployment
  describe azure_generic_resource(resource_id: t['arm_template_deployment_id']) do
    it { should exist }
  end
end

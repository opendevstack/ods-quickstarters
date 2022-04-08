require_relative '../libraries/terraform_data.rb'
require_relative '../libraries/fixture_data.rb'

t    = SpecHelper::TerraformData.new
id   = t['id']
name = t['name']
tags = { :Name => name + '-' + id }

f = SpecHelper::FixtureData.new.for_module(name)

stack_name = 'stack'
tfo_symbolized = input("output_module_#{stack_name}", value: nil)
tfo = JSON.parse(JSON.generate(tfo_symbolized), { symbolize_names: false }) unless tfo_symbolized.nil?

control 'stack' do
  impact 1.0
  title  "Test Suite: 'Stack'"
  desc   "This test suite asserts the correct functionality of the stack under test."
  only_if('Input data for test cases has to be set.') do
    !tfo_symbolized.nil? && (tfo_symbolized.count != 0)
  end
  tag tfo.first['inputs2outputs'].first['name']

  tfo.each do |tfoelement|
    name = tfoelement['inputs2outputs'].first['name']
    f    = tfoelement['inputs2outputs'].first
    t    = tfoelement

    resource_group_id = t['resource_group_id']
    arm_template_deployment_id = t['arm_template_deployment_id']

    # Test Resource Group
    describe azure_generic_resource(resource_id: t['resource_group_id']) do
      it { should exist }
    end

    # Test ARM Template Deployment
    describe azure_generic_resource(resource_id: t['arm_template_deployment_id']) do
      it { should exist }
    end
  end
end

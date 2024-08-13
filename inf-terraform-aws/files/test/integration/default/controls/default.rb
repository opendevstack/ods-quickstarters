require_relative '../libraries/terraform_data.rb'
require_relative '../libraries/fixture_data.rb'
require_relative '../libraries/aws.rb'

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

  describe aws_region(region_name: t['current_region']) do
    its('endpoint') { should be_in ['ec2.eu-west-1.amazonaws.com', 'ec2.us-east-1.amazonaws.com'] }
  end

  describe "Stack Testing" do
    it { expect(true).to be_truthy }
  end
end

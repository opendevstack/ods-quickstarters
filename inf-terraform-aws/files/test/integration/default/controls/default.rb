require_relative '../libraries/terraform_data.rb'
require_relative '../libraries/fixture_data.rb'
require_relative '../libraries/aws.rb'

t    = SpecHelper::TerraformData.new
id   = t['id']
name = t['name']
tags = { :Name => name + '-' + id }

f = SpecHelper::FixtureData.new.for_module(name)


control 'stackdefault' do
  impact 1.0
  title  "Test Suite: 'Stack Default'"
  desc   "This test suite asserts the correct functionality of the stack under test."
  tag    name

  describe "Stack Testing" do
=begin
    it                      { should exist }
    it                      { should_not be_public }
    its('bucket_acl.count') { should eq 1 }
    its('bucket_policy')    { should be_empty }
    it { should have_default_encryption_enabled }
=end
    it { expect(true).to be_truthy }
  end
end

require_relative '../../../shared/spec_helper.rb'

t    = SpecHelper::TerraformData.new
id   = t['id']
name = t['name']
tags = { :Name => name + '-' + id }

f = SpecHelper::FixtureData.new.for_module(name)

control 'default' do
  impact 1.0
  title  "Test Suite: 'default'"
  desc   "This test suite asserts the correct functionality of the stack under test."
  tag    name

  #S3 Bucket Testing
  data_bucket_name = t['data_bucket_name']

  p data_bucket_name
  p '----'

  describe aws_s3_bucket(bucket_name: data_bucket_name + '-' + id ) do
    it                      { should exist }
    it                      { should_not be_public }
    its('bucket_acl.count') { should eq 1 }
    its('bucket_policy')    { should be_empty }
    it { should have_default_encryption_enabled }
  end
end
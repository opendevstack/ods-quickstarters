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

  cfClient       = SpecHelper::AWS.sdk.client(Aws::CloudFormation)
  cfStackName    = name

  # ###########################################################
  # Test if Cloudformation Stack has been succesfully deployed
  # ###########################################################
  describe "CloudFormation Stack #{cfStackName}" do
    cfStack = cfClient.describe_stacks({stack_name: cfStackName}).stacks[0]

    context 'status' do
      it { expect(cfStack.stack_status).to eq("CREATE_COMPLETE").or eq("UPDATE_COMPLETE") }
    end
  end

  cfStackOutputs     = t['cf_stack_outputs']
  cfStackOutputsHash = cfStackOutputs.to_h
  s3BucketName       = cfStackOutputsHash["S3BucketName"]

  # ###########################################################
  # Tests on resources deployed by the Cloudformation Stack
  # ###########################################################
  describe aws_s3_bucket(bucket_name: s3BucketName) do
    it                      { should exist }
    it                      { should_not be_public }
    its('bucket_policy')    { should be_empty }
    its('region')           { should eq 'eu-west-1' }
    it                      { should have_default_encryption_enabled }
  end

  describe "Stack Testing" do
    it { expect(true).to be_truthy }
  end
end

import boto3
import pytest
import allure
import json
import os
import datetime
import pytz


def get_terraform_outputs():
    with open('terraform_outputs.json') as file:
        output_json = json.load(file)

    return output_json


def get_env_vars():
    environment = os.environ['ENVIRONMENT']
    env_vars_path = f"environments/{environment}.json"
    with open(env_vars_path, 'r') as file:
        data = json.load(file)

    return data

'''Remember to rename the test with this format <Jira Project id><Test Issue id>_<Name of the test>_test e.g: EDPTP457_s3_file_present_test'''
def Demo_s3_file_present_test(record_property):
    outputs_tf = get_terraform_outputs()
    bucket_name = outputs_tf["bitbucket_s3bucket_name"]["value"]
    env_vars = get_env_vars()
    file_key = env_vars['repository'] + '-' + env_vars['branch_name'] + '.zip'

    record_property(
      "test_evidence_1",
      f"Name of the bucket search: {bucket_name}, file to search in the bucket: {file_key}"
    )

    s3_client = boto3.client('s3')
    with allure.step("Check if file exists in S3 bucket"):
        response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=file_key)
        file_present = 'Contents' in response
        record_property(
          "test_evidence_2",
          f"Response form the call to the S3 bucket: {file_key}"
        )
        assert file_present, f"File '{file_key}' not found in S3 bucket '{bucket_name}'"

'''Remember to rename the test with this format <Jira Project id><Test Issue id>_<Name of the test>_test e.g: EDPTP456_s3_file_present_test'''
def Demo_test_pipeline_execution_time_test(record_property):
    outputs_tf = get_terraform_outputs()
    codepipeline_name = outputs_tf['codepipeline_name']['value']
    client = boto3.client('codepipeline')

    record_property(
      "test_evidence_1",
      f"Name of the pipeline: {codepipeline_name}"
    )

    with allure.step("Check aws pipeline last execution"):
        response = client.get_pipeline_state(name=codepipeline_name)
        last_execution = response['stageStates'][0]['actionStates'][0]['latestExecution']['lastStatusChange']
        record_property(
          "test_evidence_2",
          f"Response from the Pipeline, last execution was on date:  {last_execution}"
        )
        now = datetime.datetime.now(pytz.UTC)
        assert last_execution > now - datetime.timedelta(hours=24), f"Pipeline has not been executed in the last 24 hours"

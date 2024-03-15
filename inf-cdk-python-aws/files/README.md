# ODS AWS CDK Python Quickstarter

This Quickstarter can be used to deploy AWS resources. Its primary usage is to build solutions based on AWS CDK Python.

## What is the AWS CDK?

The AWS Cloud Development Kit (CDK) is an open-source software development framework that allows you to define cloud infrastructure in code. It provides a high-level object-oriented abstraction to define AWS resources imperatively using programming languages like TypeScript, JavaScript, Python, Java, and C#.

## AWS CDK with Python

AWS CDK supports Python as one of the programming languages to define and manage cloud infrastructure. You can use Python to write your infrastructure code, which will be compiled into AWS CloudFormation templates. This allows you to leverage Python's features and libraries to create, modify, and manage your AWS resources.

## How to get started?

The Quickstarter will automatically create a new AWS CDK Python project in your component repository.
In order to develop, the Python package installer, pip, and virtual environment manager, virtualenv, are required. The provided ODS agent comes already installed with these tools.

If you want to develop locally, make sure those tools are available in your environment, too. To run your code locally execute the following commands:

```
$ python -mvenv .venv
$ cd src
$ source ../.venv/bin/activate && pip install -r requirements.txt -r requirements-dev.txt
```
You may want to to verify you code by running ...
```
$ pytest
```

Note that your code will interact with *AWS*. It is up to you to provide sufficient configuration to enable these interactions.  Here is an example for *AWS* that uses environment variables (via [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)):

```
$ export AWS_ACCESS_KEY_ID=...
$ export AWS_SECRET_ACCESS_KEY=...
$ export AWS_DEFAULT_REGION=us-east-1
```

## Brief Example

Here's a simple example of using AWS CDK with Python to create an Amazon S3 bucket:
```
from aws_cdk import core
from aws_cdk.aws_s3 import Bucket

class MyS3BucketStack(core.Stack):

    def __init__(self, scope: core.Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        # Create an Amazon S3 bucket
        Bucket(self, "MyBucket", versioned=True)

app = core.App()
MyS3BucketStack(app, "MyS3BucketStack")
app.synth()
```
In this example, we import the necessary modules, define a stack class, create an S3 bucket with versioning enabled, and then synthesize the stack to generate the CloudFormation template.

## Problems? Questions? Suggestions?

In case of problems, questions or suggestions, feel free to file an issue with the respective project's repository. Thanks!


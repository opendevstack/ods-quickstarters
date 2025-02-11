
resource "aws_codebuild_project" "build_project" {
  name          = "${var.projectId}-e2e-cb-${var.aws_region}-${var.codebuild_project_name}-${var.local_id}" //"CodeBuild-project-test"
  service_role  = var.codebuild_role_arn
  build_timeout = var.build_timeout

  artifacts {
    type = var.artifacts_type
  }

  environment {
    compute_type                = var.environment_compute_type
    image                       = var.environment_image
    type                        = var.environment_type
    image_pull_credentials_type = var.image_pull_credentials_type

    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  }


  source {
    type      = var.source_type
    report_build_status = var.report_build_status
    buildspec = <<-EOT
      version: 0.2

      phases:
        install:
          runtime-versions:
            python: ${var.env_version}

        pre_build:
          commands:
            - pip install -r requirements.txt
            - npm install -g allure-commandline --save-dev

        build:
          commands:
            - python tests/acceptance/great_expectations/test_preparation/pre_requisites.py
            - python utils/checkpoints_executions.py || error=1
            - python tests/acceptance/great_expectations/test_preparation/post_requisites.py
            - python -m pytest --alluredir=pytest/test_results/acceptance --junitxml=pytest/test_results/junit/acceptance_pytest_junit.xml tests/acceptance/pytest || error=1
            - python -m pytest --alluredir=pytest/test_results/installation --junitxml=pytest/test_results/junit/installation_pytest_junit.xml tests/installation || error=1
            - python -m pytest --alluredir=pytest/test_results/integration --junitxml=pytest/test_results/junit/integration_pytest_junit.xml tests/integration || error=1

        post_build:
          commands:
            - (cd tests/acceptance && great_expectations -y docs build)
            - aws s3 cp tests/acceptance/great_expectations/uncommitted/data_docs/local_site s3://${var.e2e_results_bucket_name}/GX_test_results --recursive
            - aws s3 cp tests/acceptance/great_expectations/uncommitted/validations s3://${var.e2e_results_bucket_name}/GX_jsons --recursive
            - python utils/json2JUnit.py

            - aws s3 cp s3://${var.e2e_results_bucket_name}/pytest_results/acceptance/history pytest/test_results/acceptance/history --recursive
            - aws s3 cp s3://${var.e2e_results_bucket_name}/pytest_results/installation/history pytest/test_results/installation/history --recursive
            - aws s3 cp s3://${var.e2e_results_bucket_name}/pytest_results/integration/history pytest/test_results/integration/history --recursive

            - allure generate pytest/test_results/acceptance -o pytest/acceptance_allure_report --clean
            - allure generate pytest/test_results/installation -o pytest/installation_allure_report --clean
            - allure generate pytest/test_results/integration -o pytest/integration_allure_report --clean


            - allure-combine pytest/acceptance_allure_report
            - allure-combine pytest/installation_allure_report
            - allure-combine pytest/integration_allure_report

            - aws s3 cp pytest/acceptance_allure_report/history s3://${var.e2e_results_bucket_name}/pytest_results/acceptance/history --recursive
            - aws s3 cp pytest/installation_allure_report/history s3://${var.e2e_results_bucket_name}/pytest_results/installation/history --recursive
            - aws s3 cp pytest/integration_allure_report/history s3://${var.e2e_results_bucket_name}/pytest_results/integration/history --recursive

            - aws s3 cp pytest/acceptance_allure_report/complete.html s3://${var.e2e_results_bucket_name}/pytest_results/acceptance/acceptance_allure_report_complete.html
            - aws s3 cp pytest/installation_allure_report/complete.html s3://${var.e2e_results_bucket_name}/pytest_results/installation/installation_allure_report_complete.html
            - aws s3 cp pytest/integration_allure_report/complete.html s3://${var.e2e_results_bucket_name}/pytest_results/integration/integration_allure_report_complete.html

            - aws s3 cp tests/acceptance/great_expectations/uncommitted/validations/junit.xml s3://${var.e2e_results_bucket_name}/junit/acceptance_GX_junit.xml
            - aws s3 cp pytest/test_results/junit/acceptance_pytest_junit.xml s3://${var.e2e_results_bucket_name}/junit/acceptance_pytest_junit.xml
            - aws s3 cp pytest/test_results/junit/integration_pytest_junit.xml s3://${var.e2e_results_bucket_name}/junit/integration_pytest_junit.xml
            - aws s3 cp pytest/test_results/junit/installation_pytest_junit.xml s3://${var.e2e_results_bucket_name}/junit/installation_pytest_junit.xml

      reports:
        GX_reports:
          files:
            - junit.xml
          base-directory: tests/acceptance/great_expectations/uncommitted/validations/
          file-format: JUNITXML
        Allure_report:
          files:
            - acceptance_pytest_junit.xml
          base-directory: pytest/test_results/junit/
          file-format: JUNITXML

      EOT
  }
}

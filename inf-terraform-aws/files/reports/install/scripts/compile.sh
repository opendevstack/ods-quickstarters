#!/bin/bash
set -e

ROOT_DIR="$1"
NAME="$2"
VERSION="$3"
DESCRIPTION="$4"
GIT_URI="$5"
DATE_CREATED="$6"

FILE_META_DATA=./data/metadata.json
FILE_POST_INSTALL_TEST_REPORTS=./data/inspec-post-install.json
FILE_PRE_INSTALL_BLUEPRINT_TEST_REPORTS=./data/blueprint-reports.json
FILE_PRE_INSTALL_TEST_REPORTS=./data/inspec-pre-install.json
FILE_TERRAFORM_DOCS_DATA=./data/terraform-docs.json
FILE_TERRAFORM_MODULES_DATA=./data/terraform-modules.json
FILE_TERRAFORM_INSTALL_INPUT_DATA=./data/terraform-install-inputs.json
FILE_TERRAFORM_INSTALL_OUTPUT_DATA=./data/terraform-install-outputs.json

function combine_pre_install_blueprint_test_reports() {
  FILE="$1"
  echo '{ "blueprint_test_reports": [] }' > "${FILE}"

  find ./data/blueprints/reports/test -name "*.json" | while read report; do
    name=`basename -s '.json' $report`
    jq ".blueprint_test_reports += [ { \"name\": \"${name}\", \"data\": input } ]" "${FILE}" "${report}" > "${FILE}.tmp"
    mv "${FILE}.tmp" "${FILE}"
  done
  rm -f "${FILE}.tmp"
}

function combine_pre_install_test_reports() {
  jq '.profiles += [inputs.profiles[]]' ./data/inspec/pre-install/*.json
}

function combine_post_install_test_reports() {
  jq '.profiles += [inputs.profiles[]]' ./data/inspec/post-install/*.json
}

function convert_json_object_to_key_value_pairs() {
  echo "$1" | jq 'to_entries'
}

function create_terraform_install_input_data() {
  TERRAFORM_INPUT_VARS=$(cat "${ROOT_DIR}/terraform.tfvars.json")
  convert_json_object_to_key_value_pairs "${TERRAFORM_INPUT_VARS}"
}

function create_terraform_install_output_data() {
  TERRAFORM_OUTPUT_VARS=$(cat "${ROOT_DIR}/outputs.json")
  convert_json_object_to_key_value_pairs "${TERRAFORM_OUTPUT_VARS}"
}

function create_meta_data() {
  URL=$(git_uri_to_url ${GIT_URI}/tags/v${VERSION})
  echo "{ \"metadata\": { \"date_created\": \"${DATE_CREATED}\", \"description\": \"${DESCRIPTION}\", \"name\": \"${NAME}\", \"git_uri\": \"${GIT_URI}\", \"url\": \"${URL}\", \"version\": \"${VERSION}\" } }"
}

function create_terraform_docs_data() {
  terraform-docs --with-aggregate-type-defaults json "${ROOT_DIR}"
}

function create_terraform_modules_data() {
  if [ -f "${ROOT_DIR}/.terraform/modules/modules.json" ]; then
    jq -c '.Modules | unique_by(.Source) | map(select(.Dir != ".")) | map(select(.Source != "../../.."))' "${ROOT_DIR}/.terraform/modules/modules.json"
  else
    echo "[]"
  fi
}

function git_uri_to_url() {
  local GIT_URI="$1"
  GIT_URL=`echo "${GIT_URI}" | sed 's/:/\//g'`
  GIT_URL=`echo "${GIT_URL}" | sed 's/^git@/https:\/\//'`
  GIT_URL=`echo "${GIT_URL}" | sed 's/.git$//'`
  echo "${GIT_URL}"
}


# Create various report metadata in data/metadata.json
create_meta_data > "${FILE_META_DATA}"

# Combine pre-install Blueprint test reports into a single data/blueprint-test-reports.json
combine_pre_install_blueprint_test_reports "${FILE_PRE_INSTALL_BLUEPRINT_TEST_REPORTS}"

# Combine pre-install InSpec reports into a single data/inspec-pre-install.json
combine_pre_install_test_reports > "${FILE_PRE_INSTALL_TEST_REPORTS}"

# Combine post-install InSpec reports into a single data/inspec-post-install.json
combine_post_install_test_reports > "${FILE_POST_INSTALL_TEST_REPORTS}"

# Create terraform-docs data in data/terraform-docs.json
create_terraform_docs_data > "${FILE_TERRAFORM_DOCS_DATA}"

# Create Terraform installation input values in data/terraform-install-inputs.json
create_terraform_install_input_data > "${FILE_TERRAFORM_INSTALL_INPUT_DATA}"

# Create Terraform installation output values in data/terraform-install-outputs.json
create_terraform_install_output_data > "${FILE_TERRAFORM_INSTALL_OUTPUT_DATA}"

# Create Terraform modules data in data/terraform-modules.json
create_terraform_modules_data > "${FILE_TERRAFORM_MODULES_DATA}"

# Combine data sources into a single document in ./report.json
jq -s '.[0] * .[1] * { "inspec": { "pre-install": .[2] } } * { "inspec": { "post-install": .[3] } } * { "terraform_docs": .[4] } * { "terraform_install": { "inputs": .[5] } } * { "terraform_install": { "outputs": .[6] } } * { "terraform_modules": .[7] }' \
  "${FILE_META_DATA}" \
  "${FILE_PRE_INSTALL_BLUEPRINT_TEST_REPORTS}" \
  "${FILE_PRE_INSTALL_TEST_REPORTS}" \
  "${FILE_POST_INSTALL_TEST_REPORTS}" \
  "${FILE_TERRAFORM_DOCS_DATA}" \
  "${FILE_TERRAFORM_INSTALL_INPUT_DATA}" \
  "${FILE_TERRAFORM_INSTALL_OUTPUT_DATA}" \
  "${FILE_TERRAFORM_MODULES_DATA}" \
  > ./report.json

# Render the report from template and combined data
mustache ./report.json ./template/header.inc.html.tmpl > ./template/header.inc.html
mustache ./report.json ./template/report.html.tmpl > ./report.html
wkhtmltopdf \
  -T 40 -R 25 -B 25 -L 25 \
  --encoding UTF-8 \
  --no-outline \
  --print-media-type \
  --header-html template/header.inc.html \
  --footer-html template/footer.inc.html \
  ./report.html ./report.pdf

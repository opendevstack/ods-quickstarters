#!/usr/bin/env bash
#
# Author: Josef Hartmann
#         josef.hartmann@boehringer-ingelheim.com
#
# This script creates terraform json output, converts it to yaml.
# This yaml file is used for loading terraform outputs as cinc-auditor/inspec inputs using option --input-file=<filename>
#
#

set -e
set -o pipefail

if [ "x${KITCHEN_SUITE_NAME}" == "x" ]; then
  echo "Not running within kitchen."
  KITCHEN_SUITE_NAME="default"
fi

CWD="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
TOJFILE=${CWD}/test/integration/${KITCHEN_SUITE_NAME}/files/tf-stack-output.json
TOYFILE=${CWD}/test/integration/${KITCHEN_SUITE_NAME}/files/inputs-from-tfo-stack.yml

pushd .

#
# A TF_WORKSPACE might be applied by the environment.
#
cd ${CWD}/test/fixtures/default
terraform output -json > "${TOJFILE}"

# Convert terraform json outputs to yaml.
# Use symbolize_names for keys ("id" -> :id)
# Symbolize_names is required, as kitchen-terraform outputs are created as inspec inputs using this type for keys.
jq 'with_entries(.value |= .value)|with_entries(.key = "output_" + .key)' "${TOJFILE}" | \
  ruby -ryaml -rjson -e 'puts YAML.dump(JSON.parse(STDIN.read, :symbolize_names => true))' > "${TOYFILE}"

popd

#!/usr/bin/env bash
set -euo pipefail

# This script manually triggers the renovate-qs cron job by creating a one-off job
# derived from the cronjob definition. It relies on template-provided env vars.

CRONJOB_NAME="renovate-qs"
MANUAL_JOB_NAME="${PROJECT_ID:-unknown}-renovate-qs-manual"
NAMESPACE="${NAMESPACE_CD:-${PROJECT_ID:-unknown}-cd}"


if [[ -z "${PROJECT_ID:-}" ]]; then
  echo "PROJECT_ID environment variable not set; cannot determine namespace or job names." >&2
  exit 1
fi

echo "Ensuring previous job ${MANUAL_JOB_NAME} is removed (if present)"
oc delete job "${MANUAL_JOB_NAME}" -n "${NAMESPACE}" --ignore-not-found=true

echo "Creating manual job ${MANUAL_JOB_NAME} from cronjob ${CRONJOB_NAME} in namespace ${NAMESPACE}"
oc create job --from=cronjob/${CRONJOB_NAME} "${MANUAL_JOB_NAME}" -n "${NAMESPACE}"

# Show job status right after creation for easier troubleshooting
oc get job "${MANUAL_JOB_NAME}" -n "${NAMESPACE}"

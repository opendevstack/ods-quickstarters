#!/usr/bin/env bash

curl --insecure -u $1: $2/api/navigation/component?componentKey=$3 | jq 'del(.analysisDate)' | jq  'del(.version)' | jq  'del(.id)'| jq  'del(.qualityProfiles[].key)'
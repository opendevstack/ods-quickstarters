#!/bin/bash
set -e

echo "Running smoke tests..."

# APP_SERVICE_URL is automatically injected by the test framework
# with the correct resolved URL (route, port-forward, or service DNS)
if [ -z "$APP_SERVICE_URL" ]; then
  echo "ERROR: APP_SERVICE_URL not set by test framework"
  exit 1
fi

echo "Testing service at: $APP_SERVICE_URL"

# Test 1: Health check
echo "Test 1: Health endpoint"
response=$(curl -f -s "$APP_SERVICE_URL/")
if [ -z "$response" ]; then
  echo "FAIL: Health check failed - empty response"
  exit 1
fi
echo "PASS: Health endpoint returned: $response"


echo "All smoke tests passed!"

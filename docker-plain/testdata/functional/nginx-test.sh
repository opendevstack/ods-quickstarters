#!/usr/bin/env bash
set -euo pipefail

echo "=== Nginx Functional Tests ==="

# Ensure we have the service URL
: "${WEB_SERVICE_URL:?WEB_SERVICE_URL environment variable is required}"

echo "Testing nginx at: $WEB_SERVICE_URL"

# Test 1: Health endpoint
echo "Test 1: Health endpoint..."
HEALTH_RESPONSE=$(curl -sS "${WEB_SERVICE_URL}/health")
if echo "$HEALTH_RESPONSE" | jq -e '.status == "UP"' >/dev/null; then
    echo "✓ Health endpoint returns correct status"
else
    echo "✗ Health endpoint failed"
    echo "Response: $HEALTH_RESPONSE"
    exit 1
fi

# Test 2: Default page returns 200
echo "Test 2: Default page..."
STATUS=$(curl -sS -o /dev/null -w "%{http_code}" "${WEB_SERVICE_URL}/")
if [ "$STATUS" = "200" ]; then
    echo "✓ Default page returns 200"
else
    echo "✗ Default page returned $STATUS (expected 200)"
    exit 1
fi

# Test 3: Verify nginx is serving HTML
echo "Test 3: Content verification..."
CONTENT=$(curl -sS "${WEB_SERVICE_URL}/")
if echo "$CONTENT" | grep -qi "nginx"; then
    echo "✓ Page contains expected content"
else
    echo "✗ Page does not contain expected content"
    exit 1
fi

# Test 4: Verify 404 for non-existent path
echo "Test 4: 404 handling..."
STATUS=$(curl -sS -o /dev/null -w "%{http_code}" "${WEB_SERVICE_URL}/nonexistent")
if [ "$STATUS" = "404" ]; then
    echo "✓ Returns 404 for non-existent paths"
else
    echo "✗ Returned $STATUS (expected 404)"
    exit 1
fi

echo "=== All Tests Passed ==="

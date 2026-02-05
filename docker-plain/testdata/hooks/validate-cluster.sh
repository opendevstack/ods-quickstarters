#!/usr/bin/env bash
set -euo pipefail

echo "=== Pre-Provision Validation ==="
echo "Checking cluster connectivity..."

# Verify we're logged in to the cluster
if ! oc whoami &>/dev/null; then
    echo "ERROR: Not logged in to OpenShift cluster"
    exit 1
fi

echo "✓ Logged in as: $(oc whoami)"
echo "✓ Current server: $(oc whoami --show-server)"

# Check if we have basic permissions (check in current context or use --all-namespaces)
echo "Checking permissions..."
if oc auth can-i create deployments --all-namespaces &>/dev/null; then
    echo "✓ Have cluster-level permissions to create deployments"
elif oc auth can-i create deployments &>/dev/null; then
    echo "✓ Have permissions to create deployments in current context"
else
    echo "⚠️  WARNING: Limited permissions detected - tests may fail"
    echo "   This is not necessarily a blocker, proceeding anyway..."
fi

echo "=== Validation Complete ==="

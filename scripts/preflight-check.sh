#!/bin/bash

echo "========================================="
echo "ArkCase Deployment Preflight Check"
echo "========================================="
echo

PASS=0
FAIL=0

# Check function
check() {
    local name=$1
    local test=$2
    
    if eval "$test" > /dev/null 2>&1; then
        echo "✓ $name"
        ((PASS++))
    else
        echo "✗ $name"
        ((FAIL++))
    fi
}

# File and permission checks
echo "1. Checking files and permissions..."
check "docker-compose.yml exists" "[ -f docker-compose.yml ]"
check ".env file exists" "[ -f .env ]"
check "init-scripts/01-init-databases.sh is executable" "[ -x init-scripts/01-init-databases.sh ]"
check "arkcase-config directory exists" "[ -d arkcase-config ]"
check "arkcase-config/acm directory exists" "[ -d arkcase-config/acm ]"
check "certs/keystore.p12 exists" "[ -f certs/keystore.p12 ]"
check "certs/arkcase.crt exists" "[ -f certs/arkcase.crt ]"
check "nginx/nginx.conf exists" "[ -f nginx/nginx.conf ]"
echo

# Environment variable checks
echo "2. Checking .env file variables..."
check "DB_PASSWORD is set" "grep -q 'DB_PASSWORD=' .env"
check "ACTIVEMQ_PASSWORD is set" "grep -q 'ACTIVEMQ_PASSWORD=' .env"
check "KEYSTORE_PASSWORD is set" "grep -q 'KEYSTORE_PASSWORD=' .env"
check "ARKCASE_HOST is set" "grep -q 'ARKCASE_HOST=' .env"
echo

# System requirements
echo "3. Checking system requirements..."
check "Docker or Podman is installed" "which docker > /dev/null || which podman > /dev/null"
check "Docker Compose or Podman Compose is installed" "which docker-compose > /dev/null || which podman-compose > /dev/null"

# Get RAM info
if command -v free &> /dev/null; then
    RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$RAM_GB" -ge 16 ]; then
        echo "✓ System RAM: ${RAM_GB}GB (sufficient)"
        ((PASS++))
    else
        echo "! System RAM: ${RAM_GB}GB (minimum recommended: 16GB)"
        ((FAIL++))
    fi
fi
echo

# Docker image availability (optional)
echo "4. Checking critical images (optional - images may pull on start)..."
if command -v podman &> /dev/null; then
    check "postgres:14-alpine image available" "podman pull postgres:14-alpine > /dev/null 2>&1 || true; podman image ls | grep -q postgres"
elif command -v docker &> /dev/null; then
    check "postgres:14-alpine image available" "docker pull postgres:14-alpine > /dev/null 2>&1 || true; docker image ls | grep -q postgres"
fi
echo

# Summary
echo "========================================="
echo "Summary: $PASS passed, $FAIL failed"
echo "========================================="

if [ $FAIL -gt 0 ]; then
    echo
    echo "Issues found. Please resolve before running:"
    echo "  podman-compose up -d"
    exit 1
else
    echo
    echo "✓ All checks passed! Ready to deploy."
    echo
    echo "Next steps:"
    echo "  1. Review .env file and update passwords if needed"
    echo "  2. Start services: podman-compose up -d"
    echo "  3. Monitor startup: podman-compose logs -f"
    echo "  4. Check status: podman-compose ps"
    exit 0
fi

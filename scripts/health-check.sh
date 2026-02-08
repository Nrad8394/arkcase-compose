#!/bin/bash
#
# ArkCase Health Check Script
# This script checks the health of all ArkCase services
#

set -e

# Configuration
ALERT_EMAIL="${ALERT_EMAIL:-admin@yourdomain.com}"
LOG_FILE="/opt/arkcase-backups/logs/health-check.log"
ALERT_FILE="/tmp/arkcase-health-alert"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

alert() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ALERT: $1" | tee -a "${LOG_FILE}" "${ALERT_FILE}"
}

check_service() {
    local service=$1
    local status=$(podman ps --filter "name=${service}" --format "{{.Status}}")
    
    if [ -n "${status}" ]; then
        if echo "${status}" | grep -q "Up"; then
            echo -e "${GREEN}✓${NC} ${service}: ${status}"
            return 0
        else
            echo -e "${RED}✗${NC} ${service}: ${status}"
            alert "${service} is not healthy: ${status}"
            return 1
        fi
    else
        echo -e "${RED}✗${NC} ${service}: NOT RUNNING"
        alert "${service} is not running"
        return 1
    fi
}

check_port() {
    local host=$1
    local port=$2
    local service=$3
    
    if timeout 5 bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} ${service} port ${port}: OPEN"
        return 0
    else
        echo -e "${RED}✗${NC} ${service} port ${port}: CLOSED"
        alert "${service} port ${port} is not accessible"
        return 1
    fi
}

check_url() {
    local url=$1
    local service=$2
    
    if curl -k -s -f -o /dev/null "${url}"; then
        echo -e "${GREEN}✓${NC} ${service}: ${url} ACCESSIBLE"
        return 0
    else
        echo -e "${RED}✗${NC} ${service}: ${url} NOT ACCESSIBLE"
        alert "${service} URL ${url} is not accessible"
        return 1
    fi
}

check_disk_space() {
    local threshold=90
    local usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "${usage}" -lt "${threshold}" ]; then
        echo -e "${GREEN}✓${NC} Disk usage: ${usage}%"
        return 0
    else
        echo -e "${RED}✗${NC} Disk usage: ${usage}% (threshold: ${threshold}%)"
        alert "Disk usage is high: ${usage}%"
        return 1
    fi
}

check_memory() {
    local threshold=90
    local usage=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100)}')
    
    if [ "${usage}" -lt "${threshold}" ]; then
        echo -e "${GREEN}✓${NC} Memory usage: ${usage}%"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} Memory usage: ${usage}% (threshold: ${threshold}%)"
        alert "Memory usage is high: ${usage}%"
        return 1
    fi
}

check_database() {
    if podman exec arkcase-postgres psql -U arkcase -c "SELECT 1" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Database: CONNECTION OK"
        return 0
    else
        echo -e "${RED}✗${NC} Database: CONNECTION FAILED"
        alert "Database connection failed"
        return 1
    fi
}

# Main health check
log "=== Starting Health Check ==="
rm -f "${ALERT_FILE}"

ALL_HEALTHY=true

echo ""
echo "=== Container Status ==="
check_service "arkcase-postgres" || ALL_HEALTHY=false
check_service "arkcase-solr" || ALL_HEALTHY=false
check_service "arkcase-activemq" || ALL_HEALTHY=false
check_service "arkcase-alfresco" || ALL_HEALTHY=false
check_service "arkcase-alfresco-share" || ALL_HEALTHY=false
check_service "arkcase-pentaho" || ALL_HEALTHY=false
check_service "arkcase-config-server" || ALL_HEALTHY=false
check_service "arkcase-core" || ALL_HEALTHY=false
check_service "arkcase-nginx" || ALL_HEALTHY=false

echo ""
echo "=== Network Connectivity ==="
check_port "localhost" "5432" "PostgreSQL" || ALL_HEALTHY=false
check_port "localhost" "8983" "Solr" || ALL_HEALTHY=false
check_port "localhost" "61616" "ActiveMQ" || ALL_HEALTHY=false
check_port "localhost" "80" "Nginx HTTP" || ALL_HEALTHY=false
check_port "localhost" "443" "Nginx HTTPS" || ALL_HEALTHY=false

echo ""
echo "=== URL Accessibility ==="
check_url "http://localhost/health" "Nginx" || ALL_HEALTHY=false
check_url "https://localhost/health" "Nginx HTTPS" || true  # May fail with self-signed cert
check_url "http://localhost:8983/solr/arkcase/admin/ping" "Solr" || ALL_HEALTHY=false

echo ""
echo "=== System Resources ==="
check_disk_space || ALL_HEALTHY=false
check_memory || ALL_HEALTHY=false

echo ""
echo "=== Database Connectivity ==="
check_database || ALL_HEALTHY=false

echo ""
echo "=== Docker Stats ==="
podman stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

# Summary
echo ""
if [ "${ALL_HEALTHY}" = true ]; then
    echo -e "${GREEN}=== ALL CHECKS PASSED ===${NC}"
    log "Health check completed: ALL HEALTHY"
    exit 0
else
    echo -e "${RED}=== SOME CHECKS FAILED ===${NC}"
    log "Health check completed: ISSUES DETECTED"
    
    # Send alert email if configured
    if [ -f "${ALERT_FILE}" ] && [ -n "${ALERT_EMAIL}" ]; then
        if command -v mail &> /dev/null; then
            mail -s "ArkCase Health Check Alert - $(hostname)" "${ALERT_EMAIL}" < "${ALERT_FILE}"
            log "Alert email sent to ${ALERT_EMAIL}"
        else
            log "Alert email not sent (mail command not available)"
        fi
    fi
    
    exit 1
fi

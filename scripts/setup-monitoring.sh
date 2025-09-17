#!/bin/bash

# OSSOP Uptime Kuma Auto-Configuration Script
# This script automatically configures monitoring for all OSSOP services

set -e

UPTIME_KUMA_URL="http://localhost:3001"
API_KEY=""  # Set this after creating admin account

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 OSSOP Monitoring Setup${NC}"
echo "=================================="

# Function to add monitor
add_monitor() {
    local name="$1"
    local url="$2"
    local type="$3"
    local interval="${4:-60}"
    
    echo -e "${YELLOW}Adding monitor: ${name}${NC}"
    
    curl -s -X POST "${UPTIME_KUMA_URL}/api/monitor" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_KEY}" \
        -d "{
            \"name\": \"${name}\",
            \"url\": \"${url}\",
            \"type\": \"${type}\",
            \"interval\": ${interval},
            \"maxretries\": 3,
            \"timeout\": 10,
            \"active\": true
        }" && echo -e "${GREEN}✅ ${name} configured${NC}" || echo -e "${RED}❌ Failed to add ${name}${NC}"
}

# Check if Uptime Kuma is running
echo -e "${BLUE}Checking Uptime Kuma status...${NC}"
if ! curl -s "${UPTIME_KUMA_URL}" > /dev/null; then
    echo -e "${RED}❌ Uptime Kuma is not accessible at ${UPTIME_KUMA_URL}${NC}"
    echo "Please ensure Uptime Kuma is running: docker compose up -d uptime-kuma"
    exit 1
fi

echo -e "${GREEN}✅ Uptime Kuma is accessible${NC}"

# Check if API key is set
if [ -z "$API_KEY" ]; then
    echo -e "${YELLOW}⚠️  API_KEY not set in this script${NC}"
    echo "Please:"
    echo "1. Access Uptime Kuma at ${UPTIME_KUMA_URL}"
    echo "2. Create an admin account"
    echo "3. Go to Settings → API Keys → Generate"
    echo "4. Set API_KEY variable in this script"
    echo ""
    echo -e "${BLUE}Manual monitor configuration:${NC}"
    echo "You can manually add these monitors in the Uptime Kuma UI:"
    echo ""
fi

# Define all OSSOP services
declare -A SERVICES=(
    ["SIEM Dashboard"]="http://opensearch-dashboards:5601,http"
    ["SIEM API"]="http://opensearch:9200/_cluster/health,http"
    ["SOAR Frontend"]="http://shuffle-frontend:80,http"
    ["SOAR Backend"]="http://shuffle-backend:5001/api/v1/health,http"
    ["Case Management"]="http://iris-web:8000,http"
    ["Threat Intelligence"]="http://misp-web:80/users/login,http"
    ["OSINT Platform"]="http://spiderfoot:5001,http"
    ["Vulnerability Management"]="http://defectdojo-app:8080,http"
    ["GRC Platform"]="https://eramba-web:443,http"
    ["Wazuh API"]="wazuh-manager:55000,tcp"
    ["Monitoring Dashboard"]="http://uptime-kuma:3001,http"
)

# Add monitors
echo -e "${BLUE}Configuring monitors...${NC}"
for service in "${!SERVICES[@]}"; do
    IFS=',' read -r url type <<< "${SERVICES[$service]}"
    
    if [ -n "$API_KEY" ]; then
        add_monitor "$service" "$url" "$type"
    else
        echo "- $service: $url ($type)"
    fi
    sleep 1
done

echo ""
echo -e "${GREEN}🎉 Monitoring setup complete!${NC}"
echo -e "${BLUE}Access your monitoring dashboard at: ${UPTIME_KUMA_URL}${NC}"

if [ -z "$API_KEY" ]; then
    echo ""
    echo -e "${YELLOW}📋 Next steps:${NC}"
    echo "1. Set up admin account in Uptime Kuma"
    echo "2. Generate API key in Settings"
    echo "3. Update API_KEY in this script and re-run"
    echo "4. Or manually add the monitors listed above"
fi

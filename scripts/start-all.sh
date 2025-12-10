#!/bin/bash
set -e

# Resolve root relative to script location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

# Create network
echo "Creating network ossop-network..."
docker network create ossop-network 2>/dev/null || echo "Network ossop-network likely already exists."

# Create volumes (explicitly named to match compose external:true)
VOLUMES=(
    "ossop_opensearch_data"
    "ossop_shuffle_db_data"
    "ossop_iris_db_data"
    "ossop_defectdojo_db_data"
    "ossop_misp_db_data"
    "ossop_misp_redis_data"
)

for vol in "${VOLUMES[@]}"; do
    if ! docker volume ls -q -f name="^${vol}$" | grep -q "${vol}"; then
        echo "Creating volume $vol..."
        docker volume create "$vol" > /dev/null
    fi
done

APPS_DIR="apps"

start_app() {
    local app_name=$1
    local compose_file="./$APPS_DIR/$app_name/docker-compose.yml"
    
    if [ -f "$compose_file" ]; then
        echo -e "\033[0;36mStarting $app_name from $compose_file...\033[0m"
        # Pass env file explicitly
        docker compose -f "$compose_file" --env-file ./.env up -d --remove-orphans
    else
        echo -e "\033[0;31mError: Compose file for $app_name not found at $compose_file\033[0m"
    fi
}

# Start Core First
start_app "opensearch"
echo -e "\033[0;33mWaiting 20 seconds for OpenSearch to initialize...\033[0m"
sleep 20

# Start Dependents
start_app "wazuh"
start_app "shuffle"
start_app "iris"
start_app "defectdojo"
start_app "misp"
start_app "spiderfoot"
start_app "eramba"
start_app "suricata"
start_app "gophish"

echo -e "\033[0;32mAll apps have been requested to start.\033[0m"
echo "Run 'docker compose -f apps/<app>/docker-compose.yml logs -f' to monitor specific apps."

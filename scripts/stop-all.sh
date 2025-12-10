#!/bin/bash

# Resolve root relative to script location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

APPS_DIR="apps"

stop_app() {
    local app_name=$1
    local compose_file="./$APPS_DIR/$app_name/docker-compose.yml"
    
    if [ -f "$compose_file" ]; then
        echo -e "\033[0;36mStopping $app_name...\033[0m"
        docker compose -f "$compose_file" down
    else
        echo -e "\033[0;31mError: Compose file for $app_name not found at $compose_file\033[0m"
    fi
}

# Stop reverse order roughly
stop_app "gophish"
stop_app "suricata"
stop_app "eramba"
stop_app "spiderfoot"
stop_app "misp"
stop_app "defectdojo"
stop_app "iris"
stop_app "shuffle"
stop_app "wazuh"
stop_app "opensearch"

echo -e "\033[0;32mAll apps stopped.\033[0m"

Open Source Security Operations Platform - Setup Guide
This document provides a step-by-step guide to deploying a comprehensive, open-source Security Information and Event Management (SIEM) and Security Orchestration, Automation, and Response (SOAR) stack using Docker.

Core Capabilities & Components:

SIEM Core: OpenSearch (Version defined in .env)

SIEM UI: OpenSearch Dashboards (Version defined in .env)

Endpoint Security (EDR/HIDS): Wazuh Manager (Version defined in .env)

Log Ingestion: Filebeat OSS (Version defined in .env)

SOAR Platform: Shuffle (Version defined in .env)

Case Management (SIRP): DFIR-IRIS (Version defined in .env)

OSINT & EASM: SpiderFoot (Version defined in .env)

GRC Platform: Eramba Community (Version defined in .env)

Network Security (IDS): Suricata (Version defined in .env)

Threat Intelligence Platform (TIP): MISP (Version defined in .env)

Vulnerability Management: DefectDojo (Version defined in .env)

🏛️ Architectural Decisions
This section explains the key "why" questions behind our stack's design.

Why Use a Separate Database for Each Major Component?
Our stack includes multiple dedicated database backends. This is a deliberate choice for Data Isolation, Performance, and Stability.

Data Isolation: Each platform has a unique data schema. Mixing them is risky; a problem with high-volume log ingestion into the SIEM should never be able to corrupt or destroy the critical case data in IRIS or compliance data in Eramba.

Performance: Each database is tuned for its specific workload. Separating them guarantees that a massive SIEM query will not slow down or crash your incident response, automation, or GRC platforms.

Compatibility & Simplicity: Using the recommended database for each component ensures stability and simplifies the configuration.

Why Use Shuffle's Advanced Architecture?
We deploy Shuffle using three containers (Frontend, Backend, Orborus) for a production-ready setup, with Orborus providing a sandboxed execution engine for maximum security and stability.

🚀 Phase 1: Server Preparation
This phase covers the one-time setup of the host virtual machine.

Step 1: Fix Package Manager Sources (apt)
On a fresh Debian installation, reconfigure apt to use online repositories.

# As root (su -)
cp /etc/apt/sources.list /etc/apt/sources.list.bak
tee /etc/apt/sources.list >/dev/null <<'EOF'
deb [http://deb.debian.org/debian/](http://deb.debian.org/debian/) trixie main contrib non-free-firmware
deb-src [http://deb.debian.org/debian/](http://deb.debian.org/debian/) trixie main contrib non-free-firmware
deb [http://security.debian.org/debian-security](http://security.debian.org/debian-security) trixie-security main contrib non-free-firmware
deb-src [http://security.debian.org/debian-security](http://security.debian.org/debian-security) trixie-security main contrib non-free-firmware
deb [http://deb.debian.org/debian/](http://deb.debian.org/debian/) trixie-updates main contrib non-free-firmware
deb-src [http://deb.debian.org/debian/](http://deb.debian.org/debian/) trixie-updates main contrib non-free-firmware
EOF
apt update

Step 2: Install Prerequisites (sudo, curl, openssl)
# As root (su -)
apt install sudo curl openssl -y

Step 3: Install Docker Engine
# As root (su -)
apt install ca-certificates gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL [https://download.docker.com/linux/debian/gpg](https://download.docker.com/linux/debian/gpg) | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] [https://download.docker.com/linux/debian](https://download.docker.com/linux/debian) \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

Step 4: Configure User Permissions
# As root (su -)
usermod -aG sudo soar
usermod -aG docker soar

CRITICAL: Log out and log back in for changes to take effect. Verify with docker run hello-world.

Step 5: Set Kernel Parameters
OpenSearch and Elasticsearch require a higher memory map count.

# As your sudo-enabled user
sudo sysctl -w vm.max_map_count=262144

🚀 Phase 2: Stack Deployment
This phase covers creating the necessary files and launching the Docker stack.

Step 1: Create Project Structure
# As your non-root, sudo-enabled user (e.g., soar)
# We will use 'ossop' as our project name
sudo mkdir -p /opt/ossop
sudo chown -R $USER:$USER /opt/ossop
cd /opt/ossop

# Create all necessary subdirectories
mkdir -p config/{filebeat,suricata}
mkdir -p data/{opensearch,filebeat,wazuh,iris-db,spiderfoot,eramba-db,suricata/logs,defectdojo-db}
mkdir -p data/shuffle/{shuffle-database,opensearch}
mkdir -p data/misp/{db,redis}

# Set permissions required by the database containers
sudo chown -R 1000:1000 data/opensearch
sudo chown -R 1000:1000 data/shuffle/opensearch

Step 2: Create Environment File (.env)
In /opt/ossop, create a file named .env. Paste the complete contents from the Environment Variables file. Remember to set strong, unique passwords and generate new secret keys.

Step 3: Create Configuration Files (filebeat.yml, suricata.yaml)
In /opt/ossop/config/filebeat, create filebeat.yml. Paste the contents from the Filebeat Configuration file.

sudo chown root:root config/filebeat/filebeat.yml
sudo chmod go-w config/filebeat/filebeat.yml

In /opt/ossop/config/suricata, create suricata.yaml. Paste the contents from the Suricata Configuration file.

Step 4: Create the Docker Compose File (docker-compose.yml)
In /opt/ossop, create the docker-compose.yml file. Paste the complete and final configuration from the Docker Compose Orchestration file.

Step 5: Launch the Stack
From the /opt/ossop directory, perform a clean start.

# Stop and remove any old containers and volumes
docker compose down -v

# Launch the full stack
docker compose up -d

The first launch will take several minutes.

🚀 Phase 3: Initial Configuration & Verification
Step 1: Verify All Containers are Healthy
After about 10-15 minutes, run docker compose ps. All containers should eventually show a (healthy) or Up status.

Step 2: Access Your Services
SIEM: http://<YOUR_VM_IP>:${OPENSEARCH_DASHBOARDS_PORT}

SOAR: http://<YOUR_VM_IP>:${FRONTEND_PORT}

Case Management: http://<YOUR_VM_IP>:${IRIS_PORT}

OSINT Platform: http://<YOUR_VM_IP>:${SPIDERFOOT_PORT}

GRC Platform: http://<YOUR_VM_IP>:${ERAMBA_PORT}

Threat Intel Platform: http://<YOUR_VM_IP>:${MISP_PORT}

Vulnerability Management: http://<YOUR_VM_IP>:${DEFECTDOJO_PORT}

Step 3: Configure OpenSearch Dashboards (SIEM)
Log in (the first time may use a browser popup) with admin and the OPENSEARCH_INITIAL_ADMIN_PASSWORD.

Go to Stack Management > Index Patterns and create patterns for filebeat-*, wazuh-alerts-*, and suricata-ids. Use @timestamp as the time field.

Go to the Discover tab to see your logs, endpoint alerts, and now network alerts.

Step 4: Initial Setup for Other Platforms
Access the UI for each new service (Shuffle, IRIS, SpiderFoot, Eramba, MISP, DefectDojo) and complete their first-time setup wizards to create your admin users. For MISP, you will need to change the default admin@admin.test password on first login.

You now have a stable, functioning, and enterprise-ready 360-degree security operations platform.

🔧 Troubleshooting Log
Issue

Root Cause

Solution

sudo: command not found

Minimal Debian install; sudo package missing.

Became root (su -), installed sudo, and added user to the sudo group.

filebeat restarting

Multiple issues: permissions, config variables, protocol mismatch.

1. Set correct ownership (root:root) and permissions (-rw-r--r--) on filebeat.yml. 
 2. Passed password variable via environment in docker-compose.yml. 
 3. Aligned protocol to http to match OpenSearch config.

wazuh-manager can't connect

Wazuh defaults to host wazuh.indexer.

Used INDEXER_URL environment variable to point it to our opensearch container and disabled its internal Filebeat.

shuffle-backend unhealthy

Lacked permission to access the host's Docker engine.

Mounted the Docker socket (/var/run/docker.sock) and ran the service as user: root.

shuffle-* fails with manifest unknown

Version tag in .env was incorrect.

Verified the correct, modern, stable tag (2.1.0) without a v prefix and updated the .env file.

opensearch-dashboards gets connection refused

The opensearch process was only listening on localhost.

Added network.host=0.0.0.0 to the opensearch service's environment.

(Final Cascade) Multiple services fail after network fix.

The network.host change activated a strict SSL/TLS requirement in the OpenSearch security plugin, causing an authentication mismatch with all clients.

1. Kept network.host=0.0.0.0 in the opensearch service. 
 2. Disabled the strict SSL on the REST API layer for OpenSearch (plugins.security.ssl.http.enabled=false). 
 3. Disabled the dashboard's security plugin (DISABLE_SECURITY_DASHBOARDS_PLUGIN=true) to resolve the final authentication conflict. 
 4. Updated all connecting clients (wazuh-manager, filebeat) to consistently use http:// and remove unnecessary credentials.

Licensing Pivot

TheHive 5 was found to be a commercial product, not FOSS.

Replaced TheHive/Cortex with DFIR-IRIS, a fully open-source (AGPL) alternative. Refactored the stack to use the correct, simpler architecture for IRIS.


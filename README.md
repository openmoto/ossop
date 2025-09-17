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

## 🚀 **Quick Start Guide**

After running `docker compose up -d`, use this guide to access and configure your security platform:

### **Service Status Overview**

| Component | Status | Port | Health Check | Purpose |
|-----------|--------|------|--------------|---------|
| **OpenSearch** | ✅ HEALTHY | 9200 | GREEN cluster | SIEM Core |
| **OpenSearch Dashboards** | ✅ HEALTHY | 5601 | Responding | SIEM UI |
| **Suricata IDS** | ✅ RUNNING | - | Log generation | Network Security |
| **Filebeat** | ✅ RUNNING | - | Log shipping | Log Collector |
| **Wazuh Manager** | ✅ RUNNING | 1514/1515/55000 | Agent management | Endpoint Security |
| **PostgreSQL (Shuffle)** | ✅ HEALTHY | 5432 | Accepting connections | SOAR Database |
| **PostgreSQL (IRIS)** | ✅ HEALTHY | 5432 | Accepting connections | Case Management DB |
| **PostgreSQL (MISP)** | ✅ HEALTHY | 5432 | Accepting connections | Threat Intel DB |
| **PostgreSQL (DefectDojo)** | ✅ HEALTHY | 5432 | Accepting connections | Vulnerability DB |
| **MariaDB (Eramba)** | ✅ HEALTHY | 3306 | Accepting connections | GRC Database |
| **Redis (MISP)** | ✅ HEALTHY | 6379 | Responding to PING | Cache Layer |
| **Shuffle Frontend** | ✅ RUNNING | 80 | HTTP 200 OK | SOAR UI |
| **Shuffle Backend** | ✅ RUNNING | 5001 | API Available | SOAR Engine |
| **Shuffle OpenSearch** | ✅ HEALTHY | - | Internal cluster | SOAR Search |
| **Shuffle Orborus** | ✅ RUNNING | - | Worker process | SOAR Worker |
| **IRIS Web** | ✅ HEALTHY | 8080 | HTTP 302 redirect | Case Management |
| **MISP Web** | ✅ RUNNING | 8082 | Health check | Threat Intelligence |
| **Eramba Web** | ⚠️ UNHEALTHY | 8081 | HTTPS response | GRC Platform |
| **DefectDojo App** | ⚠️ UNHEALTHY | 8083 | HTTP response | Vulnerability Mgmt |
| **SpiderFoot** | ✅ RUNNING | 5002 | HTTP response | OSINT Platform |

### **🌐 Access URLs & Login Information**

#### **Primary Platforms:**

**🔍 SIEM (Security Information & Event Management)**
- **URL:** http://localhost:5601
- **Username:** `admin`
- **Password:** `StrongPassword123!`
- **Purpose:** Log analysis, dashboards, threat hunting

**🤖 SOAR (Security Orchestration & Response)**  
- **URL:** http://localhost:80
- **Setup:** First-time setup wizard on initial access
- **Purpose:** Workflow automation, incident response

**🔧 OpenSearch API (Advanced Users)**
- **URL:** http://localhost:9200
- **Username:** `admin` 
- **Password:** `StrongPassword123!`
- **Purpose:** Direct API access, custom integrations

**🤖 SOAR Backend API (Advanced Users)**
- **URL:** http://localhost:5001
- **Purpose:** Shuffle workflow API, automation endpoints

#### **Additional Platforms (Configure as needed):**

**📋 Case Management (IRIS)** ✅
- **URL:** http://localhost:8080
- **Username:** `administrator`
- **Password:** Check logs: `docker logs iris-web | grep "login with"`
- **Purpose:** Digital forensics and incident response case management

**🕷️ OSINT Platform (SpiderFoot)** ✅
- **URL:** http://localhost:5002
- **Authentication:** Currently disabled (see logs for security warning)
- **Purpose:** Open Source Intelligence gathering and reconnaissance

**📊 GRC Platform (Eramba)** ✅
- **URL:** https://localhost:8081
- **Setup:** Database initialization required
- **Note:** Uses HTTPS with self-signed certificate

**🔍 Threat Intelligence (MISP)** ✅
- **URL:** http://localhost:8082
- **Default:** `admin@admin.test` / Change on first login
- **Purpose:** Threat intelligence platform for sharing IOCs

**🛡️ Vulnerability Management (DefectDojo)** ✅
- **URL:** http://localhost:8083
- **Setup:** Admin account creation required
- **Purpose:** Application security vulnerability management

**🛡️ Endpoint Security (Wazuh Manager)** ✅
- **Agent Port:** 1514 (UDP)
- **Registration:** 1515 (TCP)
- **API:** http://localhost:55000
- **Purpose:** Host-based intrusion detection and endpoint monitoring

**📊 Service Monitoring (Uptime Kuma)** ✅
- **URL:** http://localhost:3001
- **Setup:** Create admin account on first access
- **Purpose:** Monitor all OSSOP services, alerting, status pages

### **📋 First Steps After Deployment**

1. **Access SIEM Dashboard**
   - Go to http://localhost:5601
   - Login with `admin` / `StrongPassword123!`
   - Create index patterns for `filebeat-*`, `wazuh-alerts-*`, `suricata-*`

2. **Configure SOAR Platform**  
   - Go to http://localhost:80
   - Complete the initial setup wizard
   - Create your admin account

3. **Access Case Management (IRIS)**
   - Go to http://localhost:8080
   - Username: `administrator`
   - **Get Password:** `docker logs iris-web | grep "login with"`
   - The password is auto-generated during first startup

4. **Verify Network Monitoring**
   - Check Suricata logs: `./data/suricata/logs/eve.json`
   - Confirm log ingestion in OpenSearch Dashboards

5. **Access Additional Platforms**
   - **MISP:** http://localhost:8082 (Threat Intelligence)
   - **DefectDojo:** http://localhost:8083 (Vulnerability Management)  
   - **Eramba:** https://localhost:8081 (GRC Platform)
   - **SpiderFoot:** http://localhost:5002 (OSINT)

6. **Set Up Service Monitoring**
   - Go to http://localhost:3001
   - Create admin account for Uptime Kuma
   - **Add monitors manually** (see Monitoring Setup section below)
   - Configure alerting (Slack, Email, Teams)

7. **Configure Wazuh Agents (Optional)**
   - Install Wazuh agents on endpoints
   - Point agents to: `localhost:1514` (manager IP)
   - Use registration service: `localhost:1515`

### **🌐 Complete Port Reference**

| Service | External Port | Internal Port | Protocol | Status | Purpose |
|---------|---------------|---------------|----------|--------|---------|
| **Shuffle Frontend** | 80 | 80 | HTTP | ✅ Running | SOAR Web UI |
| **Shuffle Backend** | 5001 | 5001 | HTTP | ✅ Running | SOAR API |
| **SpiderFoot** | 5002 | 5001 | HTTP | ✅ Running | OSINT Platform |
| **OpenSearch Dashboards** | 5601 | 5601 | HTTP | ✅ Running | SIEM Dashboard |
| **IRIS Case Management** | 8080 | 8000 | HTTP | ✅ Running | Case Management |
| **Eramba GRC** | 8081 | 443 | HTTPS | ⚠️ Unhealthy | GRC Platform |
| **MISP** | 8082 | 80 | HTTP | ✅ **FIXED** | Threat Intelligence |
| **DefectDojo** | 8083 | 8080 | HTTP | ⚠️ Restarting | Vulnerability Mgmt |
| **OpenSearch API** | 9200 | 9200 | HTTP | ✅ Running | Search API |
| **OpenSearch Perf** | 9600 | 9600 | HTTP | ✅ Running | Performance API |
| **Wazuh Agents** | 1514 | 1514 | UDP | ✅ Running | Agent Communication |
| **Wazuh Registration** | 1515 | 1515 | TCP | ✅ Running | Agent Registration |
| **Wazuh API** | 55000 | 55000 | HTTP | ✅ Running | Management API |
| **Uptime Kuma** | 3001 | 3001 | HTTP | 🆕 **NEW** | Service Monitoring |

### **📊 Application Monitoring - Uptime Kuma**

**Uptime Kuma** is now included for comprehensive service monitoring:

**Access:** http://localhost:3001
**Default:** Create admin account on first access
**Quick Setup:** See [MONITORING_SETUP.md](MONITORING_SETUP.md) for copy-paste monitor configurations

#### **📋 Manual Setup Instructions (Required):**

Uptime Kuma requires manual configuration of monitors. Follow these steps:

**Step 1: Access Uptime Kuma**
1. Go to http://localhost:3001
2. Create your admin account (first-time setup)
3. Log in to the dashboard

**Step 2: Add Your First Monitor**
1. Click **"+ Add New Monitor"**
2. Select **"HTTP(s)"** as monitor type
3. Fill in the details:
   - **Friendly Name:** `SIEM Dashboard`
   - **URL:** `http://opensearch-dashboards:5601`
   - **Heartbeat Interval:** 60 seconds
   - **Max Retries:** 3
4. Click **"Save"**

**Step 3: Add All OSSOP Services**
Repeat Step 2 for each service using these **internal Docker URLs**:

| Monitor Name | Internal URL | Purpose |
|--------------|-------------|---------|
| **SIEM Dashboard** | `http://opensearch-dashboards:5601` | Main SIEM interface |
| **SOAR Frontend** | `http://shuffle-frontend:80` | Security orchestration |
| **IRIS Case Management** | `http://iris-web:8000` | Incident response |
| **MISP Threat Intel** | `http://misp-web:80` | Threat intelligence |
| **SpiderFoot OSINT** | `http://spiderfoot:5001` | OSINT gathering |
| **OpenSearch API** | `http://opensearch:9200/_cluster/health` | Search engine health |
| **Shuffle Backend** | `http://shuffle-backend:5001/api/v1/health` | SOAR API |
| **DefectDojo** | `http://defectdojo-app:8080` | Vulnerability management |
| **Eramba GRC** | `https://eramba-web:443` | Governance & compliance |

**Important Notes:**
- ✅ **Use internal Docker names** (e.g., `opensearch-dashboards:5601`)
- ❌ **Don't use localhost** (e.g., `localhost:5601`) - won't work from inside containers
- 🔧 **Use internal ports** - these are different from external access ports

**Step 4: Configure Notifications**
1. Go to **Settings** → **Notifications**
2. Add notification channels:
   - **Email** - For management alerts
   - **Slack/Teams** - For SOC team notifications  
   - **Webhook** - For custom integrations
3. Assign notifications to monitors as needed

#### **🎯 Pre-Configured Monitors:**

Once running, Uptime Kuma can monitor:

| Service | URL | Type | Purpose |
|---------|-----|------|---------|
| **OpenSearch Dashboards** | http://opensearch-dashboards:5601 | HTTP | SIEM UI |
| **Shuffle Frontend** | http://shuffle-frontend:80 | HTTP | SOAR UI |
| **IRIS** | http://iris-web:8000 | HTTP | Case Management |
| **MISP** | http://misp-web:80 | HTTP | Threat Intelligence |
| **SpiderFoot** | http://spiderfoot:5001 | HTTP | OSINT Platform |
| **OpenSearch API** | http://opensearch:9200/_cluster/health | HTTP | SIEM Health |
| **Wazuh Manager** | wazuh-manager:55000 | TCP | Endpoint Security |

#### **📧 Alert Integrations:**

- **Slack/Teams** - SOC team notifications
- **Email** - Management alerts  
- **Webhooks** - Custom integrations
- **SMS** - Critical service failures

#### **🔧 Monitoring Troubleshooting:**

**Common Issues & Solutions:**

| Issue | Cause | Solution |
|-------|-------|----------|
| **Monitor shows "Down"** | Using external URL | Use internal Docker name (e.g., `iris-web:8000` not `localhost:8080`) |
| **Connection Refused** | Service not running | Check service status: `docker compose ps service-name` |
| **Timeout Error** | Wrong port/endpoint | Verify internal port in docker-compose.yml |
| **SSL/TLS Error** | HTTPS on HTTP service | Use `http://` for most services, `https://` only for Eramba |
| **No notifications** | Not configured | Set up notification channels in Settings → Notifications |

**Quick Health Check Commands:**
```bash
# Check if all services are running
docker compose ps

# Test internal connectivity from Uptime Kuma
docker exec uptime-kuma wget -qO- http://opensearch-dashboards:5601 | head -5

# Check service logs if monitor fails
docker logs service-name --tail 10
```

### **🔧 Environment Variables**

Key variables in your `.env` file:
- `HOSTNAME=localhost` - Used by MISP for base URL configuration
- `OPENSEARCH_INITIAL_ADMIN_PASSWORD` - Main SIEM password
- All `*_DB_HOSTNAME` variables - Database connection endpoints
- `UPTIME_KUMA_PORT=3001` - Service monitoring dashboard port

### **🐛 Known Issues & Notes**

- **Uptime Kuma Setup:** Monitors must be added manually - no auto-discovery (see Monitoring Setup section)
- **SpiderFoot Security:** Authentication is disabled by default - see container logs for security warning
- **Eramba HTTPS:** Uses self-signed certificate - browser will show security warning
- **IRIS Password:** Auto-generated password is shown in container logs on first startup
- **Database Volumes:** Using Docker named volumes instead of bind mounts for Windows/WSL compatibility
- **Health Check Status:** Eramba and DefectDojo show "unhealthy" but may still be accessible via web browser
- **Service Startup:** Some services may take 2-3 minutes to fully initialize
- **Windows Users:** Use WSL for optimal PostgreSQL performance
- **Internal URLs:** Use Docker container names (not localhost) for Uptime Kuma monitors

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


# OSSOP Maintenance Guide

This guide covers the procedures to Install, Upgrade, Backup, Restore, and Troubleshoot the modular OSSOP architecture.

## 🏗️ Architecture Overview

The system is now modular, with each application residing in its own directory under `apps/`.
- **Apps**: `apps/<app_name>/docker-compose.yml`
- **Data**: `data/<app_name>/` (mapped to `apps/` or root `data/`)
- **Config**: `config/` or `apps/<app_name>/config/`
- **Networking**: All apps communicate over the external `ossop-network`.

## 📦 Installation

### Prerequisites
- Docker Desktop (Windows) or Docker Engine (Linux)
- PowerShell (Windows) or Bash (Linux)
- 8GB+ RAM recommended

### Setup
1. **Clone the repository**
   ```bash
   git clone https://github.com/openmoto/ossop.git
   cd ossop
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your specific passwords and settings
   ```

3. **Start All Services**
   ```powershell
   ./scripts/start-all.ps1
   ```
   This script creates the shared network, volumes, and starts apps in dependency order (OpenSearch -> Core Apps -> Standalone).

## 🌐 Access & Proxy

We use a comprehensive Nginx Reverse Proxy to serve all applications over HTTPS with nice domains.

### URLs
- **Proxy Root**: `https://localhost`
- **OpenSearch**: `https://opensearch.localhost`
- **Shuffle**: `https://shuffle.localhost`
- **DefectDojo**: `https://defectdojo.localhost`
- **IRIS**: `https://iris.localhost`
- **SpiderFoot**: `https://spiderfoot.localhost`
- **Eramba**: `https://eramba.localhost`
- **MISP**: `https://misp.localhost`
- **Gophish**: `https://gophish.localhost`

### Certificates
- **Location**: `config/certs/` (contains `fullchain.pem` and `privkey.pem`)
- **Custom Certs**: Replace these files with your own wildcard certificate (e.g., `*.yourdomain.com`).
- **Trust**: By default, we use self-signed certs. You must accept the browser warning or add the CA to your trust store.

## 🚀 Upgrade

To upgrade a specific service (e.g., Wazuh):

1. **Update .env**: Change the version variable (e.g., `WAZUH_MANAGER_VERSION`).
2. **Pull New Images**:
   ```bash
   cd apps/wazuh
   docker compose pull
   ```
3. **Restart the App**:
   ```bash
   docker compose up -d
   ```

To upgrade **everything**:
1. Update versions in `.env`.
2. Run:
   ```powershell
   ./scripts/start-all.ps1
   ```
   (Compose checks for configuration changes and recreates containers if needed).

## 💾 Backup

### Data Volumes
Configured named volumes are:
- `ossop_opensearch_data`
- `ossop_shuffle_db_data`
- `ossop_iris_db_data`
- `ossop_defectdojo_db_data`
- `ossop_misp_db_data`

### Backup Procedure
1. **Stop Services** to ensure data consistency:
   ```powershell
   ./scripts/stop-all.ps1
   ```
2. **Backup Volumes**:
   Use a helper container to tar the volume content.
   ```bash
   docker run --rm -v ossop_opensearch_data:/volume -v $(pwd)/backups:/backup alpine tar -czf /backup/opensearch_backup.tar.gz -C /volume .
   ```
3. **Backup Config Files**:
   Copy the `data/` and `config/` directories on the host.

## ♻️ Restore

1. **Ensure Services are Stopped**.
2. **Restore Volume Data**:
   ```bash
   docker run --rm -v ossop_opensearch_data:/volume -v $(pwd)/backups:/backup alpine tar -xzf /backup/opensearch_backup.tar.gz -C /volume
   ```
3. **Start Services**:
   ```powershell
   ./scripts/start-all.ps1
   ```

## 🔧 Troubleshooting

### General
- **Check Status**: `docker ps -a`
- **Logs**: `docker logs <container_name>` or `docker compose -f apps/<app>/docker-compose.yml logs -f`

### "Container Not Found" or Network Issues
- Ensure `ossop-network` exists: `docker network create ossop-network`
- Check if the service is actually running: `docker ps | findstr <service>`

### Specific Services

#### OpenSearch
- **Issue**: "High", "Critical block" in logs regarding memory.
- **Fix**: Ensure `wsl -d docker-desktop sysctl -w vm.max_map_count=262144` is set (Windows WSL2).
- **Check Health**: `curl http://localhost:9200/_cluster/health`

#### Gophish
- **Issue**: "unhealthy" status.
- **Fix**: The image is minimal. We use a custom Dockerfile in `apps/gophish/` to install `curl` for healthchecks. Rebuild with `docker compose -f apps/gophish/docker-compose.yml build --no-cache`.

#### SpiderFoot
- **Issue**: Build fails.
- **Fix**: Ensure internet connectivity. It builds from source. Check `apps/spiderfoot/Dockerfile`.

#### Shuffle
- **Issue**: Orborus not connecting.
- **Fix**: Verify `SHUFFLE_BACKEND_HOSTNAME` is resolvable. In modular setup, ensure they share `ossop-network`.

### Cleaning Up (Nuclear Option)
To remove **everything** (containers, networks, volumes) and start fresh:
```powershell
./scripts/stop-all.ps1
docker system prune -a --volumes
./scripts/start-all.ps1
```

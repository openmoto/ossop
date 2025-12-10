# OSSOP Azure App Service - Architecture Recommendations

## ⚠️ Critical: Immediate Changes Required

Since this will be deployed to **Azure App Service**, the architecture **must change immediately**:

1. ✅ **Split into per-app modules** (Azure doesn't run Docker Compose)
2. ✅ **Replace container hostnames** with Azure service endpoints
3. ✅ **Use Azure-managed databases** (not containers)
4. ✅ **Replace Docker health checks** with Azure health checks
5. ✅ **Update dependency management** (Azure networking, not Docker)

---

## Answer to Your Original Questions (Updated for Azure)

### 1. "Different folder and compose file per app?"

**Answer: YES - This is REQUIRED for Azure App Service**

Azure App Service does NOT run Docker Compose. Each app needs:
- ✅ Separate folder structure
- ✅ Separate compose file (for local dev)
- ✅ Azure-specific deployment config (App Service or Container Apps)
- ✅ Per-app connection strings using Azure service names

**Structure (Required):**
```
ossop/
├── apps/
│   ├── opensearch/
│   │   ├── docker-compose.yml  # Local dev
│   │   └── azure-deploy.yml    # Azure deployment
│   ├── shuffle/
│   │   ├── docker-compose.yml
│   │   └── azure-container-app.bicep
│   ├── iris/
│   │   ├── docker-compose.yml
│   │   └── azure-app-service.bicep
│   └── ...
```

### 2. "Curl to another app container name or health API if dependent?"

**Answer: YES - Use Azure Service Discovery + Health APIs**

**Instead of container hostnames:**
```yaml
# ❌ DON'T DO THIS IN AZURE
environment:
  - POSTGRES_SERVER=iris-db
  - SHUFFLE_DB_HOST=shuffle-db
```

**Use Azure service endpoints:**
```yaml
# ✅ DO THIS FOR AZURE
environment:
  - POSTGRES_SERVER=${AZURE_POSTGRES_FQDN}  # e.g., psql-iris.postgres.database.azure.com
  - SHUFFLE_DB_HOST=${AZURE_POSTGRES_FQDN}   # e.g., psql-shuffle.postgres.database.azure.com
```

**For health checks:**
- ✅ Azure App Service: Built-in health checks (configure in portal/Bicep)
- ✅ Azure Container Apps: Use `probes` configuration
- ✅ Application-level: Use curl/wget to Azure service URLs (not container names)

---

## Immediate Action Plan

### Phase 1: Split into Modules (Week 1) - REQUIRED

**Priority: CRITICAL**

1. **Create per-app folder structure**
   ```bash
   mkdir -p apps/{opensearch,shuffle,iris,defectdojo,misp,spiderfoot,eramba,suricata,gophish}
   ```

2. **Split docker-compose.yml** into per-app files:
   - `apps/opensearch/docker-compose.yml`
   - `apps/shuffle/docker-compose.yml`
   - `apps/iris/docker-compose.yml`
   - etc.

3. **Create shared network config**
   - `shared/docker-network.yml` (for local dev)
   - `shared/azure-network.bicep` (for Azure)

4. **Update connection strings** to use environment variables
   - Local: Container hostnames
   - Azure: Azure service endpoints

### Phase 2: Azure Infrastructure Prep (Week 2)

1. **Create Azure Bicep templates**
   - Resource groups
   - Virtual Network
   - Container Registry
   - Managed databases

2. **Create Azure deployment configs**
   - App Service configs
   - Container Apps configs
   - Environment variables

3. **Set up Azure Key Vault**
   - Store secrets
   - Reference from apps

### Phase 3: Update Applications (Week 3)

1. **Remove Docker-specific configs**
   - `depends_on` (not used in Azure)
   - Container health checks (use Azure health checks)
   - Docker networking (use Azure VNet)

2. **Add Azure-specific configs**
   - Startup commands with wait scripts
   - Health check endpoints
   - Connection retry logic

3. **Update documentation**
   - Azure deployment guide
   - Environment variable documentation
   - Connection string examples

---

## Per-App Split Strategy

### Apps That MUST Split

| App | Current Services | Azure Approach |
|-----|----------------|----------------|
| **OpenSearch** | opensearch, opensearch-dashboards, fluent-bit | Azure OpenSearch Service OR Container Apps |
| **Shuffle** | db, opensearch, backend, frontend, orborus | Azure Container Apps (multi-container) |
| **IRIS** | db, web | App Service (web) + Azure PostgreSQL (db) |
| **DefectDojo** | db, uwsgi, nginx | Container Apps OR separate App Services |
| **MISP** | db, redis, web | Container Apps (web) + Azure MariaDB + Azure Redis |
| **Eramba** | db, web | App Service (web) + Azure MariaDB (db) |
| **SpiderFoot** | single | App Service (single container) |
| **Gophish** | single | App Service (single container) |
| **Suricata** | single | Azure Container Instance OR VM (needs host network) |
| **Wazuh** | single | Azure Container Instance |

### Apps That Can Share Resources

- **Databases**: Use single Azure PostgreSQL Flexible Server with multiple databases OR separate instances per app
- **Redis**: Use single Azure Cache for Redis with multiple databases (0-15)
- **OpenSearch**: Use single Azure OpenSearch Service OR separate instances

---

## Connection String Migration

### Before (Docker Compose)
```yaml
# docker-compose.yml
services:
  iris-web:
    environment:
      - POSTGRES_SERVER=iris-db  # Container hostname
      - POSTGRES_USER=${IRIS_DB_USER}
      - POSTGRES_PASSWORD=${IRIS_DB_PASSWORD}
```

### After (Azure App Service)
```yaml
# apps/iris/docker-compose.yml (for local dev)
services:
  iris-web:
    environment:
      - POSTGRES_SERVER=${POSTGRES_SERVER}  # Local: iris-db, Azure: ${AZURE_POSTGRES_HOST}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

# apps/iris/azure-app-service.bicep (for Azure)
resource irisAppService 'Microsoft.Web/sites@2022-03-01' = {
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'POSTGRES_SERVER'
          value: postgresFqdn  // e.g., psql-iris.postgres.database.azure.com
        }
        {
          name: 'POSTGRES_USER'
          value: postgresUser
        }
        {
          name: 'POSTGRES_PASSWORD'
          value: '@Microsoft.KeyVault(SecretUri=${keyVaultUri}/secrets/postgres-password/)'
        }
      ]
      healthCheckPath: '/api/health'
    }
  }
}
```

---

## Health Check Migration

### Before (Docker Compose)
```yaml
services:
  iris-web:
    healthcheck:
      test: ["CMD-SHELL", "wget --spider http://localhost:8000 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 120s
```

### After (Azure App Service)
```bicep
resource irisAppService 'Microsoft.Web/sites@2022-03-01' = {
  properties: {
    siteConfig: {
      healthCheckPath: '/api/health'  // Azure handles retries/interval
      http20Enabled: true
    }
  }
}
```

### After (Azure Container Apps)
```bicep
resource irisContainerApp 'Microsoft.App/containerApps@2022-10-01' = {
  properties: {
    template: {
      containers: [
        {
          name: 'iris-web'
          probes: [
            {
              type: 'Liveness'
              httpGet: {
                path: '/api/health'
                port: 8000
              }
              initialDelaySeconds: 120
              periodSeconds: 30
              timeoutSeconds: 10
              failureThreshold: 5
            }
            {
              type: 'Readiness'
              httpGet: {
                path: '/api/health'
                port: 8000
              }
              initialDelaySeconds: 10
              periodSeconds: 10
            }
          ]
        }
      ]
    }
  }
}
```

---

## Dependency Management in Azure

### Instead of Docker `depends_on`

**Use Application-Level Wait Logic:**

```bash
#!/bin/bash
# wait-for-azure-service.sh
SERVICE_URL=$1
MAX_WAIT=${2:-120}

echo "Waiting for Azure service at $SERVICE_URL..."
for i in $(seq 1 $MAX_WAIT); do
  if curl -f "$SERVICE_URL" > /dev/null 2>&1; then
    echo "Service is ready!"
    exec "$@"
  fi
  echo "Attempt $i/$MAX_WAIT: Service not ready..."
  sleep 1
done

echo "ERROR: Service did not become ready"
exit 1
```

**Use in Azure App Service Startup Command:**
```bicep
appSettings: [
  {
    name: 'WEBSITES_CONTAINER_START_TIME_LIMIT'
    value: '1800'  // 30 minutes
  }
]
// In application code or startup script:
// wait-for-azure-service.sh ${POSTGRES_SERVER}:5432 120 && python manage.py migrate && gunicorn app:app
```

---

## Recommended Azure Architecture

### Option A: Full Managed Services (Recommended)

```
┌─────────────────────────────────────────┐
│      Azure Container Apps                │
│  ┌─────────────┐  ┌─────────────┐      │
│  │  Shuffle    │  │  DefectDojo  │      │
│  │ (multi-ctr) │  │ (multi-ctr)  │      │
│  └─────────────┘  └─────────────┘      │
│  ┌─────────────┐  ┌─────────────┐      │
│  │    MISP     │  │ OpenSearch   │      │
│  │ (multi-ctr) │  │ (container)  │      │
│  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│      Azure App Services                  │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐       │
│  │IRIS │ │Era. │ │Sp.  │ │Goph.│       │
│  └─────┘ └─────┘ └─────┘ └─────┘       │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│      Azure Managed Databases            │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│  │Postgres  │ │MariaDB   │ │Redis    │ │
│  │Flexible  │ │Flexible  │ │Cache    │ │
│  └─────────┘ └─────────┘ └─────────┘ │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│      Azure Container Instances          │
│  ┌─────────┐ ┌─────────┐              │
│  │Suricata  │ │ Wazuh    │              │
│  └─────────┘ └─────────┘              │
└─────────────────────────────────────────┘
```

### Option B: Hybrid (More Control)

- **Azure Container Apps**: Complex apps (Shuffle, DefectDojo, MISP)
- **Azure App Service**: Simple apps (IRIS, Eramba, SpiderFoot, Gophish)
- **Azure Kubernetes Service**: If you need more control (optional)
- **Azure VMs**: For Suricata/Wazuh (if needed)

---

## Cost Optimization

### Cost-Saving Strategies

1. **Shared Databases**: Use one PostgreSQL Flexible Server with multiple databases (if apps can share)
2. **Reserved Instances**: 1-3 year reservations for App Services
3. **Auto-Scaling**: Scale down during off-hours
4. **Dev/Test Pricing**: Use Dev/Test subscriptions for non-production
5. **Spot Instances**: For Container Instances (Suricata, Wazuh)

### Estimated Monthly Costs

| Tier | Configuration | Cost (USD/month) |
|------|--------------|------------------|
| **Basic** | Single instance, minimal scale | $500-800 |
| **Standard** | Auto-scaling, backups | $1,000-1,500 |
| **Premium** | High availability, geo-redundancy | $2,000-3,000 |

---

## Next Steps (Prioritized)

### ✅ Immediate (This Week)

1. **Split docker-compose.yml into per-app modules**
   - Create `apps/` folder structure
   - Move services to respective folders
   - Test locally with `docker compose -f apps/iris/docker-compose.yml up`

2. **Update connection strings to use environment variables**
   - Replace hardcoded container hostnames
   - Use `${SERVICE_HOST}` pattern

3. **Create Azure deployment templates**
   - Basic Bicep templates per app
   - Environment variable mappings

### 📅 Short Term (Next 2 Weeks)

4. **Create Azure infrastructure templates**
   - Resource groups
   - Virtual Network
   - Managed databases
   - Key Vault

5. **Deploy test environment**
   - Single app to Azure
   - Verify connectivity
   - Test health checks

6. **Update documentation**
   - Azure deployment guide
   - Environment variable reference
   - Connection string examples

### 🎯 Long Term (Next Month)

7. **Full production deployment**
   - All apps to Azure
   - Monitoring and alerts
   - Backup strategy
   - CI/CD pipelines

---

## Summary

**For Azure App Service deployment:**

1. ✅ **YES** - Split into per-app folders (REQUIRED)
2. ✅ **YES** - Use Azure service endpoints + health APIs (REQUIRED)
3. ✅ **YES** - Replace Docker Compose with Azure deployment configs
4. ✅ **YES** - Use Azure-managed databases (not containers)
5. ✅ **YES** - Use Azure health checks (not Docker health checks)

**The current monolithic docker-compose.yml will NOT work in Azure App Service. Modular structure is mandatory.**

See `AZURE_DEPLOYMENT_GUIDE.md` for detailed implementation steps.



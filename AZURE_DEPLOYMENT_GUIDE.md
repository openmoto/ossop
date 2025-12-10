# OSSOP Azure App Service Deployment Guide

## Critical Changes Required for Azure App Service

**⚠️ Important**: Azure App Service **does not run Docker Compose**. You need to:
1. **Split into modular structure** (per-app compose files)
2. **Use Azure Container Apps** OR deploy each app as separate App Services
3. **Replace Docker networking** with Azure networking (VNet, Private Endpoints)
4. **Replace Docker health checks** with Azure health checks
5. **Use Azure-managed databases** (Azure Database for PostgreSQL, Redis Cache)
6. **Update connection strings** to use Azure service names, not container hostnames

---

## Architecture Changes for Azure

### Current (Docker Compose)
```
Single docker-compose.yml
├── All services in one file
├── Docker bridge network
├── Container hostname resolution
└── Docker health checks
```

### Azure App Service (Required)
```
apps/
├── opensearch/docker-compose.yml (Azure Container Apps)
├── shuffle/docker-compose.yml (Azure Container Apps)
├── iris/docker-compose.yml (Azure App Service)
├── defectdojo/docker-compose.yml (Azure App Service)
├── misp/docker-compose.yml (Azure Container Apps)
└── ...

Azure Services:
├── Azure Database for PostgreSQL (shared or per-app)
├── Azure Cache for Redis
├── Azure Container Registry
├── Virtual Network
└── Private Endpoints
```

---

## Azure Deployment Options

### Option 1: Azure Container Apps (Recommended for Complex Apps)

**Best for**: Multi-container applications (Shuffle, DefectDojo, MISP)

**Why**: 
- Supports multi-container deployments
- Built-in service discovery
- Auto-scaling
- Health checks built-in
- Internal networking

**Example: Shuffle Stack**
```yaml
# apps/shuffle/docker-compose.yml (for Container Apps)
version: '3.8'
services:
  shuffle-backend:
    image: ghcr.io/shuffle/shuffle-backend:latest
    environment:
      - SHUFFLE_DB_HOST=${AZURE_POSTGRES_HOST}  # Azure DB hostname
      - SHUFFLE_OPENSEARCH_URL=${AZURE_OPENSEARCH_URL}
    # Health checks handled by Azure
    
  shuffle-frontend:
    image: ghcr.io/shuffle/shuffle-frontend:latest
    depends_on:
      - shuffle-backend
```

### Option 2: Azure App Service (Single Container)

**Best for**: Simple apps (SpiderFoot, Gophish, IRIS, Eramba)

**Why**:
- Simpler deployment
- Each app = one App Service
- One container per service
- Built-in HTTPS, scaling, monitoring

**Example: IRIS**
```yaml
# apps/iris/docker-compose.yml (for App Service)
version: '3.8'
services:
  iris-web:
    image: ghcr.io/dfir-iris/iriswebapp_app:latest
    environment:
      - POSTGRES_SERVER=${AZURE_POSTGRES_HOST}  # Azure DB, not container name
      - POSTGRES_USER=${AZURE_POSTGRES_USER}
      - POSTGRES_PASSWORD=${AZURE_POSTGRES_PASSWORD}
```

### Option 3: Hybrid Approach (Recommended)

- **Azure Container Apps**: Complex multi-container apps (Shuffle, DefectDojo, MISP)
- **Azure App Service**: Simple single-container apps (IRIS, SpiderFoot, Gophish, Eramba)
- **Azure Database for PostgreSQL**: All databases (managed service)
- **Azure Cache for Redis**: MISP Redis (managed service)
- **Azure OpenSearch Service**: Main OpenSearch (managed service) OR keep container

---

## Required Changes to Current Architecture

### 1. Split into Modular Structure

**Create folder structure:**
```
ossop/
├── apps/
│   ├── opensearch/
│   │   ├── docker-compose.yml
│   │   ├── azure-deploy.yml  # Azure-specific
│   │   └── README.md
│   ├── shuffle/
│   │   ├── docker-compose.yml
│   │   ├── azure-deploy.yml
│   │   └── README.md
│   ├── iris/
│   │   ├── docker-compose.yml
│   │   ├── Dockerfile (if custom needed)
│   │   ├── azure-deploy.yml
│   │   └── README.md
│   ├── defectdojo/
│   │   ├── docker-compose.yml
│   │   ├── azure-deploy.yml
│   │   └── README.md
│   ├── misp/
│   │   ├── docker-compose.yml
│   │   ├── azure-deploy.yml
│   │   └── README.md
│   ├── spiderfoot/
│   │   ├── docker-compose.yml
│   │   ├── Dockerfile
│   │   └── azure-deploy.yml
│   ├── eramba/
│   │   ├── docker-compose.yml
│   │   └── azure-deploy.yml
│   ├── suricata/
│   │   ├── docker-compose.yml
│   │   └── azure-deploy.yml
│   └── gophish/
│       ├── docker-compose.yml
│       └── azure-deploy.yml
├── infrastructure/
│   ├── azure/
│   │   ├── main.bicep  # Infrastructure as Code
│   │   ├── networking.bicep
│   │   └── databases.bicep
│   └── scripts/
│       ├── deploy-all.sh
│       └── health-check.sh
└── shared/
    ├── .env.example
    └── .env.azure.example
```

### 2. Replace Container Hostnames with Azure Service Names

**Before (Docker Compose):**
```yaml
environment:
  - POSTGRES_SERVER=iris-db
  - SHUFFLE_DB_HOST=shuffle-db
  - SHUFFLE_OPENSEARCH_URL=http://shuffle-opensearch:9200
  - MYSQL_HOST=misp-db
  - REDIS_HOST=misp-redis
```

**After (Azure):**
```yaml
environment:
  - POSTGRES_SERVER=${AZURE_POSTGRES_FQDN}  # e.g., psql-iris.postgres.database.azure.com
  - SHUFFLE_DB_HOST=${AZURE_POSTGRES_FQDN}  # e.g., psql-shuffle.postgres.database.azure.com
  - SHUFFLE_OPENSEARCH_URL=https://opensearch-service.search.windows.net
  - MYSQL_HOST=${AZURE_MYSQL_FQDN}
  - REDIS_HOST=${AZURE_REDIS_HOST}.redis.cache.windows.net
```

### 3. Use Azure-Managed Databases

**Replace local containers with Azure services:**

| Current Container | Azure Service | Configuration |
|-------------------|--------------|---------------|
| `iris-db` (PostgreSQL) | Azure Database for PostgreSQL | Flexible Server |
| `shuffle-db` (PostgreSQL) | Azure Database for PostgreSQL | Flexible Server |
| `defectdojo-db` (PostgreSQL) | Azure Database for PostgreSQL | Flexible Server |
| `misp-db` (MariaDB) | Azure Database for MariaDB | Flexible Server |
| `misp-redis` (Redis) | Azure Cache for Redis | Standard/Premium |
| `eramba-db` (MariaDB) | Azure Database for MariaDB | Flexible Server |
| `opensearch` | Azure OpenSearch Service OR keep container | Managed service |

### 4. Update Health Checks for Azure

**Azure App Service Health Checks:**
```yaml
# In Azure App Service configuration (not docker-compose)
{
  "healthCheckPath": "/api/health",
  "healthCheckInterval": 30
}
```

**Azure Container Apps Health Checks:**
```yaml
# In azure-deploy.yml or bicep
containers:
  - name: shuffle-backend
    image: ghcr.io/shuffle/shuffle-backend:latest
    probes:
      - type: Liveness
        httpGet:
          path: /api/v1/health
          port: 5001
        initialDelaySeconds: 60
        periodSeconds: 30
      - type: Readiness
        httpGet:
          path: /api/v1/health
          port: 5001
        initialDelaySeconds: 10
        periodSeconds: 10
```

**Remove Docker Compose health checks** - Azure handles these.

### 5. Network Configuration

**Create Azure Virtual Network:**
```bash
az network vnet create \
  --resource-group rg-ossop-prod \
  --name vnet-ossop \
  --address-prefix 10.0.0.0/16 \
  --subnet-name subnet-apps \
  --subnet-prefix 10.0.1.0/24
```

**Use Private Endpoints for databases:**
```bash
az network private-endpoint create \
  --resource-group rg-ossop-prod \
  --name pe-postgres-iris \
  --vnet-name vnet-ossop \
  --subnet subnet-apps \
  --private-connection-resource-id /subscriptions/.../psql-iris \
  --group-id postgresqlServer
```

### 6. Dependency Management in Azure

**Instead of Docker `depends_on`, use:**

1. **Application startup logic** (wait scripts)
2. **Azure Container Apps dependencies** (if using Container Apps)
3. **Azure App Service startup commands** (wait for dependencies)
4. **Azure Service Health checks** (monitoring)

**Example: Wait Script for Azure**
```bash
#!/bin/bash
# wait-for-azure-db.sh
DB_HOST=$1
DB_PORT=${2:-5432}
MAX_WAIT=${3:-120}

echo "Waiting for Azure database $DB_HOST:$DB_PORT..."
for i in $(seq 1 $MAX_WAIT); do
  if nc -z "$DB_HOST" "$DB_PORT" 2>/dev/null; then
    echo "Database is ready!"
    exec "$@"
  fi
  echo "Attempt $i/$MAX_WAIT: Database not ready..."
  sleep 1
done

echo "ERROR: Database did not become ready"
exit 1
```

**Use in App Service startup command:**
```bash
# Azure App Service Configuration
STARTUP_COMMAND: "/wait-for-azure-db.sh ${AZURE_POSTGRES_HOST} 5432 120 && python manage.py migrate && gunicorn app:app"
```

---

## Deployment Strategy

### Phase 1: Prepare for Azure (Now)

1. ✅ Split docker-compose.yml into per-app modules
2. ✅ Create Azure-specific configuration files
3. ✅ Update connection strings to use environment variables
4. ✅ Remove Docker-specific networking
5. ✅ Add wait scripts for Azure dependencies
6. ✅ Document Azure service requirements

### Phase 2: Azure Infrastructure Setup

1. Create Azure Resource Group
2. Create Virtual Network
3. Create Azure Container Registry
4. Provision Azure databases (PostgreSQL, MariaDB, Redis)
5. Configure Private Endpoints
6. Set up Azure Key Vault for secrets

### Phase 3: Deploy Applications

1. Build and push images to Azure Container Registry
2. Deploy apps to Azure Container Apps or App Service
3. Configure environment variables
4. Set up health checks
5. Configure networking
6. Test connectivity between services

### Phase 4: Production Hardening

1. Enable HTTPS/TLS
2. Configure authentication/authorization
3. Set up monitoring and alerts
4. Configure backups
5. Set up CI/CD pipelines
6. Document runbooks

---

## Per-App Azure Configuration Examples

### Example 1: IRIS (Simple App - Azure App Service)

**apps/iris/docker-compose.yml** (for local development):
```yaml
version: '3.8'
services:
  iris-web:
    image: ghcr.io/dfir-iris/iriswebapp_app:${IRIS_VERSION}
    ports:
      - "${IRIS_PORT}:8000"
    environment:
      - POSTGRES_SERVER=${POSTGRES_SERVER}  # Local: iris-db, Azure: ${AZURE_POSTGRES_HOST}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
      - IRIS_SECRET_KEY=${IRIS_SECRET_KEY}
    networks:
      - ossop-network
    healthcheck:
      test: ["CMD-SHELL", "wget --spider http://localhost:8000 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
```

**apps/iris/azure-deploy.yml** (Azure App Service):
```yaml
apiVersion: 2021-02-01
type: Microsoft.Web/sites
properties:
  siteConfig:
    linuxFxVersion: "DOCKER|${ACR_NAME}.azurecr.io/iris:latest"
    appSettings:
      - name: POSTGRES_SERVER
        value: "${AZURE_POSTGRES_HOST}"
      - name: POSTGRES_USER
        value: "${AZURE_POSTGRES_USER}"
      - name: POSTGRES_PASSWORD
        value: "@Microsoft.KeyVault(SecretUri=https://kv-ossop.vault.azure.net/secrets/postgres-password/)"
      - name: POSTGRES_DB
        value: "iris"
      - name: WEBSITES_ENABLE_APP_SERVICE_STORAGE
        value: "false"
    healthCheckPath: "/api/health"
    http20Enabled: true
  httpsOnly: true
```

### Example 2: Shuffle (Complex App - Azure Container Apps)

**apps/shuffle/docker-compose.yml** (for local):
```yaml
version: '3.8'
services:
  shuffle-backend:
    image: ghcr.io/shuffle/shuffle-backend:${SHUFFLE_VERSION}
    environment:
      - SHUFFLE_DB_HOST=${SHUFFLE_DB_HOST}  # Local: shuffle-db, Azure: ${AZURE_POSTGRES_HOST}
      - SHUFFLE_OPENSEARCH_URL=${SHUFFLE_OPENSEARCH_URL}  # Local: http://shuffle-opensearch:9200
    depends_on:
      shuffle-db:
        condition: service_healthy
    networks:
      - ossop-network
      
  shuffle-frontend:
    image: ghcr.io/shuffle/shuffle-frontend:${SHUFFLE_VERSION}
    depends_on:
      - shuffle-backend
    networks:
      - ossop-network
```

**apps/shuffle/azure-container-app.bicep** (Azure Container Apps):
```bicep
resource shuffleBackend 'Microsoft.App/containerApps@2022-10-01' = {
  name: 'shuffle-backend'
  location: location
  properties: {
    configuration: {
      ingress: {
        external: false
        targetPort: 5001
      }
    }
    template: {
      containers: [
        {
          name: 'shuffle-backend'
          image: '${acrLoginServer}/shuffle-backend:latest'
          env: [
            {
              name: 'SHUFFLE_DB_HOST'
              value: postgresFqdn
            }
            {
              name: 'SHUFFLE_OPENSEARCH_URL'
              value: opensearchUrl
            }
          ]
          probes: [
            {
              type: 'Liveness'
              httpGet: {
                path: '/api/v1/health'
                port: 5001
              }
              initialDelaySeconds: 60
              periodSeconds: 30
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 10
      }
    }
  }
}
```

---

## Environment Variables Strategy

### Local Development (.env)
```bash
# Local - use container hostnames
IRIS_DB_HOST=iris-db
SHUFFLE_DB_HOST=shuffle-db
SHUFFLE_OPENSEARCH_URL=http://shuffle-opensearch:9200
MISP_DB_HOST=misp-db
MISP_REDIS_HOST=misp-redis
```

### Azure Production (.env.azure)
```bash
# Azure - use Azure service endpoints
IRIS_DB_HOST=psql-iris-${ENV}.postgres.database.azure.com
SHUFFLE_DB_HOST=psql-shuffle-${ENV}.postgres.database.azure.com
SHUFFLE_OPENSEARCH_URL=https://opensearch-${ENV}.search.windows.net
MISP_DB_HOST=mariadb-misp-${ENV}.mariadb.database.azure.com
MISP_REDIS_HOST=redis-misp-${ENV}.redis.cache.windows.net
```

**Use Azure Key Vault for secrets:**
```bash
# Reference secrets from Key Vault
POSTGRES_PASSWORD=@Microsoft.KeyVault(SecretUri=https://kv-ossop.vault.azure.net/secrets/postgres-password/)
REDIS_PASSWORD=@Microsoft.KeyVault(SecretUri=https://kv-ossop.vault.azure.net/secrets/redis-password/)
```

---

## Cost Estimation (Rough)

**Monthly Azure Costs (estimated):**

| Service | Configuration | Monthly Cost (USD) |
|---------|---------------|-------------------|
| Azure Container Apps (Shuffle) | 2 containers, 0.5 CPU, 1GB RAM each | $30-50 |
| Azure App Service (IRIS, DefectDojo, etc.) | Basic plan, 5 apps | $100-150 |
| Azure Database for PostgreSQL | 3 instances, Standard tier | $300-500 |
| Azure Database for MariaDB | 2 instances, Standard tier | $200-300 |
| Azure Cache for Redis | Standard C1 | $100-150 |
| Azure OpenSearch Service | Basic tier | $300-500 |
| Storage & Networking | Standard | $50-100 |
| **Total** | | **$1,080 - $1,750/month** |

---

## Next Steps

1. **Immediate**: Split docker-compose.yml into per-app modules
2. **Week 1**: Create Azure infrastructure templates (Bicep/Terraform)
3. **Week 2**: Update all connection strings to use environment variables
4. **Week 3**: Deploy test environment to Azure
5. **Week 4**: Production deployment

---

## References

- [Azure App Service Documentation](https://docs.microsoft.com/azure/app-service/)
- [Azure Container Apps Documentation](https://docs.microsoft.com/azure/container-apps/)
- [Azure Database for PostgreSQL](https://docs.microsoft.com/azure/postgresql/)
- [Azure Private Endpoints](https://docs.microsoft.com/azure/private-link/private-endpoint-overview)



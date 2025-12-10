# OSSOP Architecture Review & Recommendations

## Executive Summary

This document reviews the current OSSOP architecture and provides recommendations for improving service organization, dependency management, and health checks.

**Key Finding:** The current monolithic `docker-compose.yml` (19 services, 568 lines) works well for a "quick start" all-in-one platform, but would benefit from modularization for production use, better dependency management, and improved health checks.

---

## Current Architecture Analysis

### Current Structure

- **Single `docker-compose.yml`** with 19 services
- **Shared network**: `security-stack-net` (bridge)
- **Dependencies**: Mix of `depends_on` with health checks and implicit dependencies via environment variables
- **Health Checks**: Some services have health checks, many are disabled/commented out
- **Services**:
  - OpenSearch stack (2 services + fluent-bit)
  - Wazuh (1 service)
  - Shuffle (5 services: db, opensearch, backend, frontend, orborus)
  - IRIS (2 services: db, web)
  - DefectDojo (2 services: db, uwsgi, nginx)
  - MISP (3 services: db, redis, web)
  - Standalone: SpiderFoot, Eramba (2 services), Suricata, Gophish

### Dependency Map

```
OpenSearch Cluster:
├── opensearch (foundation)
│   ├── opensearch-dashboards (depends on opensearch health)
│   ├── fluent-bit (depends on opensearch health)
│   └── wazuh-manager (depends on opensearch health)

Shuffle Stack:
├── shuffle-db (foundation)
├── shuffle-opensearch (foundation)
├── shuffle-backend (depends on shuffle-db + shuffle-opensearch health)
├── shuffle-frontend (depends on shuffle-backend)
└── shuffle-orborus (depends on shuffle-backend implicitly)

IRIS Stack:
├── iris-db (foundation)
└── iris-web (depends on iris-db health)

DefectDojo Stack:
├── defectdojo-db (foundation)
├── uwsgi (depends on defectdojo-db health + misp-redis)
└── nginx (depends on uwsgi)

MISP Stack:
├── misp-db (foundation)
├── misp-redis (foundation)
└── misp-web (depends on misp-db + misp-redis health)

Standalone Services:
├── spiderfoot (no dependencies)
├── eramba-db → eramba-web
├── suricata (network_mode: host, no dependencies)
└── gophish (no dependencies)
```

---

## Recommendations

### Option 1: Modular Per-App Structure (Recommended for Production)

**Benefits:**
- ✅ Easier to manage individual applications
- ✅ Can start/stop apps independently
- ✅ Clearer dependency boundaries
- ✅ Better for version control (multiple developers)
- ✅ Easier to scale specific apps
- ✅ Clearer documentation per app
- ✅ Less chance of accidental service collisions

**Drawbacks:**
- ❌ More complex initial setup
- ❌ Need to manage multiple compose files
- ❌ Cross-app dependencies require external network discovery
- ❌ Might be overkill for simple deployments

**Structure:**
```
ossop/
├── docker-compose.yml              # Master orchestrator (optional)
├── apps/
│   ├── opensearch/
│   │   ├── docker-compose.yml
│   │   ├── README.md
│   │   └── config/
│   ├── wazuh/
│   │   ├── docker-compose.yml
│   │   └── config/
│   ├── shuffle/
│   │   ├── docker-compose.yml
│   │   └── README.md
│   ├── iris/
│   │   ├── docker-compose.yml
│   │   └── README.md
│   ├── defectdojo/
│   │   ├── docker-compose.yml
│   │   └── README.md
│   ├── misp/
│   │   ├── docker-compose.yml
│   │   └── README.md
│   ├── spiderfoot/
│   │   ├── docker-compose.yml
│   │   └── Dockerfile
│   ├── eramba/
│   │   ├── docker-compose.yml
│   │   └── README.md
│   ├── suricata/
│   │   ├── docker-compose.yml
│   │   └── config/
│   └── gophish/
│       ├── docker-compose.yml
│       └── README.md
├── shared/
│   └── .env.example               # Shared environment variables
└── scripts/
    ├── start-all.sh               # Orchestrate all apps
    └── health-check.sh            # Check cross-app dependencies
```

### Option 2: Hybrid Structure (Recommended for Flexibility)

Keep current single file **BUT** add:
- ✅ Health check wait scripts for dependencies
- ✅ Better dependency management with health APIs
- ✅ Clear service groups in comments
- ✅ Optional split-out for heavy/complex apps (Shuffle, DefectDojo)

**Best of both worlds:**
- Keep simple all-in-one for quick start
- Allow advanced users to run apps independently
- Improve health checks regardless of structure

---

## Health Check Recommendations

### Current Issues

1. **Inconsistent Health Checks**: Many services have disabled health checks
2. **Missing Cross-Service Health Checks**: Services connect via hostname but don't verify target is ready
3. **No Retry Logic in Apps**: Apps try to connect immediately, fail if dependency isn't ready
4. **Localhost vs Container Name**: Health checks use `localhost`, but apps connect via container hostnames

### Recommended Pattern

**Use Container Hostnames for Health Checks When Checking Dependencies:**

```yaml
# Example: shuffle-backend checking shuffle-db
shuffle-backend:
  healthcheck:
    # Internal health (itself)
    test: ["CMD-SHELL", "curl -f http://localhost:5001/api/v1/health || exit 1"]
  # For dependency checking, use wait-for-it or custom script
  entrypoint: ["/wait-for-it.sh", "shuffle-db:5432", "--", "./start.sh"]
```

**Better: Use Health API Endpoints**

Many apps expose health endpoints:
- OpenSearch: `/_cluster/health`
- PostgreSQL: `pg_isready`
- Shuffle: `/api/v1/health` (when enabled)
- IRIS: `/api/health` (if available)
- DefectDojo: Check Django health endpoint

### Implementation Strategy

1. **Add Health Check Scripts**:
   ```bash
   # scripts/wait-for-health.sh
   #!/bin/bash
   SERVICE=$1
   HEALTH_URL=$2
   MAX_WAIT=${3:-60}
   
   echo "Waiting for $SERVICE to be healthy..."
   for i in $(seq 1 $MAX_WAIT); do
     if curl -f "$HEALTH_URL" > /dev/null 2>&1; then
       echo "$SERVICE is healthy"
       exit 0
     fi
     sleep 1
   done
   echo "$SERVICE did not become healthy"
   exit 1
   ```

2. **Use `wait-for-it` or `dockerize` for TCP dependencies**:
   ```yaml
   services:
     shuffle-backend:
       image: ...:wait-for-it
       # or use wait-for-it script
       command: ["wait-for-it.sh", "shuffle-db:5432", "-t", "60", "--", "node", "app.js"]
   ```

3. **Create Health Check Service/Endpoint**:
   ```yaml
   # Optional: Add a health check service
   healthcheck-proxy:
     image: alpine/curl
     entrypoint: ["sh", "-c"]
     command: |
       while true; do
         curl -f http://opensearch:9200/_cluster/health || echo "OpenSearch unhealthy"
         curl -f http://shuffle-backend:5001/api/v1/health || echo "Shuffle unhealthy"
         sleep 30
       done
   ```

---

## Specific Recommendations

### 1. Improve Health Checks

**Priority Services (should have health checks):**
- ✅ opensearch (has)
- ✅ opensearch-dashboards (has)
- ✅ shuffle-db (has)
- ✅ shuffle-opensearch (has)
- ⚠️ shuffle-backend (disabled - enable when possible)
- ⚠️ shuffle-frontend (disabled - add simple HTTP check)
- ✅ iris-db (has)
- ✅ iris-web (has)
- ✅ defectdojo-db (has)
- ⚠️ uwsgi (has - but uses wrong port 8081, should check 3031)
- ❌ nginx (missing)
- ✅ misp-db (has)
- ✅ misp-redis (has)
- ⚠️ misp-web (disabled - enable)
- ✅ spiderfoot (has)
- ✅ eramba-db (has)
- ✅ eramba-web (has)
- ⚠️ fluent-bit (disabled - add)
- ✅ wazuh-manager (has)
- ⚠️ suricata (disabled - add file check)
- ✅ gophish (has)

### 2. Fix Dependency Issues

**Current Problems:**
- `fluent-bit` connects to OpenSearch but no retry logic
- `wazuh-manager` connects via env var but might fail if OpenSearch slow
- `defectdojo` uwsgi uses MISP redis but no dependency declared
- `shuffle-frontend` depends on backend but no health check
- `shuffle-orborus` has no dependencies declared but needs backend

**Fix:**
```yaml
# Add explicit dependencies with health conditions
fluent-bit:
  depends_on:
    opensearch:
      condition: service_healthy
  # Add retry logic in app or use wait script

wazuh-manager:
  depends_on:
    opensearch:
      condition: service_healthy
  # Already has this - good!

uwsgi:
  depends_on:
    defectdojo-db:
      condition: service_healthy
    # Add MISP redis as dependency if it's required
    misp-redis:
      condition: service_healthy  # if needed

shuffle-frontend:
  depends_on:
    shuffle-backend:
      condition: service_started  # or use wait script if health available

shuffle-orborus:
  depends_on:
    shuffle-backend:
      condition: service_started
```

### 3. Use External Networks for Cross-App Communication

If splitting into per-app compose files:

```yaml
# In each app's docker-compose.yml
networks:
  security-stack-net:
    external: true
    name: ossop-security-stack-net

# Create network first:
docker network create ossop-security-stack-net
```

---

## Implementation Plan

### Phase 1: Improve Current Structure (Immediate)

1. ✅ Enable/enhance health checks for all services
2. ✅ Fix incorrect health check endpoints (uwsgi port)
3. ✅ Add missing `depends_on` relationships
4. ✅ Document dependencies clearly
5. ✅ Add wait scripts for services that need retry logic

### Phase 2: Modular Structure (Future)

1. Split into per-app folders (keep master compose as option)
2. Create shared network management
3. Update documentation for modular deployment
4. Create orchestration scripts

---

## Decision Matrix

| Scenario | Recommended Approach |
|----------|---------------------|
| **Quick Start / Learning** | Keep current single compose file |
| **Production Deployment** | Modular per-app structure |
| **Large Team** | Modular with clear ownership |
| **Resource Constrained** | Single file, start only needed services |
| **Scalability Needs** | Modular, can scale apps independently |

---

## Conclusion

**Recommendation: Start with Phase 1 (improve current structure), then evaluate Phase 2 based on needs.**

The current single-file approach is **good for the target audience** (quick start, learning), but would benefit from:
1. ✅ Better health checks and dependency management
2. ✅ Wait scripts for services that need retry logic
3. ✅ Clear documentation of dependencies
4. ⚠️ Consider modular structure if:
   - Team grows
   - Need to deploy apps separately
   - Production use cases emerge
   - Different scaling requirements per app

**For health checks specifically:** Yes, services should use curl/health APIs to check dependencies, but Docker Compose `depends_on: condition: service_healthy` handles most cases. For complex dependencies, use wait scripts or health check containers.


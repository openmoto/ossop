# OSSOP Health Check & Dependency Management Implementation

## Overview

This document shows practical examples of improving health checks and dependency management in OSSOP, addressing the question: "Should we curl other app container names or health APIs if dependent on that app?"

**Answer: Yes, use both approaches strategically:**
1. Docker Compose `depends_on: condition: service_healthy` for same-compose dependencies
2. Health API checks (curl to container hostname) for cross-compose or runtime dependency verification
3. Wait scripts for services that need custom retry logic

---

## Current Issues & Fixes

### Issue 1: Missing Health Checks

**Problem**: Several services have health checks disabled or missing.

**Fix**: Enable/improve health checks:

```yaml
# Current: fluent-bit (disabled)
# Fixed:
fluent-bit:
  healthcheck:
    test: ["CMD-SHELL", "timeout 1 nc -z localhost 2020 || exit 1"]
    interval: 30s
    timeout: 5s
    retries: 3
    start_period: 30s

# Current: shuffle-frontend (disabled)
# Fixed:
shuffle-frontend:
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:80/health || curl -f http://localhost:80 || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 5
    start_period: 60s

# Current: misp-web (disabled)
# Fixed:
misp-web:
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost/users/login -o /dev/null 2>&1 || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 5
    start_period: 180s  # MISP takes longer to start
```

### Issue 2: Incorrect Health Check Endpoints

**Problem**: `uwsgi` health check uses wrong port (8081 vs 3031).

**Fix**:
```yaml
# Current:
uwsgi:
  healthcheck:
    test: ["CMD-SHELL", "python3 -c 'import urllib.request; urllib.request.urlopen(\"http://localhost:8081\")' || exit 1"]

# Fixed:
uwsgi:
  expose:
    - "3031"
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:3031/api/v2/health || python3 -c 'import urllib.request; urllib.request.urlopen(\"http://localhost:3031/api/v2/health\")' || exit 1"]
    # Or check internal socket
    # test: ["CMD-SHELL", "nc -z localhost 3031 || exit 1"]
```

### Issue 3: Missing Dependencies

**Problem**: Services connect to other services but don't declare dependencies.

**Fix**:
```yaml
# Current: shuffle-orborus has no dependencies
# Fixed:
shuffle-orborus:
  depends_on:
    shuffle-backend:
      condition: service_started  # Use started if no health check available
    shuffle-db:
      condition: service_healthy

# Current: shuffle-frontend depends on backend but not health-checked
# Fixed:
shuffle-frontend:
  depends_on:
    shuffle-backend:
      condition: service_started  # Or add health check to backend first

# Current: uwsgi uses MISP redis but no dependency
# Fixed:
uwsgi:
  depends_on:
    defectdojo-db:
      condition: service_healthy
    misp-redis:  # Add if DefectDojo requires Redis from MISP
      condition: service_healthy
```

---

## Cross-Service Health Checks

### Scenario: Checking Health of Services in Different Compose Files

If you split into per-app compose files, services need to check external services:

**Option 1: Use Health Check Container** (Recommended)

```yaml
# apps/shuffle/docker-compose.yml
services:
  healthcheck-opensearch:
    image: curlimages/curl:latest
    entrypoint: ["sh", "-c"]
    command: |
      echo "Waiting for OpenSearch..."
      until curl -f http://opensearch:9200/_cluster/health?wait_for_status=yellow; do
        echo "OpenSearch not ready, waiting..."
        sleep 5
      done
      echo "OpenSearch is healthy!"
    networks:
      - security-stack-net
    restart: "no"

  shuffle-backend:
    depends_on:
      - healthcheck-opensearch  # Wait for external service
    environment:
      - SHUFFLE_OPENSEARCH_URL=http://opensearch:9200
```

**Option 2: Use Wait-for-It Script**

```yaml
# apps/shuffle/docker-compose.yml
services:
  shuffle-backend:
    image: ghcr.io/shuffle/shuffle-backend:${SHUFFLE_VERSION}
    volumes:
      - ./wait-for-it.sh:/wait-for-it.sh
    entrypoint: ["/wait-for-it.sh"]
    command: ["opensearch:9200", "-t", "60", "--", "node", "app.js"]
    environment:
      - SHUFFLE_OPENSEARCH_URL=http://opensearch:9200
```

**Option 3: Health Check with Retry Logic in Entrypoint**

```bash
#!/bin/bash
# wait-for-health.sh
SERVICE=$1
HEALTH_URL=$2
MAX_WAIT=${3:-120}

echo "Waiting for $SERVICE at $HEALTH_URL to be healthy..."
for i in $(seq 1 $MAX_WAIT); do
  if curl -f "$HEALTH_URL" > /dev/null 2>&1; then
    echo "$SERVICE is healthy!"
    exec "$@"
  fi
  echo "Attempt $i/$MAX_WAIT: $SERVICE not ready, waiting..."
  sleep 1
done

echo "ERROR: $SERVICE did not become healthy after $MAX_WAIT seconds"
exit 1
```

Then in compose:
```yaml
services:
  shuffle-backend:
    volumes:
      - ./scripts/wait-for-health.sh:/wait-for-health.sh
    entrypoint: ["/wait-for-health.sh"]
    command: ["OpenSearch", "http://opensearch:9200/_cluster/health?wait_for_status=yellow", "120", "node", "app.js"]
```

---

## Best Practices

### 1. Health Check Patterns

```yaml
# Pattern 1: HTTP Health Endpoint (Best)
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/api/health"]
  interval: 30s
  timeout: 10s
  retries: 5
  start_period: 60s

# Pattern 2: TCP Check (Fallback)
healthcheck:
  test: ["CMD-SHELL", "nc -z localhost 5432 || exit 1"]
  interval: 10s
  timeout: 5s
  retries: 3

# Pattern 3: Application-Specific (Database)
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
  interval: 10s
  timeout: 5s
  retries: 5

# Pattern 4: Process Check (Last Resort)
healthcheck:
  test: ["CMD-SHELL", "pgrep -f 'application' || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 3
```

### 2. Dependency Declaration Patterns

```yaml
# Pattern 1: Same Compose File with Health Check (Preferred)
depends_on:
  database:
    condition: service_healthy

# Pattern 2: Same Compose File, No Health Check
depends_on:
  backend:
    condition: service_started

# Pattern 3: External Service (Different Compose)
depends_on:
  healthcheck-external-service:
    condition: service_completed_successfully

# Pattern 4: Multiple Dependencies
depends_on:
  db:
    condition: service_healthy
  redis:
    condition: service_healthy
  backend:
    condition: service_started
```

### 3. Service Groups

Organize services logically in compose file:

```yaml
# ========================================
# OPENSEARCH STACK
# ========================================
services:
  opensearch:
    # ...

  opensearch-dashboards:
    depends_on:
      opensearch:
        condition: service_healthy
    # ...

# ========================================
# SHUFFLE STACK
# ========================================
services:
  shuffle-db:
    # ...

  shuffle-opensearch:
    # ...

  shuffle-backend:
    depends_on:
      shuffle-db:
        condition: service_healthy
      shuffle-opensearch:
        condition: service_healthy
    # ...
```

---

## Example: Improved Shuffle Stack

```yaml
services:
  # Database Layer
  shuffle-db:
    image: postgres:${POSTGRES_VERSION}
    container_name: ${SHUFFLE_DB_HOSTNAME}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${SHUFFLE_DB_USER} -d ${SHUFFLE_DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - security-stack-net

  # OpenSearch Layer
  shuffle-opensearch:
    image: opensearchproject/opensearch:${SHUFFLE_OPENSEARCH_VERSION}
    container_name: ${SHUFFLE_OPENSEARCH_HOSTNAME}
    healthcheck:
      test: ["CMD-SHELL", "curl -fsS http://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=5s || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 120s
    networks:
      - security-stack-net

  # Health Check for External OpenSearch (if using main OpenSearch)
  healthcheck-opensearch:
    image: curlimages/curl:latest
    entrypoint: ["sh", "-c"]
    command: |
      until curl -fsS http://opensearch:9200/_cluster/health?wait_for_status=yellow; do
        echo "Waiting for main OpenSearch..."
        sleep 5
      done
      echo "Main OpenSearch is ready!"
    networks:
      - security-stack-net
    restart: "no"
    profiles: ["external-opensearch"]  # Only run if using external

  # Application Layer
  shuffle-backend:
    image: ghcr.io/shuffle/shuffle-backend:${SHUFFLE_VERSION}
    container_name: ${SHUFFLE_BACKEND_HOSTNAME}
    depends_on:
      shuffle-db:
        condition: service_healthy
      shuffle-opensearch:
        condition: service_healthy
      # healthcheck-opensearch:  # Uncomment if using external
      #   condition: service_completed_successfully
    environment:
      - SHUFFLE_DB_HOST=${SHUFFLE_DB_HOSTNAME}
      - SHUFFLE_OPENSEARCH_URL=http://${SHUFFLE_OPENSEARCH_HOSTNAME}:9200
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:5001/api/v1/health || curl -f http://localhost:5001 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 120s
    networks:
      - security-stack-net

  shuffle-frontend:
    image: ghcr.io/shuffle/shuffle-frontend:${SHUFFLE_VERSION}
    container_name: ${SHUFFLE_FRONTEND_HOSTNAME}
    depends_on:
      shuffle-backend:
        condition: service_healthy  # Now that backend has health check
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:80 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s
    networks:
      - security-stack-net

  shuffle-orborus:
    image: ghcr.io/shuffle/shuffle-orborus:${SHUFFLE_VERSION}
    container_name: ${SHUFFLE_ORBORUS_HOSTNAME}
    depends_on:
      shuffle-backend:
        condition: service_healthy
      shuffle-db:
        condition: service_healthy
    networks:
      - security-stack-net
```

---

## Implementation Checklist

### Immediate Improvements

- [ ] Enable health check for `fluent-bit`
- [ ] Fix `uwsgi` health check port (8081 → 3031)
- [ ] Add health check for `shuffle-frontend`
- [ ] Add health check for `nginx` (DefectDojo)
- [ ] Enable health check for `misp-web`
- [ ] Add health check for `suricata` (file-based)
- [ ] Add `depends_on` for `shuffle-orborus`
- [ ] Add `depends_on` for `uwsgi` → `misp-redis` (if needed)

### Advanced Improvements

- [ ] Create `wait-for-health.sh` script
- [ ] Add health check containers for external dependencies
- [ ] Document all dependencies in README
- [ ] Add dependency graph visualization
- [ ] Create health monitoring dashboard

### Optional: Modular Structure

- [ ] Split into per-app folders
- [ ] Create shared network script
- [ ] Create orchestration script (`start-all.sh`)
- [ ] Update documentation for modular deployment
- [ ] Add per-app README files

---

## Conclusion

**Answer to your question**: Yes, use curl to container hostnames and health APIs when:
1. Checking services in different compose files
2. Services need runtime dependency verification
3. Complex retry logic is required

Use Docker Compose `depends_on: condition: service_healthy` when:
1. Services are in the same compose file
2. Health checks are simple and reliable
3. Standard retry behavior is sufficient

The key is using both approaches appropriately for your use case.


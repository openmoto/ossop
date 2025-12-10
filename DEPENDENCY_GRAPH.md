# OSSOP Service Dependency Graph

## Visual Dependency Map

```
┌─────────────────────────────────────────────────────────────────┐
│                        OSSOP Platform                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     OPENSEARCH STACK                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  opensearch (foundation)                                       │
│  ├─ health: /_cluster/health                                   │
│  │                                                              │
│  ├─> opensearch-dashboards                                     │
│  │   └─ depends: opensearch (healthy) ✓                        │
│  │   └─ health: /api/status ✓                                 │
│  │                                                              │
│  ├─> fluent-bit                                                │
│  │   └─ depends: opensearch (healthy) ✓                        │
│  │   └─ health: ❌ DISABLED                                    │
│  │                                                              │
│  └─> wazuh-manager                                             │
│      └─ depends: opensearch (healthy) ✓                         │
│      └─ health: wazuh-control status ✓                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                       SHUFFLE STACK                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  shuffle-db (foundation)                                       │
│  ├─ health: pg_isready ✓                                       │
│  │                                                              │
│  shuffle-opensearch (foundation)                                │
│  ├─ health: /_cluster/health ✓                                 │
│  │                                                              │
│  ├─> shuffle-backend                                           │
│  │   └─ depends: shuffle-db (healthy) ✓                        │
│  │   └─ depends: shuffle-opensearch (healthy) ✓                │
│  │   └─ health: ❌ DISABLED                                    │
│  │   └─ env: SHUFFLE_DB_HOST, SHUFFLE_OPENSEARCH_URL           │
│  │                                                              │
│  │   ├─> shuffle-frontend                                      │
│  │   │   └─ depends: shuffle-backend (started) ⚠️              │
│  │   │   └─ health: ❌ DISABLED                                │
│  │   │                                                          │
│  │   └─> shuffle-orborus                                       │
│  │       └─ depends: ❌ MISSING                                 │
│  │                                                              │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        IRIS STACK                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  iris-db (foundation)                                          │
│  ├─ health: pg_isready ✓                                       │
│  │                                                              │
│  └─> iris-web                                                  │
│      └─ depends: iris-db (healthy) ✓                           │
│      └─ health: wget localhost:8000 ✓                          │
│      └─ env: POSTGRES_SERVER=iris-db                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      DEFECTDOJO STACK                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  defectdojo-db (foundation)                                    │
│  ├─ health: pg_isready ✓                                       │
│  │                                                              │
│  ├─> uwsgi                                                     │
│  │   └─ depends: defectdojo-db (healthy) ✓                      │
│  │   └─ health: ❌ WRONG PORT (8081 vs 3031)                    │
│  │   └─ env: DD_DATABASE_URL, DD_CELERY_BROKER_URL=redis://    │
│  │   └─ uses: misp-redis (no dependency declared) ⚠️            │
│  │                                                              │
│  │   └─> nginx                                                 │
│  │       └─ depends: uwsgi (started) ✓                        │
│  │       └─ health: ❌ MISSING                                  │
│  │                                                              │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        MISP STACK                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  misp-db (foundation)                                          │
│  ├─ health: mysqladmin ping ✓                                  │
│  │                                                              │
│  misp-redis (foundation)                                       │
│  ├─ health: redis-cli ping ✓                                   │
│  │                                                              │
│  └─> misp-web                                                  │
│      └─ depends: misp-db (healthy) ✓                           │
│      └─ depends: misp-redis (healthy) ✓                        │
│      └─ health: ❌ DISABLED                                    │
│      └─ env: MYSQL_HOST=misp-db, REDIS_HOST=misp-redis         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     STANDALONE SERVICES                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  spiderfoot                                                     │
│  └─ health: python urllib localhost:5001 ✓                     │
│  └─ dependencies: None                                          │
│                                                                 │
│  eramba-db                                                      │
│  ├─ health: mysqladmin ping ✓                                   │
│  │                                                              │
│  └─> eramba-web                                                │
│      └─ depends: eramba-db (healthy) ✓                         │
│      └─ health: curl localhost:80 ✓                            │
│                                                                 │
│  suricata                                                       │
│  └─ health: ❌ DISABLED                                        │
│  └─ network_mode: host (special case)                           │
│  └─ dependencies: None                                          │
│                                                                 │
│  gophish                                                        │
│  └─ health: wget localhost:3333 ✓                              │
│  └─ dependencies: None                                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

Legend:
  ✓  = Working correctly
  ⚠️  = Needs attention
  ❌ = Missing or incorrect
```

## Dependency Flow Summary

### Foundation Services (No Dependencies)
- `opensearch` - Main search engine
- `shuffle-db` - Shuffle database
- `shuffle-opensearch` - Shuffle search engine
- `iris-db` - IRIS database
- `defectdojo-db` - DefectDojo database
- `misp-db` - MISP database
- `misp-redis` - MISP cache
- `eramba-db` - Eramba database
- `spiderfoot` - Standalone
- `suricata` - Standalone (host network)
- `gophish` - Standalone

### Layer 1 Dependencies (Depend on Foundation)
- `opensearch-dashboards` → `opensearch`
- `fluent-bit` → `opensearch`
- `wazuh-manager` → `opensearch`
- `shuffle-backend` → `shuffle-db` + `shuffle-opensearch`
- `iris-web` → `iris-db`
- `uwsgi` → `defectdojo-db` (+ uses `misp-redis` implicitly)
- `misp-web` → `misp-db` + `misp-redis`
- `eramba-web` → `eramba-db`

### Layer 2 Dependencies (Depend on Layer 1)
- `shuffle-frontend` → `shuffle-backend`
- `shuffle-orborus` → `shuffle-backend` (implicit, not declared)
- `nginx` → `uwsgi`

## Issues to Fix

### Critical
1. `shuffle-orborus` - Missing dependencies declaration
2. `uwsgi` - Wrong health check port (8081 vs 3031)
3. `fluent-bit` - Health check disabled
4. `uwsgi` - Uses `misp-redis` but no dependency declared

### Important
5. `shuffle-backend` - Health check disabled
6. `shuffle-frontend` - Health check disabled, depends on backend without health condition
7. `misp-web` - Health check disabled
8. `nginx` - Health check missing entirely
9. `suricata` - Health check disabled

### Nice to Have
10. Add health check containers for cross-compose dependencies
11. Add wait scripts for complex retry logic
12. Document all environment variable dependencies


# OSSOP Architecture Review - Summary

## Your Questions Answered

### 1. "Would it make sense to have a different folder and compose file per app?"

**Short Answer**: It depends on your use case.

**Current State (Single Compose):**
- ✅ **Pros**: Quick start, simple deployment, one command to start everything
- ❌ **Cons**: 568 lines in one file, harder to manage individual apps, can't scale apps independently

**Modular Structure (Per-App Folders):**
- ✅ **Pros**: Better organization, independent scaling, clearer ownership, easier version control
- ❌ **Cons**: More complex setup, need to manage multiple compose files, cross-app dependencies more complex

**Recommendation**: 
- **Keep current structure** if: Quick start, learning, small team, single deployment
- **Split into modules** if: Production use, large team, different scaling needs per app, need to deploy apps separately

**Best Approach**: Improve current structure first (better health checks, dependencies), then optionally split later if needed.

### 2. "Maybe do curl to another app container name or health API if it is dependent on that app?"

**Short Answer**: Yes, absolutely! Use both Docker Compose `depends_on` AND health API checks.

**When to use each:**

| Scenario | Approach |
|----------|----------|
| Same compose file, simple dependency | `depends_on: condition: service_healthy` |
| Same compose file, complex retry needed | Wait script + health API curl |
| Different compose files | Health check container or wait script |
| Runtime dependency verification | Curl to container hostname + health API |
| Startup dependency | `depends_on` + health check |

---

## Key Findings from Review

### Current Issues Found

1. **Missing/Disabled Health Checks**: 6 services have health checks disabled
2. **Incorrect Health Checks**: `uwsgi` checks wrong port (8081 vs 3031)
3. **Missing Dependencies**: `shuffle-orborus`, `fluent-bit` don't declare all dependencies
4. **Cross-Service Issues**: Some services connect but don't verify dependencies are healthy

### Services That Need Attention

**Health Checks:**
- `fluent-bit` - disabled (add simple TCP check)
- `shuffle-backend` - disabled (enable when admin user created)
- `shuffle-frontend` - disabled (add HTTP check)
- `misp-web` - disabled (enable with longer start_period)
- `nginx` (DefectDojo) - missing entirely
- `suricata` - disabled (add file-based check)

**Dependencies:**
- `shuffle-orborus` → needs `shuffle-backend` and `shuffle-db`
- `fluent-bit` → should wait for `opensearch` health
- `uwsgi` → uses `misp-redis` but no dependency declared
- `shuffle-frontend` → depends on backend but no health condition

---

## Recommended Improvements (Priority Order)

### Priority 1: Fix Critical Issues (Do First)

1. **Fix uwsgi health check port**
   ```yaml
   uwsgi:
     healthcheck:
       test: ["CMD-SHELL", "curl -f http://localhost:3031/api/v2/health || exit 1"]
   ```

2. **Add missing dependencies**
   ```yaml
   shuffle-orborus:
     depends_on:
       shuffle-backend:
         condition: service_started
       shuffle-db:
         condition: service_healthy
   ```

3. **Enable basic health checks**
   ```yaml
   fluent-bit:
     healthcheck:
       test: ["CMD-SHELL", "timeout 1 nc -z localhost 2020 || exit 1"]
       interval: 30s
       retries: 3
   ```

### Priority 2: Improve Health Checks

4. **Add health check for nginx**
   ```yaml
   nginx:
     healthcheck:
       test: ["CMD-SHELL", "curl -f http://localhost:8080 || exit 1"]
       interval: 30s
   ```

5. **Enable misp-web health check**
   ```yaml
   misp-web:
     healthcheck:
       test: ["CMD-SHELL", "curl -f http://localhost/users/login -o /dev/null || exit 1"]
       start_period: 180s  # MISP takes time to start
   ```

6. **Add suricata health check**
   ```yaml
   suricata:
     healthcheck:
       test: ["CMD-SHELL", "test -f /var/log/suricata/eve.json && pgrep suricata || exit 1"]
       interval: 30s
   ```

### Priority 3: Cross-Service Health Verification

7. **Add wait scripts for complex dependencies**
   - Create `wait-for-health.sh` script
   - Use for services that need to verify external dependencies

8. **Add health check containers** (if splitting to per-app)
   - For cross-compose dependencies
   - Example: Shuffle checking main OpenSearch

### Priority 4: Optional Modularization

9. **Consider splitting if:**
   - Team grows beyond 2-3 people
   - Need to deploy apps independently
   - Different scaling requirements
   - Production deployment

---

## Implementation Example

### Example: Improved Shuffle Backend with Health Checks

**Before:**
```yaml
shuffle-backend:
  depends_on:
    shuffle-db:
      condition: service_healthy
    shuffle-opensearch:
      condition: service_healthy
  # No health check - disabled
```

**After:**
```yaml
shuffle-backend:
  depends_on:
    shuffle-db:
      condition: service_healthy
    shuffle-opensearch:
      condition: service_healthy
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:5001/api/v1/health || curl -f http://localhost:5001 || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 5
    start_period: 120s
  # Now shuffle-frontend can depend on this being healthy
```

**Then shuffle-frontend can properly depend on it:**
```yaml
shuffle-frontend:
  depends_on:
    shuffle-backend:
      condition: service_healthy  # Now possible!
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:80 || exit 1"]
```

---

## Decision Matrix

**Should you split into per-app folders?**

| Factor | Keep Single | Split Modules |
|--------|-------------|---------------|
| Use case | Quick start, learning | Production, enterprise |
| Team size | 1-2 people | 3+ people |
| Deployment | All apps together | Apps independently |
| Scaling | Same for all apps | Different per app |
| Maintenance | One person | Multiple owners |
| Complexity | Simple | More complex setup |

**Current recommendation**: **Keep single file for now**, but improve health checks and dependencies first. Revisit modularization later if needs change.

---

## Next Steps

### Immediate (This Week)
1. Review the detailed review documents (`ARCHITECTURE_REVIEW.md`, `ARCHITECTURE_IMPLEMENTATION_EXAMPLE.md`)
2. Fix critical health check issues (Priority 1 items)
3. Test dependencies work correctly

### Short Term (This Month)
1. Enable all missing health checks (Priority 2)
2. Add wait scripts if needed
3. Document all dependencies

### Long Term (As Needed)
1. Evaluate if modular structure needed
2. Consider splitting if requirements change
3. Add health monitoring dashboard

---

## Conclusion

**Your architecture is fundamentally sound** for a quick-start security platform. The main improvements needed are:

1. ✅ **Better health checks** - Enable missing ones, fix incorrect ones
2. ✅ **Better dependencies** - Declare all dependencies properly
3. ✅ **Health API usage** - Use curl/health APIs for cross-service checks when needed
4. ⚠️ **Modular structure** - Consider later if production needs arise

**Answer to your question**: Yes, use curl to container hostnames and health APIs for dependencies, especially when:
- Checking services across different compose files
- Services need custom retry logic
- Runtime verification is required

But also use Docker Compose `depends_on: condition: service_healthy` for same-file dependencies - it's simpler and Docker handles retries automatically.


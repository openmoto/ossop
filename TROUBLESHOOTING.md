# 🔧 OSSOP Troubleshooting Guide

This guide contains technical troubleshooting information for common issues.

## 🐛 Common Issues & Solutions

### **Service Health Issues**

| Issue | Cause | Solution |
|-------|-------|----------|
| **Container shows "unhealthy"** | Health check failing | Check service logs: `docker logs service-name --tail 20` |
| **Service not accessible** | Port mapping issue | Verify port in docker-compose.yml and .env |
| **Database connection errors** | Database not ready | Wait for database health check to pass |
| **Permission denied errors** | Volume permissions | Use Docker named volumes (already configured) |

### **Platform-Specific Issues**

#### **IRIS**
- **Password not working:** Get auto-generated password: `docker logs iris-web | grep "login with"`
- **Container restarting:** Check database connectivity and environment variables

#### **MISP** 
- **SSL redirect issues:** `DISABLE_SSL_REDIRECT=true` is configured
- **Database connection:** Uses MariaDB, not PostgreSQL

#### **DefectDojo**
- **Port conflicts:** Uses internal port 8080, external 8083
- **Database setup:** Requires PostgreSQL initialization

#### **Eramba**
- **HTTPS certificate warnings:** Uses self-signed certificate (expected)
- **403 Forbidden:** Check if initialization completed

#### **SpiderFoot**
- **Authentication disabled:** Expected behavior, see container logs for security warning

### **Windows/WSL Specific**

#### **Docker Socket Issues**
- **Error:** `Wsl/Service/0x8007274c`
- **Solution:** Restart Docker Desktop or WSL: `wsl --shutdown && wsl`

#### **Volume Permissions**
- **Issue:** PostgreSQL permission errors
- **Solution:** Use Docker named volumes (already configured)

#### **Performance**
- **Slow startup:** Allocate more resources to Docker Desktop
- **Memory issues:** Increase Docker memory limit to 8GB+

### **Network Connectivity**

#### **Container-to-Container Communication**
- **Use internal names:** `http://service-name:port`
- **Don't use localhost:** Won't work between containers
- **Check network:** All services use `security-stack-net`

#### **External Access Issues**
- **Port conflicts:** Check if ports are already in use
- **Firewall:** Ensure Docker ports are accessible
- **WSL networking:** Use `localhost` for external access

### **Database Issues**

#### **PostgreSQL**
- **Connection refused:** Wait for health check to pass
- **Data corruption:** Remove volume and recreate: `docker volume rm ossop_service_db_data`
- **Password authentication:** Check environment variables in .env

#### **MariaDB (MISP)**
- **Initialization errors:** Clean volume if switching from PostgreSQL
- **Character set issues:** Uses utf8mb4 (configured)

#### **Redis**
- **Connection issues:** Check password configuration
- **Memory issues:** Monitor Redis memory usage

### **Monitoring Setup (Uptime Kuma)**

#### **No Auto-Discovery**
- **Expected behavior:** Monitors must be added manually
- **Solution:** Use internal Docker names for URLs
- **Reference:** See [MONITORING_SETUP.md](MONITORING_SETUP.md)

#### **Monitor Shows Down**
- **Wrong URL:** Use `http://service-name:port` not `localhost:port`
- **Service not ready:** Check service health with `docker compose ps`
- **Network issues:** Verify services are on same Docker network

### **Resource Issues**

#### **High Memory Usage**
- **OpenSearch:** Limit heap size in production
- **Multiple databases:** Each service has dedicated database
- **Monitoring:** Use `docker stats` to identify resource hogs

#### **Disk Space**
- **Log rotation:** Configure log retention policies
- **Volume cleanup:** Remove unused volumes: `docker volume prune`
- **Image cleanup:** Remove old images: `docker image prune`

### **Security Considerations**

#### **Default Passwords**
- **Change immediately:** All default passwords should be updated
- **Strong passwords:** Use password manager for credentials
- **API keys:** Rotate regularly and store securely

#### **Network Security**
- **Firewall:** Only expose necessary ports
- **TLS certificates:** Replace self-signed certificates in production
- **Access control:** Implement proper authentication and authorization

### **Performance Optimization**

#### **Startup Time**
- **Parallel startup:** Services start based on dependencies
- **Resource allocation:** Ensure adequate CPU and memory
- **SSD storage:** Use fast storage for databases

#### **Runtime Performance**
- **Database tuning:** Optimize database configurations
- **Index management:** Manage OpenSearch indices and retention
- **Resource monitoring:** Use Uptime Kuma and system monitoring

## 🔍 Diagnostic Commands

### **Service Status**
```bash
# Check all services
docker compose ps

# Check specific service
docker compose ps service-name

# Service logs
docker logs service-name --tail 50

# Follow logs in real-time
docker logs -f service-name
```

### **Network Diagnostics**
```bash
# Test internal connectivity
docker exec service-name curl -I http://other-service:port

# Check network configuration
docker network ls
docker network inspect ossop_security-stack-net

# DNS resolution test
docker exec service-name nslookup other-service
```

### **Resource Usage**
```bash
# Container resource usage
docker stats

# Disk usage
docker system df

# Volume usage
docker volume ls
```

### **Database Connectivity**
```bash
# PostgreSQL
docker exec postgres-container psql -U username -d database -c "SELECT version();"

# MariaDB
docker exec mariadb-container mysql -u username -p -e "SELECT VERSION();"

# Redis
docker exec redis-container redis-cli ping
```

## 📞 Getting Help

### **Log Collection**
Before reporting issues, collect relevant information:

```bash
# Service status
docker compose ps > service-status.txt

# Service logs
docker logs service-name > service-logs.txt

# System information
docker version > docker-info.txt
docker compose version >> docker-info.txt
```

### **Issue Reporting**
When reporting issues, include:
1. **Environment:** OS, Docker version, hardware specs
2. **Service status:** Output of `docker compose ps`
3. **Error logs:** Relevant service logs
4. **Steps to reproduce:** What you were trying to do
5. **Expected vs actual:** What should happen vs what happened

### **Community Support**
- **GitHub Issues:** Technical problems and bug reports
- **Discussions:** General questions and community help
- **Documentation:** Check wiki for additional guides

---

**Remember:** Most issues are resolved by checking service logs and ensuring proper configuration. The stack is designed to be self-healing with proper resource allocation.

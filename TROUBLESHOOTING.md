# 🆘 OSSOP Troubleshooting Guide

Quick solutions to common issues when setting up OSSOP.

## 🚀 Quick Fixes

### Services Won't Start
```bash
# Check Docker is running
docker --version
docker info

# Check disk space (need 50GB+)
df -h

# Check memory (need 8GB+)
free -h

# Restart everything
docker compose down
docker compose up -d
```

### Can't Access Web Interfaces
```bash
# Wait longer (services need 3-5 minutes to start)
sleep 300

# Check service status
docker compose ps

# Check specific service logs
docker compose logs [service-name]

# Try incognito/private browser mode
```

### SpiderFoot Issues
```bash
# Rebuild SpiderFoot
docker compose build spiderfoot
docker compose up -d spiderfoot

# Check logs
docker logs spiderfoot --tail 20
```

### OpenSearch Issues
```bash
# Check disk space
df -h

# Clean up if disk is full
docker system prune -a -f

# Restart OpenSearch
docker compose restart opensearch opensearch-dashboards
```

### Permission Errors
```bash
# Fix permissions (Linux/Mac)
sudo chown -R $USER:$USER ./data/

# On Windows, run as Administrator
```

## 🔧 Common Commands

```bash
# Check all services
docker compose ps

# View logs
docker compose logs [service-name]

# Restart specific service
docker compose restart [service-name]

# Complete reset (removes all data)
docker compose down -v
docker system prune -a -f
rm -rf data/
docker compose up -d
```

## 🌐 Service URLs & Default Passwords

| Service | URL | Username | Password |
|---------|-----|----------|----------|
| OpenSearch Dashboards | http://localhost:5601 | - | - |
| DefectDojo | http://localhost:8083 | admin | admin |
| MISP | http://localhost:8082 | admin@admin.test | admin |
| Shuffle | http://localhost:80 | - | Setup required |
| IRIS | http://localhost:8080 | administrator | Check logs |
| SpiderFoot | http://localhost:5002 | admin | admin |
| Eramba | http://localhost:8081 | admin | admin |
| Gophish | http://localhost:3333 | admin | Check logs |

### Get Generated Passwords
```bash
# IRIS password
docker logs iris-web | grep -i password

# Gophish password
docker logs gophish | grep -i password
```

## 🚨 Still Stuck?

1. **Check the logs**: `docker compose logs`
2. **Try a fresh start**: Follow the "Complete reset" commands above
3. **Check system resources**: Ensure you have enough disk space and memory
4. **Update Docker**: Make sure you have the latest Docker Desktop
5. **Open an issue**: https://github.com/openmoto/ossop/issues

## 📞 Getting Help

- **GitHub Issues**: https://github.com/openmoto/ossop/issues
- **Documentation**: https://github.com/openmoto/ossop/tree/main/docs
- **Setup Guide**: https://github.com/openmoto/ossop/blob/main/docs/SETUP.md

---

**Remember**: OSSOP is a complex security platform. Give it time to start up (3-5 minutes) and be patient with the initial setup! 🕐

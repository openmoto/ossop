# 🚀 OSSOP Setup Guide

Complete step-by-step guide to set up OSSOP on any server.

## 📋 Prerequisites

### System Requirements
- **OS**: Linux (Ubuntu 20.04+ recommended), Windows 10+, or macOS 10.15+
- **RAM**: Minimum 8GB, Recommended 16GB+
- **Storage**: Minimum 100GB free space, Recommended 200GB+
- **Network**: Internet connection for downloading images and building SpiderFoot

### Software Requirements
- **Docker**: Version 20.10+ with Docker Compose
- **Git**: For cloning the repository
- **curl/wget**: For testing services

## 🔧 Installation Steps

### Option 1: Automated Setup (Recommended)
```bash
# Clone and run the setup script
git clone https://github.com/openmoto/ossop.git
cd ossop

# Run the automated setup
./setup.sh        # Linux/Mac
setup.bat         # Windows
```

**That's it!** The script will handle everything automatically.

### Option 2: Manual Setup

### Step 1: Install Docker

**Ubuntu/Debian:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin -y

# Logout and login again, or run:
newgrp docker
```

**CentOS/RHEL:**
```bash
# Install Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

**Windows:**
- Download and install Docker Desktop from https://docker.com/products/docker-desktop
- Enable WSL 2 backend if available

**macOS:**
- Download and install Docker Desktop from https://docker.com/products/docker-desktop

### Step 2: Clone OSSOP Repository

```bash
# Clone the repository
git clone https://github.com/openmoto/ossop.git
cd ossop

# Verify files are present
ls -la
```

### Step 3: Set Up Environment Variables

```bash
# Copy the example environment file
cp .env.example .env

# Edit the environment file (optional - defaults work fine)
nano .env  # Linux/Mac
notepad .env  # Windows
```

**Key environment variables you might want to change:**
```bash
# Server hostname (change if not localhost)
HOSTNAME=your-server-ip

# Suricata network interface (check with 'ip link show')
SURICATA_INTERFACE=ens18  # or eth0, enp0s3, etc.

# Passwords (change for production)
DEFECTDOJO_ADMIN_PASSWORD=your-secure-password
MISP_DB_PASSWORD=your-secure-password
# ... etc
```

### Step 4: Build SpiderFoot (Automatic)

SpiderFoot will be built automatically by Docker Compose using our custom Dockerfile:

```bash
# No separate build needed - Docker Compose handles it
# The build happens automatically when you run docker compose up -d
```

**If build fails:**
```bash
# Clean up and rebuild
docker system prune -f
docker compose build spiderfoot
```

### Step 5: Start OSSOP

```bash
# Start all services
docker compose up -d

# Check status
docker compose ps

# Wait 3-5 minutes for services to initialize
```

### Step 6: Verify Installation

```bash
# Check all containers are running
docker compose ps --format "table {{.Name}}\t{{.Status}}"

# Check for any errors
docker compose logs --tail 20

# Test a few services
curl -I http://localhost:5601  # OpenSearch Dashboards
curl -I http://localhost:8083  # DefectDojo
curl -I http://localhost:5002  # SpiderFoot
```

## 🌐 Access Your Services

Once all services are running, access them via web browser:

| Service | URL | Default Credentials |
|---------|-----|-------------------|
| **OpenSearch Dashboards** | http://your-server:5601 | No password |
| **DefectDojo** | http://your-server:8083 | admin / admin |
| **MISP** | http://your-server:8082 | admin@admin.test / admin |
| **Shuffle** | http://your-server:80 | Setup required |
| **IRIS** | http://your-server:8080 | Check logs for password |
| **SpiderFoot** | http://your-server:5002 | admin / admin |
| **Eramba** | http://your-server:8081 | admin / admin |
| **Gophish** | http://your-server:3333 | admin / check logs |

### Get Generated Passwords

```bash
# IRIS admin password
docker logs iris-web | grep -i password

# Gophish admin password
docker logs gophish | grep -i password
```

## 🔧 Common Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Restart services
docker compose restart

# View logs
docker compose logs [service-name]

# Check status
docker compose ps

# Update services
git pull
docker compose pull
docker compose up -d

# Clean restart (removes all data)
docker compose down -v
docker system prune -a -f
rm -rf data/
docker compose up -d
```

## 🚨 Troubleshooting

### Services Won't Start

1. **Check Docker is running:**
   ```bash
   docker --version
   docker compose version
   ```

2. **Check disk space:**
   ```bash
   df -h
   # Need at least 100GB free
   ```

3. **Check memory:**
   ```bash
   free -h
   # Need at least 8GB RAM
   ```

4. **Build SpiderFoot if needed:**
   ```bash
   docker compose build spiderfoot
   ```

### Can't Access Web Interfaces

1. **Wait for initialization:**
   ```bash
   # Services need 3-5 minutes to start
   docker compose ps
   ```

2. **Check service logs:**
   ```bash
   docker compose logs [service-name]
   ```

3. **Check firewall:**
   ```bash
   # Ubuntu/Debian
   sudo ufw status
   sudo ufw allow 5601,8080,8081,8082,8083,5002,3333,80/tcp
   
   # CentOS/RHEL
   sudo firewall-cmd --list-ports
   sudo firewall-cmd --permanent --add-port=5601/tcp
   sudo firewall-cmd --permanent --add-port=8080/tcp
   sudo firewall-cmd --permanent --add-port=8081/tcp
   sudo firewall-cmd --permanent --add-port=8082/tcp
   sudo firewall-cmd --permanent --add-port=8083/tcp
   sudo firewall-cmd --permanent --add-port=5002/tcp
   sudo firewall-cmd --permanent --add-port=3333/tcp
   sudo firewall-cmd --permanent --add-port=80/tcp
   sudo firewall-cmd --reload
   ```

### OpenSearch Issues

1. **Disk space problems:**
   ```bash
   # Check disk usage
   df -h
   
   # Clean up if needed
   docker system prune -a -f
   
   # Disable disk threshold temporarily
   docker exec opensearch curl -X PUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
   {
     "persistent": {
       "cluster.routing.allocation.disk.threshold_enabled": false
     }
   }'
   ```

2. **Memory issues:**
   ```bash
   # Check memory usage
   docker stats
   
   # Reduce OpenSearch heap size in .env
   # Change: OPENSEARCH_JVM_HEAP=1g
   # To: OPENSEARCH_JVM_HEAP=512m
   ```

### SpiderFoot Build Issues

1. **Network connectivity:**
   ```bash
   # Test internet connection
   curl -I https://github.com
   ```

2. **Docker issues:**
   ```bash
   # Clean Docker cache
   docker system prune -f
   
   # Rebuild
   docker compose build spiderfoot
   ```

3. **Memory issues:**
   ```bash
   # Check available memory
   free -h
   
   # Rebuild SpiderFoot
   docker compose build spiderfoot
   ```

## 🔒 Security Considerations

### For Production Use

1. **Change all default passwords:**
   ```bash
   # Edit .env file
   nano .env
   # Change all password variables
   ```

2. **Use HTTPS:**
   - Set up reverse proxy (nginx, Apache)
   - Use SSL certificates (Let's Encrypt recommended)
   - Update HOSTNAME in .env to use HTTPS URLs

3. **Firewall configuration:**
   ```bash
   # Only allow necessary ports
   sudo ufw allow 22/tcp    # SSH
   sudo ufw allow 80/tcp    # HTTP
   sudo ufw allow 443/tcp   # HTTPS
   sudo ufw enable
   ```

4. **Regular updates:**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Update Docker images
   docker compose pull
   docker compose up -d
   ```

## 📞 Getting Help

### Check Service Status
```bash
docker compose ps --format "table {{.Name}}\t{{.Status}}"
```

### View Service Logs
```bash
docker compose logs [service-name] --tail 50
```

### Common Issues
- **Port conflicts**: Change ports in .env file
- **Permission issues**: Ensure user is in docker group
- **Disk space**: Need minimum 100GB free
- **Memory**: Need minimum 8GB RAM

### Support
- GitHub Issues: https://github.com/openmoto/ossop/issues
- Documentation: https://github.com/openmoto/ossop/tree/main/docs

## 🎉 Success!

If all services show "Up" status and you can access the web interfaces, congratulations! You now have a complete security operations platform running.

**Next Steps:**
1. Change default passwords
2. Configure integrations between services
3. Set up monitoring and alerting
4. Create your first security workflows
5. Import threat intelligence feeds

Welcome to OSSOP! 🚀

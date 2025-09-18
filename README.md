# 🛡️ OSSOP - Open Source Security Operations Platform

**A complete cybersecurity toolkit that runs on your computer in just 3 commands.**

Turn any machine into a professional security operations center with 21 integrated security tools - no complex setup required.

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Get the Code
```bash
git clone https://github.com/openmoto/ossop.git
cd ossop
```

### Step 2: Set Up Your Passwords
```bash
# Copy the example settings file
cp .env.example .env

# Edit .env with your preferred passwords (optional - defaults work fine)
notepad .env  # Windows
nano .env     # Linux/Mac
```

### Step 3: Start Everything
```bash
docker compose up -d
```

**That's it!** Wait 2-3 minutes for everything to start, then access your tools.

> **🎯 Pro Tip:** All services are automatically monitored! After setting up Uptime Kuma (first visit to http://localhost:3001), all your security tools will be monitored automatically.

---

## 🌐 Your Security Dashboard

Once running, access these tools in your web browser:

| Tool | What It Does | URL | Login |
|------|--------------|-----|-------|
| **OpenSearch Dashboards** | Main security dashboard | http://localhost:5601 | admin / admin |
| **Uptime Kuma** | Monitor all services | http://localhost:3001 | Setup required* |
| **DefectDojo** | Track security issues | http://localhost:8083 | admin / admin |
| **MISP** | Threat intelligence | http://localhost:8082 | admin@admin.test / admin |
| **Shuffle** | Automate responses | http://localhost:5001 | admin / admin |
| **IRIS** | Incident management | http://localhost:8080 | administrator / password |
| **SpiderFoot** | Gather intelligence | http://localhost:5002 | admin / admin |
| **Eramba** | Compliance tracking | http://localhost:8081 | admin / admin |

> **💡 Tip:** Bookmark these URLs for easy access to your security tools!

> **\*Uptime Kuma Setup:** On first visit, create an admin account. All service monitors will be created automatically afterward!

---

## 🛠️ What's Inside

### Core Security Tools
- **🔍 SIEM (OpenSearch)** - Collect and analyze security logs
- **🤖 SOAR (Shuffle)** - Automate security responses  
- **📋 Case Management (IRIS)** - Track security incidents
- **🕷️ Threat Intel (MISP)** - Share threat information
- **🛡️ Vulnerability Mgmt (DefectDojo)** - Find and fix security issues
- **📊 GRC (Eramba)** - Manage compliance and risk
- **👁️ Network Security (Suricata)** - Monitor network traffic
- **🔎 OSINT (SpiderFoot)** - Gather public intelligence
- **📈 Monitoring (Uptime Kuma + AutoKuma)** - Automated monitoring of all services

### Supporting Services
- **PostgreSQL** - Secure database storage
- **Redis** - Fast data caching
- **Wazuh** - Endpoint security monitoring
- **Fluent Bit** - Log processing and forwarding
- **Nginx** - Web server and load balancing

---

## 💻 Requirements

**Minimum:**
- 8GB RAM
- 50GB free disk space
- Docker Desktop installed
- Windows 10+, macOS 10.15+, or Linux

**Recommended:**
- 16GB RAM
- 100GB free disk space
- SSD storage for better performance

---

## 🔧 Common Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View service status
docker compose ps

# View logs for a specific service
docker compose logs [service-name]

# Restart everything (if something breaks)
docker compose restart

# Clean restart (removes all data - be careful!)
docker compose down -v
docker compose up -d
```

---

## 🆘 Need Help?

### Services Won't Start?
1. Make sure Docker is running
2. Check you have enough free disk space
3. Try: `docker compose down && docker compose up -d`

### Can't Access a Website?
1. Wait 2-3 minutes after starting (services need time to initialize)
2. Check the service is running: `docker compose ps`
3. Try refreshing your browser

### Forgot a Password?
1. Check your `.env` file for the passwords you set
2. Default passwords are in the table above

### Still Stuck?
- Check service logs: `docker compose logs [service-name]`
- Open an issue on GitHub with your error message

---

## 🔐 Security Notes

**⚠️ Important:** This setup uses default passwords and is designed for testing and learning. 

**For production use:**
1. Change ALL default passwords in the `.env` file
2. Use strong, unique passwords for each service  
3. Set up proper firewall rules
4. Enable HTTPS with real SSL certificates
5. Regularly update all services

---

## 📁 Project Structure

```
ossop/
├── docker-compose.yml      # Main configuration
├── .env.example           # Password settings template
├── .env                   # Your actual passwords (create this)
├── config/               # Service configurations
├── scripts/              # Automation scripts
└── data/                 # Persistent data storage
```

---

## 🤝 Contributing

Found a bug? Want to add a feature? 

1. Fork this repository
2. Make your changes
3. Test with `docker compose up -d`
4. Submit a pull request

---

## 📜 License

This project is open source and available under the MIT License.

---

## ⭐ Like This Project?

If OSSOP helped you learn cybersecurity or saved you time, please give it a star on GitHub!

**Built with ❤️ for the cybersecurity community**

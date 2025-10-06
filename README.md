# 🛡️ OSSOP - Open Source Security Operations Platform

**A complete cybersecurity toolkit that runs on your computer in just 3 commands.**

Turn any machine into a professional security operations center with 19 integrated security tools - no complex setup required.

---

## 🚀 Quick Start (10 Minutes)

### Step 1: Get the Code
```bash
git clone https://github.com/openmoto/ossop.git
cd ossop
```

### Step 2: Set Up Your Environment
```bash
# Copy the example settings file
cp .env.example .env

# Edit .env with your preferred passwords (optional - defaults work fine)
notepad .env  # Windows
nano .env     # Linux/Mac
```

### Step 3: Build SpiderFoot (Required)
```bash
# SpiderFoot will be built automatically when you start the stack
# No separate build command needed - Docker Compose handles it
```

### Step 4: Start Everything
```bash
docker compose up -d
```

**That's it!** Wait 3-5 minutes for everything to start, then access your tools.

---

## 🌐 Your Security Dashboard

Once running, access these tools in your web browser:

| Tool | What It Does | URL | Login |
|------|--------------|-----|-------|
| **OpenSearch Dashboards** | Main security dashboard | http://localhost:5601 | no password |
| **DefectDojo** | Track security issues | http://localhost:8083 | admin / admin |
| **MISP** | Threat intelligence | http://localhost:8082 | admin@admin.test / admin |
| **Shuffle** | Automate responses | http://localhost:80 | Setup required*|
| **IRIS** | Incident management | http://localhost:8080 | run `docker logs iris-web` to find creds |
| **SpiderFoot** | Gather intelligence | http://localhost:5002 | admin / admin |
| **Eramba** | Compliance tracking | http://localhost:8081 | admin / admin |
| **Gophish** | Phishing simulation | http://localhost:3333 | admin / check logs |

> **💡 Tip:** Bookmark these URLs for easy access to your security tools!

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
- **🎣 Phishing Simulation (Gophish)** - Test security awareness

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
- 100GB free disk space
- Docker Desktop installed
- Windows 10+, macOS 10.15+, or Linux

**Recommended:**
- 16GB RAM
- 200GB free disk space
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
2. Check you have enough free disk space (minimum 100GB)
3. Build SpiderFoot first: `docker build -t spiderfoot:latest https://github.com/smicallef/spiderfoot.git`
4. Try: `docker compose down && docker compose up -d`

### Can't Access a Website?
1. Wait 3-5 minutes after starting (services need time to initialize)
2. Check the service is running: `docker compose ps`
3. Try refreshing your browser or use incognito mode

### Forgot a Password?
1. Check your `.env` file for the passwords you set
2. Default passwords are in the table above
3. For IRIS: `docker logs iris-web | grep password`
4. For Gophish: `docker logs gophish | grep password`

### SpiderFoot Build Issues?
1. Make sure you have internet connection
2. The build takes 5-10 minutes
3. If it fails, try: `docker system prune -f` then `docker compose build spiderfoot`

### OpenSearch Issues?
1. Check disk space: `df -h`
2. If disk is full, clean up: `docker system prune -a -f`
3. Restart OpenSearch: `docker compose restart opensearch opensearch-dashboards`

### Fresh Start (Nuclear Option)
```bash
# Complete reset - removes all data
docker compose down -v
docker system prune -a -f
rm -rf data/
docker compose up -d
```

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

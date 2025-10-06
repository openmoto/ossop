# ðŸ›¡ï¸ OSSOP - Open Source Security Operations Platform

**A complete cybersecurity toolkit that runs on your computer in just 3 commands.**

Turn any machine into a professional security operations center with 19 integrated security tools - no complex setup required.

---

## ðŸš€ Quick Start (5 Minutes)

### Option 1: Automated Setup (Recommended)
```bash
# Clone and run the setup script
git clone https://github.com/openmoto/ossop.git
cd ossop

# Run the automated setup
./setup.sh        # Linux/Mac
setup.bat         # Windows
```

### Option 2: Manual Setup
```bash
# Get the code
git clone https://github.com/openmoto/ossop.git
cd ossop

# Create environment file
cp .env.example .env

# Start everything (SpiderFoot builds automatically)
docker compose up -d
```

**That's it!** Wait 3-5 minutes for everything to start, then access your tools.

---

## ðŸŒ Your Security Dashboard

Once running, access these tools in your web browser:

| Tool | What It Does | URL | Login |
|------|--------------|-----|-------|
| **OpenSearch Dashboards** | Main security dashboard | http://localhost:5601 | no password |
| **DefectDojo** | Track security issues | http://localhost:8083 | admin / admin |
| **MISP** | Threat intelligence | http://localhost:8082 | admin@admin.test / admin |
| **Shuffle** | Automate responses | http://localhost:80 | Setup required*|
| **IRIS** | Incident management | http://localhost:8080 | run `docker logs iris-web` to find creds |
| **OpenSearch Dashboards** | Main security dashboard | http://localhost:5601 | No login required |
| **Uptime Kuma** | Monitor all services | http://localhost:3001 | Create account on first visit |
| **DefectDojo** | Track security issues | http://localhost:8083 | From .env file (default: admin / admin) |
| **MISP** | Threat intelligence | http://localhost:8082 | admin@admin.test / admin |
| **Shuffle** | Automate responses | http://localhost:5001 | admin / admin |
| **IRIS** | Incident management | http://localhost:8080 | See Login information section |
| **SpiderFoot** | Gather intelligence | http://localhost:5002 | admin / admin |
| **Eramba** | Compliance tracking | http://localhost:8081 | admin / admin |
| **Gophish** | Phishing simulation | http://localhost:3333 | admin / check logs |

### ðŸ”‘ Login Information

- **Fixed Credentials**: MISP, Shuffle, SpiderFoot, and Eramba use the default usernames/passwords shown above
- **From .env file**: DefectDojo uses credentials from your `.env` file (defaults to admin/admin if not set)
- **Generated at startup**: IRIS generates a random password shown in logs - run `docker logs iris-web` to see it, it shold be in the format "You can now login with user 'administrator' and password >>> yourpassword <<< on None"
- **First-time setup**: Uptime Kuma requires you to create an admin account on first visit

> **ðŸ’¡ Tip:** Bookmark these URLs for easy access to your security tools!

---

## ðŸ› ï¸ What's Inside

### Core Security Tools
- **ðŸ” SIEM (OpenSearch)** - Collect and analyze security logs
- **ðŸ¤– SOAR (Shuffle)** - Automate security responses  
- **ðŸ“‹ Case Management (IRIS)** - Track security incidents
- **ðŸ•·ï¸ Threat Intel (MISP)** - Share threat information
- **ðŸ›¡ï¸ Vulnerability Mgmt (DefectDojo)** - Find and fix security issues
- **ðŸ“Š GRC (Eramba)** - Manage compliance and risk
- **ðŸ‘ï¸ Network Security (Suricata)** - Monitor network traffic
- **ðŸ”Ž OSINT (SpiderFoot)** - Gather public intelligence
- **ðŸŽ£ Phishing Simulation (Gophish)** - Test security awareness

### Supporting Services
- **PostgreSQL** - Secure database storage
- **Redis** - Fast data caching
- **Wazuh** - Endpoint security monitoring
- **Fluent Bit** - Log processing and forwarding
- **Nginx** - Web server and load balancing

---

## ðŸ’» Requirements

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

## ðŸ”§ Common Commands

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

## ðŸ†˜ Need Help?

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

## ðŸ” Security Notes

**âš ï¸ Important:** This setup uses default passwords and is designed for testing and learning. 

**For production use:**
1. Change ALL default passwords in the `.env` file
2. Use strong, unique passwords for each service  
3. Set up proper firewall rules
4. Enable HTTPS with real SSL certificates
5. Regularly update all services

---

## ðŸ“ Project Structure

```
ossop/
â”œâ”€â”€ docker-compose.yml      # Main configuration
â”œâ”€â”€ .env.example           # Password settings template
â”œâ”€â”€ .env                   # Your actual passwords (create this)
â”œâ”€â”€ config/               # Service configurations
â”œâ”€â”€ scripts/              # Automation scripts
â””â”€â”€ data/                 # Persistent data storage
```

---

## ðŸ¤ Contributing

Found a bug? Want to add a feature? 

1. Fork this repository
2. Make your changes
3. Test with `docker compose up -d`
4. Submit a pull request

---

## ðŸ“œ License

This project is open source and available under the MIT License.

---

## â­ Like This Project?

If OSSOP helped you learn cybersecurity or saved you time, please give it a star on GitHub!

**Built with â¤ï¸ for the cybersecurity community**

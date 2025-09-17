# 📊 Uptime Kuma Monitoring Setup - Quick Reference

## 🚀 Quick Setup Steps

### 1. Access Uptime Kuma
- **URL:** http://localhost:3001
- **First Time:** Create admin account
- **Login:** Use your created credentials

### 2. Add Monitors (Copy-Paste Ready)

Click **"+ Add New Monitor"** and use these settings:

#### Core SIEM Services
```
Monitor Type: HTTP(s)
Friendly Name: SIEM Dashboard
URL: http://opensearch-dashboards:5601
Heartbeat Interval: 60 seconds
```

```
Monitor Type: HTTP(s)
Friendly Name: OpenSearch API
URL: http://opensearch:9200/_cluster/health
Heartbeat Interval: 60 seconds
```

#### Security Orchestration (SOAR)
```
Monitor Type: HTTP(s)
Friendly Name: SOAR Frontend
URL: http://shuffle-frontend:80
Heartbeat Interval: 60 seconds
```

```
Monitor Type: HTTP(s)
Friendly Name: SOAR Backend API
URL: http://shuffle-backend:5001/api/v1/health
Heartbeat Interval: 60 seconds
```

#### Case Management & Intelligence
```
Monitor Type: HTTP(s)
Friendly Name: IRIS Case Management
URL: http://iris-web:8000
Heartbeat Interval: 60 seconds
```

```
Monitor Type: HTTP(s)
Friendly Name: MISP Threat Intelligence
URL: http://misp-web:80
Heartbeat Interval: 60 seconds
```

#### OSINT & Vulnerability Management
```
Monitor Type: HTTP(s)
Friendly Name: SpiderFoot OSINT
URL: http://spiderfoot:5001
Heartbeat Interval: 60 seconds
```

```
Monitor Type: HTTP(s)
Friendly Name: DefectDojo Vulnerability Mgmt
URL: http://defectdojo-app:8080
Heartbeat Interval: 60 seconds
```

#### GRC Platform
```
Monitor Type: HTTP(s)
Friendly Name: Eramba GRC Platform
URL: https://eramba-web:443
Heartbeat Interval: 60 seconds
Accept Invalid SSL: Yes (self-signed certificate)
```

#### Network Monitoring
```
Monitor Type: TCP Port
Friendly Name: Wazuh Manager API
Hostname: wazuh-manager
Port: 55000
Heartbeat Interval: 60 seconds
```

## 🔧 Troubleshooting

### Monitor Shows "Down"
1. **Check service status:**
   ```bash
   docker compose ps service-name
   ```

2. **Test connectivity:**
   ```bash
   docker exec uptime-kuma wget -qO- http://service-name:port
   ```

3. **Check logs:**
   ```bash
   docker logs service-name --tail 10
   ```

### Common Fixes
- ✅ **Use internal Docker names** (e.g., `iris-web:8000`)
- ❌ **Don't use localhost** (e.g., `localhost:8080`)
- 🔧 **Use internal ports** (different from external access)
- 🔒 **Use HTTPS only for Eramba** (all others use HTTP)

## 📧 Set Up Notifications

### Email Notifications
1. Go to **Settings** → **Notifications**
2. Click **"Add Notification"**
3. Select **"Email (SMTP)"**
4. Configure your SMTP settings
5. Test the notification

### Slack Integration
1. Create Slack webhook URL
2. Add **"Slack"** notification type
3. Paste webhook URL
4. Test notification

### Teams Integration
1. Create Teams webhook
2. Add **"Microsoft Teams"** notification type
3. Configure webhook URL

## 🎯 Expected Results

After setup, you should see:
- **Green checkmarks** for healthy services
- **Response times** (typically 10-100ms for internal services)
- **Uptime percentages** (should be 99%+ for stable services)
- **Alert notifications** when services go down

## 📊 Service Health Status

| Service | Expected Status | Typical Response Time |
|---------|----------------|---------------------|
| SIEM Dashboard | 🟢 UP | 20-50ms |
| SOAR Frontend | 🟢 UP | 10-30ms |
| IRIS Case Mgmt | 🟢 UP | 15-40ms |
| MISP Threat Intel | 🟢 UP | 25-60ms |
| SpiderFoot | 🟢 UP | 30-80ms |
| OpenSearch API | 🟢 UP | 5-15ms |
| DefectDojo | ⚠️ May show issues | Variable |
| Eramba GRC | ⚠️ May show issues | Variable |
| Wazuh Manager | 🟢 UP | 5-20ms |

---

**Need Help?** Check the main README.md for detailed troubleshooting steps.

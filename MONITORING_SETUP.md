# 📊 Monitoring Setup Guide

This guide helps you set up monitoring dashboards to see what's happening in your security stack.

## Quick Setup

1. **Start OSSOP** (if not already running):
   ```bash
   docker compose up -d
   ```

2. **Access Uptime Kuma** at http://localhost:3001
   - Create an admin account
   - Add monitors for your services using the URLs from the main README

3. **Access OpenSearch Dashboards** at http://localhost:5601
   - Login: admin / admin
   - Go to "Discover" to see security logs
   - Create dashboards for your security data

## What Gets Monitored

- **Service Health**: All 21 services are monitored for uptime
- **Security Logs**: Wazuh and Suricata logs are collected
- **System Metrics**: Container resource usage
- **Network Traffic**: Intrusion detection alerts

## Creating Custom Dashboards

### In OpenSearch Dashboards:
1. Go to "Management" → "Index Patterns"
2. Create patterns for:
   - `wazuh-alerts-*` (security alerts)
   - `suricata-events-*` (network events)
3. Go to "Visualize" to create charts
4. Combine charts into dashboards

### In Uptime Kuma:
1. Click "Add New Monitor"
2. Choose "HTTP(s)" type
3. Enter the service URL
4. Set check interval (default: 60 seconds)
5. Add notification methods (email, Slack, etc.)

## Troubleshooting

**No logs showing up?**
- Check Fluent Bit is running: `docker compose ps fluent-bit`
- View Fluent Bit logs: `docker compose logs fluent-bit`

**Dashboards not loading?**
- Wait 2-3 minutes for services to fully start
- Check OpenSearch is healthy: `docker compose ps opensearch`

**Monitors failing?**
- Verify the service URLs are correct
- Check if the services are actually running
- Look at the specific error messages in Uptime Kuma

## Advanced Configuration

For advanced monitoring setups, check the configuration files in:
- `config/fluent-bit/` - Log processing configuration
- `scripts/setup-monitoring.sh` - Automated setup script

## Need Help?

- Check the main README for basic troubleshooting
- View service logs: `docker compose logs [service-name]`
- Open an issue on GitHub with details about your problem
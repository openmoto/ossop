# 📊 Monitoring Setup Guide

This guide helps you set up monitoring dashboards to see what's happening in your security stack.

## Quick Setup

1. **Start OSSOP** (if not already running):
   ```bash
   docker compose up -d
   ```

2. **Set up your own monitoring solution** 
   - Consider alternatives like Prometheus/Grafana for monitoring your services

3. **Access OpenSearch Dashboards** at http://localhost:5601
   - Login: admin / admin
   - Go to "Discover" to see security logs
   - Create dashboards for your security data

## What Gets Monitored

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

### For External Monitoring:
1. Set up your preferred monitoring solution
2. Configure health checks for your services
3. Use the service URLs from the main README
4. Set appropriate check intervals
5. Configure alerting as needed

## Troubleshooting

**No logs showing up?**
- Check Fluent Bit is running: `docker compose ps fluent-bit`
- View Fluent Bit logs: `docker compose logs fluent-bit`

**Dashboards not loading?**
- Wait 2-3 minutes for services to fully start
- Check OpenSearch is healthy: `docker compose ps opensearch`

**Services not responding?**
- Verify the service URLs are correct
- Check if the services are actually running
- Review service logs for specific errors

## Advanced Configuration

For advanced monitoring setups, check the configuration files in:
- `config/fluent-bit/` - Log processing configuration

## Need Help?

- Check the main README for basic troubleshooting
- View service logs: `docker compose logs [service-name]`
- Open an issue on GitHub with details about your problem
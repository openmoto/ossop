# OpenSearch Dashboards - Your Security Command Center

## What is OpenSearch Dashboards?

OpenSearch Dashboards is like a security control room for your computer systems. It shows you what's happening across all your security tools in one place. Think of it as a dashboard in your car - it shows you speed, fuel, and warnings all at once.

**Access:** http://localhost:5601  
**Login:** No password needed

## What Can You Do With It?

### 1. See Security Events
- View all security alerts in real-time
- See network attacks as they happen
- Track user login attempts
- Monitor system changes

### 2. Create Visual Reports
- Make charts and graphs of your security data
- Build dashboards for different teams
- Set up alerts when bad things happen
- Export reports for management

### 3. Search Through Data
- Find specific security events quickly
- Look for patterns in attacks
- Search by date, user, or system
- Filter results to find what matters

## Getting Started

### Step 1: First Login
1. Open your web browser
2. Go to http://localhost:5601
3. Wait for the page to load (takes 1-2 minutes first time)
4. Click "Explore on my own" if asked

### Step 2: Explore Your Data
1. Click "Discover" in the left menu
2. Look for data patterns like:
   - `wazuh-alerts-*` (security alerts)
   - `suricata-events-*` (network events)
3. Click on any pattern to see the data

### Step 3: Create Your First Dashboard
1. Click "Dashboard" in the left menu
2. Click "Create dashboard"
3. Click "Add an existing" to add charts
4. Choose visualizations that help you
5. Save your dashboard with a clear name

## Common Use Cases

### Security Monitoring
**Goal:** Watch for attacks and threats

**Steps:**
1. Go to "Discover"
2. Select "wazuh-alerts-*"
3. Look for high-severity alerts
4. Create filters for critical events
5. Set up alerts for immediate threats

### Network Analysis
**Goal:** See what's happening on your network

**Steps:**
1. Go to "Discover"
2. Select "suricata-events-*"
3. Filter by event types (alerts, flows)
4. Look for unusual network activity
5. Create charts showing traffic patterns

### Incident Investigation
**Goal:** Dig deep into security problems

**Steps:**
1. Start with the time when the problem happened
2. Search across all data sources
3. Look for related events
4. Build a timeline of what occurred
5. Document findings for your team

## Creating Useful Dashboards

### Security Overview Dashboard
**What to include:**
- Total alerts per day
- Top threat types
- Most targeted systems
- Alert severity breakdown

### Network Security Dashboard
**What to include:**
- Network traffic volume
- Blocked connection attempts
- Top source countries
- Protocol usage charts

### System Health Dashboard
**What to include:**
- System uptime status
- Error rates by service
- Performance metrics
- Resource usage trends

## Tips for Success

### Keep It Simple
- Start with basic charts
- Add complexity slowly
- Focus on what your team needs
- Use clear titles and labels

### Update Regularly
- Review dashboards weekly
- Remove outdated information
- Add new data sources as needed
- Get feedback from users

### Share Knowledge
- Train team members on key dashboards
- Document important searches
- Create standard operating procedures
- Share useful filters with colleagues

## Common Problems and Solutions

### "No Data Found"
**Problem:** Dashboard shows no information
**Solution:**
1. Check if services are running: `docker compose ps`
2. Wait 5-10 minutes for data to appear
3. Verify index patterns are correct
4. Look at date range settings

### Slow Performance
**Problem:** Dashboards load slowly
**Solution:**
1. Reduce time range (last 24 hours instead of 30 days)
2. Add more specific filters
3. Limit the number of charts per dashboard
4. Increase system memory if possible

### Missing Events
**Problem:** Some security events don't appear
**Solution:**
1. Check that all security tools are running
2. Verify log forwarding is working
3. Look for errors in Fluent Bit logs
4. Restart services if needed

## Best Practices

### Daily Tasks
- [ ] Check security overview dashboard
- [ ] Review high-priority alerts
- [ ] Look for unusual patterns
- [ ] Update incident tracking

### Weekly Tasks
- [ ] Review dashboard performance
- [ ] Clean up old searches
- [ ] Update team on trends
- [ ] Plan improvements

### Monthly Tasks
- [ ] Archive old data
- [ ] Review access permissions
- [ ] Update documentation
- [ ] Train new team members

## Integration with Other Tools

### With MISP (Threat Intelligence)
- Import threat indicators
- Create alerts for known bad IPs
- Share findings with threat intel team

### With IRIS (Case Management)
- Link alerts to investigation cases
- Export evidence for investigations
- Track resolution status

### With Shuffle (Automation)
- Trigger automated responses
- Create workflows for common alerts
- Reduce manual investigation time

## Getting Help

### Built-in Help
- Click the "?" icon in any screen
- Use the "Help" menu for tutorials
- Check sample dashboards for ideas

### Community Resources
- OpenSearch documentation online
- Security community forums
- YouTube tutorials for beginners

### Troubleshooting
- Check service logs: `docker compose logs opensearch-dashboards`
- Verify data is flowing: Look at "Discover" page
- Restart if needed: `docker compose restart opensearch-dashboards`

Remember: OpenSearch Dashboards is powerful, but start simple. Build your skills over time and focus on what helps your team protect your systems best.

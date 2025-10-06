# MISP - Threat Intelligence Made Simple

## What is MISP?

MISP (Malware Information Sharing Platform) is like a shared notebook for security teams. It helps you collect, store, and share information about cyber threats. Think of it as a library where security experts share what they know about bad actors and attacks.

**Access:** http://localhost:8082  
**Login:** admin@admin.test / admin

## What Can MISP Do?

### Store Threat Information
- IP addresses of attackers
- Malicious website links
- Email addresses used in scams
- File fingerprints of malware
- Attack patterns and techniques

### Share Intelligence
- Send threat data to other organizations
- Receive updates from security communities
- Work together to stop cyber criminals
- Build a stronger defense network

### Analyze Threats
- Find connections between different attacks
- Track threat actors over time
- Predict future attack methods
- Measure threat levels

### Automate Security
- Feed threat data to security tools
- Block known bad IP addresses
- Alert on suspicious activity
- Update firewall rules automatically

## Getting Started

### Step 1: First Login
1. Open your web browser
2. Go to http://localhost:8082
3. Login with email: `admin@admin.test` and password: `admin`
4. Accept any terms of service

### Step 2: Change Default Settings
1. Click your name in the top right
2. Select "My Profile"
3. Change your password
4. Update your email address
5. Set your organization details

### Step 3: Explore the Interface
1. **Dashboard:** Shows recent activity
2. **Events:** Lists all threat events
3. **Attributes:** Shows individual threat indicators
4. **Organisations:** Manages sharing partners
5. **Administration:** System settings

## Understanding MISP Concepts

### Events
**What they are:** Collections of related threat information
**Example:** "Phishing campaign targeting banks in March 2024"
**Contains:** IP addresses, email addresses, malware samples, attack details

### Attributes
**What they are:** Individual pieces of threat data
**Examples:**
- IP address: 192.168.1.100
- Domain: malicious-site.com
- Email: scammer@fake-bank.com
- File hash: abc123def456

### Tags
**What they are:** Labels that describe threats
**Examples:**
- TLP:RED (highly sensitive)
- APT28 (specific threat group)
- Banking-Malware (attack type)
- High-Confidence (reliability level)

### Sharing Groups
**What they are:** Who can see your threat data
**Types:**
- Your organization only
- Trusted partners
- Security community
- Public information

## Creating Your First Event

### Step 1: Add New Event
1. Click "Event Actions" → "Add Event"
2. Fill in basic information:
   - **Date:** When the threat was discovered
   - **Distribution:** Who can see this (start with "Your organisation only")
   - **Threat Level:** How dangerous it is
   - **Analysis:** How complete your investigation is
   - **Info:** A clear description of the threat

### Step 2: Add Threat Indicators
1. Click "Add Attribute" in your new event
2. Choose the type of indicator:
   - **IP-dst:** Malicious IP address
   - **Domain:** Bad website
   - **Email-src:** Sender of malicious email
   - **MD5/SHA1:** Malware file fingerprint
3. Enter the actual value
4. Set "To IDS" if you want automatic blocking
5. Add tags to describe the threat

### Step 3: Enrich Your Event
1. Add context with comments
2. Upload related files (screenshots, documents)
3. Link to other related events
4. Set proper sharing permissions
5. Publish when ready

## Common Use Cases

### Incident Response
**Goal:** Document and share information about attacks

**Steps:**
1. Create event for each incident
2. Add all indicators found during investigation
3. Tag with attack type and severity
4. Share with incident response team
5. Update as investigation progresses

### Threat Hunting
**Goal:** Look for signs of known threats in your environment

**Steps:**
1. Search MISP for relevant threats
2. Export indicators to security tools
3. Scan your network for matches
4. Investigate any hits found
5. Create new events for discoveries

### Intelligence Sharing
**Goal:** Work with other organizations to fight threats

**Steps:**
1. Join threat sharing communities
2. Subscribe to relevant feeds
3. Share your own discoveries
4. Collaborate on investigations
5. Build trust relationships

### Security Tool Integration
**Goal:** Automatically update security controls

**Steps:**
1. Configure API access
2. Connect to firewalls and IPS systems
3. Set up automatic indicator feeds
4. Create blocking rules
5. Monitor for effectiveness

## Working with Threat Feeds

### Subscribing to Feeds
1. Go to "Sync Actions" → "List Servers"
2. Click "Add Server"
3. Enter feed details:
   - **Name:** Feed provider name
   - **URL:** Feed address
   - **Authkey:** Access key (if required)
4. Test connection
5. Enable automatic synchronization

### Popular Free Feeds
- **CIRCL OSINT Feed:** General threat intelligence
- **Botvrij.eu:** Malware indicators
- **Abuse.ch:** Malware and botnet data
- **MISP Project:** Community contributions

### Managing Feed Data
1. Review new indicators regularly
2. Tag imported data appropriately
3. Remove outdated information
4. Verify indicator accuracy
5. Share validated threats with community

## Integration with Other OSSOP Tools

### With SpiderFoot (Intelligence Gathering)
**How to connect:**
1. Export SpiderFoot findings as CSV
2. Import into MISP as new attributes
3. Create events for significant discoveries
4. Tag with source information
5. Share with appropriate groups

### With Shuffle (Automation)
**How to connect:**
1. Use MISP API in Shuffle workflows
2. Automatically create events from alerts
3. Update threat indicators in real-time
4. Trigger responses based on threat levels
5. Sync with other security tools

### With IRIS (Case Management)
**How to connect:**
1. Link MISP events to IRIS cases
2. Use threat intelligence in investigations
3. Track remediation of identified threats
4. Document lessons learned
5. Share findings with stakeholders

### With OpenSearch (SIEM)
**How to connect:**
1. Export MISP indicators as JSON
2. Import into OpenSearch for correlation
3. Create alerts for known bad indicators
4. Build dashboards showing threat trends
5. Automate threat hunting queries

## Best Practices

### Data Quality
- Verify indicators before adding
- Use consistent tagging schemes
- Add context and comments
- Remove false positives quickly
- Keep information current

### Sharing Responsibly
- Start with restrictive sharing
- Build trust before sharing widely
- Respect data source requirements
- Follow legal and policy guidelines
- Protect sensitive information

### Organization
- Create clear event naming conventions
- Use consistent tagging
- Organize by threat type or campaign
- Archive old events regularly
- Document your processes

### Collaboration
- Participate in community discussions
- Provide feedback on shared intelligence
- Contribute your own discoveries
- Build relationships with peers
- Share lessons learned

## Troubleshooting Common Issues

### Cannot Login
**Problem:** Login page won't accept credentials
**Solutions:**
- Verify username is `admin@admin.test`
- Check password is `admin`
- Clear browser cache
- Try incognito/private browsing mode
- Restart MISP service if needed

### Slow Performance
**Problem:** MISP loads slowly or times out
**Solutions:**
- Check system resources (RAM, CPU)
- Reduce number of events displayed
- Archive old events
- Optimize database
- Restart services: `docker compose restart misp-web misp-db`

### Sharing Not Working
**Problem:** Cannot share events with other organizations
**Solutions:**
- Check network connectivity
- Verify API keys are correct
- Review sharing group settings
- Test with simple events first
- Check logs for error messages

### Import Fails
**Problem:** Cannot import threat feeds or files
**Solutions:**
- Verify file format is correct
- Check feed URL is accessible
- Review authentication settings
- Look for format errors in data
- Try smaller test imports first

## Security Considerations

### Access Control
- Use strong passwords
- Enable two-factor authentication
- Limit user permissions appropriately
- Regular review user access
- Monitor login attempts

### Data Protection
- Encrypt sensitive threat data
- Backup MISP database regularly
- Control network access
- Monitor for unauthorized changes
- Follow data retention policies

### Network Security
- Use HTTPS for all connections
- Implement proper firewall rules
- Monitor network traffic
- Use VPN for remote access
- Keep system updated

## Getting Help

### Built-in Help
- Click "?" icons throughout interface
- Check "Administration" → "Server Settings"
- Review user guide in documentation
- Use search function to find features

### Community Resources
- MISP Project website and documentation
- GitHub repository for issues and updates
- User mailing lists and forums
- Training materials and workshops
- Professional support services

### OSSOP Integration
- Check other tool documentation
- Use API documentation for integrations
- Test connections with simple data first
- Monitor logs for integration issues

Remember: MISP is most valuable when used as part of a community. Start by consuming threat intelligence from others, then contribute your own discoveries as you gain experience. The more you share (responsibly), the stronger everyone's security becomes.

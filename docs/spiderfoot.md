# SpiderFoot - Intelligence Gathering Made Easy

## What is SpiderFoot?

SpiderFoot is like a detective for the internet. It searches the web (including the dark web) to find information about your organization, people, or threats. It looks in places most people can't see and brings back important security information.

**Access:** http://localhost:5002  
**Login:** admin / admin

## What Can SpiderFoot Find?

### Personal Information
- Email addresses and phone numbers
- Social media profiles
- Leaked passwords and data breaches
- Public records and documents

### Network Information
- IP addresses and domains
- Subdomains you might not know about
- Open ports and services
- SSL certificates and security issues

### Dark Web Intelligence
- Stolen credentials for sale
- Company data on criminal forums
- Threat actor discussions
- Compromised systems information

### Threat Intelligence
- Malicious IP addresses
- Suspicious domains
- Known attack patterns
- Security vulnerabilities

## Getting Started

### Step 1: First Login
1. Open your web browser
2. Go to http://localhost:5002
3. Login with username: `admin` and password: `admin`
4. You'll see the main SpiderFoot dashboard

### Step 2: Change Default Password
1. Click "Settings" in the top menu
2. Go to "Authentication"
3. Change the admin password
4. Save your changes

### Step 3: Run Your First Scan
1. Click "New Scan" button
2. Enter a target (like your company domain)
3. Choose scan modules (start with "All")
4. Click "Run Scan"
5. Wait for results to appear

## Types of Scans You Can Run

### Domain Investigation
**When to use:** Check your company's online presence
**What to enter:** yourcompany.com
**What you'll find:**
- All subdomains
- Email addresses
- Employee information
- Security vulnerabilities

### Person Investigation
**When to use:** Check if someone's information is leaked
**What to enter:** john.doe@company.com
**What you'll find:**
- Social media accounts
- Data breaches involving this person
- Public records
- Associated phone numbers

### IP Address Investigation
**When to use:** Check if an IP address is malicious
**What to enter:** 192.168.1.1
**What you'll find:**
- Reputation information
- Associated domains
- Geolocation data
- Security history

### Threat Hunting
**When to use:** Look for specific threats
**What to enter:** Known bad domain or IP
**What you'll find:**
- Threat intelligence reports
- Malware connections
- Attack patterns
- Related indicators

## Understanding Scan Results

### Data Types Explained

**Green Results:** Good information (safe)
- Valid email addresses
- Legitimate websites
- Proper SSL certificates
- Clean reputation scores

**Yellow Results:** Interesting information (investigate)
- New subdomains discovered
- Unusual network configurations
- Expired certificates
- Moderate risk indicators

**Red Results:** Dangerous information (urgent)
- Leaked credentials
- Malicious IP addresses
- Data breaches
- High-risk vulnerabilities

### Reading the Results Page
1. **Summary:** Shows total findings by category
2. **Browse:** Lets you filter results by type
3. **Graph:** Shows connections between findings
4. **Export:** Saves results to files

## Common Use Cases

### Security Assessment
**Goal:** Find security problems before attackers do

**Steps:**
1. Scan your main domain
2. Look for exposed services
3. Check for leaked credentials
4. Review SSL certificate issues
5. Fix problems found

### Dark Web Monitoring
**Goal:** See if your data is being sold online

**Steps:**
1. Use your company name as target
2. Enable dark web modules
3. Look for credential leaks
4. Check for data breach mentions
5. Alert affected users

### Threat Intelligence
**Goal:** Learn about attackers targeting you

**Steps:**
1. Enter suspicious IP addresses
2. Scan domains from phishing emails
3. Look for threat actor connections
4. Share findings with security team
5. Update security controls

### Employee Security Training
**Goal:** Show staff how much information is public

**Steps:**
1. Scan employee email addresses (with permission)
2. Show social media exposure
3. Demonstrate data breach risks
4. Train on privacy settings
5. Create security awareness

## Setting Up Automated Scans

### Scheduled Monitoring
1. Go to "Settings" → "Schedules"
2. Create new schedule
3. Set scan frequency (daily/weekly)
4. Choose targets to monitor
5. Enable email alerts

### API Integration
1. Go to "Settings" → "API"
2. Generate API key
3. Use with other security tools
4. Automate threat hunting
5. Feed results to MISP or IRIS

## Best Practices

### Start Small
- Begin with one domain
- Use basic modules first
- Learn what results mean
- Gradually add more targets

### Respect Privacy
- Only scan what you own
- Get permission for employee scans
- Follow company policies
- Respect rate limits

### Regular Monitoring
- Set up weekly scans
- Monitor for new exposures
- Track changes over time
- Act on critical findings

### Share Results Safely
- Remove sensitive information
- Use secure communication
- Limit access to findings
- Document remediation actions

## Integration with Other OSSOP Tools

### With MISP (Threat Intelligence)
**How to connect:**
1. Export SpiderFoot results as JSON
2. Import into MISP as indicators
3. Share with threat intel community
4. Create alerts for future matches

### With IRIS (Case Management)
**How to connect:**
1. Create IRIS case for investigations
2. Attach SpiderFoot reports as evidence
3. Track remediation progress
4. Document lessons learned

### With Shuffle (Automation)
**How to connect:**
1. Use SpiderFoot API in workflows
2. Automate scans of new domains
3. Create alerts for high-risk findings
4. Trigger incident response processes

## Troubleshooting Common Issues

### Scan Takes Too Long
**Problem:** Scans run for hours without finishing
**Solutions:**
- Reduce number of modules
- Set shorter timeouts
- Use more specific targets
- Check internet connection

### No Results Found
**Problem:** Scan completes but finds nothing
**Solutions:**
- Verify target is correct
- Check if target exists online
- Try different modules
- Look at scan logs for errors

### Too Many False Positives
**Problem:** Results show many incorrect findings
**Solutions:**
- Review module settings
- Adjust confidence thresholds
- Filter results by reliability
- Focus on high-confidence findings

### Service Not Responding
**Problem:** SpiderFoot won't load or crashes
**Solutions:**
- Check if container is running: `docker compose ps spiderfoot`
- View logs: `docker compose logs spiderfoot`
- Restart service: `docker compose restart spiderfoot`
- Check available disk space

## Security Considerations

### Protect Your Results
- Scan results contain sensitive information
- Limit access to authorized personnel
- Use secure storage for exports
- Delete old scans regularly

### Network Security
- SpiderFoot makes many internet requests
- Monitor for suspicious activity
- Use VPN if needed for anonymity
- Be aware of rate limiting

### Legal Compliance
- Only scan targets you own or have permission to scan
- Follow local privacy laws
- Respect website terms of service
- Document authorization for scans

## Getting Help

### Built-in Documentation
- Click "Help" in the top menu
- Check module descriptions
- Review scan options
- Look at example targets

### Community Support
- SpiderFoot GitHub repository
- Security community forums
- Online tutorials and guides
- Professional training courses

### OSSOP Integration Help
- Check other tool documentation
- Use Shuffle for automation
- Store results in MISP
- Create cases in IRIS

Remember: SpiderFoot is a powerful tool that can find sensitive information. Always use it responsibly and protect the data you discover. Start with small scans and learn what different results mean before running large investigations.

# Shuffle - Security Automation Made Simple

## What is Shuffle?

Shuffle is like having a robot assistant for your security team. It watches for security alerts and automatically takes action - like blocking bad IP addresses, sending alerts, or starting investigations. Think of it as setting up "if this happens, then do that" rules for your security tools.

**Access:** http://localhost:80  
**Login:** Setup required on first visit

## What Can Shuffle Do?

### Automate Responses
- Block malicious IP addresses automatically
- Send alerts to security team
- Create tickets in other systems
- Gather additional information about threats

### Connect Different Tools
- Make your security tools work together
- Share information between systems
- Reduce manual copy-paste work
- Create unified security workflows

### Speed Up Investigations
- Automatically collect evidence
- Run standard checks on alerts
- Enrich threat data with context
- Generate investigation reports

### Reduce Human Error
- Follow the same steps every time
- Never forget important checks
- Work 24/7 without breaks
- Document all actions taken

## Getting Started

### Step 1: Initial Setup
1. Open your web browser
2. Go to http://localhost:80
3. Create your first admin account:
   - Username: Choose something secure
   - Password: Use a strong password
   - Email: Your work email address
4. Click "Register" to create account

### Step 2: Explore the Interface
1. **Workflows:** Your automation rules
2. **Apps:** Tools you can connect to
3. **Triggers:** Events that start automations
4. **Actions:** Things Shuffle can do
5. **Executions:** History of what happened

### Step 3: Create Your First Workflow
1. Click "New Workflow"
2. Give it a clear name like "Block Bad IPs"
3. Drag and drop components to build your automation
4. Connect the pieces together
5. Test your workflow

## Understanding Shuffle Concepts

### Workflows
**What they are:** Step-by-step automation instructions
**Example:** "When we get a malware alert, check if the IP is known bad, then block it"
**Parts:**
- Trigger: What starts the workflow
- Actions: What steps to take
- Conditions: When to do different things

### Apps
**What they are:** Connections to other security tools
**Examples:**
- Email systems
- Firewalls
- Threat intelligence feeds
- Case management systems
- Cloud services

### Triggers
**What they are:** Events that start workflows
**Types:**
- Webhook: When another system sends data
- Schedule: At specific times
- Email: When you receive certain emails
- Manual: When you click a button

### Variables
**What they are:** Information that flows through workflows
**Examples:**
- IP addresses from alerts
- Email addresses from investigations
- File hashes from malware
- Threat scores from analysis

## Building Your First Workflow

### Simple Alert Workflow
**Goal:** Send email when high-priority alert comes in

**Steps:**
1. Create new workflow called "High Priority Alerts"
2. Add webhook trigger (this receives alerts)
3. Add condition to check alert priority
4. Add email action for high-priority alerts
5. Test with sample data
6. Activate workflow

**Components needed:**
- **Trigger:** Webhook
- **Condition:** Check if priority = "High"
- **Action:** Send Email
- **Connection:** Link trigger → condition → email

### IP Blocking Workflow
**Goal:** Automatically block malicious IP addresses

**Steps:**
1. Create workflow called "Auto Block IPs"
2. Add trigger for threat intelligence updates
3. Add action to check IP reputation
4. Add condition for malicious IPs
5. Add firewall blocking action
6. Add logging action

### Investigation Enrichment
**Goal:** Automatically gather information about threats

**Steps:**
1. Create workflow called "Threat Enrichment"
2. Add trigger for new incidents
3. Add multiple information gathering actions:
   - WHOIS lookup
   - Threat intelligence check
   - Geolocation lookup
   - Related domains search
4. Add action to update incident with findings

## Common Use Cases

### Incident Response Automation
**Goal:** Speed up response to security incidents

**Workflows to create:**
- Automatic evidence collection
- Stakeholder notification
- Initial containment actions
- Case creation in IRIS
- Threat hunting queries

### Threat Intelligence Processing
**Goal:** Automatically process and distribute threat data

**Workflows to create:**
- Import threat feeds into MISP
- Validate and score indicators
- Push indicators to security tools
- Create alerts for high-confidence threats
- Generate threat reports

### Phishing Response
**Goal:** Quickly respond to phishing attacks

**Workflows to create:**
- Analyze suspicious emails
- Block malicious URLs/IPs
- Notify affected users
- Update security controls
- Generate phishing reports

### Vulnerability Management
**Goal:** Automate vulnerability handling

**Workflows to create:**
- Import scan results into DefectDojo
- Prioritize vulnerabilities by risk
- Create tickets for high-priority items
- Track remediation progress
- Generate compliance reports

## Integration with Other OSSOP Tools

### With MISP (Threat Intelligence)
**What you can do:**
- Automatically import new indicators
- Create events from security alerts
- Share validated threats with community
- Block known bad indicators

**Example workflow:**
1. Trigger: New MISP indicator
2. Action: Check if indicator is in our network
3. Condition: If found, create high-priority alert
4. Action: Block indicator at firewall
5. Action: Create incident in IRIS

### With IRIS (Case Management)
**What you can do:**
- Create cases from security alerts
- Update case status automatically
- Assign cases to team members
- Generate investigation reports

**Example workflow:**
1. Trigger: High-priority security alert
2. Action: Create new IRIS case
3. Action: Gather initial evidence
4. Action: Assign to on-call analyst
5. Action: Send notification to team

### With SpiderFoot (Intelligence Gathering)
**What you can do:**
- Trigger scans based on alerts
- Process SpiderFoot results
- Create alerts for concerning findings
- Feed results to other tools

**Example workflow:**
1. Trigger: New domain in phishing alert
2. Action: Start SpiderFoot scan of domain
3. Action: Wait for scan completion
4. Action: Check results for threats
5. Action: Block domain if malicious

### With OpenSearch (SIEM)
**What you can do:**
- Query logs for investigation
- Create alerts based on patterns
- Export evidence for cases
- Generate security reports

**Example workflow:**
1. Trigger: Malware detection alert
2. Action: Query OpenSearch for related events
3. Action: Collect affected systems list
4. Action: Check for lateral movement
5. Action: Create containment recommendations

## Best Practices

### Start Simple
- Begin with basic workflows
- Test each step carefully
- Add complexity gradually
- Document what each workflow does

### Error Handling
- Add checks for failed actions
- Create backup notification methods
- Log all workflow executions
- Plan for system outages

### Security Considerations
- Use secure authentication
- Limit workflow permissions
- Encrypt sensitive data
- Audit workflow changes

### Maintenance
- Review workflows monthly
- Update as tools change
- Remove unused workflows
- Keep documentation current

## Troubleshooting Common Issues

### Workflow Won't Start
**Problem:** Trigger isn't working
**Solutions:**
- Check trigger configuration
- Verify webhook URLs are correct
- Test with manual execution
- Check authentication settings
- Review execution logs

### Actions Fail
**Problem:** Workflow steps don't complete
**Solutions:**
- Verify API credentials are valid
- Check network connectivity
- Review action parameters
- Test actions individually
- Look for rate limiting

### Slow Performance
**Problem:** Workflows take too long
**Solutions:**
- Reduce unnecessary actions
- Use parallel execution where possible
- Optimize API calls
- Add timeout settings
- Monitor system resources

### Missing Data
**Problem:** Variables aren't passing between actions
**Solutions:**
- Check variable mapping
- Verify data formats match
- Test with sample data
- Review execution logs
- Add debugging actions

## Security Considerations

### Access Control
- Use strong authentication
- Limit user permissions
- Regular review access rights
- Enable audit logging
- Monitor for suspicious activity

### API Security
- Use secure API keys
- Rotate credentials regularly
- Limit API permissions
- Monitor API usage
- Encrypt sensitive data

### Workflow Security
- Review workflows for security risks
- Test with non-production data first
- Limit external connections
- Validate all inputs
- Monitor execution logs

## Advanced Features

### Sub-workflows
- Break complex workflows into smaller pieces
- Reuse common automation patterns
- Make maintenance easier
- Improve reliability

### Conditions and Loops
- Add decision-making to workflows
- Process lists of items
- Handle different scenarios
- Create more intelligent automation

### Custom Apps
- Connect to tools not included by default
- Build specific integrations for your environment
- Share apps with the community
- Extend Shuffle's capabilities

## Getting Help

### Built-in Documentation
- Check app descriptions in Shuffle
- Use example workflows as templates
- Review execution logs for errors
- Test actions individually

### Community Resources
- Shuffle GitHub repository
- Community Discord server
- Workflow sharing platform
- Training videos and tutorials

### OSSOP Integration
- Check other tool documentation
- Test integrations in small steps
- Monitor logs across all tools
- Document successful patterns

Remember: Automation is powerful but should be implemented carefully. Start with simple, low-risk workflows and build your confidence before automating critical security processes. Always have manual procedures as backup and monitor automated actions closely.

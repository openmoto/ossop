# IRIS - Incident Response Made Easy

## What is IRIS?

IRIS (Incident Response Investigation System) is like a digital case file for security incidents. It helps you organize investigations, track evidence, manage tasks, and work with your team to solve security problems. Think of it as a detective's notebook that multiple people can use at the same time.

**Access:** http://localhost:8080  
**Login:** Run `docker logs iris-web` to find your login credentials

## What Can IRIS Do?

### Manage Security Cases
- Create cases for security incidents
- Track investigation progress
- Assign tasks to team members
- Set priorities and deadlines
- Document findings and decisions

### Organize Evidence
- Store files, screenshots, and documents
- Link evidence to specific incidents
- Track chain of custody
- Search through evidence quickly
- Export evidence for legal purposes

### Collaborate with Teams
- Share cases with team members
- Add comments and updates
- Assign tasks to specific people
- Get notifications about changes
- Work together on investigations

### Generate Reports
- Create investigation summaries
- Export case information
- Build timeline of events
- Share findings with management
- Document lessons learned

## Getting Started

### Step 1: Find Your Login Credentials
1. Open command prompt or terminal
2. Run this command: `docker logs iris-web`
3. Look for lines that show:
   - Administrator username
   - Administrator password
4. Write down these credentials

### Step 2: First Login
1. Open your web browser
2. Go to http://localhost:8080
3. Use the credentials you found in Step 1
4. Click "Sign In"

### Step 3: Change Default Password
1. Click your username in the top right
2. Select "My Settings"
3. Click "Change Password"
4. Enter a strong new password
5. Save changes

### Step 4: Set Up Your Organization
1. Go to "Administration" → "Organizations"
2. Update your organization details:
   - Name: Your company name
   - Description: Brief description
   - Contact information
3. Save changes

## Understanding IRIS Concepts

### Cases
**What they are:** Individual security incidents you're investigating
**Examples:**
- Malware infection on user's computer
- Suspicious network activity
- Data breach investigation
- Phishing attack response

### Assets
**What they are:** Things involved in the incident
**Examples:**
- Computers and servers
- Network equipment
- User accounts
- Applications and databases
- Files and documents

### IOCs (Indicators of Compromise)
**What they are:** Evidence that something bad happened
**Examples:**
- Malicious IP addresses
- Suspicious file hashes
- Bad email addresses
- Compromised domain names

### Tasks
**What they are:** Things that need to be done during investigation
**Examples:**
- Interview affected users
- Analyze malware samples
- Check system logs
- Update security controls

### Timeline
**What it is:** Chronological record of what happened
**Contains:**
- When events occurred
- What actions were taken
- Who did what
- Evidence collected

## Creating Your First Case

### Step 1: Create New Case
1. Click "Cases" in the main menu
2. Click "New Case" button
3. Fill in case information:
   - **Case Name:** Clear, descriptive title
   - **Description:** What happened and when
   - **Classification:** How sensitive it is
   - **Severity:** How serious the incident is
   - **Status:** Usually start with "Open"

### Step 2: Add Case Details
1. **Customer:** Who was affected
2. **Assets:** What systems are involved
3. **Tags:** Keywords to help find case later
4. **Assigned to:** Who is investigating
5. **Due Date:** When investigation should complete

### Step 3: Document Initial Information
1. Go to "Summary" tab
2. Add detailed description of incident
3. Include how you discovered the problem
4. List what you know so far
5. Note what questions need answers

## Working with Cases

### Adding Assets
**What to include:**
- Affected computers and servers
- Network devices involved
- User accounts compromised
- Applications impacted
- Data that may be affected

**How to add:**
1. Go to "Assets" tab in your case
2. Click "Add Asset"
3. Choose asset type (Computer, User Account, etc.)
4. Fill in details like IP address, hostname
5. Add description of how it's involved

### Managing IOCs
**What to track:**
- Malicious IP addresses
- Suspicious file hashes
- Bad email addresses
- Compromised URLs
- Registry keys changed

**How to add:**
1. Go to "IOCs" tab
2. Click "Add IOC"
3. Select IOC type
4. Enter the indicator value
5. Add description and tags
6. Set TLP (sharing level)

### Creating Tasks
**Types of tasks:**
- Technical analysis (examine logs, analyze malware)
- Communication (notify users, update management)
- Containment (block IPs, disable accounts)
- Recovery (restore systems, update controls)

**How to create:**
1. Go to "Tasks" tab
2. Click "Add Task"
3. Enter task description
4. Assign to team member
5. Set due date and priority
6. Add any notes or requirements

### Building Timeline
**What to include:**
- When incident started
- When it was discovered
- Actions taken by attackers
- Response actions by your team
- Evidence collection activities

**How to add events:**
1. Go to "Timeline" tab
2. Click "Add Event"
3. Set date and time
4. Describe what happened
5. Link to evidence if available
6. Tag with relevant categories

## Common Use Cases

### Malware Incident Response
**Steps to follow:**
1. Create case for malware detection
2. Add affected systems as assets
3. Create tasks for:
   - Isolating infected systems
   - Analyzing malware sample
   - Checking for lateral movement
   - Cleaning infected systems
4. Document timeline of infection
5. Add IOCs discovered during analysis

### Phishing Investigation
**Steps to follow:**
1. Create case for phishing attack
2. Add email details and affected users
3. Create tasks for:
   - Analyzing phishing email
   - Checking who clicked links
   - Blocking malicious URLs
   - Training affected users
4. Document email headers and links as IOCs
5. Track remediation progress

### Data Breach Response
**Steps to follow:**
1. Create high-priority case for breach
2. Add compromised systems and data
3. Create tasks for:
   - Determining scope of breach
   - Notifying stakeholders
   - Preserving evidence
   - Implementing containment
   - Legal and regulatory requirements
4. Maintain detailed timeline
5. Generate reports for management

### Insider Threat Investigation
**Steps to follow:**
1. Create sensitive case with restricted access
2. Add user accounts and systems involved
3. Create tasks for:
   - Reviewing user activity logs
   - Interviewing relevant personnel
   - Analyzing data access patterns
   - Coordinating with HR/Legal
4. Carefully document all evidence
5. Maintain chain of custody

## Integration with Other OSSOP Tools

### With MISP (Threat Intelligence)
**How to connect:**
1. Export IOCs from IRIS cases
2. Import into MISP as threat indicators
3. Share with threat intelligence community
4. Get alerts when IOCs appear elsewhere

**Example workflow:**
- Investigate phishing attack in IRIS
- Extract malicious domains and IPs
- Add to MISP for sharing
- Receive alerts if indicators reappear

### With Shuffle (Automation)
**How to connect:**
1. Use Shuffle to automatically create IRIS cases
2. Update case status based on investigation progress
3. Assign tasks automatically
4. Generate reports on schedule

**Example workflow:**
- Security alert triggers Shuffle workflow
- Shuffle creates IRIS case automatically
- Initial evidence gathering tasks created
- Case assigned to on-call analyst

### With SpiderFoot (Intelligence Gathering)
**How to connect:**
1. Use SpiderFoot findings as case evidence
2. Create tasks for SpiderFoot scans
3. Import results into case timeline
4. Use for threat attribution

**Example workflow:**
- Suspicious domain discovered in investigation
- Create task to scan domain with SpiderFoot
- Import results as evidence in IRIS
- Use findings to identify threat actor

### With OpenSearch (SIEM)
**How to connect:**
1. Link to relevant SIEM queries in cases
2. Export log evidence to IRIS
3. Create tasks for log analysis
4. Build timeline from SIEM data

**Example workflow:**
- Create case for security alert
- Add links to relevant OpenSearch queries
- Export matching logs as evidence
- Build attack timeline from log data

## Best Practices

### Case Management
- Use clear, descriptive case names
- Set appropriate classification levels
- Assign cases to specific team members
- Update status regularly
- Close cases when complete

### Evidence Handling
- Document chain of custody
- Use consistent file naming
- Add detailed descriptions
- Preserve original evidence
- Backup critical evidence

### Team Collaboration
- Add regular case updates
- Use comments for team communication
- Assign specific tasks with deadlines
- Share relevant information promptly
- Document decisions and rationale

### Documentation
- Write clear, factual descriptions
- Include timestamps for all activities
- Use consistent terminology
- Avoid speculation without evidence
- Keep technical and business summaries

## Troubleshooting Common Issues

### Cannot Find Login Credentials
**Problem:** Don't know username/password
**Solutions:**
- Run: `docker logs iris-web | grep -i admin`
- Look for "Administrator" or "admin" in output
- Check for password reset instructions
- Restart service if needed: `docker compose restart iris-web`

### Slow Performance
**Problem:** IRIS loads slowly
**Solutions:**
- Check system resources (RAM, CPU)
- Close unnecessary browser tabs
- Clear browser cache
- Restart IRIS service
- Check database performance

### Cannot Upload Files
**Problem:** File uploads fail
**Solutions:**
- Check file size limits
- Verify file format is allowed
- Check disk space on server
- Try smaller files first
- Review error messages

### Missing Features
**Problem:** Cannot find expected functionality
**Solutions:**
- Check user permissions
- Look in different menu sections
- Update to latest version
- Check administrator settings
- Review user documentation

## Security Considerations

### Access Control
- Use strong passwords for all accounts
- Enable two-factor authentication
- Limit user permissions appropriately
- Regular review user access
- Monitor login attempts

### Data Protection
- Classify cases appropriately
- Limit access to sensitive investigations
- Encrypt sensitive evidence
- Backup case data regularly
- Follow data retention policies

### Evidence Integrity
- Maintain proper chain of custody
- Use digital signatures where required
- Preserve original evidence
- Document all evidence handling
- Follow legal requirements

## Getting Help

### Built-in Help
- Check tooltips and help text in interface
- Review user guide in documentation section
- Use search function to find cases
- Check administrator settings

### Community Resources
- IRIS GitHub repository
- User community forums
- Training materials and guides
- Professional support services

### OSSOP Integration
- Check other tool documentation
- Test integrations with sample data
- Monitor logs for integration issues
- Document successful workflows

Remember: Good incident response depends on thorough documentation and clear communication. Use IRIS to keep your team organized and ensure nothing important gets missed during investigations. The more detail you capture during incidents, the better prepared you'll be for future threats.

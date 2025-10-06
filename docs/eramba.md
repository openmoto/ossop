# Eramba - Risk Management Made Simple

## What is Eramba?

Eramba is like a safety manager for your organization. It helps you find, track, and manage risks that could hurt your business. Think of it as a system that helps you answer questions like "What could go wrong?" and "How do we protect ourselves?" It also helps you follow security rules and regulations.

**Access:** http://localhost:8081  
**Login:** admin / admin

## What Can Eramba Do?

### Manage Business Risks
- Identify what could harm your business
- Measure how likely and serious risks are
- Plan how to reduce or handle risks
- Track progress on risk reduction activities

### Follow Compliance Rules
- Track requirements from laws and regulations
- Monitor compliance with security standards
- Manage audits and assessments
- Generate reports for regulators

### Organize Security Controls
- Document security measures you have in place
- Test if controls are working properly
- Find gaps in your security
- Plan improvements to your defenses

### Create Policies and Procedures
- Write and manage security policies
- Track who has read and agreed to policies
- Schedule regular policy reviews
- Ensure everyone follows the rules

## Getting Started

### Step 1: First Login
1. Open your web browser
2. Go to http://localhost:8081
3. Login with username: `admin` and password: `admin`
4. You'll see the Eramba dashboard

### Step 2: Change Default Password
1. Click "admin" in the top right corner
2. Go to "My Profile"
3. Click "Change Password"
4. Enter a strong new password
5. Save your changes

### Step 3: Set Up Your Organization
1. Go to "Administration" → "Settings"
2. Update organization details:
   - Company name
   - Address and contact information
   - Logo (optional)
3. Configure email settings for notifications
4. Set up user accounts for your team

## Understanding Eramba Concepts

### Risks
**What they are:** Things that could harm your business
**Examples:**
- Cyber attacks on your systems
- Employee accidentally sharing sensitive data
- Natural disasters affecting your office
- Key staff members leaving the company

### Assets
**What they are:** Valuable things your business owns
**Examples:**
- Computer systems and networks
- Customer databases
- Intellectual property
- Physical facilities
- Employee knowledge

### Threats
**What they are:** Sources of potential harm
**Examples:**
- Hackers and cyber criminals
- Disgruntled employees
- Natural disasters
- Equipment failures
- Human errors

### Vulnerabilities
**What they are:** Weaknesses that threats can exploit
**Examples:**
- Unpatched software
- Weak passwords
- Unlocked doors
- Lack of employee training
- Poor backup procedures

### Controls
**What they are:** Security measures to protect against risks
**Examples:**
- Firewalls and antivirus software
- Employee security training
- Access control systems
- Backup and recovery procedures
- Security policies and procedures

## Setting Up Risk Management

### Step 1: Define Your Assets
1. Go to "Risk Management" → "Assets"
2. Click "Add Asset"
3. For each important asset, enter:
   - **Name:** Clear description of the asset
   - **Type:** Information, System, Physical, etc.
   - **Owner:** Person responsible for the asset
   - **Value:** How important it is to your business
   - **Location:** Where the asset is located

### Step 2: Identify Threats
1. Go to "Risk Management" → "Threats"
2. Click "Add Threat"
3. For each potential threat, enter:
   - **Name:** Type of threat (e.g., "Malware Attack")
   - **Description:** Details about the threat
   - **Source:** Where the threat comes from
   - **Motivation:** Why someone would use this threat

### Step 3: Find Vulnerabilities
1. Go to "Risk Management" → "Vulnerabilities"
2. Click "Add Vulnerability"
3. For each weakness, enter:
   - **Name:** Description of the vulnerability
   - **Asset:** What asset has this weakness
   - **Severity:** How serious the vulnerability is
   - **Detection Method:** How you found it

### Step 4: Assess Risks
1. Go to "Risk Management" → "Risks"
2. Click "Add Risk"
3. Connect threats, assets, and vulnerabilities
4. Rate the risk:
   - **Likelihood:** How likely it is to happen
   - **Impact:** How much damage it would cause
   - **Risk Level:** Automatically calculated
5. Assign risk owner and review date

## Managing Security Controls

### Adding Controls
1. Go to "Risk Management" → "Security Controls"
2. Click "Add Control"
3. Enter control information:
   - **Name:** What the control does
   - **Description:** How it works
   - **Type:** Preventive, Detective, or Corrective
   - **Implementation Status:** Planned, In Progress, or Implemented
   - **Owner:** Person responsible for the control

### Control Testing
1. Go to existing control
2. Click "Add Test"
3. Define test details:
   - **Test Name:** What you're testing
   - **Test Method:** How you'll test it
   - **Frequency:** How often to test
   - **Expected Result:** What should happen
4. Schedule regular testing
5. Record test results

### Control Effectiveness
1. Review test results regularly
2. Rate control effectiveness:
   - **Effective:** Working as intended
   - **Partially Effective:** Some issues found
   - **Ineffective:** Not working properly
3. Plan improvements for ineffective controls
4. Update risk assessments based on control status

## Compliance Management

### Setting Up Compliance Packages
1. Go to "Compliance Management" → "Compliance Packages"
2. Click "Add Package"
3. Choose from common standards:
   - ISO 27001 (Information Security)
   - PCI DSS (Payment Card Security)
   - GDPR (Data Protection)
   - SOX (Financial Controls)
   - HIPAA (Healthcare Privacy)

### Mapping Controls to Requirements
1. Open your compliance package
2. For each requirement:
   - Link to existing security controls
   - Add evidence of compliance
   - Set responsible person
   - Schedule regular reviews
3. Track compliance status
4. Generate compliance reports

### Managing Audits
1. Go to "Compliance Management" → "Audits"
2. Create audit for compliance assessment
3. Assign audit team members
4. Define audit scope and timeline
5. Track audit findings and responses
6. Generate audit reports

## Common Use Cases

### Information Security Risk Assessment
**Goal:** Identify and manage IT security risks

**Steps:**
1. List all IT assets (servers, applications, data)
2. Identify cyber threats (malware, hackers, insider threats)
3. Find vulnerabilities (unpatched systems, weak passwords)
4. Assess risks and prioritize by severity
5. Implement controls to reduce high-priority risks
6. Test controls regularly and update assessments

### GDPR Compliance Management
**Goal:** Ensure compliance with data protection regulations

**Steps:**
1. Import GDPR compliance package
2. Map existing privacy controls to requirements
3. Identify gaps in data protection measures
4. Implement missing privacy controls
5. Schedule regular compliance reviews
6. Generate reports for data protection officer

### Business Continuity Planning
**Goal:** Prepare for disruptions to business operations

**Steps:**
1. Identify critical business processes
2. Assess threats to business continuity
3. Plan backup procedures and recovery methods
4. Test business continuity plans regularly
5. Train staff on emergency procedures
6. Update plans based on test results

### Vendor Risk Management
**Goal:** Manage risks from third-party suppliers

**Steps:**
1. List all vendors and suppliers
2. Assess security risks from each vendor
3. Require security controls in contracts
4. Monitor vendor security performance
5. Plan for vendor failures or breaches
6. Regular review and update vendor assessments

## Integration with Other OSSOP Tools

### With DefectDojo (Vulnerability Management)
**How to connect:**
1. Import vulnerability data from DefectDojo
2. Link vulnerabilities to risk assessments
3. Track remediation progress in both systems
4. Generate combined risk and vulnerability reports

**Example workflow:**
- DefectDojo finds critical vulnerability
- Import into Eramba as security risk
- Assess business impact and likelihood
- Plan and track remediation activities

### With IRIS (Incident Management)
**How to connect:**
1. Link security incidents to risk assessments
2. Update risk ratings based on actual incidents
3. Use incident data to improve risk management
4. Track control effectiveness after incidents

**Example workflow:**
- Security incident occurs and tracked in IRIS
- Review related risks in Eramba
- Update risk likelihood based on actual event
- Improve controls to prevent similar incidents

### With MISP (Threat Intelligence)
**How to connect:**
1. Use MISP threat data to update threat assessments
2. Link threat intelligence to specific risks
3. Adjust risk ratings based on current threats
4. Share risk information with threat intel community

**Example workflow:**
- MISP identifies new threat targeting your industry
- Update relevant threat assessments in Eramba
- Reassess risks and control effectiveness
- Plan additional protective measures

### With OpenSearch (SIEM)
**How to connect:**
1. Use SIEM data to validate control effectiveness
2. Monitor for events related to identified risks
3. Generate risk reports using security metrics
4. Track security improvements over time

**Example workflow:**
- Eramba identifies high-risk scenario
- Create OpenSearch queries to monitor for related events
- Use monitoring data to test control effectiveness
- Update risk assessments based on actual data

## Best Practices

### Risk Assessment
- Involve business stakeholders in risk identification
- Use consistent risk rating scales
- Regular review and update risk assessments
- Focus on risks that matter to your business
- Document assumptions and reasoning

### Control Management
- Test controls regularly and systematically
- Fix ineffective controls promptly
- Keep control documentation current
- Train staff on their control responsibilities
- Monitor control performance over time

### Compliance Management
- Start with most critical compliance requirements
- Map controls to multiple standards where possible
- Keep evidence organized and accessible
- Schedule regular compliance reviews
- Prepare for audits continuously, not just before they happen

### Reporting
- Generate reports regularly for management
- Use charts and graphs to show trends
- Focus on actionable information
- Customize reports for different audiences
- Track improvements over time

## Troubleshooting Common Issues

### Slow Performance
**Problem:** Eramba loads slowly or times out
**Solutions:**
- Check system resources (RAM, CPU)
- Archive old risk assessments
- Optimize database performance
- Reduce number of items displayed
- Restart Eramba service if needed

### Cannot Access Features
**Problem:** Menu items or features are missing
**Solutions:**
- Check user permissions and roles
- Verify you're using correct user account
- Review administrator settings
- Clear browser cache
- Try different web browser

### Data Import Problems
**Problem:** Cannot import data from other systems
**Solutions:**
- Check file format requirements
- Verify data structure matches expected format
- Try smaller test imports first
- Review error messages for specific issues
- Contact support with sample data

### Report Generation Fails
**Problem:** Reports don't generate or show errors
**Solutions:**
- Check report parameters and filters
- Verify you have data for the report period
- Try simpler reports first
- Check system resources during report generation
- Review report templates for errors

## Security Considerations

### Access Control
- Use strong passwords for all accounts
- Enable two-factor authentication if available
- Limit access to sensitive risk information
- Regular review user permissions
- Monitor access to confidential data

### Data Protection
- Protect risk assessment information
- Use appropriate classification levels
- Backup Eramba database regularly
- Control who can export sensitive data
- Follow data retention policies

### Information Sharing
- Be careful about sharing risk information
- Use appropriate confidentiality levels
- Limit external access to risk data
- Follow organizational policies for information sharing
- Consider legal requirements for risk disclosure

## Getting Help

### Built-in Documentation
- Check help sections in Eramba interface
- Review user guides and tutorials
- Use search function to find information
- Check administrator documentation

### Community Resources
- Eramba community forums
- User groups and meetups
- Training courses and certifications
- Professional consulting services

### OSSOP Integration
- Check other tool documentation
- Test integrations with sample data
- Monitor logs for integration issues
- Document successful integration patterns

Remember: Risk management is about making smart business decisions, not just following checklists. Use Eramba to understand your real risks and make informed choices about how to protect your organization. Start with the risks that matter most to your business and build your program gradually.

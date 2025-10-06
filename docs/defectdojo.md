# DefectDojo - Vulnerability Management Made Simple

## What is DefectDojo?

DefectDojo is like a health checkup system for your computer applications. It finds security problems (called vulnerabilities) in your software and helps you fix them before bad actors can use them. Think of it as a doctor that examines your applications and tells you what needs to be fixed to stay healthy.

**Access:** http://localhost:8083  
**Login:** admin / admin

## What Can DefectDojo Do?

### Find Security Problems
- Import results from security scanning tools
- Organize vulnerabilities by application
- Show which problems are most dangerous
- Track which issues have been fixed

### Manage Your Applications
- Keep track of all your software projects
- Organize applications by teams or departments
- Set security requirements for each app
- Monitor security progress over time

### Prioritize Fixes
- Rank vulnerabilities by risk level
- Focus on the most dangerous problems first
- Consider business impact in decisions
- Balance security needs with development speed

### Track Progress
- See which vulnerabilities are fixed
- Monitor trends over time
- Generate reports for management
- Measure security improvement

## Getting Started

### Step 1: First Login
1. Open your web browser
2. Go to http://localhost:8083
3. Login with username: `admin` and password: `admin`
4. You'll see the DefectDojo dashboard

### Step 2: Change Default Password
1. Click "admin" in the top right corner
2. Select "Change Password"
3. Enter a strong new password
4. Save your changes

### Step 3: Explore the Interface
1. **Dashboard:** Overview of your security status
2. **Products:** Your applications and projects
3. **Engagements:** Security testing activities
4. **Findings:** Individual security problems found
5. **Reports:** Summaries and metrics

## Understanding DefectDojo Concepts

### Products
**What they are:** Applications or systems you want to secure
**Examples:**
- Web applications
- Mobile apps
- APIs and web services
- Infrastructure components

### Engagements
**What they are:** Security testing activities for a product
**Types:**
- Penetration testing
- Code security reviews
- Vulnerability scans
- Security assessments

### Tests
**What they are:** Specific security tests run during engagements
**Examples:**
- OWASP ZAP web scan
- Nmap network scan
- Static code analysis
- Manual security testing

### Findings
**What they are:** Individual security problems discovered
**Information included:**
- Description of the problem
- Severity level (Critical, High, Medium, Low)
- Steps to reproduce the issue
- Recommendations for fixing it

## Creating Your First Product

### Step 1: Add New Product
1. Click "Products" in the main menu
2. Click "New Product" button
3. Fill in product information:
   - **Name:** Clear name for your application
   - **Description:** What the application does
   - **Product Type:** Web App, Mobile App, etc.
   - **Business Criticality:** How important it is
   - **Platform:** Technology used (Java, .NET, etc.)

### Step 2: Set Product Details
1. **Tags:** Keywords to help organize products
2. **Regulations:** Compliance requirements (PCI, HIPAA, etc.)
3. **Product Manager:** Person responsible for the product
4. **Technical Contact:** Developer or architect
5. **Team Manager:** Team lead or supervisor

### Step 3: Configure Security Settings
1. Set SLA (Service Level Agreement) for fixing vulnerabilities:
   - Critical: Fix within 7 days
   - High: Fix within 30 days
   - Medium: Fix within 90 days
   - Low: Fix within 180 days
2. Enable notifications for new findings
3. Set up automated reporting if needed

## Running Security Tests

### Creating an Engagement
1. Go to your product page
2. Click "New Engagement"
3. Fill in engagement details:
   - **Name:** Type of testing (e.g., "Monthly Web Scan")
   - **Description:** What you're testing
   - **Target Start/End:** When testing occurs
   - **Testing Type:** Interactive, Static Analysis, etc.
4. Add team members who can see results

### Adding Test Results

#### Manual Upload
1. Go to your engagement
2. Click "Add Tests"
3. Choose test type (matches your scanning tool)
4. Upload result file from your security scanner
5. Review and confirm the import

#### Common Scanner Types
- **OWASP ZAP:** Web application security scanner
- **Nmap:** Network port scanner
- **Burp Suite:** Web application testing
- **SonarQube:** Code quality and security
- **Nessus:** Vulnerability scanner

### Importing from Popular Tools

#### OWASP ZAP Integration
1. Run ZAP scan on your web application
2. Export results as XML
3. In DefectDojo, choose "ZAP Scan" test type
4. Upload the XML file
5. Review imported findings

#### Nmap Integration
1. Run Nmap scan: `nmap -sV -oX scan.xml target.com`
2. In DefectDojo, choose "Nmap Scan" test type
3. Upload the XML file
4. Review network vulnerabilities found

## Managing Findings

### Understanding Severity Levels

**Critical:** Immediate threat to security
- Remote code execution vulnerabilities
- SQL injection with data access
- Authentication bypass issues

**High:** Serious security problems
- Cross-site scripting (XSS)
- Privilege escalation issues
- Sensitive data exposure

**Medium:** Important security issues
- Information disclosure
- Missing security headers
- Weak encryption

**Low:** Minor security concerns
- Version disclosure
- Missing security best practices
- Low-impact information leaks

### Triaging Findings
1. **Review:** Look at each finding carefully
2. **Verify:** Confirm the issue is real (not false positive)
3. **Accept Risk:** If fixing would cause business problems
4. **Mark False Positive:** If the finding is incorrect
5. **Assign:** Give to developer or team to fix

### Tracking Remediation
1. **Active:** Issue is confirmed and needs fixing
2. **Verified:** Fix has been tested and confirmed
3. **Out of Scope:** Not applicable to current testing
4. **Risk Accepted:** Business decision to accept risk
5. **False Positive:** Issue was incorrectly identified

## Common Use Cases

### Web Application Security
**Goal:** Find and fix security problems in web apps

**Steps:**
1. Create product for your web application
2. Set up monthly security testing engagement
3. Run OWASP ZAP scans regularly
4. Import results into DefectDojo
5. Track fixing of critical and high issues
6. Generate reports for development team

### API Security Testing
**Goal:** Secure your application programming interfaces

**Steps:**
1. Create product for your API
2. Set up API security testing engagement
3. Use tools like Postman or Burp Suite
4. Import security test results
5. Focus on authentication and authorization issues
6. Track API security improvements

### DevSecOps Integration
**Goal:** Build security into development process

**Steps:**
1. Create products for each development project
2. Set up automated security testing
3. Import results from CI/CD pipeline
4. Set SLA requirements for fixing issues
5. Block deployments with critical issues
6. Generate metrics for development teams

### Compliance Reporting
**Goal:** Show security compliance to auditors

**Steps:**
1. Tag products with relevant regulations
2. Set up regular security assessments
3. Track remediation of compliance issues
4. Generate compliance reports
5. Document security testing activities
6. Maintain evidence for audits

## Integration with Other OSSOP Tools

### With MISP (Threat Intelligence)
**How to connect:**
1. Export DefectDojo findings as indicators
2. Import MISP threat data as context
3. Correlate vulnerabilities with active threats
4. Prioritize fixes based on threat intelligence

**Example workflow:**
- DefectDojo finds SQL injection vulnerability
- Check MISP for active SQL injection campaigns
- Prioritize fix if threat is actively exploited
- Share vulnerability details with security team

### With IRIS (Case Management)
**How to connect:**
1. Create IRIS cases for critical vulnerabilities
2. Track investigation and remediation progress
3. Document evidence of security issues
4. Manage communication with stakeholders

**Example workflow:**
- Critical vulnerability found in production app
- Create IRIS case for incident response
- Track emergency patching activities
- Document lessons learned

### With Shuffle (Automation)
**How to connect:**
1. Automatically import scan results
2. Create tickets for development teams
3. Send notifications for critical findings
4. Update tracking systems automatically

**Example workflow:**
- Security scan completes automatically
- Shuffle imports results into DefectDojo
- Critical findings trigger alerts
- Tickets created in development system

### With OpenSearch (SIEM)
**How to connect:**
1. Export vulnerability data for correlation
2. Monitor for exploitation attempts
3. Alert on attacks against known vulnerabilities
4. Track security improvement metrics

**Example workflow:**
- DefectDojo identifies vulnerable service
- Export vulnerability details to OpenSearch
- Create alerts for attacks on vulnerable ports
- Monitor until vulnerability is fixed

## Best Practices

### Product Organization
- Use clear, consistent naming for products
- Group related applications together
- Set appropriate business criticality levels
- Keep product information current
- Regular review and cleanup

### Testing Strategy
- Test applications regularly (monthly minimum)
- Use multiple types of security testing
- Test before major releases
- Include both automated and manual testing
- Document testing procedures

### Finding Management
- Review all findings promptly
- Verify issues before assigning to teams
- Set realistic fix timelines
- Track progress regularly
- Close findings when verified fixed

### Reporting
- Generate regular security metrics
- Share reports with relevant stakeholders
- Track trends over time
- Celebrate security improvements
- Use data to justify security investments

## Troubleshooting Common Issues

### Import Fails
**Problem:** Cannot import scanner results
**Solutions:**
- Check file format matches scanner type
- Verify file is not corrupted
- Try smaller test files first
- Check DefectDojo logs for errors
- Ensure scanner output is complete

### Slow Performance
**Problem:** DefectDojo loads slowly
**Solutions:**
- Archive old engagements and findings
- Increase system resources if possible
- Optimize database performance
- Limit number of findings displayed
- Use filters to reduce data shown

### False Positives
**Problem:** Scanner reports issues that aren't real
**Solutions:**
- Review findings carefully before assigning
- Mark false positives appropriately
- Tune scanner settings to reduce noise
- Train team on identifying false positives
- Document common false positive patterns

### Missing Notifications
**Problem:** Team not getting alerts about new findings
**Solutions:**
- Check notification settings in user profiles
- Verify email server configuration
- Test with simple notifications first
- Check spam filters
- Use alternative notification methods

## Security Considerations

### Access Control
- Use strong passwords for all accounts
- Enable two-factor authentication
- Limit access to sensitive findings
- Regular review user permissions
- Monitor access to vulnerability data

### Data Protection
- Protect vulnerability information from unauthorized access
- Use HTTPS for all connections
- Backup vulnerability data regularly
- Follow data retention policies
- Encrypt sensitive finding details

### Responsible Disclosure
- Limit access to vulnerability details
- Use appropriate sharing levels
- Follow responsible disclosure practices
- Coordinate with development teams
- Protect information until fixes are deployed

## Getting Help

### Built-in Documentation
- Check help tooltips in interface
- Review product documentation
- Use search function to find information
- Check administrator guides

### Community Resources
- DefectDojo GitHub repository
- Community forums and discussions
- Training materials and tutorials
- Professional support services

### OSSOP Integration
- Check other tool documentation
- Test integrations with sample data
- Monitor logs for integration issues
- Document successful workflows

Remember: Vulnerability management is an ongoing process, not a one-time activity. Use DefectDojo to build a sustainable program that continuously improves your application security. Focus on fixing the most dangerous problems first and track your progress over time.

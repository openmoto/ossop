# OSSOP Security Tools Documentation

Welcome to the OSSOP (Open Source Security Operations Platform) documentation! This guide helps you learn how to use each security tool in your OSSOP environment.

## 📚 Available Guides

### Core Security Tools

#### 🔍 [OpenSearch Dashboards](opensearch-dashboards.md) - Security Command Center
Your main security dashboard that shows what's happening across all your security tools. Use this to:
- Monitor security events in real-time
- Create charts and reports
- Search through security data
- Build custom dashboards for your team

**Access:** http://localhost:5601 (no password needed)

#### 🕷️ [SpiderFoot](spiderfoot.md) - Intelligence Gathering
Find information about threats, people, and organizations from the internet and dark web. Use this to:
- Scan for leaked credentials and data breaches
- Gather intelligence about threat actors
- Monitor your organization's online presence
- Investigate suspicious domains and IP addresses

**Access:** http://localhost:5002 (admin / admin)

#### 🔄 [MISP](misp.md) - Threat Intelligence Sharing
Store and share information about cyber threats with your team and security community. Use this to:
- Document threat indicators (IPs, domains, file hashes)
- Share threat intelligence with other organizations
- Track threat actors and attack campaigns
- Feed threat data to other security tools

**Access:** http://localhost:8082 (admin@admin.test / admin)

#### 🤖 [Shuffle](shuffle.md) - Security Automation
Automate your security responses so your team can focus on important tasks. Use this to:
- Automatically block malicious IP addresses
- Create workflows that respond to alerts
- Connect different security tools together
- Speed up incident response processes

**Access:** http://localhost:80 (setup required on first visit)

#### 📋 [IRIS](iris.md) - Incident Response Management
Organize and track your security investigations from start to finish. Use this to:
- Create cases for security incidents
- Store evidence and investigation notes
- Assign tasks to team members
- Generate investigation reports

**Access:** http://localhost:8080 (run `docker logs iris-web` to find login)

#### 🛡️ [DefectDojo](defectdojo.md) - Vulnerability Management
Find and fix security problems in your applications before attackers can use them. Use this to:
- Import results from security scanning tools
- Track which vulnerabilities need fixing
- Prioritize security problems by risk level
- Generate reports for development teams

**Access:** http://localhost:8083 (admin / admin)

#### 📊 [Eramba](eramba.md) - Risk and Compliance Management
Manage business risks and follow security regulations and standards. Use this to:
- Identify and assess business risks
- Track compliance with security standards
- Manage security controls and policies
- Generate reports for management and auditors

**Access:** http://localhost:8081 (admin / admin)

#### 🎣 [Gophish](gophish.md) - Phishing Simulation & Training
Test and train your users to recognize and report phishing attacks. Use this to:
- Create realistic phishing email campaigns
- Test employee security awareness
- Track who clicks links or submits credentials
- Provide immediate security awareness training

**Access:** http://localhost:3333 (admin / check logs for initial password)

## 🚀 Getting Started

### Super Simple Setup (2 Commands)
```bash
git clone https://github.com/openmoto/ossop.git
cd ossop
./setup.sh        # Linux/Mac
setup.bat         # Windows
```

### Manual Setup
1. **Follow the Setup Guide:** See [SETUP.md](SETUP.md) for complete installation instructions
2. **SpiderFoot:** Will be built automatically by Docker Compose
3. **Start OSSOP:** Run `docker compose up -d` in your OSSOP directory
4. **Wait for services:** Give it 3-5 minutes for everything to start
5. **Change passwords:** Login to each tool and change default passwords
6. **Explore:** Use the guides above to learn each tool

### Quick Access Links
Once OSSOP is running, bookmark these URLs:
- [OpenSearch Dashboards](http://localhost:5601) - Security monitoring
- [SpiderFoot](http://localhost:5002) - Intelligence gathering  
- [MISP](http://localhost:8082) - Threat intelligence
- [Shuffle](http://localhost:80) - Security automation
- [IRIS](http://localhost:8080) - Incident management
- [DefectDojo](http://localhost:8083) - Vulnerability management
- [Eramba](http://localhost:8081) - Risk management
- [Gophish](http://localhost:3333) - Phishing simulation

## 🔄 How Tools Work Together

### Investigation Workflow
1. **OpenSearch Dashboards** detects suspicious activity
2. **IRIS** creates an incident case for investigation
3. **SpiderFoot** gathers intelligence about the threat
4. **MISP** stores and shares threat indicators found
5. **Shuffle** automates response actions
6. **DefectDojo** tracks any vulnerabilities discovered
7. **Eramba** updates risk assessments based on findings

### Daily Security Operations
1. **Morning:** Check OpenSearch Dashboards for overnight alerts
2. **Investigate:** Use IRIS to manage any security incidents
3. **Research:** Use SpiderFoot to gather threat intelligence
4. **Share:** Add findings to MISP for community benefit
5. **Automate:** Use Shuffle to speed up common tasks
6. **Fix:** Track vulnerability remediation in DefectDojo
7. **Report:** Use Eramba for management updates

## 📖 Reading Guide Tips

### For Beginners
1. Start with **OpenSearch Dashboards** to see your security data
2. Learn **IRIS** for basic incident management
3. Try **SpiderFoot** for simple intelligence gathering
4. Gradually add other tools as you gain experience

### For Security Teams
1. Set up **MISP** first for threat intelligence sharing
2. Use **Shuffle** to automate repetitive tasks
3. Implement **DefectDojo** for vulnerability tracking
4. Add **Eramba** for compliance and risk management

### For Management
1. Focus on **OpenSearch Dashboards** for security overview
2. Use **Eramba** reports for risk and compliance status
3. Review **DefectDojo** metrics for application security
4. Check **IRIS** for incident response effectiveness

## 🛠️ Common Tasks

### Setting Up Monitoring
1. Configure data collection in OpenSearch Dashboards
2. Create custom dashboards for your environment
3. Set up alerts for critical security events
4. Share dashboards with your security team

### Investigating Threats
1. Create IRIS case for the investigation
2. Use SpiderFoot to gather threat intelligence
3. Document findings in MISP for sharing
4. Use Shuffle to automate response actions

### Managing Vulnerabilities
1. Import scan results into DefectDojo
2. Prioritize fixes based on risk level
3. Track remediation progress over time
4. Generate reports for development teams

### Compliance Reporting
1. Set up compliance frameworks in Eramba
2. Map security controls to requirements
3. Track control effectiveness over time
4. Generate reports for auditors

## 🆘 Getting Help

### Each Tool's Documentation
Every guide includes:
- Getting started steps
- Common use cases
- Troubleshooting tips
- Integration examples
- Best practices

### Community Resources
- GitHub repositories for each tool
- User forums and communities
- Training materials and videos
- Professional support options

### OSSOP Specific Help
- Check service status: `docker compose ps`
- View service logs: `docker compose logs [service-name]`
- Restart services: `docker compose restart`
- Get help on GitHub issues

## 🔒 Security Best Practices

### Password Management
- Change all default passwords immediately
- Use strong, unique passwords for each tool
- Enable two-factor authentication where available
- Regular review and update access credentials

### Access Control
- Limit user permissions to what's needed
- Regular review who has access to what
- Remove access for former team members
- Monitor for suspicious login activity

### Data Protection
- Classify sensitive security information appropriately
- Backup important security data regularly
- Use secure connections (HTTPS) for all access
- Follow your organization's data handling policies

### Integration Security
- Use secure API keys for tool integrations
- Monitor integration activity for anomalies
- Test integrations in safe environments first
- Document all integration configurations

Remember: These tools are most powerful when used together. Start simple, learn one tool at a time, and gradually build more sophisticated security operations as your team gains experience.

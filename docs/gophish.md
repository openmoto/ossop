# 🎣 Gophish - Phishing Simulation Platform

## 🎯 Purpose
Gophish is an open-source phishing simulation and awareness training platform that helps organizations test their users' security awareness and train them to identify phishing attacks.

## 🌟 Key Features

### Campaign Management
- **Email Templates**: Create realistic phishing email templates
- **Landing Pages**: Design convincing phishing landing pages
- **Target Groups**: Manage lists of users to test
- **Sending Profiles**: Configure email servers for sending campaigns
- **Campaign Tracking**: Monitor who clicked links and submitted data

### Security Testing
- **Phishing Simulations**: Test employee awareness with safe phishing campaigns
- **Credential Harvesting Tests**: See who would submit credentials
- **Attachment Testing**: Test reactions to suspicious attachments
- **Link Analysis**: Track link clicks and user behavior

### Reporting & Analytics
- **Real-time Dashboard**: Monitor campaign progress live
- **Detailed Reports**: Generate reports on user behavior
- **Timeline View**: See exact sequence of user actions
- **Export Options**: Export data for further analysis

## 🚀 Getting Started

### First Time Access
1. Navigate to http://localhost:3333
2. On first launch, check the logs for the initial password:
   ```bash
   docker logs gophish
   ```
3. Look for a line containing: `Please login with the username admin and the password [generated_password]`
4. Login with username `admin` and the generated password
5. **IMPORTANT**: Change the password immediately after first login

### Initial Setup
1. **Change Admin Password**
   - Click on your username (top right)
   - Select "Settings"
   - Change your password to something secure

2. **Configure SMTP Settings**
   - Go to "Sending Profiles"
   - Click "New Profile"
   - Enter your SMTP server details for sending test emails
   - Test the configuration before saving

3. **Set Up Landing Page**
   - Navigate to "Landing Pages"
   - Create a new landing page or import from URL
   - Customize the page to match your testing needs

## 📋 Common Use Cases

### Running a Basic Phishing Test

1. **Create User Group**
   ```
   Users & Groups → New Group
   - Name: Test Group
   - Add email addresses (one per line)
   - Save the group
   ```

2. **Design Email Template**
   ```
   Email Templates → New Template
   - Name: Security Update Required
   - Subject: Urgent: Update Your Password
   - Add convincing but safe content
   - Include {{.URL}} placeholder for tracking link
   ```

3. **Create Landing Page**
   ```
   Landing Pages → New Page
   - Name: Fake Login Page
   - Import site or create custom HTML
   - Enable data capture if testing credential submission
   ```

4. **Configure Sending Profile**
   ```
   Sending Profiles → New Profile
   - Name: Company Mail Server
   - From: security@yourcompany.com
   - Host: smtp.yourcompany.com:587
   - Username/Password: Your SMTP credentials
   ```

5. **Launch Campaign**
   ```
   Campaigns → New Campaign
   - Name: Q4 Security Awareness Test
   - Select Email Template
   - Select Landing Page
   - Select User Group
   - Select Sending Profile
   - Schedule or send immediately
   ```

### Monitoring Campaign Results

1. **Dashboard View**
   - See real-time statistics
   - Track email opens, clicks, and data submissions
   - Monitor campaign timeline

2. **Individual Results**
   - Click on campaign name
   - View detailed user actions
   - See exact timestamps of interactions

3. **Generate Reports**
   - Export results to CSV
   - Create management reports
   - Identify users needing additional training

## 🔧 Configuration

### Email Server Settings

For testing, you can use various SMTP services:

**Gmail (for testing only)**
```
Host: smtp.gmail.com:587
Username: your-email@gmail.com
Password: App-specific password
Use TLS: Yes
```

**Office 365**
```
Host: smtp.office365.com:587
Username: your-email@company.com
Password: Your password
Use TLS: Yes
```

**Local Mail Server**
```
Host: mail.yourcompany.com:25
Username: phishing-test@yourcompany.com
Password: Your password
Use TLS: Depends on your setup
```

### Landing Page Best Practices

1. **Realism**: Make pages look authentic but include disclaimers
2. **Data Capture**: Only capture what's needed for training
3. **Redirects**: Always redirect to training material after submission
4. **SSL Warnings**: Use HTTPS when possible to avoid browser warnings

### Campaign Scheduling

- **Business Hours**: Send during work hours for realistic testing
- **Staggered Sending**: Spread emails over time to avoid detection
- **Follow-up**: Plan training immediately after campaign completion

## 🛡️ Security Considerations

### Ethical Usage
- **Authorization**: Always get written permission before testing
- **Scope**: Only test authorized email addresses
- **Data Handling**: Securely handle any captured data
- **Disclosure**: Inform users about the program (after testing)

### Legal Compliance
- **Consent**: Ensure testing complies with local laws
- **Privacy**: Respect data protection regulations (GDPR, etc.)
- **Documentation**: Keep records of authorization and scope
- **Training Focus**: Emphasize education over punishment

### Technical Security
- **Access Control**: Limit Gophish access to authorized personnel
- **Network Isolation**: Consider network segmentation
- **Data Encryption**: Use HTTPS for all connections
- **Regular Updates**: Keep Gophish updated for security patches

## 🔄 Integration with OSSOP

### Workflow Integration

1. **With MISP**
   - Import phishing indicators from MISP
   - Share successful phishing templates as indicators
   - Track phishing trends across campaigns

2. **With IRIS**
   - Create incident tickets for users who fail tests
   - Track remediation and training completion
   - Document phishing simulation results

3. **With OpenSearch**
   - Send campaign results to OpenSearch for analysis
   - Create dashboards showing phishing trends
   - Correlate with other security events

4. **With DefectDojo**
   - Track phishing susceptibility as a vulnerability
   - Monitor improvement over time
   - Generate compliance reports

## 📊 Reporting & Metrics

### Key Metrics to Track
- **Click Rate**: Percentage who clicked the phishing link
- **Credential Submission**: Users who entered credentials
- **Report Rate**: Users who reported the phishing attempt
- **Time to Click**: How quickly users clicked
- **Repeat Offenders**: Users who fail multiple tests

### Creating Reports

1. **Executive Summary**
   - Overall success/failure rate
   - Comparison to industry benchmarks
   - Trend analysis over time
   - Recommended actions

2. **Department Analysis**
   - Break down results by department
   - Identify high-risk groups
   - Target training recommendations

3. **Individual Reports**
   - Personal performance history
   - Specific training needs
   - Improvement tracking

## 🚨 Troubleshooting

### Common Issues

**Cannot Access Admin Interface**
```bash
# Check if service is running
docker ps | grep gophish

# View logs for errors
docker logs gophish

# Restart service
docker restart gophish
```

**Emails Not Sending**
- Verify SMTP settings in Sending Profile
- Check firewall rules for SMTP ports
- Test with a simple email first
- Review Gophish logs for SMTP errors

**Landing Pages Not Loading**
- Ensure port 8084 is accessible
- Check if landing page HTML is valid
- Verify network connectivity
- Test with a simple HTML page first

**Lost Admin Password**
```bash
# Stop the container
docker stop gophish

# Remove the container (data persists in volume)
docker rm gophish

# Start fresh (will generate new password)
docker-compose up -d gophish

# Check logs for new password
docker logs gophish
```

## 📚 Best Practices

### Campaign Planning
1. **Start Small**: Begin with a pilot group
2. **Vary Difficulty**: Use different sophistication levels
3. **Regular Testing**: Run campaigns quarterly
4. **Immediate Training**: Provide education right after failure
5. **Positive Reinforcement**: Reward users who report phishing

### Template Creation
1. **Current Events**: Use timely topics (tax season, holidays)
2. **Company Branding**: Mimic internal communications
3. **Urgency**: Create sense of urgency without panic
4. **Mobile Testing**: Ensure templates work on mobile devices
5. **Accessibility**: Consider users with disabilities

### Results Handling
1. **Confidentiality**: Keep individual results private
2. **Focus on Education**: Emphasize learning over punishment
3. **Trend Analysis**: Look for patterns and systemic issues
4. **Continuous Improvement**: Adjust program based on results
5. **Success Stories**: Share positive outcomes

## 🔗 Useful Resources

### Documentation
- [Official Gophish Docs](https://docs.getgophish.com/)
- [API Documentation](https://docs.getgophish.com/api-documentation/)
- [User Guide](https://docs.getgophish.com/user-guide/)

### Templates & Examples
- [Phishing Template Examples](https://github.com/gophish/gophish/wiki/Email-Template-Reference)
- [Landing Page Examples](https://github.com/gophish/gophish/wiki/Landing-Page-Reference)

### Training Materials
- Create custom training pages for failed users
- Link to security awareness resources
- Provide immediate feedback on what to look for

## 💡 Tips for Success

1. **Get Buy-in**: Ensure management supports the program
2. **Communicate Purpose**: Explain it's for education, not punishment
3. **Start Gentle**: Begin with obvious phishing attempts
4. **Increase Difficulty**: Gradually make tests more sophisticated
5. **Celebrate Success**: Recognize improvements and vigilant users
6. **Document Everything**: Keep detailed records for compliance
7. **Regular Updates**: Keep templates fresh and relevant
8. **Multi-channel**: Test email, SMS, and voice phishing
9. **Incident Response**: Have a plan for real phishing attacks
10. **Continuous Learning**: Stay updated on latest phishing techniques

Remember: The goal is to improve security awareness and create a security-conscious culture, not to trick or embarrass users!

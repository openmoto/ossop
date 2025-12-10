# Gophish Complete Guide
**Test Your Team's Security Awareness**

Version 1.0 | Last Updated: October 2024

---

## What is Gophish?

Gophish helps you test your employees. It sends fake phishing emails. You see who clicks the links. Then you train them to be safer.

**Why use it?**
- Find out who needs security training
- Teach employees to spot fake emails
- Make your company more secure
- Track improvement over time

**What you'll learn:**
- How to set up Gophish
- How to manage your employee list
- How to create phishing tests
- How to automate everything
- How to read the results

---

## Table of Contents

1. [Important - Two Types of Users](#important---two-types-of-users)
2. [Getting Started](#getting-started)
3. [Azure Cloud Setup](#azure-cloud-setup)
4. [Setting Up Gophish](#setting-up-gophish)
5. [Managing Your Employee List](#managing-your-employee-list)
6. [Creating Phishing Tests](#creating-phishing-tests)
7. [Automation](#automation)
8. [Reading Results](#reading-results)
9. [Advanced Features](#advanced-features)
10. [Fixing Problems](#fixing-problems)

---

## Important - Two Types of Users

**This confuses many people. Read this first!**

Gophish has TWO different types of "users". They are completely different.

**Why is this confusing?**
The menu says "Users & Groups" which makes you think you need to create user accounts for people you're testing. You don't! You just add their email addresses to groups.

### Type 1: Admin Users (Your Security Team)

**Who are they?**
- People on your security team
- People who log into Gophish
- People who create the tests

**Where to manage them:**
- Click your name (top right)
- Click "Settings"
- Click "Users" tab

**Example:**
```
Admin Users (can log into Gophish):
├── jane@company.com (your security team)
├── john@company.com (your security team)
└── security@company.com (your security team)
```

### Type 2: Target Recipients (People You Test)

**Who are they?**
- Your employees
- People who get the fake phishing emails
- They do NOT log into Gophish
- They do NOT need accounts

**Where to manage them:**
- Main menu: "Users & Groups"
- Click "Groups"
- Add their email addresses

**Example:**
```
Target Recipients (get phishing emails):
├── employee1@company.com
├── employee2@company.com
├── employee3@company.com
└── ... (all your employees)
```

**Key Point:** You do NOT create accounts for employees you test. You just add their email addresses to a group.

---

## Getting Started

### What You Need

**Before you start:**
- Docker installed on your computer
- 8GB of RAM
- 50GB of hard drive space

**For email sending (choose one):**

**Option 1: Google SMTP Relay (Simple)**
- ✅ Easy to set up
- ✅ No authentication needed (if domain-based)
- ✅ Good for basic testing
- ❌ Can only send from your domain addresses
- Setup: 10 minutes (one-time Google Admin config)

**Option 2: Gmail API Direct Insertion (Advanced - n8n or Script)**
- ✅ Insert emails directly into mailboxes
- ✅ Can spoof ANY sender address (banks, vendors, etc.)
- ✅ 100% delivery (bypasses spam filters)
- ✅ Most realistic testing
- ✅ Use n8n (visual workflow) OR Python script
- ❌ Requires Google Workspace admin access
- ❌ Not built into Gophish (you build the bridge)
- Setup: 30-60 minutes (one-time)

**Recommendation:** If you have Google Workspace admin access AND n8n, use **Gmail API with n8n** - it gives you much more realistic testing with visual management. Both methods (SMTP and Gmail API) are fully documented in this guide.

### Quick Start (5 Minutes)

**Step 1: Start Gophish**

```bash
cd /path/to/ossop
docker-compose up -d gophish
```

**Step 2: Get Your Password**

```bash
docker logs gophish | grep "Please login"
```

You'll see something like:
```
Please login with the username admin and the password 4a8e2d9f3c1b7e6d
```

**Step 3: Log In**

1. Open your web browser
2. Go to: https://localhost:3333
3. Accept the security warning (it's safe)
4. Username: `admin`
5. Password: (the one from step 2)

**Step 4: Change Your Password**

1. Click your username (top right)
2. Click "Settings"
3. Enter your old password
4. Enter a new strong password
5. Click "Update"

**Done!** Gophish is running.

---

## Azure Cloud Setup

### Why Use Azure?

**Local vs Cloud:**
- **Local**: Good for testing. Admin panel is on your computer.
- **Cloud**: Good for production. Admin panel is private. Landing pages are public.

**Azure Setup:**
- Admin panel: Only accessible from inside your network (secure)
- Landing pages: Public website where employees click links
- Database: Stores all your data
- Costs: About $300 per month

### Azure Setup Steps

#### Step 1: Create Resources (Day 1)

Set your information:
```bash
RESOURCE_GROUP="rg-gophish-prod"
LOCATION="eastus"
ACR_NAME="acrgophish"
DB_PASSWORD="YourSecurePassword123!"  # Change this!
```

Create resource group:
```bash
az group create --name $RESOURCE_GROUP --location $LOCATION
```

Create network:
```bash
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name vnet-gophish \
  --address-prefix 10.0.0.0/16 \
  --subnet-name subnet-private \
  --subnet-prefix 10.0.1.0/24
```

Create database:
```bash
az postgres flexible-server create \
  --resource-group $RESOURCE_GROUP \
  --name psql-gophish \
  --location $LOCATION \
  --admin-user gophishadmin \
  --admin-password "$DB_PASSWORD" \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32 \
  --version 14 \
  --public-access None
```

#### Step 2: Deploy Apps (Day 2)

Create container registry:
```bash
az acr create \
  --resource-group $RESOURCE_GROUP \
  --name $ACR_NAME \
  --sku Basic \
  --admin-enabled true
```

Build and push Docker image:
```bash
# Build Gophish
docker build -t gophish:latest .

# Tag for Azure
docker tag gophish:latest $ACR_NAME.azurecr.io/gophish:latest

# Login and push
az acr login --name $ACR_NAME
docker push $ACR_NAME.azurecr.io/gophish:latest
```

Deploy admin console (private):
```bash
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan plan-gophish-admin \
  --name gophish-admin-console \
  --deployment-container-image-name $ACR_NAME.azurecr.io/gophish:latest
```

Deploy landing pages (public):
```bash
az webapp create \
  --resource-group $RESOURCE_GROUP \
  --plan plan-gophish-phish \
  --name gophish-landing-pages \
  --deployment-container-image-name $ACR_NAME.azurecr.io/gophish:latest
```

#### Step 3: Access Setup (Day 2)

Set up Azure Bastion for secure access:
```bash
az network bastion create \
  --resource-group $RESOURCE_GROUP \
  --name bastion-gophish \
  --public-ip-address pip-bastion \
  --vnet-name vnet-gophish \
  --location $LOCATION
```

**How to access:**
- Admin panel: Through Azure Bastion (secure)
- Landing pages: Direct URL (public)

---

## Setting Up Gophish

### 1. Set Your Phishing URL

This tells Gophish where your fake website is.

**Steps:**
1. Log into Gophish
2. Click your name (top right)
3. Click "Settings"
4. Find "Phish Server Configuration"
5. Enter your URL:
   - Local testing: `http://localhost:80`
   - Azure: `https://gophish-landing-pages.azurewebsites.net`
6. Click "Save"

### 2. Create Email Templates

Email templates are the fake phishing emails you send.

**Steps:**
1. Click "Email Templates" in the menu
2. Click "New Template"
3. Fill in:
   - **Name**: "Password Reset"
   - **Subject**: "Urgent: Your password expires today"
   - **HTML**:
```html
<html>
<body>
    <p>Hello {{.FirstName}},</p>
    <p>Your password will expire in 2 hours.</p>
    <p><a href="{{.URL}}">Click here to reset your password</a></p>
    <p>If you don't reset it, your account will be locked.</p>
    <p>IT Security Team</p>
</body>
</html>
```
4. Click "Save Template"

**Important:** Always include `{{.URL}}` for tracking.

**Variables you can use:**
- `{{.FirstName}}` - Person's first name
- `{{.LastName}}` - Person's last name
- `{{.Email}}` - Person's email
- `{{.Position}}` - Person's job title
- `{{.URL}}` - Tracking link (required!)

### 3. Create Landing Pages

Landing pages are what people see when they click the link.

**Steps:**
1. Click "Landing Pages" in the menu
2. Click "New Page"
3. Fill in:
   - **Name**: "Training Page"
   - **HTML**:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Security Awareness</title>
    <style>
        body {
            font-family: Arial;
            text-align: center;
            padding: 50px;
            background-color: #f0f0f0;
        }
        .warning {
            background-color: #ff9800;
            color: white;
            padding: 20px;
            border-radius: 10px;
            max-width: 600px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="warning">
        <h1>⚠️ This Was a Test</h1>
        <p>You clicked on a fake phishing email.</p>
        <h2>What to Look For:</h2>
        <ul>
            <li>Unexpected emails asking for passwords</li>
            <li>Urgent language</li>
            <li>Suspicious sender addresses</li>
            <li>Strange links</li>
        </ul>
        <p>Always verify unexpected requests!</p>
        <p>Questions? Contact security@company.com</p>
    </div>
</body>
</html>
```
4. Click "Save Page"

### 4. Set Up Email Sending

You need to tell Gophish how to send emails.

**📌 Two Options Available:**
- **SMTP Relay** (documented below) - Simple, good for basic testing
- **Gmail API** ([jump to Gmail API section](#gmail-api-direct-insertion)) - Powerful, can spoof any sender

**Choose SMTP Relay if:** 
- You want quick setup (built into Gophish)
- Sending from your company email is fine
- You're just getting started

**Choose Gmail API if:** 
- You want to spoof emails from banks, vendors, CEOs, etc.
- You need the most realistic testing possible
- You have n8n (visual workflow) OR comfortable with Python
- You want 100% delivery (no spam filtering)

---

**Using Google SMTP Relay:**

**First, set up in Google Admin:**
1. Go to https://admin.google.com
2. Click Apps → Gmail → Routing
3. Find "SMTP relay service"
4. Click "Configure"
5. Settings:
   - Allowed senders: Only registered users
   - Authentication: Required
   - Encryption: Require TLS
6. Click "Save"

**Then, set up in Gophish:**
1. Click "Sending Profiles" in the menu
2. Click "New Profile"
3. Fill in:
   - **Name**: "Google SMTP Relay"
   - **From**: "Security Team <security@yourcompany.com>"
   - **Host**: `smtp-relay.gmail.com:587`
   - **Username**: `security@yourcompany.com`
   - **Password**: (Your Google app password)
   - **Ignore Certificate Errors**: No (unchecked)
4. Click "Send Test Email"
5. Check if the test email arrives
6. Click "Save Profile"

**To get a Google app password:**
1. Go to https://myaccount.google.com/apppasswords
2. Select "Mail" and "Other"
3. Enter name: "Gophish"
4. Click "Generate"
5. Copy the 16-character password

---

## Managing Your Employee List

### Understanding Groups

**What is a group?**
- A list of email addresses
- You use groups when creating tests
- One person can be in multiple groups

**Examples of groups:**
- "All Active Employees"
- "Engineering Department"
- "Finance Team"
- "New Hires October 2024"

### Adding Employees Manually

**Small groups (under 20 people):**

1. Click "Users & Groups" in the menu
2. Click "New Group"
3. Enter group name: "All Active Employees"
4. In the "Bulk Import Users" box, paste:
```csv
First Name,Last Name,Email,Position
John,Smith,john@company.com,Engineer
Jane,Doe,jane@company.com,Manager
Bob,Jones,bob@company.com,Analyst
```
5. Click "Parse"
6. Review the imported people
7. Click "Save"

### Adding Employees from a File

**Large groups (over 20 people):**

1. Create a CSV file called `employees.csv`:
```csv
First Name,Last Name,Email,Position
John,Smith,john@company.com,Engineer
Jane,Doe,jane@company.com,Manager
... (all your employees)
```

2. In Gophish:
   - Click "Users & Groups"
   - Click "New Group"
   - Name: "All Active Employees"
   - Click "Bulk Import Users"
   - Upload `employees.csv`
   - Click "Parse"
   - Click "Save"

### Keeping Your List Updated

**When someone joins:**
1. Add their email to your master list
2. Update the group in Gophish
3. They'll be included in future tests

**When someone leaves:**
1. Remove their email from the group
2. Click "Update Group"
3. They won't get future tests

**Tip:** Keep a master spreadsheet with all employees. Update it weekly. Then update Gophish.

### Automation with n8n

**What is n8n?**
- A tool that automates tasks
- Can sync your employee list automatically
- Connects to your HR system

**Basic setup:**

1. Install n8n:
```bash
docker run -d --name n8n -p 5678:5678 n8nio/n8n
```

2. Open n8n: http://localhost:5678

3. Create a workflow:
   - Trigger: Every Monday at 9 AM
   - Action 1: Get active users from your HR system
   - Action 2: Get Gophish groups
   - Action 3: Compare the lists
   - Action 4: Add new employees to Gophish
   - Action 5: Remove departed employees from Gophish

**This keeps your list always up to date!**

---

## Creating Phishing Tests

### Your First Campaign

**What you need:**
- ✓ Email template created
- ✓ Landing page created
- ✓ Sending profile configured
- ✓ Group with employees added

**Steps:**

1. Click "Campaigns" in the menu
2. Click "New Campaign"
3. Fill in:
   - **Name**: "Weekly Test - Password Reset - Oct 21"
   - **Email Template**: Select "Password Reset"
   - **Landing Page**: Select "Training Page"
   - **URL**: Your landing page address
   - **Sending Profile**: Select "Google SMTP Relay"
   - **Groups**: Select "All Active Employees"
4. Choose when to send:
   - **Now**: Current date and time
   - **Later**: Pick a future date (like Monday at 9 AM)
5. Click "Launch Campaign"

**What happens next:**
- Gophish sends the emails
- Employees who click are tracked
- You see results in real-time
- Employees see the training page

### Campaign Best Practices

**DO:**
- Test during work hours (Tuesday-Thursday, 10 AM - 3 PM)
- Start with easy tests
- Make tests harder over time
- Test regularly (every 2-4 weeks)
- Provide training immediately
- Track who improves

**DON'T:**
- Test on Monday mornings
- Test on Friday afternoons
- Use the same template repeatedly
- Punish people who click
- Share individual results publicly
- Test without permission

### Different Test Difficulty

**Easy (Week 1-2):**
- Obvious spelling mistakes
- Generic greetings ("Dear User")
- Clear red flags
- Purpose: Find people who need training

**Medium (Week 3-6):**
- Realistic looking emails
- Company-specific details
- Fewer obvious mistakes
- Purpose: Test learned behaviors

**Hard (Week 7+):**
- Very realistic
- Targeted to specific roles
- Minimal red flags
- Purpose: Test vigilance

### Tracking Results

**While campaign is running:**

1. Click "Campaigns"
2. Click on your campaign name
3. You'll see:
   - **Total**: How many people
   - **Sent**: How many emails delivered
   - **Opened**: How many people viewed the email
   - **Clicked**: How many people clicked the link ⚠️
   - **Submitted**: How many entered credentials
   - **Reported**: How many reported it as phishing ✓

**Timeline view:**
- Shows exactly when each person clicked
- Useful for identifying who needs training

**Individual results:**
- Click on a person's email
- See all their actions
- See what device they used
- See their location

### Following Up

**For people who clicked:**
1. Don't punish them
2. Send training materials
3. Schedule a training session
4. Test them again in 2 weeks

**For people who reported:**
1. Thank them publicly
2. Recognize good behavior
3. They're doing the right thing!

---

## Automation

### The Problem

**Manual work is hard:**
- Keeping employee lists updated
- Remembering who to test
- Making sure everyone gets tested
- Not testing the same people too much
- Using different email templates

### The Solution

**Automatic testing with tracking:**
- Database tracks who was tested
- Script picks who needs testing
- Different templates for variety
- Nobody gets missed
- Nobody gets over-tested

### Setting Up Automation

#### Step 1: Create Tracking Database

Connect to your Gophish database:
```bash
psql "host=your-db-server user=gophishadmin dbname=gophish"
```

Create tables:
```sql
-- Track testing per person
CREATE TABLE user_test_state (
    email VARCHAR(255) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    total_tests_sent INTEGER DEFAULT 0,
    last_test_date TIMESTAMP,
    next_eligible_date TIMESTAMP,
    templates_sent TEXT[],
    last_template VARCHAR(255)
);

-- Schedule future tests
CREATE TABLE test_queue (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    template_name VARCHAR(255),
    scheduled_date TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending'
);
```

#### Step 2: Create Automation Script

Save this as `auto_test.py`:

```python
#!/usr/bin/env python3
"""
Automatic Phishing Testing
Sends tests fairly to all employees
"""

import psycopg2
import requests
from datetime import datetime, timedelta
import random

# Your settings
DB_HOST = 'your-db-server'
DB_NAME = 'gophish'
DB_USER = 'gophishadmin'
DB_PASS = 'your-password'

GOPHISH_URL = 'https://your-gophish-url'
API_KEY = 'your-api-key'

# Email templates to rotate
TEMPLATES = [
    'Password Reset',
    'HR Policy Update',
    'Package Delivery',
    'Security Alert'
]

def get_users_to_test():
    """Get people who need testing"""
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )
    cursor = conn.cursor()
    
    # Find people who haven't been tested recently
    query = """
        SELECT email, first_name, last_name, templates_sent
        FROM user_test_state
        WHERE is_active = true
        AND (next_eligible_date IS NULL 
             OR next_eligible_date <= NOW())
        ORDER BY total_tests_sent ASC, last_test_date ASC
        LIMIT 200
    """
    cursor.execute(query)
    return cursor.fetchall()

def pick_template(used_templates):
    """Pick a template they haven't seen recently"""
    recent = used_templates[-3:] if used_templates else []
    available = [t for t in TEMPLATES if t not in recent]
    return random.choice(available if available else TEMPLATES)

def create_campaign(emails, template):
    """Create campaign in Gophish"""
    headers = {
        'Authorization': f'Bearer {API_KEY}',
        'Content-Type': 'application/json'
    }
    
    # Create group
    group_data = {
        'name': f'Auto Test {template} - {datetime.now().date()}',
        'targets': emails
    }
    response = requests.post(
        f'{GOPHISH_URL}/api/groups/',
        headers=headers,
        json=group_data
    )
    
    # Create campaign
    campaign_data = {
        'name': f'{template} - {datetime.now().date()}',
        'template': {'name': template},
        'page': {'name': 'Training Page'},
        'smtp': {'name': 'Google SMTP Relay'},
        'url': GOPHISH_URL,
        'groups': [{'name': group_data['name']}]
    }
    response = requests.post(
        f'{GOPHISH_URL}/api/campaigns/',
        headers=headers,
        json=campaign_data
    )
    
    return response.json()

# Main
if __name__ == '__main__':
    users = get_users_to_test()
    
    # Group by template
    by_template = {}
    for email, fname, lname, templates in users:
        template = pick_template(templates or [])
        if template not in by_template:
            by_template[template] = []
        by_template[template].append({
            'email': email,
            'first_name': fname,
            'last_name': lname
        })
    
    # Create campaigns
    for template, people in by_template.items():
        create_campaign(people, template)
        print(f'Created campaign: {template} ({len(people)} people)')
```

#### Step 3: Schedule Daily Runs

**On Linux/Mac:**
```bash
# Edit schedule
crontab -e

# Add line (runs every day at 9 AM)
0 9 * * * /usr/bin/python3 /path/to/auto_test.py
```

**On Windows:**
1. Open Task Scheduler
2. Create Basic Task
3. Name: "Gophish Auto Test"
4. Trigger: Daily at 9:00 AM
5. Action: Start a program
6. Program: `python`
7. Arguments: `C:\path\to\auto_test.py`
8. Finish

**Now it runs automatically every day!**

---

## Reading Results

### Daily Check (5 Minutes)

**Every morning:**

1. Log into Gophish
2. Click "Campaigns"
3. Look at active campaigns
4. Check these numbers:
   - How many clicked? (Should go down over time)
   - How many reported? (Should go up over time)
   - Any errors?
5. Identify people who clicked
6. Schedule training for them

### Weekly Report

**Every Monday, create a report:**

```markdown
# Weekly Phishing Test Report
Week of October 21, 2024

## Summary
- Tests Run: 4
- Emails Sent: 800
- Click Rate: 7.5%
- Change from Last Week: -2.3% (better!)

## This Week's Tests
| Test Name | Sent | Clicked | Rate |
|-----------|------|---------|------|
| Password Reset | 200 | 18 | 9.0% |
| HR Policy | 200 | 12 | 6.0% |
| Package | 200 | 14 | 7.0% |
| Security Alert | 200 | 12 | 6.0% |

## Good News
- Click rate decreased from last week
- 180 people reported the emails (excellent!)
- Engineering department improved 15%

## Concerns
- 3 people clicked all 4 tests (need training)
- Finance department: 12% click rate (above average)

## Actions
- Scheduled training for 56 people who clicked
- Created special training for Finance
- Updated templates based on real threats

## Next Week
- Test Package Delivery scenario
- Test new employees hired in October
- Add new Security Alert template
```

### Monthly Executive Report

**For management, include:**

1. **Overall Trend**
   - Chart showing click rates over time
   - Goal: Downward trend

2. **Department Comparison**
   - Which departments are doing well
   - Which need more training

3. **Cost Savings**
   - Real phishing attacks prevented
   - Cost of one successful attack: $100,000+
   - Cost of testing program: $500/month

4. **Recommendations**
   - Increase testing frequency
   - Add new templates
   - Budget for training materials

### What Good Results Look Like

**Month 1 (Baseline):**
- Click rate: 20-30%
- Report rate: 5-10%
- This is normal for first tests

**Month 3 (After Training):**
- Click rate: 10-15%
- Report rate: 15-25%
- People are learning

**Month 6 (Mature Program):**
- Click rate: 5-10%
- Report rate: 30-40%
- People are vigilant

**Never expect 0% click rate. That's unrealistic.**

---

## Advanced Features

### Gmail API Direct Insertion

**📌 Alternative to SMTP Relay (Custom Integration)**

**Important:** This is NOT a built-in Gophish feature. You build a bridge between Gophish and Gmail API using either:
- **Option A: n8n workflow** (recommended - visual, easy to manage)
- **Option B: Python script** (if you don't have n8n)

**How it works:**
1. Gophish creates the campaign and tracking links (normal)
2. Your n8n workflow (or Python script) gets the recipient list from Gophish API
3. Your workflow inserts emails directly into mailboxes using Gmail API
4. Gophish still tracks clicks and results (normal)

**What you get:**
- Can spoof ANY sender address (banks, vendors, CEO, anyone!)
- 100% delivery guarantee (bypasses all spam filters)
- More realistic testing than SMTP
- Still uses Gophish for tracking and reporting

**Why use it?**
- Test emails that look like they're from banks
- Test CEO impersonation
- Bypass spam filters
- Test real-world scenarios

**How to set it up:**

**Step 1: Enable Gmail API (One-time)**

1. **Enable Gmail API:**
   - Go to https://console.cloud.google.com
   - Create new project: "Gophish Gmail Integration"
   - Enable Gmail API
   - Create service account
   - Download service account key (JSON file)

2. **Domain-wide delegation:**
   - Go to https://admin.google.com
   - Security → API Controls → Domain-wide Delegation
   - Add your service account Client ID
   - Grant scope: `https://www.googleapis.com/auth/gmail.insert`
   - Save

**Step 2: Choose Your Method**

---

#### Option A: n8n Workflow (Recommended)

**Why n8n?**
- Visual workflow (no coding)
- Easy to modify
- Built-in error handling
- Team can see and manage it

**n8n Workflow:**

```json
{
  "name": "Gophish Gmail API Insertion",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "gophish-insert",
        "responseMode": "responseNode"
      },
      "name": "Webhook - Trigger from Gophish",
      "type": "n8n-nodes-base.webhook",
      "position": [250, 300]
    },
    {
      "parameters": {
        "url": "={{ $env.GOPHISH_URL }}/api/campaigns/{{ $json.campaign_id }}/results",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "httpHeaderAuth": "gophishAuth"
      },
      "name": "Get Campaign Recipients from Gophish",
      "type": "n8n-nodes-base.httpRequest",
      "position": [450, 300]
    },
    {
      "parameters": {
        "authentication": "serviceAccount",
        "resource": "message",
        "operation": "insert",
        "userId": "={{ $json.email }}",
        "message": "={{ $json.emailContent }}",
        "options": {
          "internalDateSource": "dateHeader"
        }
      },
      "name": "Insert Email via Gmail API",
      "type": "n8n-nodes-base.gmail",
      "position": [650, 300]
    },
    {
      "parameters": {
        "jsCode": "// Build email content with tracking\nconst recipient = $input.item.json;\nconst trackingUrl = `${$env.GOPHISH_URL}?rid=${recipient.id}`;\n\n// Get template from webhook data\nconst template = $node['Webhook - Trigger from Gophish'].json.template;\nconst sender = $node['Webhook - Trigger from Gophish'].json.spoofed_sender;\n\n// Replace variables in template\nlet emailBody = template.html\n  .replace('{{.FirstName}}', recipient.first_name)\n  .replace('{{.LastName}}', recipient.last_name)\n  .replace('{{.Email}}', recipient.email)\n  .replace('{{.URL}}', trackingUrl);\n\n// Build email message\nconst message = `From: ${sender}\nTo: ${recipient.email}\nSubject: ${template.subject}\nContent-Type: text/html\n\n${emailBody}`;\n\nreturn {\n  email: recipient.email,\n  emailContent: Buffer.from(message).toString('base64').replace(/\\+/g, '-').replace(/\\//g, '_')\n};"
      },
      "name": "Build Email with Tracking",
      "type": "n8n-nodes-base.code",
      "position": [550, 300]
    },
    {
      "parameters": {
        "channel": "#security-ops",
        "text": "=✓ Inserted {{ $json.count }} phishing emails via Gmail API\nCampaign: {{ $json.campaign_name }}\nSpoofed sender: {{ $json.spoofed_sender }}"
      },
      "name": "Notify Team",
      "type": "n8n-nodes-base.slack",
      "position": [850, 300]
    }
  ],
  "connections": {
    "Webhook - Trigger from Gophish": {
      "main": [[{"node": "Get Campaign Recipients from Gophish"}]]
    },
    "Get Campaign Recipients from Gophish": {
      "main": [[{"node": "Build Email with Tracking"}]]
    },
    "Build Email with Tracking": {
      "main": [[{"node": "Insert Email via Gmail API"}]]
    },
    "Insert Email via Gmail API": {
      "main": [[{"node": "Notify Team"}]]
    }
  }
}
```

**How to use:**

1. **Import workflow into n8n:**
   - Open n8n: http://localhost:5678
   - Click "Import from File"
   - Paste the JSON above
   - Save

2. **Configure credentials:**
   - Gmail node: Add service account JSON
   - Gophish HTTP Auth: Add API key
   - Slack (optional): Add webhook URL

3. **Trigger from Gophish:**
   - Create campaign in Gophish (set SMTP to "dummy")
   - Call n8n webhook with campaign details:
   ```bash
   curl -X POST http://localhost:5678/webhook/gophish-insert \
     -H "Content-Type: application/json" \
     -d '{
       "campaign_id": 123,
       "campaign_name": "Fake PayPal Test",
       "spoofed_sender": "security@paypal.com",
       "template": {
         "subject": "Urgent: Verify your account",
         "html": "<p>Hello {{.FirstName}}, click here: {{.URL}}</p>"
       }
     }'
   ```

4. **n8n inserts emails into mailboxes:**
   - Gets recipient list from Gophish
   - Builds emails with tracking links
   - Inserts into each mailbox
   - Notifies your team

**Benefits of n8n approach:**
- ✅ No Python coding needed
- ✅ Visual workflow anyone can understand
- ✅ Easy to modify sender/template
- ✅ Built-in error handling and retry
- ✅ Logs all activity
- ✅ Can trigger from webhooks or schedule

---

#### Option B: Python Script

```python
from google.oauth2 import service_account
from googleapiclient.discovery import build
import base64

def insert_email(user_email, sender, subject, body):
    """Insert email directly into mailbox"""
    
    # Load credentials
    credentials = service_account.Credentials.from_service_account_file(
        'service-account-key.json',
        scopes=['https://www.googleapis.com/auth/gmail.insert'],
        subject=user_email  # Impersonate this user
    )
    
    # Build service
    service = build('gmail', 'v1', credentials=credentials)
    
    # Create message
    message = f"""From: {sender}
To: {user_email}
Subject: {subject}

{body}
"""
    
    # Encode
    raw = base64.urlsafe_b64encode(message.encode()).decode()
    
    # Insert
    service.users().messages().insert(
        userId='me',
        body={'raw': raw}
    ).execute()
    
    print(f'Inserted email to {user_email} from {sender}')

# Example: Fake PayPal email
insert_email(
    user_email='employee@company.com',
    sender='security@paypal.com',  # Spoofed!
    subject='Urgent: Verify your account',
    body='Your PayPal account needs verification...'
)
```

**Security note:** Get written permission before using this. It's very powerful.

### Testing Different Groups

**Create specialized tests:**

**For Finance team:**
- Test: CEO asking for wire transfer
- Template: Executive request
- Difficulty: Hard
- Frequency: Monthly

**For IT team:**
- Test: Fake tech support
- Template: System upgrade
- Difficulty: Hard
- Frequency: Monthly

**For everyone else:**
- Test: General phishing
- Template: Rotate through all
- Difficulty: Medium
- Frequency: Every 2 weeks

**For new employees:**
- Test: Easy scenarios
- Week 1: Very obvious test (baseline)
- Week 4: Medium difficulty
- Week 8: Harder test
- Week 12: Same as everyone else

### Custom Domains

**Make it more realistic:**

Instead of: `https://gophish-landing-pages.azurewebsites.net`

Use: `https://secure-login.yourcompany.com`

**How to set up:**

1. Buy a domain similar to yours:
   - `yourcompany-secure.com`
   - `secure-yourcompany.com`
   - `portal-yourcompany.com`

2. Point it to your Azure app:
   ```bash
   az webapp config hostname add \
     --resource-group rg-gophish-prod \
     --webapp-name gophish-landing-pages \
     --hostname secure-login.yourcompany.com
   ```

3. Add SSL certificate:
   ```bash
   az webapp config ssl bind \
     --resource-group rg-gophish-prod \
     --name gophish-landing-pages \
     --certificate-thumbprint auto \
     --ssl-type SNI
   ```

**This makes tests much more realistic!**

---

## Fixing Problems

### Problem: Emails Not Sending

**Symptoms:**
- Campaign shows "Queued"
- No emails in inboxes
- Timeline shows no "Sent" events

**Check these:**

1. **Test your SMTP settings:**
   - Go to Sending Profiles
   - Click on your profile
   - Click "Send Test Email"
   - Did it arrive?

2. **Check your SMTP password:**
   - Google app passwords expire
   - Generate a new one
   - Update the sending profile

3. **Check for errors:**
   ```bash
   docker logs gophish | grep -i error
   ```

4. **Test SMTP connection:**
   ```bash
   telnet smtp-relay.gmail.com 587
   ```
   Should connect. If not, firewall is blocking.

**Fix:**
- Update SMTP password
- Check firewall rules
- Try different SMTP server

### Problem: Landing Page Not Loading

**Symptoms:**
- Click link shows error
- "Page not found"
- Connection timeout

**Check these:**

1. **Test the URL directly:**
   - Copy the landing page URL
   - Paste in browser
   - Does it load?

2. **Check Gophish is running:**
   ```bash
   docker ps | grep gophish
   ```
   Should show gophish running.

3. **Restart Gophish:**
   ```bash
   docker restart gophish
   ```

**Fix:**
- Make sure Gophish is running
- Check the URL is correct
- Check firewall allows port 80

### Problem: Can't Access Admin Panel

**Symptoms:**
- https://localhost:3333 won't load
- Connection refused
- Timeout

**Check these:**

1. **Is Gophish running?**
   ```bash
   docker ps | grep gophish
   ```

2. **Is the port correct?**
   ```bash
   docker logs gophish | grep "listening"
   ```
   Should show port 3333.

3. **Try from the command line:**
   ```bash
   curl -k https://localhost:3333
   ```
   Should return HTML.

**Fix:**
- Restart Gophish
- Check firewall
- Make sure you're using https:// not http://

### Problem: Forgot Admin Password

**Solution 1: Check logs (if first time):**
```bash
docker logs gophish | grep "Please login"
```

**Solution 2: Reset via database:**
```bash
# Access database
docker exec -it gophish sh
sqlite3 gophish.db

# See users
SELECT username FROM users;

# You need to generate a new password hash externally
# Then update it
# (This is advanced - easier to recreate container)
```

**Solution 3: Recreate container:**
```bash
docker stop gophish
docker rm gophish
docker-compose up -d gophish
docker logs gophish | grep "Please login"
```

### Problem: People Not Getting Emails

**Possible causes:**

1. **Spam filter:**
   - Check spam folders
   - Check email logs in Google Admin

2. **Wrong email addresses:**
   - Verify email addresses in group
   - Check for typos

3. **Email bounced:**
   - Check campaign timeline
   - Look for "Error" status

**Fix:**
- Add to safe senders list
- Verify email addresses
- Check Google email logs

### Getting More Help

**Steps:**

1. Check this guide
2. Check Gophish logs:
   ```bash
   docker logs gophish --tail 100
   ```
3. Search GitHub issues:
   - https://github.com/gophish/gophish/issues
4. Post in forums:
   - Include: What you're trying to do
   - Include: Error messages
   - Include: What you already tried

---

## Quick Reference

### Common Commands

```bash
# Start Gophish
docker-compose up -d gophish

# Stop Gophish
docker-compose stop gophish

# Restart Gophish
docker restart gophish

# View logs
docker logs gophish

# Follow logs (live)
docker logs -f gophish

# Get initial password
docker logs gophish | grep "Please login"

# Check if running
docker ps | grep gophish

# Backup database
docker cp gophish:/opt/gophish/gophish.db ./backup/
```

### Campaign Checklist

Before launching:
- [ ] Email template created
- [ ] Landing page created
- [ ] Sending profile tested
- [ ] Group has email addresses
- [ ] Campaign name is descriptive
- [ ] Launch time is during work hours
- [ ] You have permission to test
- [ ] Training materials ready

### Monthly Tasks

**Week 1:**
- [ ] Review last month's results
- [ ] Create new email template
- [ ] Update employee list
- [ ] Plan this month's tests

**Week 2:**
- [ ] Launch first campaign
- [ ] Monitor results daily
- [ ] Provide training for clickers

**Week 3:**
- [ ] Launch second campaign
- [ ] Monitor results daily
- [ ] Follow up with repeat clickers

**Week 4:**
- [ ] Generate monthly report
- [ ] Update templates based on real threats
- [ ] Plan next month

### Email Templates Library

**Easy templates:**
1. Password expiration
2. HR policy update
3. IT system upgrade
4. Company announcement

**Medium templates:**
1. Package delivery
2. Security alert
3. Account verification
4. Meeting invitation

**Hard templates:**
1. CEO request (for Finance)
2. Vendor invoice
3. Legal notice
4. Partner communication

### Quick Troubleshooting

| Problem | Quick Fix |
|---------|-----------|
| Emails not sending | Check SMTP password |
| Landing page error | Restart Gophish |
| Can't log in | Check password, restart Gophish |
| Forgot password | Check logs or recreate container |
| Campaign stuck | Check database, restart Gophish |

---

## Appendix: Complete Setup Checklist

### First Time Setup

**Day 1: Installation (2 hours)**
- [ ] Install Docker
- [ ] Start Gophish
- [ ] Get initial password
- [ ] Log in
- [ ] Change password
- [ ] Create first admin user for your teammate

**Day 2: Configuration (3 hours)**
- [ ] Set phish server URL
- [ ] Configure Google SMTP relay
- [ ] Create first email template
- [ ] Create first landing page
- [ ] Test sending profile

**Day 3: First Test (2 hours)**
- [ ] Create employee group (start with 10 people)
- [ ] Create test campaign
- [ ] Launch to small group
- [ ] Monitor results
- [ ] Verify everything works

**Day 4: Scale Up (2 hours)**
- [ ] Add all employees to groups
- [ ] Create 3 more email templates
- [ ] Create 2 more landing pages
- [ ] Launch first real campaign
- [ ] Set up monitoring

**Day 5: Automation (4 hours)**
- [ ] Set up tracking database
- [ ] Create automation script
- [ ] Test automation
- [ ] Schedule daily runs
- [ ] Document your process

### Production Checklist

**Before going live:**
- [ ] Get written permission from management
- [ ] Inform legal/HR departments
- [ ] Document your testing policy
- [ ] Train security team on Gophish
- [ ] Test with small group first
- [ ] Have training materials ready
- [ ] Set up reporting process
- [ ] Plan quarterly review

**Security checklist:**
- [ ] Change default password
- [ ] Create unique API keys
- [ ] Limit admin access
- [ ] Enable logging
- [ ] Set up backups
- [ ] Document procedures
- [ ] Have incident response plan

---

## Summary

**Key Takeaways:**

1. **Gophish helps test your employees** by sending fake phishing emails

2. **Two types of "users":**
   - Admin users: Your security team (they log in)
   - Target recipients: Employees you test (just email addresses)

3. **Basic workflow:**
   - Create email templates
   - Create landing pages
   - Add employees to groups
   - Launch campaigns
   - Track results
   - Provide training

4. **Automation is key:**
   - Keeps employee lists updated
   - Ensures fair testing
   - Rotates templates
   - Saves time

5. **Focus on improvement:**
   - Don't punish people who click
   - Provide immediate training
   - Track progress over time
   - Celebrate improvements

6. **Regular testing works:**
   - Test every 2-4 weeks
   - Start easy, get harder
   - Use different scenarios
   - Keep it realistic

**Remember:** The goal is education, not punishment. Make your company more secure by teaching people to spot real threats.

---

## Contact

**Questions?**
- Check the troubleshooting section
- Review Gophish official docs: https://docs.getgophish.com
- Search GitHub issues: https://github.com/gophish/gophish/issues

**Good luck with your security awareness program!** 🛡️

---

**Document Version:** 1.0  
**Last Updated:** October 2024  
**Next Review:** January 2025


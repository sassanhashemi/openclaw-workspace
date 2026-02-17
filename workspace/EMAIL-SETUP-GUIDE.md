# Email Setup Guide for OpenClaw (Hybrid Architecture)

**Purpose:** Set up OpenClaw's email system using the hybrid approach for maximum safety and deliverability

**Target:** This guide is written for OpenClaw to execute autonomously after Sassan completes the initial account signups

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────┐
│ Google Workspace: openclaw@sassan.ai                     │
│ PURPOSE: Main identity, receive all email, send to Sassan│
│ SENDS: Only to sassan@gmail.com + replies (<10/day)     │
│ RECEIVES: All email to openclaw@sassan.ai                │
│ RISK: ZERO (minimal sending, all legitimate)            │
│ COST: $6/month                                           │
└──────────────────────────────────────────────────────────┘
                          ↓
            Receives all email, forwards internally
                          ↓
┌──────────────────────────────────────────────────────────┐
│ SendGrid (Your Existing Paid Account)                    │
│ PURPOSE: Customer outreach and campaigns                 │
│ OPTION A: Use existing sassan.ai sender         │
│   SENDS FROM: openclaw-insurance@sassan.ai       │
│   (Already authenticated, works immediately)             │
│ OPTION B: Authenticate sassan.ai domain                  │
│   SENDS FROM: openclaw-insurance@sassan.ai               │
│   (More consistent branding, requires DNS setup)         │
│ SENDS: Cold outreach, follow-ups, campaigns             │
│ LIMIT: Your paid plan limits (higher than free tier)    │
│ RECEIVES: Nothing (receive via Google Workspace)         │
│ RISK: ZERO to main account (isolated)                   │
│ COST: Already included in your existing plan            │
└──────────────────────────────────────────────────────────┘
                          ↓
            Sends customer outreach emails
                          ↓
┌──────────────────────────────────────────────────────────┐
│ Telegram Bot                                             │
│ PURPOSE: Urgent/time-sensitive notifications             │
│ SENDS: Critical errors, blockers requiring immediate action│
│ COST: $0 (free)                                          │
└──────────────────────────────────────────────────────────┘
```

**Key Benefit of sassan.ai Domain:**
✅ Complete isolation from personal email (sassan.ai)
✅ No DNS conflicts with existing email infrastructure
✅ Dedicated AI agent domain for future expansion
✅ Clean slate - no existing email routing to disrupt

---

## Prerequisites (Sassan Must Complete)

### Step 0: What Sassan Needs to Do First

**☑️ Sassan's Checklist:**

1. **Sign up for Google Workspace**
   - Go to: https://workspace.google.com/
   - Click "Get Started"
   - Business name: "Sassan Hashemi" or "OpenClaw Research"
   - Number of employees: "Just you"
   - Domain: **sassan.ai** (you already own this)
   - Create account: **openclaw@sassan.ai**
   - Password: [Generate strong password, save in 1Password]
   - Payment: Add credit card ($6/month)
   - **DO NOT complete DNS setup yet** - OpenClaw will handle

2. **Decide on SendGrid Sender Domain**
   - **Option A (Recommended for Speed):** Use existing sassan.ai
     - Already authenticated in your SendGrid account
     - Works immediately, no DNS setup needed
     - Sender: openclaw-insurance@sassan.ai

   - **Option B (Better Branding):** Authenticate sassan.ai in SendGrid
     - More consistent with openclaw@sassan.ai identity
     - Requires additional DNS setup
     - Sender: openclaw-insurance@sassan.ai

   - **You can choose either option** - OpenClaw will handle both paths

3. **Create Telegram Bot**
   - Open Telegram app
   - Message: @BotFather
   - Send: `/newbot`
   - Name: "OpenClaw Alerts"
   - Username: `openclaw_alerts_bot` (or whatever is available)
   - **Save the bot token** BotFather gives you
   - Message your new bot (send anything, like "test")
   - **DO NOT get chat ID yet** - OpenClaw will handle

4. **Provide OpenClaw with Credentials**

Create a file at: `/Users/sassan/files/claude/openclaw/.env.setup`

```bash
# Google Workspace
GOOGLE_WORKSPACE_EMAIL=openclaw@sassan.ai
GOOGLE_WORKSPACE_PASSWORD=[password you created]

# SendGrid (using your existing account)
SENDGRID_ACCOUNT_EMAIL=[your SendGrid login email]
SENDGRID_ACCOUNT_PASSWORD=[your SendGrid password]
# Or if you use SSO/2FA, OpenClaw will guide you through API key generation

# SendGrid sender domain choice
SENDGRID_USE_DOMAIN=[sassan.ai OR sassan.ai]
# Choose sassan.ai for immediate use (already authenticated)
# Choose sassan.ai for consistent branding (requires DNS setup)

# Telegram
TELEGRAM_BOT_TOKEN=[token from BotFather]

# Domain DNS Management
# For sassan.ai Google Workspace setup:
DNS_PROVIDER=[e.g., "cloudflare", "route53", "namecheap", "godaddy"]
```

Once this file is created, message OpenClaw: "Email setup prerequisites complete, proceed with configuration."

---

## OpenClaw Execution Steps

### Phase 1: Google Workspace DNS Configuration

**What OpenClaw Will Do:**

1. **Get domain verification TXT record from Google Workspace**
   - Log into Google Workspace Admin Console (using credentials from .env.setup)
   - Navigate to: Account → Domains → Manage Domains → sassan.ai
   - Get the verification TXT record

2. **Provide DNS instructions to Sassan**

**OpenClaw will send this email to sassan@gmail.com:**

```
Subject: [ACTION NEEDED] Add DNS Records for Google Workspace

Hi Sassan,

To complete Google Workspace setup, please add these DNS records to sassan.ai:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. DOMAIN VERIFICATION (TXT Record)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Host: @  (or leave blank for root domain)
Type: TXT
Value: google-site-verification=ABC123XYZ... [actual value from Google]
TTL: 3600 (or default)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2. MX RECORDS (Email Routing)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**IMPORTANT: Remove any existing MX records first**

Priority | Host | Type | Value
---------|------|------|-------
1        | @    | MX   | ASPMX.L.GOOGLE.COM.
5        | @    | MX   | ALT1.ASPMX.L.GOOGLE.COM.
5        | @    | MX   | ALT2.ASPMX.L.GOOGLE.COM.
10       | @    | MX   | ALT3.ASPMX.L.GOOGLE.COM.
10       | @    | MX   | ALT4.ASPMX.L.GOOGLE.COM.

TTL for all: 3600 (or default)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3. SPF RECORD (Sender Authentication)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Host: @
Type: TXT
Value: v=spf1 include:_spf.google.com include:sendgrid.net ~all
TTL: 3600

NOTE: This SPF record includes both Google and SendGrid.
If you have an existing SPF record, we'll need to merge them.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WHERE TO ADD THESE:
- Log into your DNS provider: [from .env.setup]
- Find DNS management or DNS records section
- Add each record above
- Save changes

HOW LONG IT TAKES:
- DNS propagation: Usually 15 minutes to 4 hours
- Worst case: Up to 48 hours

NEXT STEPS:
- After adding records, reply "DNS records added"
- I'll verify they're configured correctly
- Then proceed to next phase

Questions? Reply to this email.

- OpenClaw
```

3. **Wait for Sassan's confirmation**
   - Check email every hour for "DNS records added" reply
   - When received, proceed to verification

4. **Verify DNS records**

```bash
# Check TXT record (domain verification)
dig TXT sassan.ai +short | grep google-site-verification

# Check MX records
dig MX sassan.ai +short

# Check SPF record
dig TXT sassan.ai +short | grep spf
```

5. **If verification fails:**
   - Email Sassan with specific issue found
   - Example: "MX records not found yet, DNS may still be propagating. Will check again in 1 hour."
   - Retry every hour for 24 hours
   - If still failing after 24 hours, escalate with troubleshooting

6. **If verification succeeds:**
   - Log into Google Workspace Admin Console
   - Navigate to domain verification page
   - Click "Verify" - should succeed now
   - Activate Gmail for the domain

7. **Generate App Password for SMTP**
   - In Google Account settings (not Admin Console)
   - Security → 2-Step Verification → App Passwords
   - Generate password for "Mail" / "Other: OpenClaw SMTP"
   - Save this password securely

8. **Test Google Workspace email**

```javascript
// Send test email to Sassan
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 587,
  secure: false, // use TLS
  auth: {
    user: 'openclaw@sassan.ai',
    pass: '[APP PASSWORD from step 7]'
  }
});

await transporter.sendMail({
  from: 'openclaw@sassan.ai',
  to: 'sassan@gmail.com',
  subject: '✅ Google Workspace Email Test',
  text: 'This confirms openclaw@sassan.ai is sending successfully via Google Workspace SMTP.\n\n- OpenClaw'
});
```

9. **Verify Sassan received the test email**
   - Email Sassan: "Please confirm you received the test email from openclaw@sassan.ai"
   - Wait for confirmation
   - If not received, troubleshoot

10. **Save Google Workspace credentials**

Create: `/Users/sassan/files/claude/openclaw/.env`

```bash
# Google Workspace SMTP (for sending to Sassan)
OPENCLAW_EMAIL=openclaw@sassan.ai
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=openclaw@sassan.ai
SMTP_PASS=[APP PASSWORD from step 7]
```

**✅ Phase 1 Complete When:**
- DNS records verified via dig
- Domain verified in Google Workspace
- Test email successfully sent and received
- Credentials saved in .env

---

### Phase 2: SendGrid Configuration

**What OpenClaw Will Do:**

OpenClaw will check SENDGRID_USE_DOMAIN from .env.setup and follow the appropriate path:

---

#### **PATH A: Use Existing sassanhashemi.com Domain (Recommended)**

**When to use:** You chose `SENDGRID_USE_DOMAIN=sassanhashemi.com` in .env.setup

**Benefits:** Immediate - no DNS setup needed, already authenticated

**Steps:**

1. **Log into your existing SendGrid account**
   - Use credentials from .env.setup
   - Navigate to Settings → Sender Authentication

2. **Verify domain is already authenticated**
   - Check that sassanhashemi.com shows as "Verified"
   - Should have green checkmarks for SPF and DKIM

3. **Email you confirmation:**

```
Subject: ✅ SendGrid Using Existing Domain

Hi Sassan,

Using your existing SendGrid domain (sassanhashemi.com) for customer outreach.

Domain Status: ✅ Verified (already configured)
SPF: ✅ Passing
DKIM: ✅ Passing

No DNS changes needed - proceeding to add sender identity...

- OpenClaw
```

4. **Create Sender Identity**
   - Add sender: **openclaw-insurance@sassanhashemi.com**
   - From Name: "OpenClaw"
   - Reply To: **openclaw@sassan.ai** (Google Workspace receives)
   - Verify via email confirmation link

5. **Generate API key and test**
   - Create API key: "OpenClaw Production"
   - Test sending from openclaw-insurance@sassanhashemi.com

6. **Update .env:**

```bash
SENDGRID_API_KEY=[API key]
SENDGRID_FROM_EMAIL=openclaw-insurance@sassanhashemi.com
SENDGRID_FROM_NAME=OpenClaw
SENDGRID_REPLY_TO=openclaw@sassan.ai
```

**✅ Path A Complete:** Fastest option - works immediately!

---

#### **PATH B: Authenticate sassan.ai Domain**

**When to use:** You chose `SENDGRID_USE_DOMAIN=sassan.ai` in .env.setup

**Benefits:** Consistent branding (all @sassan.ai), dedicated AI agent domain

**Steps:**

1. **Log into SendGrid and start domain authentication**
   - Settings → Sender Authentication → Authenticate Your Domain
   - Domain: sassan.ai

2. **Get DNS records from SendGrid**
   - SendGrid will provide CNAME records for DKIM

3. **Email Sassan DNS instructions:**

```
Subject: [ACTION NEEDED] Add SendGrid DNS Records for sassan.ai

Hi Sassan,

To authenticate sassan.ai in SendGrid, please add these DNS records:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SENDGRID DKIM RECORDS (CNAME)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Host: s1._domainkey.sassan.ai
Type: CNAME
Value: [value from SendGrid]
TTL: 3600

Host: s2._domainkey.sassan.ai
Type: CNAME
Value: [value from SendGrid]
TTL: 3600

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
UPDATE EXISTING SPF RECORD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Update your existing SPF record to include SendGrid:

Host: @
Type: TXT
Value: v=spf1 include:_spf.google.com include:sendgrid.net ~all

(This should already be configured from Phase 1)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

After adding, reply "SendGrid DNS added"

- OpenClaw
```

4. **Wait for confirmation and verify**
   - Check DNS propagation with dig
   - Verify in SendGrid (green checkmarks)

5. **Create Sender Identity**
   - Add sender: **openclaw-insurance@sassan.ai**
   - From Name: "OpenClaw"
   - Reply To: **openclaw@sassan.ai**

6. **Generate API key and test**
   - Create API key
   - Test sending from openclaw-insurance@sassan.ai

7. **Update .env:**

```bash
SENDGRID_API_KEY=[API key]
SENDGRID_FROM_EMAIL=openclaw-insurance@sassan.ai
SENDGRID_FROM_NAME=OpenClaw
SENDGRID_REPLY_TO=openclaw@sassan.ai
```

**✅ Path B Complete:** Better branding, all @sassan.ai!

---

**✅ Phase 2 Complete When:**
- Domain verified in SendGrid (Path A: already done, Path B: after DNS)
- Sender identity created
- API key generated
- Test email sent and received successfully
- Credentials saved in .env

---

### Phase 3: Telegram Bot Configuration

**What OpenClaw Will Do:**

1. **Get Sassan's Telegram Chat ID**

**Method 1: Using Bot API**
```bash
# Sassan already messaged the bot in prerequisites
# Fetch updates to get chat ID
curl https://api.telegram.org/bot[BOT_TOKEN]/getUpdates

# Look for:
# "chat": {
#   "id": 123456789,  <-- This is the chat ID
#   "first_name": "Sassan",
#   ...
# }
```

**Method 2: Ask Sassan to use @userinfobot**
```
Email to Sassan:
"To get your Telegram chat ID, please message @userinfobot on Telegram.
It will reply with your ID. Reply to this email with that number."
```

2. **Test Telegram bot**

```javascript
const axios = require('axios');

const TELEGRAM_BOT_TOKEN = '[from .env.setup]';
const TELEGRAM_CHAT_ID = '[from step 1]';

async function sendTelegramMessage(message) {
  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;

  await axios.post(url, {
    chat_id: TELEGRAM_CHAT_ID,
    text: message,
    parse_mode: 'Markdown'
  });
}

// Send test message
await sendTelegramMessage(
  '✅ *Telegram Bot Test*\n\n' +
  'This confirms urgent notifications will be delivered via Telegram.\n\n' +
  'You will receive Telegram messages only for:\n' +
  '• 🚨 Critical errors blocking all progress\n' +
  '• ⚠️ Security incidents\n' +
  '• 🔥 Issues requiring immediate action\n\n' +
  'All other notifications go to sassan@gmail.com.\n\n' +
  '- OpenClaw'
);
```

3. **Verify Sassan received Telegram message**
   - Email Sassan: "Please confirm you received the Telegram test message"
   - Wait for confirmation

4. **Update .env with Telegram credentials**

```bash
# Add to existing .env file

# Telegram (for urgent notifications)
TELEGRAM_BOT_TOKEN=[token from BotFather]
TELEGRAM_CHAT_ID=[from step 1]
```

**✅ Phase 3 Complete When:**
- Chat ID retrieved
- Test message sent and received
- Credentials saved in .env

---

### Phase 4: Testing & Verification

**What OpenClaw Will Do:**

1. **Create unified email utility module**

```javascript
// File: /Users/sassan/files/claude/openclaw/lib/email.js

const nodemailer = require('nodemailer');
const sgMail = require('@sendgrid/mail');
const axios = require('axios');
require('dotenv').config();

// Configure SendGrid
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

// Configure Google Workspace SMTP
const gmailTransporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: process.env.SMTP_SECURE === 'true',
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  }
});

/**
 * Send email to Sassan (via Google Workspace)
 * Use this for: daily digests, reports, notifications, approvals
 */
async function emailSassan(subject, body) {
  await gmailTransporter.sendMail({
    from: `"OpenClaw" <${process.env.OPENCLAW_EMAIL}>`,
    to: 'sassan@gmail.com',
    subject: subject,
    text: body
  });

  console.log(`✅ Emailed Sassan: ${subject}`);
}

/**
 * Send customer outreach email (via SendGrid)
 * Use this for: cold outreach, follow-ups, campaigns
 */
async function sendOutreachEmail(to, subject, body, replyTo = null) {
  const msg = {
    to: to,
    from: {
      email: process.env.SENDGRID_FROM_EMAIL,
      name: process.env.SENDGRID_FROM_NAME
    },
    replyTo: replyTo || process.env.SENDGRID_REPLY_TO,
    subject: subject,
    text: body
  };

  await sgMail.send(msg);
  console.log(`✅ Sent outreach email to ${to}: ${subject}`);
}

/**
 * Send urgent notification to Telegram
 * Use this for: critical errors, blockers, security issues
 */
async function sendTelegramAlert(message) {
  const url = `https://api.telegram.org/bot${process.env.TELEGRAM_BOT_TOKEN}/sendMessage`;

  await axios.post(url, {
    chat_id: process.env.TELEGRAM_CHAT_ID,
    text: message,
    parse_mode: 'Markdown'
  });

  console.log('🚨 Sent Telegram alert');
}

module.exports = {
  emailSassan,
  sendOutreachEmail,
  sendTelegramAlert
};
```

2. **Run comprehensive tests**

```javascript
// File: /Users/sassan/files/claude/openclaw/tests/email-test.js

const { emailSassan, sendOutreachEmail, sendTelegramAlert } = require('../lib/email');

async function runEmailTests() {
  console.log('Starting email system tests...\n');

  // Test 1: Email to Sassan via Google Workspace
  console.log('Test 1: Sending email to Sassan (Google Workspace)...');
  await emailSassan(
    '[TEST] Daily Digest Example',
    'This is a test of the daily digest email.\n\n' +
    'All routine communications will arrive like this.\n\n' +
    '- OpenClaw'
  );
  await sleep(2000);

  // Test 2: Customer outreach via SendGrid
  console.log('Test 2: Sending customer outreach (SendGrid)...');
  await sendOutreachEmail(
    'sassan@gmail.com', // Sending to you for testing
    'Test: Insurance Commission Reconciliation Research',
    'Hi Sassan,\n\n' +
    'This is a test of customer outreach emails.\n\n' +
    `Cold emails to prospects will look like this, coming from ${process.env.SENDGRID_FROM_EMAIL}.\n\n` +
    'Best regards,\n' +
    'OpenClaw'
  );
  await sleep(2000);

  // Test 3: Urgent notification via Telegram
  console.log('Test 3: Sending urgent alert (Telegram)...');
  await sendTelegramAlert(
    '🚨 *Test: Urgent Alert*\n\n' +
    'This is a test of urgent notifications.\n\n' +
    'You will only receive Telegram messages for critical issues.\n\n' +
    '- OpenClaw'
  );

  console.log('\n✅ All tests complete!');
  console.log('\nPlease check:');
  console.log('1. sassan@gmail.com - should have 2 emails');
  console.log('2. Telegram - should have 1 message');
  console.log('\nReply to the first email confirming all tests passed.');
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

runEmailTests().catch(console.error);
```

3. **Run the test suite**

```bash
cd /Users/sassan/files/claude/openclaw
npm install nodemailer @sendgrid/mail axios dotenv
node tests/email-test.js
```

4. **Email Sassan for confirmation**

```
Subject: [TEST COMPLETE] Email System Ready for Verification

Hi Sassan,

I've completed email system setup and sent 3 test messages:

✅ Test 1: Email via Google Workspace (openclaw@sassan.ai)
   - Subject: "[TEST] Daily Digest Example"
   - Should be in your sassan@gmail.com inbox

✅ Test 2: Email via SendGrid (from configured sender)
   - Subject: "Test: Insurance Commission Reconciliation Research"
   - From: [your chosen SendGrid sender - sassanhashemi.com or sassan.ai]
   - Should be in your sassan@gmail.com inbox
   - Check it's not in spam

✅ Test 3: Telegram notification
   - Should appear in Telegram from OpenClaw Alerts bot

PLEASE VERIFY:
1. Did all 3 messages arrive?
2. Is Test 2 (SendGrid) in inbox or spam?
3. Do the sender addresses look correct?

Reply with one of:
- "All tests passed" → I'll finalize setup
- "Test X failed" → I'll troubleshoot

NOTE: These test emails DO NOT require your approval.
This confirmation is just to verify the system works.

- OpenClaw
```

5. **Wait for Sassan's confirmation**

6. **If tests passed, create final configuration summary**

```
Subject: ✅ Email System Configuration Complete

Hi Sassan,

Email system is fully configured and tested. Here's the summary:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SYSTEM CONFIGURATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📧 Google Workspace (Main Identity)
   Email: openclaw@sassan.ai
   Purpose: Receive all email, send to you
   Status: ✅ Active
   Cost: $6/month

📧 SendGrid (Customer Outreach)
   From: [openclaw-insurance@sassanhashemi.com OR openclaw-insurance@sassan.ai]
   Purpose: Cold outreach, campaigns
   Account: Your existing paid account
   Domain: [Your chosen option - see below]
   Status: ✅ Active
   Cost: Included in existing plan

   [OpenClaw will fill in which option was used:
    - Option A: sassanhashemi.com (existing, immediate)
    - Option B: sassan.ai (new, consistent branding)]

💬 Telegram Bot
   Bot: OpenClaw Alerts
   Purpose: Urgent notifications only
   Status: ✅ Active
   Cost: $0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HOW EMAILS WORK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TO YOU (sassan@gmail.com):
✅ Daily digest (8 AM) - via Google Workspace
✅ Weekly reports - via Google Workspace
✅ Monthly reports - via Google Workspace
✅ Task completions - via Google Workspace
✅ Spending approvals - via Google Workspace

📝 No approval needed to send these emails

TO CUSTOMERS (validation outreach):
✅ Cold emails - via SendGrid (openclaw-insurance@)
✅ Follow-ups - via SendGrid
✅ Interview scheduling - via SendGrid

🔄 Replies to customer emails arrive at Google Workspace
🔄 I can reply using either system

URGENT (Telegram):
🚨 Critical errors blocking all progress
🚨 Security incidents
🚨 System outages

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECURITY & SAFETY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Google Workspace account: ZERO risk
   - Low sending volume (<10 emails/day to you)
   - All legitimate business communications
   - Will never be flagged as spam

✅ SendGrid account: Isolated from main identity
   - Customer outreach completely separate
   - If any issues, main account unaffected
   - Professional deliverability monitoring

✅ All credentials stored securely in:
   - .env file (gitignored)
   - 1Password vault

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DELIVERABILITY MONITORING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

I will monitor:
📊 SendGrid deliverability stats (bounces, spam complaints)
📊 Email open rates
📊 Response rates
🔔 Alert you if deliverability drops

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Email system: COMPLETE
⏭️  Next: Continue with SETUP-GUIDE.md Phase 2 (Validation)

You can now hand me the insurance validation plan and I'll begin execution using this email infrastructure.

- OpenClaw
```

7. **Archive setup credentials**

```bash
# Move setup file to secure location
mv /Users/sassan/files/claude/openclaw/.env.setup \
   /Users/sassan/files/claude/openclaw/.env.setup.archive

# Ensure .env is gitignored
echo ".env" >> /Users/sassan/files/claude/openclaw/.gitignore
echo ".env.*" >> /Users/sassan/files/claude/openclaw/.gitignore
```

**✅ Phase 4 Complete When:**
- All 3 test messages delivered successfully
- Email utility module created
- Configuration summary sent to Sassan
- Sassan confirmed "all tests passed"

---

## Verification Checklist

**Before marking email setup as complete, verify:**

- [ ] DNS records added and verified (dig commands pass)
- [ ] Google Workspace domain verified
- [ ] Gmail activated for openclaw@sassan.ai
- [ ] Can send email from Google Workspace to sassan@gmail.com
- [ ] SendGrid domain authenticated (all green checkmarks)
- [ ] Can send email from SendGrid (openclaw-insurance@) to sassan@gmail.com
- [ ] SendGrid test email NOT in spam folder
- [ ] Telegram bot can send messages to Sassan
- [ ] All credentials saved in .env file
- [ ] .env file is gitignored
- [ ] Email utility module created and tested
- [ ] Sassan confirmed all tests passed

---

## Troubleshooting Guide

### Issue: DNS Records Not Propagating

**Symptoms:** dig commands return NXDOMAIN or no results

**Solutions:**
1. Wait longer (DNS can take up to 48 hours, usually < 4 hours)
2. Check records were added correctly (no typos)
3. Verify you added to the right domain (sassan.ai not www.sassan.ai)
4. Try different DNS server: `dig @8.8.8.8 MX sassan.ai`
5. Use online tool: https://dnschecker.org/

### Issue: Google Workspace Can't Verify Domain

**Symptoms:** Verification fails even though TXT record exists

**Solutions:**
1. Ensure TXT record has no quotes around the value
2. Wait for DNS propagation (check with dig first)
3. Try removing and re-adding the verification record
4. Clear your browser cache and try again
5. Contact Google Workspace support (chat available)

### Issue: SendGrid Test Email Goes to Spam

**Symptoms:** Test email lands in spam folder

**Solutions:**
1. Check SPF/DKIM records are properly configured
2. Verify domain authentication shows all green in SendGrid
3. Check email content doesn't trigger spam filters (avoid "FREE", "CLICK HERE", etc.)
4. Warm up the domain (send to yourself for a few days first)
5. Ask Sassan to mark as "Not Spam" and move to inbox
6. Future emails should be better

### Issue: Telegram Bot Not Sending

**Symptoms:** sendTelegramMessage() fails or messages don't arrive

**Solutions:**
1. Verify bot token is correct (check for extra spaces)
2. Verify chat ID is correct (try getting it again)
3. Check you actually messaged the bot first (required to get chat ID)
4. Test with curl: `curl -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage" -d "chat_id=<ID>&text=test"`
5. Check bot isn't blocked by Sassan

### Issue: SMTP Authentication Failed

**Symptoms:** nodemailer fails with "Invalid credentials" or "Authentication failed"

**Solutions:**
1. Verify you're using App Password, not account password
2. Re-generate App Password in Google Account settings
3. Check for spaces before/after password in .env file
4. Ensure 2FA is enabled on Google Workspace account (required for App Passwords)
5. Try port 465 with SSL instead of 587 with TLS

---

## Environment Variables Reference

**Final .env file should contain:**

```bash
# Google Workspace (for sending to Sassan, receiving all email)
OPENCLAW_EMAIL=openclaw@sassan.ai
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=openclaw@sassan.ai
SMTP_PASS=[App Password from Google]

# SendGrid (for customer outreach)
SENDGRID_API_KEY=[API Key from SendGrid]
# Choose one based on your selection:
SENDGRID_FROM_EMAIL=openclaw-insurance@sassanhashemi.com  # Option A
# OR
SENDGRID_FROM_EMAIL=openclaw-insurance@sassan.ai  # Option B
SENDGRID_FROM_NAME=OpenClaw
SENDGRID_REPLY_TO=openclaw@sassan.ai  # Always replies go to sassan.ai

# Telegram (for urgent notifications)
TELEGRAM_BOT_TOKEN=[Token from BotFather]
TELEGRAM_CHAT_ID=[Sassan's Telegram chat ID]

# Monitoring
EMAIL_DAILY_LIMIT=100  # SendGrid free tier limit
ALERT_ON_BOUNCE_RATE=0.05  # Alert if >5% bounce rate
ALERT_ON_SPAM_RATE=0.01   # Alert if >1% spam complaints
```

---

## Success Criteria

**Email system is fully operational when:**

✅ All DNS records configured and verified
✅ All 3 communication channels tested and working:
   - Google Workspace → sassan@gmail.com ✅
   - SendGrid → customer outreach ✅
   - Telegram → urgent alerts ✅
✅ No test emails in spam
✅ Credentials secured in .env and 1Password
✅ Email utility module created and tested
✅ Sassan confirmed "all tests passed"
✅ Configuration summary sent

**At this point, email infrastructure is production-ready for validation work.**

---

## Post-Setup Monitoring

**OpenClaw will automatically monitor:**

📊 **SendGrid Statistics (Daily)**
- Emails sent
- Bounce rate
- Spam complaint rate
- Open rate (if enabled)
- Click rate (if enabled)

🔔 **Alerts Triggered If:**
- Bounce rate > 5%
- Spam complaint rate > 1%
- SendGrid account shows warnings
- Approaching 100 email/day limit

📧 **Weekly Deliverability Report:**
Included in weekly validation metrics email

---

*This guide is designed for OpenClaw to execute autonomously after Sassan completes the initial account signups and provides credentials. All DNS configurations, testing, and verification will be handled by OpenClaw with clear communication to Sassan at each step.*

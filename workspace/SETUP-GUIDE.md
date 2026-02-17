# OpenClaw Comprehensive Setup Guide

**Created:** February 2026
**For:** Sassan - Solo Founder Using AI Agents as Employees
**Purpose:** Complete autonomous business validation and building system

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Philosophy & Operating Principles](#philosophy--operating-principles)
3. [System Architecture](#system-architecture)
4. [Initial Setup Steps](#initial-setup-steps)
5. [Configuration Files](#configuration-files)
6. [Security & Access Control](#security--access-control)
7. [Communication & Reporting](#communication--reporting)
8. [Decision Framework Reference](#decision-framework-reference)
9. [Success Metrics](#success-metrics)
10. [Next Steps](#next-steps)

---

## Executive Summary

### Your Vision

You are a solo technical founder validating and building B2B SaaS businesses. OpenClaw serves as your autonomous employee team, executing the detailed work of validation while you focus on strategic decisions and high-value activities.

**3-Month Success Vision:**
- ✅ Validate 1-2 business ideas thoroughly
- ✅ Reduce your hands-on time to 5-10 hours/week
- ✅ Launch MVP or landing page for validated idea
- ✅ Establish repeatable validation process for future ideas

### Your Working Model

You create comprehensive plans using Claude Code (normal mode). Once approved, you hand those plans to OpenClaw for execution. OpenClaw operates with **medium autonomy**:

- **Autonomous:** Day-to-day execution, tool selection, bug fixes, minor copy changes
- **Asks Approval:** Spending money, first customer messages (templates), strategic pivots, major decisions
- **Your Focus:** Strategic direction, key decisions, relationship building, plan creation

### Core Constraints

- **Location:** Local macOS machine for now (future: cloud deployment)
- **Budget:** $100/month autonomous spending, $100-300/month AI API usage
- **Stack:** TypeScript/JavaScript (React, Node, Vite) + Docker for services
- **Git:** GitHub, OpenClaw has dedicated account added to relevant repos
- **Email:** OpenClaw has dedicated email for outreach; drafts emails needing your address

---

## Philosophy & Operating Principles

### 1. Self-Troubleshooting First

**Your Requirement:** *"Sometimes when it runs into issues it presents me with the code error that it is given. Instead of doing this, it should troubleshoot itself to achieve the stated goal. I should not be spending time troubleshooting with it."*

**Implementation:**
- When encountering errors, OpenClaw must exhaust all reasonable solutions before escalating
- Error messages are for internal debugging, not for showing you
- Escalate only after 2 hours of blocking issues with documented troubleshooting attempts
- Present: "Blocked on X because Y, tried A/B/C, need your input on D"

### 2. Proper Verification

**Your Requirement:** *"It should always verify the task properly after completion and before telling me it is done. It should not verify in a way that automatically passes, but rather thoroughly verify things properly."*

**Implementation:**
- Never claim completion without actual verification
- For UI changes: screenshot actual result
- For API integrations: test actual API calls
- For deployments: verify live URL works
- For data processing: spot-check sample outputs
- Document verification method used in completion report

### 3. Proactive Intelligence

OpenClaw should:
- **Identify patterns** in validation data and suggest pivots
- **Propose automations** when seeing repetitive work (3+ occurrences)
- **Flag anomalies** in metrics (traffic drops, conversion changes)
- **Suggest optimizations** based on weekly data analysis
- **Continuously learn** from outcomes and adapt strategies

### 4. Quality Over Speed (But Fast Execution)

- Write tests before implementation (TDD approach)
- Create detailed git commits with context and reasoning
- Produce structured, consistent markdown documentation
- Match your writing style per audience (professional for customers, clear for internal)
- Don't rush verification to claim completion

---

## System Architecture

### Deployment Model

**Current: Local-Only**
```
┌─────────────────────────────────────┐
│   Your MacBook Pro (macOS)          │
│                                      │
│  ┌────────────────────────────┐    │
│  │   OpenClaw Agent           │    │
│  │   - Runs locally           │    │
│  │   - Accesses GitHub        │    │
│  │   - Sends via dedicated    │    │
│  │     email account          │    │
│  │   - Manages local Docker   │    │
│  └────────────────────────────┘    │
│                                      │
│  ┌────────────────────────────┐    │
│  │   Local Services           │    │
│  │   - Docker containers      │    │
│  │   - Development servers    │    │
│  │   - Backup systems         │    │
│  └────────────────────────────┘    │
└─────────────────────────────────────┘
         ↓
    External Services
    - GitHub repos
    - Email (via OpenClaw account)
    - APIs (analytics, etc.)
    - Cloud services (as needed)
```

**Future: Hybrid Model** (when you're ready)
- Long-running tasks on cloud VMs
- Scheduled jobs via GitHub Actions
- Webhooks for event-driven automation

### Tech Stack

**Primary:**
- **Language:** TypeScript/JavaScript
- **Frontend:** React + Vite
- **Backend:** Node.js
- **Containerization:** Docker for services requiring isolation
- **Version Control:** Git + GitHub
- **Package Manager:** npm or pnpm (OpenClaw will standardize)

**Supporting:**
- **Testing:** Vitest (for Vite projects), Jest (Node)
- **Documentation:** Markdown + git
- **Secrets:** .env files (gitignored) + 1Password for backup
- **CI/CD:** GitHub Actions (future)

### Data Storage

**Customer Data (Sensitive):**
- Encrypted storage with access controls
- Separate from git repository
- Backup daily to secure location
- Plan for GDPR/CCPA compliance (implement post-validation)

**Working Data:**
- Git repository (private on GitHub)
- Structured markdown documents
- Detailed activity logs in dedicated log directory
- Automated backups daily

---

## Initial Setup Steps

### Phase 1: Foundation (Week 1)

#### 1.1 Create OpenClaw Identity

**GitHub Account:**
```bash
# You will create:
Username: openclaw-sassan (or similar)
Email: openclaw@[your-domain].com
Profile: "Autonomous agent assisting Sassan with business validation"

# Add to repositories:
- insurance landing page repo
- business validation repo
- future project repos as needed

# Repository access: Full read/write to assigned repos
```

**Email Account:**

See **[EMAIL-SETUP-GUIDE.md](./EMAIL-SETUP-GUIDE.md)** for complete email setup instructions.

```bash
# Set up dedicated email for OpenClaw
Primary Email: openclaw@sassanhashemi.com
Purpose: OpenClaw's permanent identity (not tied to any specific business)
Recommended: Google Workspace ($6/month)

# Project-specific emails (created as aliases):
openclaw-insurance@sassanhashemi.com (for insurance validation)
openclaw-[project]@sassanhashemi.com (for future projects)

# Sending to you:
Non-urgent: sassan@gmail.com (no approval needed)
Urgent: Telegram
```

**1Password / Secrets Management:**
```bash
# Create vault or collection for OpenClaw secrets
- GitHub personal access token
- Email SMTP credentials
- API keys (Analytics, services)
- Encryption keys for sensitive data
```

#### 1.2 Repository Setup

```bash
# Clone or create core repositories
cd /Users/sassan/files/claude

# Ensure structure:
claude/
├── openclaw/           # This directory - setup docs
├── insurance/          # Current validation project
│   ├── CLAUDE.md      # Project-specific config (to create)
│   └── ...
├── business_ideas/     # Research and planning docs
└── [future-projects]/  # Future validation projects
```

#### 1.3 Docker Installation & Setup

```bash
# Verify Docker Desktop installed
docker --version

# Create docker-compose.yml for common services
# OpenClaw will create this based on needs
```

#### 1.4 Environment Configuration

```bash
# Create root .env.example template
# OpenClaw will populate project-specific .env files

# Structure:
# .env (gitignored)
# .env.example (committed - no secrets)

# Common variables:
GITHUB_TOKEN=
OPENCLAW_EMAIL_SMTP_HOST=
OPENCLAW_EMAIL_SMTP_USER=
OPENCLAW_EMAIL_SMTP_PASS=
ANTHROPIC_API_KEY=
```

### Phase 2: Configuration (Week 1)

#### 2.1 Create CLAUDE.md Files

OpenClaw will create project-specific CLAUDE.md files using the template in `CONFIGURATION-TEMPLATE.md`.

**Priority:**
1. `/Users/sassan/files/claude/insurance/CLAUDE.md` - First validation project
2. `/Users/sassan/files/claude/openclaw/CLAUDE.md` - Meta-configuration
3. Future project directories as created

#### 2.2 Set Up Automation Infrastructure

**Cron Jobs / Scheduled Tasks:**

OpenClaw will set up (via Node.js scheduler or crontab):

```javascript
// Daily: 8:00 AM - Morning digest email
// Daily: 9:00 AM - Check landing page metrics
// Daily: 11:00 PM - Backup data and git push
// Weekly: Monday 8:00 AM - Validation metrics summary
// Weekly: Monday 8:00 AM - Suggest optimizations
// Monthly: 1st at 8:00 AM - Financial summary report
// Monthly: 1st at 9:00 AM - Industry deep dive (current focus)
// Daily: Continuous - Heartbeat monitoring
```

See `AUTOMATION-PLAYBOOK.md` for complete automation specifications.

#### 2.3 Set Up Activity Logging

```bash
# Create log directory structure
openclaw/
├── logs/
│   ├── activity/       # Detailed action logs
│   ├── decisions/      # Decision points and approvals
│   ├── errors/         # Error logs with troubleshooting
│   └── metrics/        # Success metrics tracking
└── reports/
    ├── daily/          # Daily digest archives
    ├── weekly/         # Weekly summaries
    └── monthly/        # Monthly reports
```

**Log Format:** JSON Lines for programmatic analysis, with Markdown summaries for human review.

### Phase 3: Skills Creation (Week 2)

OpenClaw will create custom skills for repetitive validation tasks. See `SKILLS-REFERENCE.md` for specifications.

**Priority Order:**
1. **Customer Outreach Skill** - Draft cold emails, LinkedIn messages, forum posts
2. **Interview Analysis Skill** - Transcribe, analyze, auto-update tracking docs
3. **Landing Page Optimization Skill** - Run A/B tests, analyze metrics, iterate copy
4. **Competitor Research Skill** - Monitor competitors, summarize market changes

**Skill Triggers:** Mix of scheduled (competitor research weekly), event-driven (interview complete → analyze), and manual invocation.

### Phase 4: Validation (Week 2)

Before fully autonomous operation:

1. **Test Outreach:** Send 3-5 cold emails to test prospects, review quality, approve template
2. **Test Landing Page Changes:** Make one A/B test change, verify properly, check traffic handling
3. **Test Interview Analysis:** Process one interview recording end-to-end
4. **Test Reporting:** Verify daily digest arrives at 8 AM with correct content
5. **Test Escalation:** Simulate blocked scenario, verify 2-hour escalation works

**Validation Checklist:**
- [ ] OpenClaw can commit and push to GitHub
- [ ] Morning digest arrives at 8 AM daily
- [ ] Escalation triggers after 2 hours of blocking
- [ ] Customer outreach drafts match approved voice
- [ ] Landing page changes deploy correctly
- [ ] Interview analysis updates tracking docs accurately
- [ ] Spending requests come to you before execution
- [ ] Strategic decisions escalate for approval

---

## Configuration Files

### CLAUDE.md Structure

Each project directory gets a `CLAUDE.md` file with:

**Sections:**
1. **Project Context** - What is being validated/built
2. **Current Phase** - Where you are in the process (validation phase X)
3. **Success Criteria** - Clear go/no-go metrics for this phase
4. **Key Contacts** - Interview prospects, partners, important relationships
5. **Decision Log** - Major decisions made and rationale
6. **Autonomy Settings** - Project-specific autonomy overrides
7. **Active Experiments** - A/B tests, outreach campaigns, hypotheses being tested

See `CONFIGURATION-TEMPLATE.md` for the complete template.

### MEMORY.md (Auto-Updated)

OpenClaw will maintain your `/Users/sassan/.claude/projects/-Users-sassan-files-claude/memory/MEMORY.md` with:

- **Validation Patterns:** What works for customer discovery
- **Technical Preferences:** Stack choices, tool preferences
- **Communication Patterns:** Effective outreach language, response rates
- **Mistakes & Learnings:** Things that didn't work, why, what to do instead

**Update Frequency:** Real-time as patterns emerge, with git commit notifications

### Lessons Learned Document

`/Users/sassan/files/claude/openclaw/LESSONS-LEARNED.md` - Continuously updated based on outcomes:

- Outreach approach X yielded Y response rate
- Interview insight: agencies care more about Z than expected
- Landing page headline change improved conversion by N%
- Mistake: Tried ABC, failed because XYZ, now doing DEF instead

---

## Security & Access Control

### Secrets Management

**Storage:**
```bash
# Local .env files (gitignored)
insurance/.env
openclaw/.env

# 1Password Vault
"OpenClaw Secrets" vault contains:
- GitHub PAT
- Email credentials
- API keys
- Encryption keys
```

**Access Pattern:**
- OpenClaw reads from .env at runtime
- Never logs secrets
- Rotates credentials quarterly (automated reminder)

### Data Protection

**Customer Interview Data:**
```bash
# Encrypted directory (not in git)
~/secure-data/
├── interviews/
│   ├── transcripts/
│   └── recordings/
└── contacts/
    └── pii/
```

**Encryption:**
- At-rest encryption via macOS FileVault + encrypted disk image
- Access via OpenClaw only when needed for processing
- Backups encrypted separately
- Plan for GDPR compliance post-validation (data access, deletion procedures)

### GitHub Access

**OpenClaw GitHub Account:**
- Dedicated account (openclaw-sassan)
- Added as collaborator to specific repos
- Full read/write access to assigned repos only
- Can push to feature branches and create PRs
- **Cannot force-push to main branch** (protected)

**Commit Signing:**
- Optional: Set up GPG key for OpenClaw commits
- Distinguishes automated commits from your manual commits

### Email Access

**Outreach:** OpenClaw sends from `openclaw@[domain].com`
**Personal:** When email must come from your address, OpenClaw drafts and you send manually

---

## Communication & Reporting

### Daily Digest (8:00 AM)

**Format:** Email to sassan@gmail.com (non-urgent, no approval needed for these emails)

**Contents:**
```markdown
# OpenClaw Daily Digest - [Date]

## Summary
- [Brief overview of yesterday's work]

## Completed Tasks
- ✅ Task 1: [description] ([link to PR/doc])
- ✅ Task 2: [description]

## In Progress
- 🔄 Task X: [status, ETA]

## Decisions Needed
- ⚠️ Decision 1: [context, options, recommendation]

## Metrics Update
- Landing page: X visitors, Y% conversion (↑/↓ vs. prior day)
- Interviews: N scheduled, M completed

## Issues / Blockers
- [Any blockers or problems encountered]

## System Health
- ✅ All services operational
- ✅ Backups completed
- API usage: $X / $300 budget

## Today's Plan
- [ ] Planned task 1
- [ ] Planned task 2

---
View detailed logs: [link to activity log]
```

### Real-Time Notifications

**Urgent (via Telegram):**
- ⚠️ Critical errors blocking all progress
- 🚨 Time-sensitive approvals needed
- 🔥 Major issues requiring immediate attention

**Important but not urgent (via email to sassan@gmail.com):**
- ✅ Critical errors blocking all progress
- ✅ Spending approval needed (over $100/month threshold)
- ✅ Major validation wins (e.g., 10 interviews scheduled, 20% landing page conversion)
- ✅ Major validation issues (e.g., all interviews saying problem isn't real)
- ✅ Task completion when you explicitly requested a specific task

**Format:** Email subject clearly indicates priority level
- `[URGENT]` - Blocking error
- `[APPROVAL NEEDED]` - Spending or strategic decision
- `[WIN]` - Major positive outcome
- `[ISSUE]` - Major negative signal
- `[COMPLETE]` - Requested task done

### Weekly Reports (Mondays, 8 AM)

**Validation Metrics Summary:**
```markdown
# Weekly Validation Report - Week of [Date]

## Insurance Commission Reconciliation Validation

### This Week's Activity
- Interviews completed: N
- Outreach sent: X emails, Y LinkedIn messages
- Response rate: Z%
- Landing page: X visitors, Y signups (Z% conversion)

## Key Insights
- [Pattern 1: e.g., "Agencies with 10+ producers more interested"]
- [Pattern 2: e.g., "Price sensitivity lower than expected"]

## Go/No-Go Signals
✅ Positive: [List signals supporting continuation]
⚠️  Concerns: [List concerns or blocking issues]

## Recommendations
- [Strategic suggestion 1]
- [Optimization suggestion 2]

## Next Week's Plan
- [Key activities planned]

---
Detailed data: [link to tracking spreadsheet]
```

### Monthly Reports (1st of month, 8 AM)

**Financial Summary:**
```markdown
# Monthly Financial Report - [Month]

## Spending Breakdown
- Tools & Services: $X
  - [Service 1]: $Y
  - [Service 2]: $Z
- AI API Usage: $X (X% of $300 budget)
- Paid Interviews: $X (N interviews at ~$Y each)
- One-time purchases: $X

## Total: $X

## ROI Analysis
- Time saved: ~X hours
- Value at $Y/hr: $Z
- Net: $(savings - spending)

## Budget Forecast
- Current run rate: $X/month
- Projected next month: $X
- Recommendations: [any budget adjustments needed]
```

**Industry Deep Dive Report:**
```markdown
# Industry Deep Dive - [Current Focus Area]

## Insurance Commission Reconciliation Market

### Market Developments
- [Notable carrier changes]
- [New competitors or product launches]
- [Regulatory changes]

### Competitive Intelligence
- [Competitor A: recent updates]
- [Competitor B: pricing changes]

### Industry Trends
- [Trend 1]
- [Trend 2]

### Implications for Your Validation
- [How these developments affect your approach]
- [Opportunities or threats identified]

---
*Note: This report adapts to whatever business you're currently validating*
```

### Milestone Progress Report (Included in Weekly)

```markdown
## Validation Phase Progress

**Current Phase:** Problem Validation (Phase 1)

**Success Criteria:**
- [ ] 15-20 interviews completed (currently: N)
- [ ] 10+ rated as top-3 pain (currently: N)
- [ ] 5+ said would pay $500+/mo (currently: N)
- [ ] Validated acquisition channel (status: ...)

**Timeline:**
- Started: [Date]
- Target completion: [Date]
- Status: On track / Behind / Ahead

**Completion:** X% complete
```

---

## Decision Framework Reference

See `DECISION-FRAMEWORK.md` for complete details. Quick reference:

### You Must Approve

- ❌ All strategic changes (customer segment, features, abandon hypothesis)
- ❌ All spending over $100/month (including paid interviews)
- ❌ Any spending at all before execution (ask first)
- ❌ Major decisions: build commitment, pricing, partnerships
- ❌ Destructive operations: production database changes
- ❌ Bulk communications unless to pre-approved lists with approved templates
- ❌ New product features (UX improvements OK)
- ❌ Hiring contractors (can propose with vetting)

### OpenClaw Decides Autonomously

- ✅ Tool and library selection
- ✅ Minor copy and content changes
- ✅ Bug fixes and code refactoring
- ✅ Documentation creation and updates
- ✅ Dev dependency updates (ask for production deps)
- ✅ Small UX improvements
- ✅ A/B test execution (depends on traffic - will ask if high traffic)
- ✅ Feature branch git operations (never force-push to main)

### Medium Autonomy (Ask for Approval After First Examples)

- 🔄 Customer outreach messages (approve first 3-5 examples of each type)
- 🔄 Calendar invites (prepare invites, ask before sending)
- 🔄 Landing page changes (autonomous unless high traffic detected)

---

## Success Metrics

OpenClaw will track and report on:

### 1. Time Saved
- **Metric:** Hours per week you spend on validation work
- **Target:** Reduce from 40+ hours to 5-10 hours/week
- **Tracking:** Weekly self-report + OpenClaw estimate based on tasks automated

### 2. Velocity
- **Metric:** Days to complete validation phases
- **Target:** Complete Phase 1 (Problem Validation) in 2-4 weeks
- **Tracking:** Milestone timestamps in activity logs

### 3. Quality
- **Metric:** Percentage of OpenClaw work requiring your revisions
- **Target:** <10% revision rate
- **Tracking:** Git commits/changes by you to OpenClaw's work

### 4. Validation Outcomes
- **Metric:** Clear go/no-go decisions on business ideas
- **Target:** 1-2 ideas validated thoroughly in 3 months
- **Tracking:** Completion of validation phases per playbook

### Holistic Evaluation

Success = Time saved + High quality + Fast velocity + Clear validation outcomes

**Monthly Review:** Compare actual vs. targets, identify bottlenecks, optimize process

---

## Next Steps

### Your Action Items

1. **Create OpenClaw Identity:**
   - [ ] Register GitHub account: `openclaw-sassan`
   - [ ] Set up primary email: `openclaw@sassanhashemi.com` (see [EMAIL-SETUP-GUIDE.md](./EMAIL-SETUP-GUIDE.md))
   - [ ] Set up project email alias: `openclaw-insurance@sassanhashemi.com`
   - [ ] Configure Telegram bot for urgent notifications (see EMAIL-SETUP-GUIDE.md)
   - [ ] Create 1Password vault: "OpenClaw Secrets"
   - [ ] Add OpenClaw GitHub account to insurance repo

2. **Grant Access:**
   - [ ] Generate GitHub Personal Access Token for OpenClaw
   - [ ] Configure email SMTP credentials
   - [ ] Share Anthropic API key for Claude access

3. **Review & Approve:**
   - [ ] Read `DECISION-FRAMEWORK.md` - ensure decision boundaries are clear
   - [ ] Read `AUTOMATION-PLAYBOOK.md` - review all scheduled tasks
   - [ ] Read `SKILLS-REFERENCE.md` - approve custom skills to build
   - [ ] Review `CONFIGURATION-TEMPLATE.md` - approve CLAUDE.md format

4. **Validate Setup:**
   - [ ] OpenClaw performs Phase 4 validation tests (see above)
   - [ ] Receive first daily digest at 8 AM
   - [ ] Verify escalation workflow with test scenario

5. **Launch:**
   - [ ] Hand OpenClaw the insurance validation plan
   - [ ] Approve first batch of customer outreach messages (3-5 examples)
   - [ ] Begin Phase 1: Problem Validation execution

### OpenClaw Action Items (After Your Setup)

1. **Infrastructure Setup:**
   - Create log directory structure
   - Set up backup automation
   - Configure scheduled tasks (daily digest, weekly reports, etc.)

2. **Configuration Files:**
   - Create `insurance/CLAUDE.md` using template
   - Initialize `LESSONS-LEARNED.md`
   - Set up encrypted directory for sensitive data

3. **Skills Development:**
   - Build Customer Outreach Skill
   - Build Interview Analysis Skill
   - Build Landing Page Optimization Skill
   - Build Competitor Research Skill

4. **Validation Testing:**
   - Execute Phase 4 validation checklist
   - Verify all communication channels
   - Test escalation workflows
   - Demonstrate proper task verification

5. **Begin Execution:**
   - Await your handoff of insurance validation plan
   - Execute first outreach campaign (after template approval)
   - Begin daily digest delivery
   - Start learning and optimizing

---

## Appendix: Key Files Reference

| File | Purpose | Location |
|------|---------|----------|
| **SETUP-GUIDE.md** | This file - comprehensive setup guide | `/openclaw/` |
| **DECISION-FRAMEWORK.md** | Detailed autonomy boundaries | `/openclaw/` |
| **AUTOMATION-PLAYBOOK.md** | All scheduled tasks & monitoring | `/openclaw/` |
| **SKILLS-REFERENCE.md** | Custom skills specifications | `/openclaw/` |
| **CONFIGURATION-TEMPLATE.md** | Template for project CLAUDE.md files | `/openclaw/` |
| **LESSONS-LEARNED.md** | Continuously updated learnings | `/openclaw/` |
| **[project]/CLAUDE.md** | Project-specific configuration | Each project dir |
| **MEMORY.md** | Auto-updated patterns & preferences | `.claude/memory/` |

---

## Support & Iteration

This is a living system. As you and OpenClaw work together:

- **Feedback:** Reply to any OpenClaw email with corrections - it learns from your feedback
- **Adjustments:** Decision boundaries can be tuned based on what works
- **Evolution:** OpenClaw will propose process improvements based on outcomes
- **New Skills:** As repetitive patterns emerge, OpenClaw suggests new automations

**The goal:** Over time, OpenClaw becomes increasingly effective at executing your validation playbook, freeing you to focus entirely on strategic decisions and relationship building.

---

*Ready to build your autonomous validation system. Let's start with your identity creation and access grants.*

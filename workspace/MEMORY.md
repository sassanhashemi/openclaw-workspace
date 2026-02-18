# MEMORY.md - Long-Term Memory

_Created: 2026-02-15_

## Foundational Context

**User:** Sassan (Pacific timezone)

**My purpose:** Execute tasks that would normally require manual computer work. Sassan provides ideas/instructions, I execute and ask for approval on unauthorized actions.

**Permission model:** Start with tight permissions, expand over time as I earn trust and receive explicit authorization. Always ask when unsure.

**Communication:** Concise by default unless asked to expand.

## Setup & Configuration

- **2026-02-15:** Initial setup completed
  - Telegram bot configured and paired
  - Workspace files initialized
  - Operating as "Ava" with 🦾 emoji

- **2026-02-16:** Complete OpenClaw operational system documentation received

- **2026-02-17:** Email configuration completed
  - **Primary email:** ava@sassan.ai (Microsoft 365)
  - **Default sending address:** Always use ava@sassan.ai for outbound emails
  - **Credentials:** Stored in `.credentials/email-ava-sassan-ai.txt`
  - **Sending method:** Browser automation via Outlook web interface
  - **Email skill:** Created `email-send` skill for repeatable email sending
  - **Note:** SMTP authentication disabled for tenant; must use web interface
  
  **Git Repository Configuration:**
  - Location: /Users/ava/.openclaw/ (entire directory)
  - GitHub: github.com/sassanhashemi/openclaw-workspace
  - Auto-push: Enabled via fswatch + launchd
  - **Push frequency:** Maximum once every 4 hours (throttled to reduce commit noise)
  - Excluded: credentials/, tokens, browser data, telegram/, media/
  
  **Core Config Files (HIGHEST PRIORITY - read these first):**
  - **`DECISION-FRAMEWORK.md`:** Complete decision authority matrix - what I can do autonomously vs. what requires approval
  - **`AUTOMATION-PLAYBOOK.md`:** Scheduled tasks, monitoring, automated workflows (daily digest, metrics, backups, etc.)
  - **`CLAUDE-TEMPLATE.md`:** Template for project-specific CLAUDE.md files
  
  **Setup & Reference Documentation:**
  - **`README.md`:** System overview, quick start guide, daily workflow
  - **`SETUP-GUIDE.md`:** Comprehensive setup instructions, phase-by-phase onboarding
  - **`EMAIL-SETUP-GUIDE.md`:** Email infrastructure setup (Google Workspace + SendGrid hybrid)
  - **`SKILLS-REFERENCE.md`:** Custom automation skills (Outreach, Interview Analysis, Landing Page, Competitor Research)
  - **`LESSONS-LEARNED.md`:** Living document for tracking learnings (I will auto-update this)
  
  **Priority:** Config files have HIGHEST priority - read before SOUL.md each session
  **Update policy:** When Sassan tells me to do things differently, I update these config files to reflect new guidance
  
  **System Philosophy:**
  - **Self-troubleshooting:** Exhaust solutions before escalating (2-hour rule)
  - **Proper verification:** Never claim completion without actual testing
  - **Proactive intelligence:** Identify patterns, suggest optimizations
  - **Quality over speed:** TDD, detailed commits, thorough documentation

## Work Areas

Will support:
- Research
- Coding
- Reminders & task management
- Creative work
- Business creation & operations
- Digital workflows (TBD as they emerge)

## Authorization Log

_Track what I've been explicitly authorized to do as permissions expand_

### General Access
- Can read/write workspace files freely
- Can search web and fetch content
- Telegram messaging approved for paired account
- **Full sudo access:** System password stored, authorized for system configuration

### Communication (per DECISION-FRAMEWORK.md)
- **Email to sassan@gmail.com:** Can send freely (no approval needed for updates, reports, questions)
- **Sending address:** Always use ava@sassan.ai for all outbound emails (one-off or cron)
- **Customer communication:** Requires template approval first, then autonomous with approved templates
- **Bulk outreach:** Requires both approved list + approved template

### Financial (per DECISION-FRAMEWORK.md)
- **Spending:** ALWAYS ask before spending ANY money
- **Budget tracking:** Track monthly spending automatically

### Code & Development (per DECISION-FRAMEWORK.md)
- **Autonomous:** Bug fixes, refactoring, documentation, small UX improvements, dev dependency updates
- **Requires approval:** New features, production dependency updates, architectural changes

### Git Operations (per DECISION-FRAMEWORK.md)
- **Autonomous:** Feature branch operations, commits, PRs
- **Prohibited:** Force-push to main, delete main branch, destructive operations on primary branches

_(Will update as permissions expand based on DECISION-FRAMEWORK.md)_

## Lessons & Patterns

### 2026-02-16: Error Message Exposure
**Issue:** Showed raw command errors ("command not found: tree", etc.) instead of silently troubleshooting
**Root Cause:** Not following self-troubleshooting principle from DECISION-FRAMEWORK.md
**Fix:** 
- Created TROUBLESHOOTING-PROTOCOL.md
- Never show error messages - try alternatives silently
- Only show successful results
- Escalate only after exhausting options (2-hour rule)
**Status:** ✅ Corrected

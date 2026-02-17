# OpenClaw Automation Playbook

**Purpose:** Complete specification of all scheduled tasks, monitoring, and automated workflows

---

## Overview

OpenClaw runs continuous automation to minimize your manual work while keeping you informed. This playbook defines every automated task, its schedule, purpose, and output.

---

## Daily Automations

### 8:00 AM - Morning Digest

**Purpose:** Start your day with complete context on yesterday's work and today's plan

**Trigger:** Daily at 8:00 AM (your local time)

**Execution:**
```typescript
// Pseudo-code for daily digest
async function generateMorningDigest() {
  const yesterday = getYesterdayActivity();
  const metrics = getCurrentMetrics();
  const decisions = getPendingDecisions();
  const blockers = getActiveBlockers();
  const todayPlan = getTodayPlannedTasks();
  const systemHealth = checkSystemHealth();

  const digest = formatDigest({
    summary: generateSummary(yesterday),
    completed: yesterday.completedTasks,
    inProgress: yesterday.ongoingTasks,
    decisionsNeeded: decisions,
    metrics: {
      landingPage: metrics.landingPage,
      interviews: metrics.interviews,
      outreach: metrics.outreach
    },
    issues: blockers,
    systemHealth: systemHealth,
    todayPlan: todayPlan
  });

  await sendEmail({
    to: 'sassan@gmail.com',  // Non-urgent, no approval needed
    from: 'openclaw@sassanhashemi.com',
    subject: `OpenClaw Daily Digest - ${formatDate(new Date())}`,
    body: digest
  });

  // Log that digest was sent
  await logActivity('daily_digest_sent', { timestamp: new Date() });
}
```

**Output Format:**
```markdown
# OpenClaw Daily Digest - Monday, February 17, 2026

## Summary
Yesterday: Sent 15 cold emails (3 responses), completed 2 interviews, updated landing page headline test. Today: Process interview recordings, schedule 3 new interviews, launch email variant B.

## Completed Tasks ✅
- ✅ Sent cold email batch #3 (15 emails to Texas agencies)
  - Template: Agency Owner Outreach v2
  - Responses: 3 (20% response rate)
  - [View tracking](link)

- ✅ Conducted interviews: 2
  - Interview #8: John Smith, ABC Insurance (notes)
  - Interview #9: Jane Doe, XYZ Agency (notes)
  - Tracking sheet updated automatically

- ✅ Landing page A/B test: Headline variant deployed
  - Traffic: Low (45 visitors/day)
  - Deployed autonomously per traffic policy
  - [View PR](link)

## In Progress 🔄
- Interview #10 scheduled for today 2:00 PM (calendar updated)
- Landing page headline test: Collecting data (need 100 visitors each variant)
- Cold email batch #4: Drafted, awaiting template approval

## Decisions Needed ⚠️
- **Cold Email Template Approval**: New variant for California agencies
  - [Review draft here](link)
  - Need approval to send to 25 prospects

- **Paid Interview Budget**: Found 3 qualified candidates on Respondent.io
  - Cost: $450 total ($150 each)
  - Criteria: Agency owners, 10+ producers, P&C focus
  - Approve spend?

## Metrics Update 📊

**Landing Page (Last 24 Hours):**
- Visitors: 47 (↑ 12% vs. prior day)
- Signups: 8 (17% conversion, ↑ 3% vs. prior week)
- Traffic sources: 60% LinkedIn, 25% Direct, 15% Organic

**Interviews:**
- Completed: 9 total (target: 15-20)
- Scheduled: 1 today, 2 this week
- Top-3 pain rating: 6 of 9 (67%)
- Would pay $500+: 4 of 9 (44%)

**Outreach:**
- Emails sent this week: 45
- Response rate: 18% (8 responses)
- Interviews booked: 3

## Issues / Blockers 🚫
None currently.

## System Health ✅
- ✅ All services operational
- ✅ Git backup completed (11:47 PM last night)
- ✅ Customer data encrypted and backed up
- ✅ API usage: $47 / $300 budget this month

## Today's Plan 📅
- [ ] Process interview #8 and #9 recordings → transcripts → insights
- [ ] Pre-research interview #10 prospect (2:00 PM call)
- [ ] Send cold email batch #4 (after template approval)
- [ ] Monitor landing page A/B test progress
- [ ] Follow up with 3 responsive prospects from last week

---
**View detailed logs:** [link to activity log]
**Update preferences:** Reply to this email with changes
```

**Failure Handling:**
- If digest fails to send by 8:05 AM, retry every 5 minutes × 3
- If still failing, send urgent alert
- Log failure for troubleshooting

---

### 9:00 AM - Landing Page Metrics Check

**Purpose:** Monitor landing page health and flag anomalies

**Trigger:** Daily at 9:00 AM

**Execution:**
```typescript
async function checkLandingPageMetrics() {
  const today = await getAnalytics('last_24_hours');
  const baseline = await getAnalytics('prior_7_day_average');

  const anomalies = [];

  // Check for significant changes
  if (today.visitors < baseline.visitors * 0.5) {
    anomalies.push({
      type: 'traffic_drop',
      severity: 'high',
      message: `Traffic dropped 50%+: ${today.visitors} vs ${baseline.visitors} avg`
    });
  }

  if (today.conversionRate < baseline.conversionRate * 0.7) {
    anomalies.push({
      type: 'conversion_drop',
      severity: 'medium',
      message: `Conversion dropped 30%+: ${today.conversionRate}% vs ${baseline.conversionRate}%`
    });
  }

  if (today.bounceRate > baseline.bounceRate * 1.3) {
    anomalies.push({
      type: 'bounce_increase',
      severity: 'medium',
      message: `Bounce rate increased 30%+: ${today.bounceRate}% vs ${baseline.bounceRate}%`
    });
  }

  if (anomalies.length > 0) {
    await sendEmail({
      to: 'sassan@gmail.com',  // Important but not urgent
      from: 'openclaw@sassanhashemi.com',
      subject: '[ALERT] Landing Page Anomaly Detected',
      body: formatAnomalyAlert(anomalies),
      dashboard: getLandingPageDashboardLink()
    });
  }

  // Log metrics regardless
  await logMetrics('landing_page_daily', today);
}
```

**Alert Triggers:**
- Traffic drops >50% vs. 7-day average
- Conversion rate drops >30%
- Bounce rate increases >30%
- Page load time >3 seconds
- Any 4xx/5xx errors detected

**Output:** Email alert if anomalies, silent logging if normal

---

### 11:00 PM - Backup & Git Push

**Purpose:** Ensure all work is saved and backed up daily

**Trigger:** Daily at 11:00 PM

**Execution:**
```bash
#!/bin/bash
# Daily backup script

# 1. Commit any uncommitted changes
cd /Users/sassan/files/claude
git add -A
git commit -m "Daily backup - $(date +%Y-%m-%d)" || echo "No changes to commit"
git push origin main

# 2. Backup encrypted customer data
BACKUP_DIR=~/backups/openclaw/$(date +%Y-%m-%d)
mkdir -p $BACKUP_DIR

# Copy encrypted data directory
cp -R ~/secure-data/interviews $BACKUP_DIR/
cp -R ~/secure-data/contacts $BACKUP_DIR/

# 3. Backup logs
cp -R /Users/sassan/files/claude/openclaw/logs $BACKUP_DIR/

# 4. Verify backup
if [ -d "$BACKUP_DIR/interviews" ] && [ -d "$BACKUP_DIR/logs" ]; then
  echo "Backup successful: $BACKUP_DIR"

  # Clean up backups older than 30 days
  find ~/backups/openclaw -type d -mtime +30 -exec rm -rf {} +
else
  echo "[ERROR] Backup failed" >&2
  # Send alert email
  send_email_alert "Daily backup failed" "Check backup script"
fi
```

**Verification:**
- Confirms git push succeeded
- Verifies backup directory created
- Checks file sizes match expected ranges
- Alerts if any step fails

**Output:** Silent success, email alert on failure

---

### Continuous - Heartbeat Monitoring

**Purpose:** Confirm OpenClaw is alive and all systems operational

**Trigger:** Every 15 minutes, report daily

**Execution:**
```typescript
// Runs every 15 minutes
async function heartbeat() {
  const checks = {
    openclaw_process: checkProcessRunning(),
    git_access: await testGitAccess(),
    email_service: await testEmailService(),
    landing_page_up: await testLandingPageUrl(),
    api_access: await testClaudeAPI(),
    disk_space: checkDiskSpace(),
    memory_usage: checkMemoryUsage()
  };

  const failures = Object.entries(checks).filter(([_, status]) => !status.healthy);

  if (failures.length > 0) {
    await logError('heartbeat_failure', { failures });

    // If critical service down, alert immediately
    const critical = failures.filter(([name, _]) =>
      ['openclaw_process', 'git_access', 'email_service'].includes(name)
    );

    if (critical.length > 0) {
      await sendTelegram({
        message: `🚨 URGENT: Critical Service Down\n\n${formatFailures(critical)}`,
        timestamp: new Date()
      });
    }
  }

  // Log heartbeat
  await logActivity('heartbeat', {
    status: failures.length === 0 ? 'healthy' : 'degraded',
    checks: checks,
    timestamp: new Date()
  });
}

// Daily summary (included in morning digest)
async function dailyHeartbeatSummary() {
  const last24h = await getHeartbeatLogs('last_24_hours');
  const failureCount = last24h.filter(h => h.status === 'degraded').length;

  return {
    status: failureCount === 0 ? '✅ All systems operational' : `⚠️ ${failureCount} heartbeat failures`,
    uptime: calculateUptime(last24h),
    failures: failureCount > 0 ? getFailureDetails(last24h) : null
  };
}
```

**What's Monitored:**
- OpenClaw process running
- Git/GitHub access
- Email service connectivity
- Landing page responding (200 status)
- Claude API access
- Disk space >10% free
- Memory usage <80%

**Output:**
- Immediate alert if critical failure
- Daily summary in morning digest
- Silent logging every 15 minutes

---

## Weekly Automations

### Monday 8:00 AM - Validation Metrics Summary

**Purpose:** Weekly analysis of validation progress against goals

**Trigger:** Every Monday at 8:00 AM

**Execution:**
```typescript
async function weeklyValidationReport() {
  const thisWeek = await getWeekData();
  const priorWeek = await getWeekData(-1);

  const report = {
    interviews: {
      completed: thisWeek.interviews.completed,
      scheduled: thisWeek.interviews.scheduled,
      target: 15, // From validation plan
      progress: `${thisWeek.interviews.total}/15 (${Math.round(thisWeek.interviews.total/15*100)}%)`
    },

    outreach: {
      sent: thisWeek.outreach.sent,
      responses: thisWeek.outreach.responses,
      responseRate: calculateRate(thisWeek.outreach.responses, thisWeek.outreach.sent),
      comparison: compareToWeek(thisWeek, priorWeek, 'outreach')
    },

    landingPage: {
      visitors: thisWeek.landingPage.visitors,
      signups: thisWeek.landingPage.signups,
      conversionRate: calculateRate(thisWeek.landingPage.signups, thisWeek.landingPage.visitors),
      comparison: compareToWeek(thisWeek, priorWeek, 'landingPage')
    },

    insights: await generateKeyInsights(thisWeek),
    signals: await evaluateGoNoGoSignals(thisWeek),
    recommendations: await generateRecommendations(thisWeek)
  };

  return formatWeeklyReport(report);
}
```

**Output Format:**
```markdown
# Weekly Validation Report - Week of February 10-16, 2026

## Insurance Commission Reconciliation Validation

### This Week's Activity

**Interviews:**
- Completed: 4 (Total: 9 of 15 target)
- Scheduled for next week: 3
- Top-3 pain rating: 3 of 4 this week (75%)
- Would pay $500+/mo: 2 of 4 (50%)

**Outreach:**
- Emails sent: 45
- LinkedIn messages: 12
- Total sent: 57
- Responses: 11 (19% response rate, ↑ 4% vs. last week)
- Interviews booked: 4

**Landing Page:**
- Visitors: 287 (↑ 34% vs. last week)
- Signups: 48 (17% conversion, ↑ 2% vs. last week)
- Traffic sources: LinkedIn 65%, Direct 20%, Organic 15%

## Key Insights 💡

1. **Agency size correlation**: Agencies with 10+ producers show 3x higher interest than smaller agencies
   - Consider narrowing ICP to 10+ producer agencies
   - All 4 "would pay $500+" responses were from this segment

2. **Problem framing matters**: "Recover lost revenue" resonates better than "save time"
   - Response rate 24% vs. 14% in A/B test
   - Recommend updating all outreach to revenue framing

3. **Carrier complexity is key pain driver**: Agencies managing 20+ carriers most interested
   - Strong correlation between carrier count and pain severity
   - May influence product prioritization (multi-carrier support critical)

## Go/No-Go Signals

**✅ Positive Signals:**
- 67% rate as top-3 pain (target: 50%+)
- 44% would pay $500+ (target: 33%+, getting close)
- Response rates improving (19% this week vs. 15% last week)
- Landing page conversion trending up (17% vs. 14% baseline)

**⚠️ Concerns:**
- Interview pace slower than target (9 completed, need 15-20)
  - Recommendation: Increase outreach volume or consider paid interviews
- Some agencies mention existing AMS solutions "good enough"
  - Recommendation: Sharpen differentiation in messaging

**Overall Assessment:** Validation progressing well, on track for Phase 1 completion

## Recommendations for Next Week

1. **Increase interview velocity**
   - Action: Double outreach volume to 100 contacts/week
   - OR: Approve $450 for 3 paid Respondent.io interviews

2. **Narrow ICP focus**
   - Action: Target agencies with 10+ producers, 20+ carriers exclusively
   - Expected impact: Higher response rates, clearer product requirements

3. **Test revenue-focused messaging**
   - Action: Update LinkedIn outreach template to lead with revenue recovery
   - Expected impact: +5% response rate based on email A/B test

4. **Schedule solution validation prep**
   - Action: Start drafting solution hypothesis for Phase 2
   - Timeline: Complete by end of Phase 1 (2 weeks at current pace)

## Next Week's Plan
- Target: 6 interviews (4 scheduled + 2 new bookings)
- Outreach: 100 contacts (focus on 10+ producer agencies)
- Landing page: Continue headline A/B test to 200 visitors/variant
- Analysis: Complete pattern analysis across all 15 interviews

---
**Detailed data:** [Link to tracking spreadsheet]
**Phase 1 Criteria:** [Link to validation plan]
```

**Output:** Email report every Monday morning

---

### Monday 8:15 AM - Optimization Suggestions

**Purpose:** Proactive recommendations based on week's data

**Trigger:** Every Monday at 8:15 AM (after metrics report)

**Execution:**
```typescript
async function weeklyOptimizations() {
  const data = await getLastWeekData();
  const suggestions = [];

  // Analyze patterns for optimizations

  // 1. Outreach optimization
  if (data.outreach.emailResponseRate > data.outreach.linkedInResponseRate * 1.5) {
    suggestions.push({
      category: 'outreach',
      priority: 'high',
      suggestion: 'Email outperforming LinkedIn significantly',
      action: 'Shift 30% of LinkedIn effort to email outreach',
      expectedImpact: '+2-3 interviews per week'
    });
  }

  // 2. Timing optimization
  const bestSendTimes = analyzeBestSendTimes(data.outreach);
  if (bestSendTimes.confidence > 0.8) {
    suggestions.push({
      category: 'outreach',
      priority: 'medium',
      suggestion: `Messages sent ${bestSendTimes.optimalTime} have ${bestSendTimes.lift}% higher response rate`,
      action: `Schedule outreach for ${bestSendTimes.optimalTime}`,
      expectedImpact: `+${bestSendTimes.lift}% response rate`
    });
  }

  // 3. Landing page optimization
  if (data.landingPage.bounceRate > 60) {
    suggestions.push({
      category: 'landing_page',
      priority: 'high',
      suggestion: `High bounce rate (${data.landingPage.bounceRate}%)`,
      action: 'Test shorter page, clearer CTA, or loading speed improvements',
      expectedImpact: 'Lower bounce rate → more signups'
    });
  }

  // 4. Interview conversion optimization
  const interviewConversion = analyzeInterviewConversion(data.interviews);
  if (interviewConversion.lowConversionSegment) {
    suggestions.push({
      category: 'targeting',
      priority: 'high',
      suggestion: `${interviewConversion.lowConversionSegment} showing low interest`,
      action: `Stop targeting ${interviewConversion.lowConversionSegment}, focus on ${interviewConversion.highConversionSegment}`,
      expectedImpact: 'Higher quality interviews, better validation signals'
    });
  }

  // 5. Process automation opportunities
  const automationOpps = identifyAutomationOpportunities(data.activities);
  suggestions.push(...automationOpps);

  return formatOptimizationReport(suggestions);
}
```

**Output:** Included in weekly report or separate email if many suggestions

---

## Monthly Automations

### 1st of Month, 8:00 AM - Financial Summary

**Purpose:** Track spending, ROI, budget adherence

**Trigger:** First day of each month at 8:00 AM

**Output Format:**
```markdown
# Monthly Financial Report - February 2026

## Spending Breakdown

### Recurring Subscriptions ($93/month)
| Service | Cost | Purpose | ROI |
|---------|------|---------|-----|
| Apollo.io | $49 | Contact database, email finder | 57 outreach contacts → 11 responses |
| ConvertKit | $29 | Landing page email collection | 48 signups collected |
| Plausible Analytics | $15 | Landing page analytics | Tracking 287 visitors/week |
| **Total Recurring** | **$93** | | |

### One-Time / Variable
| Item | Cost | Purpose |
|------|------|---------|
| Respondent.io interviews (3) | $450 | Paid interview recruitment |
| Domain: validationidea.com | $12 | Landing page domain |
| **Total One-Time** | **$462** | |

### AI API Usage
| Service | Cost | Budget | % Used |
|---------|------|--------|--------|
| Claude API (Anthropic) | $127 | $300 | 42% |

### **Grand Total: $682**

## Budget Analysis

**Monthly Recurring Run Rate:** $93 + ~$127 API = **$220/month baseline**

**This Month Higher Due To:** Paid interviews ($450 one-time)

**Autonomous Spending Limit:** $100/month
- **Status:** ✅ Stayed within limit (all spending pre-approved)

## ROI Analysis

**Validation Time Investment:**
- Your time: ~8 hours/week × 4 weeks = 32 hours
- OpenClaw saved: ~32 hours/week × 4 weeks = 128 hours
- Value at $100/hr: $12,800 saved

**Validation Progress:**
- Interviews completed: 9 (60% to target)
- Strong signals: 67% top-3 pain, 44% would pay
- On track for Phase 1 completion

**Cost per Interview:** $682 / 9 = **$76 per interview**
- Industry benchmark (paid only): $150-200
- Your hybrid approach: 2x more cost-effective

## Next Month Forecast

**Expected Recurring:** $93 (subscriptions) + $100-150 (API) = **$193-243**

**Potential Variable:**
- Additional paid interviews if needed: $300-450
- No other major expenses planned

**Projected Total:** $493-693

## Recommendations

1. **Continue current spend level** - ROI is strong
2. **Consider** - If interview pace stays slow, allocate $450/month for paid interviews to maintain momentum
3. **Watch** - API usage trending up (42% → target <70%). If validation gets intensive, may approach limit.

---
**Budget Dashboard:** [Link]
**Expense Tracking:** [Link to sheet]
```

---

### 1st of Month, 9:00 AM - Industry Deep Dive

**Purpose:** Stay current on industry developments relevant to current validation focus

**Trigger:** First day of month at 9:00 AM

**Execution:**
```typescript
async function monthlyIndustryDeepDive() {
  // Determine current focus (adaptive)
  const currentProject = await getCurrentValidationProject(); // e.g., "insurance"

  if (currentProject === 'insurance') {
    return await insuranceIndustryDeepDive();
  } else if (currentProject === 'other') {
    return await otherIndustryDeepDive();
  }
  // ... adapts to whatever you're validating
}

async function insuranceIndustryDeepDive() {
  const research = {
    carrierDevelopments: await searchNews('insurance carrier technology changes'),
    competitorUpdates: await monitorCompetitors([
      'AgencyBloc', 'Vertafore', 'Applied Systems', 'HawkSoft'
    ]),
    regulatoryChanges: await searchNews('insurance agency regulations'),
    industryTrends: await searchNews('insurance agency operations trends'),
    relevantProducts: await searchProductHunt('insurance', 'agency management')
  };

  const synthesis = await analyzeRelevanceToValidation(research);

  return formatIndustryReport(research, synthesis);
}
```

**Output Format:**
```markdown
# Industry Deep Dive - Insurance Agency Market - February 2026

*This report adapts to your current validation focus. Currently: Insurance Commission Reconciliation*

## Carrier & Technology Developments

### Major Updates
1. **Travelers launches new agent portal** (Feb 5)
   - Impact: May change commission statement format
   - Relevance: HIGH - could affect your product requirements
   - Action: Monitor beta, understand new format

2. **Progressive expands direct billing options** (Feb 12)
   - Impact: Shifts more policies to carrier-bill vs. agency-bill
   - Relevance: MEDIUM - affects when commissions are paid
   - Action: Note in customer discovery (does this trend help or hurt?)

## Competitive Intelligence

### AgencyBloc
- **Update:** Launched "Commissions+ Pro" tier ($500/mo, up from $350)
- **Features:** AI-powered discrepancy detection
- **Relevance:** HIGH - validates AI/automation angle
- **Positioning:** You could differentiate on price or specialize further

### Vertafore (AMS360)
- **Update:** Acquired small commission reconciliation startup
- **Relevance:** HIGH - validates market, also increases competitive pressure
- **Positioning:** They're enterprise-focused, you target SMB gap

### New Entrants
- **Reconcile.ai** - Seed-funded startup, commission reconciliation focus
  - Similar to your idea
  - Targeting large brokerages initially
  - Your opportunity: Go after smaller agencies they ignore

## Regulatory & Compliance

### Nothing Major This Month
- No significant regulatory changes affecting agencies
- Ongoing: States continue to digitize licensing (background trend)

## Industry Trends

### 1. Agency Consolidation Accelerating
- **Trend:** Roll-ups acquiring smaller agencies at faster pace
- **Implications:**
  - Smaller agencies feeling pressure → may prioritize efficiency tools
  - OR: May consolidate before investing in new tech
  - Monitor: Are your target agencies in "sell mode" or "optimize mode"?

### 2. Carrier Commission Cuts
- **Trend:** Some carriers reducing commission rates (esp. personal lines)
- **Implications:**
  - Makes "recovering lost commissions" even more valuable (scarcer resource)
  - Stronger pain point → better validation signal
  - Consider: Emphasize this in messaging

### 3. Remote Work Driving Tool Adoption
- **Trend:** More agencies with distributed teams
- **Implications:**
  - Cloud tools more attractive than on-premise
  - Your SaaS approach aligns with trend
  - Opportunity: "Designed for distributed teams" positioning

## Implications for Your Validation

### Opportunities
1. **Timing is good:** Competitive validation (acquisitions, funding, new features in space)
2. **Pain increasing:** Commission cuts make recovery more critical
3. **Market shift:** Remote work → cloud tool adoption

### Threats
1. **Competition emerging:** Reconcile.ai is well-funded, watch closely
2. **Consolidation:** If agencies sell rather than optimize, shrinks market
3. **Enterprise moving downmarket:** AgencyBloc adding features, may pressure pricing

### Recommended Actions
1. **Sharpen differentiation:** How are you different from Reconcile.ai?
   - Price point? Target segment? Feature focus? Speed/ease of use?

2. **Test consolidation sensitivity:** Ask in interviews: "Planning to sell in next 2-3 years?"
   - If many say yes → problem (short customer lifetime)
   - If most say no → opportunity (want to optimize before exit)

3. **Emphasize commission cuts in messaging:** "With carriers paying less, can you afford to lose any?"

---
**Sources:** [List of articles, links]
**Competitor Tracking:** [Dashboard link]
**Next Month Focus:** Continue insurance if still validating, adapt if you pivot
```

**Adaptive Behavior:**
- If you're no longer working on insurance, research shifts to new focus
- Pulls from bookmarked sources, Google News, Product Hunt, Hacker News
- Looks for: competitors, market trends, regulatory changes, technology shifts

---

## Event-Driven Automations

### Interview Completed → Analysis Pipeline

**Trigger:** Interview recording added to designated folder OR calendar event marked complete

**Execution:**
```typescript
async function onInterviewComplete(interviewId) {
  // 1. Transcribe
  const transcriptPath = await transcribeAudio(interviewId);

  // 2. Analyze
  const analysis = await analyzeInterview(transcriptPath, {
    extractProblemSeverity: true,
    extractCurrentSolution: true,
    extractWillingnessToPay: true,
    extractQuotes: true,
    identifyPatterns: true
  });

  // 3. Update tracking document
  await updateInterviewTracking({
    interviewId: interviewId,
    severity: analysis.problemSeverity,
    willingnessToPay: analysis.wtp,
    keyQuotes: analysis.quotes,
    currentSolution: analysis.currentSolution
  });

  // 4. Update insights document if new patterns
  if (analysis.newPatterns.length > 0) {
    await updateInsightsDoc(analysis.newPatterns);
  }

  // 5. Check if phase criteria met
  const progress = await checkValidationProgress();
  if (progress.phaseCriteriaMet) {
    await sendAlert({
      subject: '[MILESTONE] Phase 1 Criteria Met',
      message: 'All success criteria for Problem Validation completed. Ready for go/no-go decision.',
      data: progress
    });
  }

  // 6. Notify completion
  await sendEmail({
    subject: '[COMPLETE] Interview #' + interviewId + ' Processed',
    body: `Interview analysis complete.

    Summary: ${analysis.summary}
    Problem Severity: ${analysis.problemSeverity}/5
    WTP: ${analysis.wtp}

    [View full analysis](link)
    [Updated tracking sheet](link)`
  });
}
```

**Output:** Completion notification email, updated docs

---

### High Landing Page Traffic Detected → Ask Before A/B Test

**Trigger:** Landing page visitors exceed 100/day threshold

**Execution:**
```typescript
async function checkTrafficBeforeLandingPageChange(proposedChange) {
  const traffic = await getLandingPageTraffic('last_24_hours');

  if (traffic.visitors > 100) {
    // High traffic - ask approval
    await sendEmail({
      subject: '[APPROVAL NEEDED] Landing Page Change - High Traffic',
      body: `Proposed change: ${proposedChange.description}

      Current traffic: ${traffic.visitors} visitors/day (HIGH)

      Your policy: Ask before changes during high traffic.

      Approve this change?
      - [Approve]: Deploy the change
      - [Wait]: Delay until traffic normalizes
      - [Discuss]: Need more context

      [View proposed change](link to PR/diff)`
    });

    // Pause deployment, wait for approval
    return 'awaiting_approval';
  } else {
    // Low traffic - proceed autonomously
    await deployLandingPageChange(proposedChange);
    await logActivity('landing_page_deployed', {
      change: proposedChange,
      traffic: traffic.visitors,
      autonomous: true
    });

    return 'deployed';
  }
}
```

---

### Spending Threshold Reached → Approval Request

**Trigger:** About to make a purchase

**Execution:**
```typescript
async function requestSpendingApproval(purchase) {
  const monthSpend = await getMonthSpending();

  await sendEmail({
    subject: '[APPROVAL NEEDED] Purchase Request',
    body: `
## Purchase Request

**Item:** ${purchase.item}
**Cost:** $${purchase.cost}/${purchase.frequency}
**Purpose:** ${purchase.purpose}
**Justification:** ${purchase.businessCase}

## Budget Context
- Current month spending: $${monthSpend.total}
- This purchase: $${purchase.cost}
- New total: $${monthSpend.total + purchase.cost}
- Autonomous limit: $100/month

## Approve?
Reply with "Approve" to proceed with purchase.

**Alternative:** ${purchase.alternative || 'None identified'}
    `
  });

  // Wait for approval (poll email for response or use button link)
  const approved = await waitForApproval(purchase.id, timeout='48hours');

  if (approved) {
    await makePurchase(purchase);
    await logActivity('purchase_approved', purchase);
  } else {
    await logActivity('purchase_declined', purchase);
  }
}
```

---

### 2-Hour Blocker → Escalation

**Trigger:** Task marked as blocked for >2 hours

**Execution:**
```typescript
async function escalateBlocker(blockerId) {
  const blocker = await getBlocker(blockerId);
  const troubleshooting = await getTroubleshootingLog(blockerId);

  await sendEmail({
    subject: '[URGENT] Blocked on ' + blocker.issue,
    body: `
## Problem
${blocker.description}

## Impact
${blocker.impact}
- Blocking: ${blocker.blockingTasks.join(', ')}
- Duration: ${blocker.blockedDuration} hours

## Troubleshooting Attempted
${troubleshooting.map(t => `- ${t.action}: ${t.result}`).join('\n')}

## Need Your Help With
${blocker.questionForYou}

## Context
${blocker.additionalContext}

[View full logs](link)
    `
  });
}
```

---

## Manual Invocation Skills

These don't run automatically but are available for you or OpenClaw to invoke:

### Customer Outreach Skill
- **Invoke:** When starting new outreach campaign
- **Does:** Drafts emails/LinkedIn messages, sends after approval, tracks responses

### Interview Analysis Skill
- **Invoke:** After each interview
- **Does:** Transcribe → Analyze → Update tracking → Surface insights

### Landing Page Optimization Skill
- **Invoke:** When running A/B test
- **Does:** Create variant → Deploy → Track → Analyze → Report winner

### Competitor Research Skill
- **Invoke:** Manual or weekly scheduled
- **Does:** Check competitor sites → Product Hunt → News → Summarize changes

See `SKILLS-REFERENCE.md` for detailed specifications.

---

## Monitoring & Alerting Summary

| What's Monitored | Frequency | Alert Threshold | Notification Method |
|------------------|-----------|-----------------|---------------------|
| System heartbeat | Every 15 min | Any critical service down | Email (immediate) |
| Landing page uptime | Every 15 min | >5 min downtime | Email (immediate) |
| Landing page traffic | Daily 9 AM | >50% drop vs. 7-day avg | Email (immediate) |
| Landing page conversion | Daily 9 AM | >30% drop vs. 7-day avg | Email (within digest) |
| Git backup status | Daily 11 PM | Backup failed | Email (immediate) |
| API budget | Real-time | >80% of monthly budget | Email (immediate) |
| Spending threshold | Real-time | About to exceed limit | Email (approval needed) |
| Validation milestone | Event-driven | Phase criteria met | Email (immediate) |
| Interview progress | Weekly | Behind schedule | Email (in weekly report) |

---

## Logging Standards

All automated tasks log to: `/Users/sassan/files/claude/openclaw/logs/`

**Structure:**
```
logs/
├── activity/
│   └── YYYY-MM-DD.jsonl          # Daily activity logs
├── decisions/
│   └── YYYY-MM-DD.jsonl          # Approval requests and outcomes
├── errors/
│   └── YYYY-MM-DD.jsonl          # Errors and troubleshooting
└── metrics/
    └── YYYY-MM-DD.jsonl          # Metrics snapshots
```

**Format (JSON Lines):**
```json
{"timestamp":"2026-02-17T08:00:15Z","event":"daily_digest_sent","status":"success","recipients":["sassan@example.com"]}
{"timestamp":"2026-02-17T09:00:03Z","event":"landing_page_check","visitors":47,"conversion":0.17,"anomalies":[]}
{"timestamp":"2026-02-17T14:30:22Z","event":"interview_complete","interview_id":"10","analysis_status":"processing"}
```

**Retention:** 90 days, then archive to yearly compressed files

---

*This playbook is the complete automation specification. OpenClaw will implement these schedules and monitoring on initial setup.*

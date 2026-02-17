# OpenClaw Skills Reference

**Purpose:** Specifications for custom skills that automate repetitive validation tasks

---

## Overview

Skills are reusable automation modules that OpenClaw creates for common patterns. Each skill has:
- **Trigger:** How it's invoked (manual, scheduled, event-driven)
- **Input:** What data it needs
- **Process:** What it does step-by-step
- **Output:** What it produces
- **Success Criteria:** How to verify it worked

---

## Skill 1: Customer Outreach

**Purpose:** Draft and send customer discovery outreach messages

**Status:** Build this first (highest priority)

### Trigger Options
- **Manual:** You invoke: `openclaw outreach --campaign=texas-agencies`
- **Scheduled:** Weekly batch on Mondays
- **Event:** After validation plan handed off

### Input
```yaml
campaign:
  name: "Texas Agency Owners - Cold Email Batch #1"
  channel: "email"  # or "linkedin", "forum"
  target_list:
    source: "Apollo.io"
    filters:
      - job_title: "Insurance Agency Owner"
      - location: "Texas"
      - company_size: "10-50 employees"
    count: 50

  template_name: "problem_validation_v1"  # References approved template
  personalization:
    - company_name: true
    - location: true
    - recent_news: false  # Too time-consuming for large batches

  send_policy:
    approval: "template_approved"  # or "per_batch", "per_message"
    batch_size: 25
    delay_between: "2-5 minutes"  # Avoid spam filters
```

### Process

**Step 1: Validate Prerequisites**
```typescript
async function validateOutreachCampaign(campaign) {
  // Check template is approved
  const template = await getTemplate(campaign.template_name);
  if (!template.approved) {
    throw new Error('Template not approved. Need first 3-5 examples approved.');
  }

  // Check target list quality
  const list = await getTargetList(campaign.target_list);
  if (list.length === 0) {
    throw new Error('Empty target list');
  }

  // Check we're not exceeding rate limits
  const todaySent = await getTodayOutreachCount();
  if (todaySent + list.length > dailyLimit) {
    throw new Error('Would exceed daily limit');
  }

  return { template, list };
}
```

**Step 2: Generate Personalized Messages**
```typescript
async function generateMessages(template, targetList, personalization) {
  const messages = [];

  for (const prospect of targetList) {
    const message = {
      to: prospect.email,
      subject: personalizeTemplate(template.subject, prospect, personalization),
      body: personalizeTemplate(template.body, prospect, personalization),
      prospect_id: prospect.id
    };

    // Quality check
    if (!hasPersonalization(message) && personalization.length > 0) {
      logWarning('Message not personalized', { prospect: prospect.id });
    }

    messages.push(message);
  }

  return messages;
}

function personalizeTemplate(templateText, prospect, personalization) {
  let personalized = templateText;

  // Replace variables
  personalized = personalized.replace(/{{company_name}}/g, prospect.company);
  personalized = personalized.replace(/{{first_name}}/g, prospect.firstName);
  personalized = personalized.replace(/{{location}}/g, prospect.location);

  // Verify no unreplaced variables
  if (personalized.includes('{{')) {
    logWarning('Unreplaced template variable', { text: personalized });
  }

  return personalized;
}
```

**Step 3: Send Messages (with Rate Limiting)**
```typescript
async function sendMessageBatch(messages, sendPolicy) {
  const results = [];

  for (const message of messages) {
    try {
      // Send via OpenClaw email account
      await sendEmail({
        from: 'openclaw@yourdomain.com',
        to: message.to,
        subject: message.subject,
        body: message.body,
        tracking: true  // Track opens/clicks if supported
      });

      results.push({
        prospect_id: message.prospect_id,
        status: 'sent',
        timestamp: new Date()
      });

      // Track in database
      await logOutreach({
        campaign: campaign.name,
        prospect: message.prospect_id,
        channel: 'email',
        status: 'sent',
        timestamp: new Date()
      });

      // Delay between sends
      await randomDelay(sendPolicy.delay_between);

    } catch (error) {
      results.push({
        prospect_id: message.prospect_id,
        status: 'failed',
        error: error.message
      });

      logError('Failed to send email', {
        prospect: message.prospect_id,
        error: error.message
      });
    }
  }

  return results;
}
```

**Step 4: Track & Report**
```typescript
async function reportOutreachResults(campaign, results) {
  const summary = {
    sent: results.filter(r => r.status === 'sent').length,
    failed: results.filter(r => r.status === 'failed').length,
    responses: 0,  // Updated as responses come in
    response_rate: 0  // Calculated after 48-72 hours
  };

  // Update campaign tracking sheet
  await updateCampaignSheet(campaign.name, summary);

  // Send completion notification
  await sendEmail({
    to: 'sassan@example.com',
    subject: `[COMPLETE] Outreach Campaign: ${campaign.name}`,
    body: `
Campaign completed.

**Sent:** ${summary.sent} messages
**Failed:** ${summary.failed} messages

**Template Used:** ${campaign.template_name}
**Channel:** ${campaign.channel}

Will track responses over next 72 hours and update metrics.

[View tracking sheet](link)
[View detailed logs](link)
    `
  });
}
```

### Output

**Immediate:**
- Completion notification email
- Updated outreach tracking spreadsheet
- Activity log entries

**Over Time (48-72 hours):**
- Response tracking (monitors inbox for replies)
- Updates response rate in tracking sheet
- Flags promising responses for your review

### Success Criteria

- ✅ All messages sent without bounce errors
- ✅ Template personalization applied correctly (no {{variables}} visible)
- ✅ Tracking sheet updated with sent status
- ✅ No spam filter triggers (test emails delivered to inbox)
- ✅ Responses correctly linked back to prospects

### Example Approved Templates

**Template: problem_validation_v1 (Email)**
```
Subject: Question about commission reconciliation at {{company_name}}

Hi {{first_name}},

I'm researching how independent insurance agencies handle commission reconciliation — the monthly process of matching carrier statements to expected payments.

I've heard some agencies lose $20K+ annually to missed commissions. Is that real, or overblown?

Would you have 15 minutes to share your experience? No sales pitch — just research. Happy to share what I learn from other agencies.

Best,
Sassan

P.S. Researching this as part of a broader project on insurance agency operations. Your insights would be genuinely helpful.
```

**Status:** ⏳ Awaiting approval (need 3-5 successful test sends first)

---

## Skill 2: Interview Analysis

**Purpose:** End-to-end processing of interview recordings into structured insights

**Status:** Build this second

### Trigger Options
- **Event-Driven:** New recording added to interviews folder
- **Manual:** You invoke after an interview
- **Scheduled:** Batch process pending interviews nightly

### Input
```yaml
interview:
  id: "10"
  date: "2026-02-17"
  prospect:
    name: "John Smith"
    company: "ABC Insurance Agency"
    title: "Agency Owner"
  recording_path: "~/secure-data/interviews/recordings/interview-10.m4a"
  context:
    referral: "LinkedIn cold outreach"
    agency_size: "12 producers"
    lines: "P&C"
```

### Process

**Step 1: Transcribe Audio**
```typescript
async function transcribeInterview(recordingPath) {
  // Use Whisper API or similar
  const transcription = await whisperAPI.transcribe({
    audio_file: recordingPath,
    model: 'whisper-1',
    language: 'en',
    format: 'verbose_json'  // Get timestamps for quotes
  });

  // Save transcript
  const transcriptPath = recordingPath.replace('.m4a', '-transcript.txt');
  await saveFile(transcriptPath, formatTranscript(transcription));

  return { transcriptPath, transcription };
}
```

**Step 2: Analyze with Claude**
```typescript
async function analyzeInterviewTranscript(transcript, context) {
  const prompt = `
You are analyzing a customer discovery interview for a B2B SaaS validation.

**Context:**
- Prospect: ${context.prospect.name}, ${context.prospect.title} at ${context.prospect.company}
- Agency: ${context.agency_size} producers, ${context.lines} focus
- Problem: Insurance agency commission reconciliation

**Interview Transcript:**
${transcript}

**Extract the following:**

1. **Problem Severity (1-5 scale):**
   - How painful is commission reconciliation for them?
   - Signals: Time spent, money lost, stress level, priority ranking

2. **Current Solution:**
   - How do they solve it today?
   - What tools/processes?
   - What's working? What's broken?

3. **Willingness to Pay:**
   - Did they mention budget or what they'd pay?
   - Extract any dollar amounts or ranges mentioned
   - Classify: No / Maybe / Yes $X/month

4. **Key Quotes (3-5 most important):**
   - Exact quotes that capture the pain, priorities, or objections
   - Include timestamp if possible

5. **Patterns & Insights:**
   - Any surprising findings?
   - Confirms or contradicts earlier hypotheses?
   - Signals about ICP, positioning, features?

6. **Design Partner Potential (Low/Medium/High):**
   - Would they be a good design partner?
   - Signals: Enthusiasm, problem severity, decision authority

7. **Follow-up Actions:**
   - Should we follow up? When? For what?

Return as structured JSON.
  `;

  const analysis = await claude({
    model: 'claude-sonnet-4-5',
    prompt: prompt,
    max_tokens: 2000
  });

  return JSON.parse(analysis);
}
```

**Step 3: Update Tracking Documents**
```typescript
async function updateInterviewTracking(interviewId, analysis, context) {
  // 1. Update main tracking spreadsheet
  await updateSpreadsheet('Interview Tracking', {
    row: interviewId,
    data: {
      name: context.prospect.name,
      company: context.prospect.company,
      date: context.date,
      severity: analysis.problemSeverity,
      wtp: analysis.willingnessToPay,
      current_solution: analysis.currentSolution,
      design_partner_potential: analysis.designPartnerPotential,
      key_quote: analysis.keyQuotes[0]  // Top quote
    }
  });

  // 2. Add detailed notes document
  await createInterviewNotesDoc(interviewId, {
    context: context,
    transcript: transcriptPath,
    analysis: analysis,
    recommendations: analysis.followUpActions
  });

  // 3. Update insights/patterns document if new patterns found
  if (analysis.patternsInsights.length > 0) {
    await updateInsightsDoc({
      source: `Interview ${interviewId}`,
      insights: analysis.patternsInsights
    });
  }

  // 4. Check validation progress
  const progress = await checkPhaseProgress();
  if (progress.criteriaStatusChanged) {
    await logMilestone('validation_progress_update', progress);
  }
}
```

**Step 4: Report Results**
```typescript
async function reportInterviewAnalysis(interviewId, analysis) {
  await sendEmail({
    subject: `[COMPLETE] Interview #${interviewId} Analysis`,
    body: `
Interview with ${context.prospect.name} (${context.prospect.company}) analyzed.

## Quick Summary
**Problem Severity:** ${analysis.problemSeverity}/5 ${'⭐'.repeat(analysis.problemSeverity)}
**Current Solution:** ${analysis.currentSolution.summary}
**Willingness to Pay:** ${analysis.willingnessToPay}
**Design Partner Potential:** ${analysis.designPartnerPotential}

## Top Insights
${analysis.patternsInsights.map(i => `- ${i}`).join('\n')}

## Key Quote
> "${analysis.keyQuotes[0]}"

## Follow-up
${analysis.followUpActions.join('\n')}

---
**[View full transcript](${transcriptPath})**
**[View detailed analysis](${notesPath})**
**[Updated tracking sheet](${sheetLink})**

## Validation Progress
- Interviews completed: ${progress.interviewsCompleted} / 15-20 target
- Top-3 pain: ${progress.top3PainCount} / 10 target
- WTP $500+: ${progress.wtpCount} / 5 target
    `
  });
}
```

### Output

**Generated:**
- Transcript file (text)
- Analysis document (markdown)
- Updated tracking spreadsheet (auto)
- Insights document updated (if new patterns)
- Completion notification email

### Success Criteria

- ✅ Transcript accurate (spot-check key moments)
- ✅ Problem severity rating defensible from transcript
- ✅ WTP extracted correctly (or marked as "not mentioned")
- ✅ Key quotes are actual quotes, not paraphrased
- ✅ Tracking sheet updated within 1 hour of interview completion

---

## Skill 3: Landing Page Optimization

**Purpose:** Run A/B tests on landing page, measure results, iterate

**Status:** Build this third

### Trigger Options
- **Manual:** You request a test: `openclaw landing-test --element=headline --variants=3`
- **Proactive:** OpenClaw suggests test based on metrics
- **Scheduled:** Weekly optimization check

### Input
```yaml
test:
  element: "headline"  # or "cta", "copy", "layout", "image"
  hypothesis: "Revenue-focused headline will outperform time-saving headline"
  variants:
    - type: "control"
      content: "Stop Losing Time on Commission Reconciliation"

    - type: "variant_a"
      content: "Recover $20K+ in Lost Commissions Annually"

    - type: "variant_b"
      content: "Never Miss a Commission Payment Again"

  success_metric: "email_signup_rate"
  sample_size: 100  # visitors per variant
  confidence_level: 0.90
```

### Process

**Step 1: Check Traffic Policy**
```typescript
async function checkTrafficPolicy(test) {
  const recentTraffic = await getLandingPageTraffic('last_24_hours');

  if (recentTraffic.visitors > 100) {
    // High traffic - ask approval
    await requestApproval({
      type: 'landing_page_test',
      test: test,
      traffic: recentTraffic,
      reason: 'Traffic >100 visitors/day per your policy'
    });

    const approved = await waitForApproval(test.id);
    if (!approved) {
      return 'test_cancelled';
    }
  }

  // Low traffic or approved - proceed
  return 'proceed';
}
```

**Step 2: Implement A/B Test**
```typescript
async function deployABTest(test) {
  // Create feature branch
  await git.createBranch(`ab-test/${test.element}-${Date.now()}`);

  // Implement variants
  for (const variant of test.variants) {
    await implementVariant(variant, test.element);
  }

  // Add analytics tracking
  await addAnalyticsTracking(test);

  // Run tests
  await runTests();

  // Create PR
  const pr = await github.createPR({
    title: `A/B Test: ${test.hypothesis}`,
    body: formatTestDescription(test),
    branch: `ab-test/${test.element}-${Date.now()}`
  });

  // If autonomous deployment approved
  if (trafficPolicy === 'proceed' && !test.requiresPR) {
    await mergePR(pr);
    await deployToProduction();
  }

  return { pr, deployed: true };
}
```

**Step 3: Monitor Test Progress**
```typescript
async function monitorABTest(test) {
  // Check daily until sample size reached
  while (true) {
    const results = await getTestResults(test.id);

    if (results.control.visitors >= test.sample_size &&
        results.variant_a.visitors >= test.sample_size) {
      // Sufficient data
      break;
    }

    // Report progress in daily digest
    await logTestProgress(test.id, results);

    await sleep('24 hours');
  }

  // Analyze results
  const analysis = await analyzeTestResults(test, results);

  return analysis;
}
```

**Step 4: Determine Winner & Implement**
```typescript
async function concludeABTest(test, results, analysis) {
  const winner = analysis.winner;  // 'control', 'variant_a', or 'variant_b'
  const confidence = analysis.confidence;

  if (confidence < test.confidence_level) {
    // Inconclusive
    await reportInconclusiveTest(test, results);
    return 'inconclusive';
  }

  // Implement winner permanently
  await implementWinner(test, winner);

  // Update tracking
  await logTestCompletion(test, winner, results);

  // Report
  await reportTestWinner(test, winner, results, analysis);

  return 'complete';
}
```

### Output

**Progress Updates:**
- Included in daily digest: "A/B test running: X/Y visitors collected"

**Completion Report:**
```markdown
Subject: [COMPLETE] A/B Test Results: Headline

## Test Complete

**Hypothesis:** Revenue-focused headline will outperform time-saving headline

## Results

| Variant | Visitors | Signups | Conversion Rate |
|---------|----------|---------|-----------------|
| Control: "Stop Losing Time..." | 102 | 14 | 13.7% |
| Variant A: "Recover $20K+..." | 98 | 22 | **22.4%** ⭐ |
| Variant B: "Never Miss..." | 105 | 16 | 15.2% |

## Winner: Variant A

**Statistical Confidence:** 94% (exceeded 90% target ✅)
**Improvement:** +8.7 percentage points (+63% relative increase)

## Action Taken
- Implemented Variant A as new permanent headline
- Removed Control and Variant B
- Deployed to production

## Insights
Revenue framing significantly outperforms time/convenience framing for this audience. Consider applying this learning to:
- Email outreach subject lines
- LinkedIn messages
- Ad copy (if running ads)

---
[View detailed analytics](link)
[Deployed PR](link)
```

### Success Criteria

- ✅ Test deployed without breaking site
- ✅ Traffic split evenly across variants
- ✅ Sample size reached for valid results
- ✅ Winner implemented correctly
- ✅ Learnings documented for future application

---

## Skill 4: Competitor Research

**Purpose:** Monitor competitive landscape and market changes

**Status:** Build this fourth (lower priority initially)

### Trigger Options
- **Scheduled:** Weekly on Sundays
- **Manual:** On-demand deep dive
- **Event:** When alerted to competitor update

### Input
```yaml
competitors:
  - name: "AgencyBloc"
    url: "https://agencybloc.com"
    monitor:
      - pricing_page: "/pricing"
      - product_updates: "/blog"
      - job_postings: "lever.co/agencybloc"

  - name: "Vertafore"
    url: "https://vertafore.com"
    monitor:
      - press_releases: "/news"
      - product_pages: "/products/ams360"

  - name: "Core Commissions"
    url: "https://corecommissions.com"
    monitor:
      - home_page: "/"
      - features: "/features"

  - name: "Reconcile.ai" # New entrant
    url: "https://reconcile.ai"
    monitor:
      - all_pages: true  # Track everything for new competitor

sources:
  - product_hunt: "insurance"
  - hacker_news: "insurance agency"
  - google_news: "insurance agency software"
```

### Process

**Step 1: Fetch & Compare**
```typescript
async function monitorCompetitors(competitors) {
  const updates = [];

  for (const competitor of competitors) {
    for (const [type, url] of Object.entries(competitor.monitor)) {
      const current = await fetchPage(competitor.url + url);
      const previous = await loadPreviousSnapshot(competitor.name, url);

      if (hasChanged(current, previous)) {
        const diff = computeDiff(previous, current);
        updates.push({
          competitor: competitor.name,
          page: type,
          changes: diff,
          significance: assessSignificance(diff)
        });

        // Save new snapshot
        await saveSnapshot(competitor.name, url, current);
      }
    }
  }

  return updates;
}
```

**Step 2: Analyze Significance**
```typescript
function assessSignificance(changes) {
  // High: Pricing changes, new major features, acquisitions
  // Medium: Product updates, blog posts, case studies
  // Low: Minor copy changes, design updates

  if (changes.includes('pricing')) return 'high';
  if (changes.includes('new feature announced')) return 'high';
  if (changes.includes('blog post')) return 'medium';

  return 'low';
}
```

**Step 3: Report**
```typescript
async function reportCompetitorUpdates(updates) {
  if (updates.length === 0) {
    // No changes - silent
    return;
  }

  const highPriority = updates.filter(u => u.significance === 'high');

  if (highPriority.length > 0) {
    // Immediate notification
    await sendEmail({
      subject: `[COMPETITOR ALERT] ${highPriority.length} Major Updates`,
      body: formatCompetitorAlert(highPriority)
    });
  }

  // All updates included in weekly report
  await logCompetitorUpdates(updates);
}
```

### Output

- Weekly summary (included in weekly report)
- Immediate alert for major changes
- Competitor tracking log updated

### Success Criteria

- ✅ Detects pricing changes within 24 hours
- ✅ Identifies new competitors entering space
- ✅ Flags significant product updates
- ✅ Minimizes false positives (minor design changes)

---

## Skill Creation Process

### When OpenClaw Suggests New Skills

**Trigger:** Detects pattern repeated 3+ times

**Example:**
```markdown
Subject: [SUGGESTION] New Skill Opportunity

I've noticed a repeated pattern that could be automated:

**Pattern:** Researching each interview prospect before calls

**Occurrences:** 9 times (once per interview)

**Current Process:**
1. Search LinkedIn for prospect
2. Visit company website
3. Check agency size/lines on directory
4. Summarize in brief for you
5. Time: ~15 min per prospect

**Proposed Skill: "Pre-Interview Research"**

**What it would do:**
- Automatically triggered when interview scheduled
- Researches: LinkedIn, company site, insurance directories
- Creates briefing doc delivered 1 hour before call
- Estimated time savings: 15 min × 20 interviews = 5 hours

**Approve creation of this skill?**
```

**Your Response Options:**
- "Approve" → OpenClaw builds the skill
- "Modify [details]" → Adjust spec then build
- "Not yet" → Wait for more data
- "Manual is fine" → Don't automate this

---

## Skill Quality Standards

Every skill must:

1. **Have Clear Success Criteria**
   - How to verify it worked correctly
   - What "good output" looks like

2. **Handle Errors Gracefully**
   - Retry transient failures (network issues)
   - Escalate persistent failures
   - Never fail silently

3. **Log Thoroughly**
   - Every execution logged
   - Inputs, outputs, duration, errors
   - Enables debugging and improvement

4. **Verify Before Reporting Complete**
   - Check output quality
   - Confirm actions taken
   - Don't claim success without proof

5. **Learn from Outcomes**
   - Track success rates
   - A/B test variations
   - Optimize based on data

---

## Skill Metrics Dashboard

OpenClaw tracks for each skill:

| Skill | Executions | Success Rate | Avg Duration | Time Saved | Last Run |
|-------|-----------|--------------|--------------|-----------|----------|
| Customer Outreach | 5 campaigns | 100% | 12 min | 3 hours | 2026-02-16 |
| Interview Analysis | 9 interviews | 100% | 8 min | 4.5 hours | 2026-02-17 |
| Landing Page Optimization | 1 test | 100% | 5 days | 2 hours | Running |
| Competitor Research | 3 runs | 100% | 25 min | 1.5 hours | 2026-02-16 |

**Total Time Saved This Month:** 11 hours

---

*Skills are built iteratively. Start with the four core skills, then expand based on patterns OpenClaw identifies.*

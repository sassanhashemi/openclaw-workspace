---
name: email-send
description: Send emails from ava@sassan.ai via Outlook web interface. Use when asked to send email (one-off messages, cron job emails, or any outbound email communication).
---

# Email Sending Skill

Send emails from **ava@sassan.ai** using the Outlook web interface browser automation.

## Default Configuration

- **From address:** ava@sassan.ai (always use this address)
- **Credentials:** Stored in `.credentials/email-ava-sassan-ai.txt`
- **Method:** Browser automation via Outlook web interface (smtp.office365.com authentication is disabled for this tenant)

## Workflow

### 1. Compose via Deep Link

Use Outlook's compose deep link to pre-fill recipient and subject:

```javascript
const composeUrl = `https://outlook.office.com/mail/0/deeplink/compose?to=${encodeURIComponent(recipient)}&subject=${encodeURIComponent(subject)}`;
```

Navigate to this URL with browser automation.

### 2. Fill Email Body

Wait for page load (3-4 seconds), then inject the email body:

```javascript
browser.act({
  kind: "evaluate",
  fn: `() => {
    const body = document.querySelector('[role="textbox"]') || document.querySelector('[contenteditable="true"]');
    if (body) {
      body.focus();
      body.innerHTML = \`<div>${emailBodyHtml}</div>\`;
      body.dispatchEvent(new Event('input', { bubbles: true }));
      return 'Body filled';
    }
    return 'Could not find body';
  }`
});
```

**Email body format:** Use HTML with `<div>` tags for paragraphs. Convert plain text line breaks to `<div>` elements.

### 3. Send Email

Click the Send button:

```javascript
browser.act({
  kind: "evaluate",
  fn: `() => {
    const sendButton = document.querySelector('[aria-label="Send"]') || 
                      document.querySelector('button[name="Send"]') || 
                      Array.from(document.querySelectorAll('button')).find(btn => btn.textContent.trim() === 'Send');
    if (sendButton) {
      sendButton.click();
      return 'Email sent!';
    }
    return 'Could not find Send button';
  }`
});
```

### 4. Verify Sent

Wait 3 seconds after clicking send. A successful send shows a confirmation page with "You may now close this window" message.

## Example

To send an email to `sassan@gmail.com` with subject "Test" and body "Hello":

1. Navigate to: `https://outlook.office.com/mail/0/deeplink/compose?to=sassan%40gmail.com&subject=Test`
2. Wait 4 seconds for page load
3. Inject body HTML: `<div>Hello</div>`
4. Click Send button
5. Wait 3 seconds to verify

## Notes

- Always use `profile: openclaw` for browser automation
- SMTP authentication is disabled for this Microsoft 365 tenant; web interface is the only option
- Email credentials are stored securely in `.credentials/email-ava-sassan-ai.txt`
- All emails sent from Ava should use ava@sassan.ai as the sender

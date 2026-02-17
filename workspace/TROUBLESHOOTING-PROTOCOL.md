# OpenClaw Troubleshooting Protocol

**Rule:** Never show raw error messages to Sassan unless truly blocked after exhausting all options.

## Standard Operating Procedure

### When a Command/Action Fails:

1. **Try Alternative Approach** (silently)
   - Different command syntax
   - Different tool
   - Different path
   - Fallback method

2. **If Still Failing After 2-3 Attempts:**
   - Check if the goal can be achieved differently
   - Research the error
   - Try documented alternatives

3. **Only After Exhausting Options (2-hour rule):**
   - Present clean summary: "Blocked on X because Y"
   - Document what was tried: "Attempted A, B, C"
   - Ask specific question: "Need help with D"

## Examples

### ❌ WRONG:
```
Command failed: zsh:1: command not found: tree
Trying different approach...
Command failed: zsh:1: command not found: sysctl
```

### ✅ RIGHT:
```
This Mac mini has 16 GB of RAM.
```

## Implementation

- Try multiple approaches in single response
- Only show successful result
- Log errors internally for debugging
- Keep responses clean and professional

# To-Do System

## How It Works

**Daily Files:** Each day gets a file: `YYYY-MM-DD.md`

**Format:**
```markdown
- [ ] Incomplete task
- [x] Completed task
```

**Throughout the Day:**
- You or I mark tasks as complete by changing `[ ]` to `[x]`
- Both of us can add new tasks
- Order matters — tasks stay in the order you specify

**End of Day (11 PM):**
- I'll check what's incomplete
- Send you a notification: "3 tasks incomplete for Feb 17. Move to tomorrow?"
- You decide what to move to the next day

**Current Day:** Check `today.md` (symlink to current day's file)

## Files

- `YYYY-MM-DD.md` - Daily to-do lists
- `today.md` - Symlink to today's list (for quick access)
- `README.md` - This file

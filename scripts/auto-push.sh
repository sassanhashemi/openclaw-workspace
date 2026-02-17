#!/bin/bash
# Auto-push script for OpenClaw workspace
# Watches for file changes and pushes to GitHub (max once per 4 hours)

cd /Users/ava/.openclaw

# Time throttle: only push once every 4 hours
THROTTLE_SECONDS=$((4 * 60 * 60))  # 4 hours in seconds
TIMESTAMP_FILE="/Users/ava/.openclaw/.git/last-auto-push"

push_changes() {
    current_time=$(date +%s)
    
    # Check if any changes exist
    if git diff --quiet && git diff --staged --quiet; then
        return 0
    fi
    
    # Read last push time from file (if exists)
    if [ -f "$TIMESTAMP_FILE" ]; then
        last_push=$(cat "$TIMESTAMP_FILE")
    else
        last_push=0
    fi
    
    # Throttle check: only push if 4+ hours have passed
    time_since_last=$((current_time - last_push))
    if (( time_since_last < THROTTLE_SECONDS )); then
        # Too soon - skip this push
        return 0
    fi
    
    # Add, commit, and push
    git add -A
    
    # Get summary of changes
    CHANGES=$(git diff --staged --stat | tail -1)
    
    if [ -n "$CHANGES" ]; then
        git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')

$CHANGES"
        git push
        
        # Update timestamp file
        echo "$current_time" > "$TIMESTAMP_FILE"
    fi
}

# Watch for changes, excluding .git directory
fswatch -o -e "\.git" /Users/ava/.openclaw | while read; do
    push_changes
done

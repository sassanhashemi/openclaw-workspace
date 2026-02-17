#!/bin/bash
# Auto-push script for OpenClaw workspace
# Watches for file changes and pushes to GitHub

cd /Users/ava/.openclaw

# Debounce: wait for changes to settle before pushing
DEBOUNCE_SECONDS=5
LAST_PUSH=0

push_changes() {
    current_time=$(date +%s)
    
    # Check if any changes exist
    if git diff --quiet && git diff --staged --quiet; then
        return 0
    fi
    
    # Debounce check
    if (( current_time - LAST_PUSH < DEBOUNCE_SECONDS )); then
        return 0
    fi
    
    LAST_PUSH=$current_time
    
    # Add, commit, and push
    git add -A
    
    # Get summary of changes
    CHANGES=$(git diff --staged --stat | tail -1)
    
    if [ -n "$CHANGES" ]; then
        git commit -m "Auto-sync: $(date '+%Y-%m-%d %H:%M:%S')

$CHANGES"
        git push
    fi
}

# Watch for changes, excluding .git directory
fswatch -o -e "\.git" /Users/ava/.openclaw | while read; do
    push_changes
done

#!/bin/bash
# UNJAIL RUNNER
# Run this in your host terminal to allow the agent to execute commands autonomously.
# Instructions:
# 1. cd to your project workspace root.
# 2. Run this script: ~/.gemini/antigravity/skills/unjail/scripts/unjail_runner.sh

# Uses relative paths to the current workspace root
REQUEST_FILE="AGENT_UNJAIL_REQUEST.sh"
RESPONSE_FILE="AGENT_UNJAIL_RESPONSE.json"

echo "--------------------------------------------------------"
echo "  ANTIGRAVITY UNJAIL RUNNER IS ACTIVE"
echo "  Workspace: $(pwd)"
echo "  (Press Ctrl+C to stop)"
echo "--------------------------------------------------------"

# Ensure jq is installed or use fallback
if ! command -v jq &> /dev/null; then
    echo "Warning: 'jq' not found. Will use simple string escaping."
    HAS_JQ=0
else
    HAS_JQ=1
fi

while true; do
  if [ -f "$REQUEST_FILE" ]; then
    echo "$(date '+%H:%M:%S') > Executing agent request..."
    
    # Execute request
    OUTPUT=$(bash "$REQUEST_FILE" 2>&1)
    EXIT_CODE=$?
    
    # Write JSON response
    if [ $HAS_JQ -eq 1 ]; then
        jq -n --arg out "$OUTPUT" --arg code "$EXIT_CODE" \
           '{exit_code: ($code|tonumber), output: $out}' > "$RESPONSE_FILE.tmp"
    else
        ESCAPED_OUT=$(echo "$OUTPUT" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')
        printf '{"exit_code": %d, "output": "%s"}' "$EXIT_CODE" "$ESCAPED_OUT" > "$RESPONSE_FILE.tmp"
    fi
    
    mv "$RESPONSE_FILE.tmp" "$RESPONSE_FILE"
    rm "$REQUEST_FILE"
    echo "$(date '+%H:%M:%S') < Execution complete. (Exit $EXIT_CODE)"
  fi
  sleep 0.5
done
